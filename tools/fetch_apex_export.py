#!/usr/bin/env python3
"""Export APEX application 111 out of the DG workspace, through ORDS, onto disk.

    python3 tools/fetch_apex_export.py apex        # writes apex/f111/

Stages apex_export.get_application(p_split => true) in DG_EXP_TMP, reads every
file back in chunks, checks its length against DBMS_LOB.GETLENGTH and aborts on
a short read, then drops the staging table. The ORDS password comes from the
macOS keychain item dg-ords; no secret is in this repository.
"""
import base64, json, pathlib, shutil, subprocess, sys, urllib.request

BASE = 'https://apps.excellencors.com/ords/dg/_/sql'
USER = 'WKSP_DG'
APP = 111
CHUNK = 6000          # characters per row
ROWS = 400            # rows per request

_pw = subprocess.run(['security', 'find-generic-password', '-s', 'dg-ords', '-w'],
                     capture_output=True, text=True, check=True).stdout.strip()
_auth = 'Basic ' + base64.b64encode(f'{USER}:{_pw}'.encode()).decode()


def sql(text, limit=ROWS):
    body = json.dumps({'statementText': text, 'limit': limit}).encode()
    req = urllib.request.Request(BASE, data=body, method='POST', headers={
        'Content-Type': 'application/json', 'Authorization': _auth})
    with urllib.request.urlopen(req, timeout=600) as r:
        payload = json.loads(r.read())
    out = []
    for item in payload.get('items', []):
        if item.get('errorCode') or item.get('errorDetails'):
            raise RuntimeError(str(item.get('errorDetails') or item.get('errorCode')).strip())
        out += (item.get('resultSet') or {}).get('items', [])
    return out


STAGE = f"""
BEGIN
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE dg_exp_tmp'; EXCEPTION WHEN OTHERS THEN NULL; END;
  EXECUTE IMMEDIATE 'CREATE TABLE dg_exp_tmp (seq NUMBER, nm VARCHAR2(400), ln NUMBER, contents CLOB)';
  DECLARE
    l_files apex_t_export_files;
    l_ws    NUMBER;
  BEGIN
    SELECT workspace_id INTO l_ws FROM apex_workspaces WHERE workspace = 'DG';
    apex_util.set_security_group_id(p_security_group_id => l_ws);
    l_files := apex_export.get_application(p_application_id => {APP}, p_split => TRUE);
    FOR i IN 1 .. l_files.COUNT LOOP
      EXECUTE IMMEDIATE 'INSERT INTO dg_exp_tmp VALUES (:1, :2, :3, :4)'
        USING i, l_files(i).name, dbms_lob.getlength(l_files(i).contents), l_files(i).contents;
    END LOOP;
    COMMIT;
  END;
END;
"""

if __name__ == '__main__':
    out = pathlib.Path(sys.argv[1])
    sql(STAGE)
    try:
        manifest = sql('select seq, nm, ln from dg_exp_tmp order by seq', limit=2000)
        print(f'{len(manifest)} files to fetch')
        if (out / f'f{APP}').exists():
            shutil.rmtree(out / f'f{APP}')   # a component deleted in APEX must disappear here too
        total = 0
        for m in manifest:
            seq, nm, ln = int(m['seq']), m['nm'], int(m['ln'])
            parts, off = [], 1
            while off <= ln:
                want = min(ROWS, ((ln - off) // CHUNK) + 1)
                got = sql(f'select lvl, dbms_lob.substr(contents, {CHUNK}, {off} + (lvl-1)*{CHUNK}) c '
                          f'from dg_exp_tmp, (select level lvl from dual connect by level <= {want}) '
                          f'where seq = {seq} order by lvl', limit=ROWS + 10)
                if not got:
                    raise RuntimeError(f'no chunks returned for {nm} at {off}')
                parts += [g['c'] for g in sorted(got, key=lambda r: int(r['lvl'])) if g['c'] is not None]
                off += want * CHUNK
            text = ''.join(parts)
            if len(text) != ln:
                sys.exit(f'aborting: {nm} came back short (want {ln}, got {len(text)})')
            dest = out / nm
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(text, encoding='utf-8')
            total += len(text)
        print(f'done: {len(manifest)} files, {total} chars')
    finally:
        sql("BEGIN EXECUTE IMMEDIATE 'DROP TABLE dg_exp_tmp'; END;")
