#!/usr/bin/env python3
"""Install the split APEX export apex/f111 into the DG workspace, through ORDS.

    python3 tools/install_apex.py apex/f111

Why not just POST install.sql: ORDS REST-Enabled SQL silently skips any
statement over 32,767 characters, and every statement after it, while still
answering 200 with no error. The export has blocks far larger (files, the
plugin). On 2026-10-29 that left app 111 deleted and never recreated.

ORDS also rewrites text on the way in: it substitutes &names and reflows
comment lines, even inside string literals. So the script (install.sql with
every @@ file inlined, SQLcl-only lines dropped) is staged into DG_IMP_TMP as
base64 pieces of its UTF-8 bytes, which ORDS has nothing to touch in; the byte
total is checked against what was sent. Then one PL/SQL call
reassembles it and runs each block with EXECUTE IMMEDIATE in a single session,
which an APEX import (import_begin ... import_end) needs. It stops at the first
failing block and names it; the count of blocks run must equal the count sent.
The ORDS password comes from the macOS keychain item dg-ords.
"""
import base64, json, pathlib, re, subprocess, sys, urllib.request

BASE = 'https://apps.excellencors.com/ords/dg/_/sql'
USER = 'WKSP_DG'
PIECE = 18000          # bytes per staged piece; base64 makes it 24,000 characters
SQLCL_ONLY = re.compile(r'^\s*(prompt|set|whenever)\b', re.I)

_pw = subprocess.run(['security', 'find-generic-password', '-s', 'dg-ords', '-w'],
                     capture_output=True, text=True, check=True).stdout.strip()
_auth = 'Basic ' + base64.b64encode(f'{USER}:{_pw}'.encode()).decode()


def post(text, statements=1):
    # ORDS substitutes &names like SQLcl; a cancelled substitution abandons the
    # rest of the request and still answers 200, so DEFINE is off and checked.
    req = urllib.request.Request(BASE, data=('SET DEFINE OFF\n' + text).encode('utf-8'), method='POST',
                                 headers={'Content-Type': 'application/sql', 'Authorization': _auth})
    with urllib.request.urlopen(req, timeout=900) as r:
        items = [i for i in json.loads(r.read()).get('items', []) if i.get('statementType') != 'sqlplus']
    for i in items:
        if i.get('errorCode') or i.get('errorDetails') or 'Substitution cancelled' in str(i.get('response')):
            raise RuntimeError(str(i.get('errorDetails') or i.get('errorCode') or i.get('response')).strip())
    if len(items) != statements:
        raise RuntimeError(f'{statements} statements sent, {len(items)} answered: ORDS dropped the rest')
    return items


def script(root):
    lines = []
    for ref in (root / 'install.sql').read_text(encoding='utf-8').splitlines():
        if ref.startswith('@@'):
            lines += [l for l in (root / ref[2:].strip()).read_text(encoding='utf-8').splitlines()
                      if not SQLCL_ONLY.match(l)]
    return '\n'.join(lines) + '\n'


RUN = """
DECLARE
  l_bin BLOB; l_all CLOB; l_blk CLOB; l_pos PLS_INTEGER := 1; l_end PLS_INTEGER; l_n PLS_INTEGER := 0;
  l_dst INTEGER := 1; l_src INTEGER := 1; l_ctx INTEGER := 0; l_warn INTEGER;
  l_sep CONSTANT VARCHAR2(3) := CHR(10) || '/' || CHR(10);
BEGIN
  dbms_lob.createtemporary(l_bin, TRUE);
  FOR r IN (SELECT piece FROM dg_imp_tmp WHERE seq > 0 ORDER BY seq) LOOP dbms_lob.append(l_bin, r.piece); END LOOP;
  dbms_lob.createtemporary(l_all, TRUE);
  dbms_lob.converttoclob(l_all, l_bin, dbms_lob.lobmaxsize, l_dst, l_src,
                         nls_charset_id('AL32UTF8'), l_ctx, l_warn);
  LOOP
    l_end := dbms_lob.instr(l_all, l_sep, l_pos);
    EXIT WHEN l_end = 0;
    dbms_lob.createtemporary(l_blk, TRUE);
    dbms_lob.copy(l_blk, l_all, l_end - l_pos, 1, l_pos);
    l_n := l_n + 1;
    BEGIN
      EXECUTE IMMEDIATE l_blk;
    EXCEPTION WHEN OTHERS THEN
      raise_application_error(-20001, 'block ' || l_n || ' failed: ' || SQLERRM || ' :: '
        || REPLACE(dbms_lob.substr(l_blk, 300, 1), CHR(10), ' '));
    END;
    dbms_lob.freetemporary(l_blk);
    l_pos := l_end + LENGTH(l_sep);
  END LOOP;
  UPDATE dg_imp_tmp SET blocks = l_n WHERE seq = 0;
  COMMIT;
END;
"""

if __name__ == '__main__':
    text = script(pathlib.Path(sys.argv[1]))
    sent = text.count('\n/\n') + (1 if text.startswith('/\n') else 0)
    post("BEGIN BEGIN EXECUTE IMMEDIATE 'DROP TABLE dg_imp_tmp'; EXCEPTION WHEN OTHERS THEN NULL; END;\n"
         "EXECUTE IMMEDIATE 'CREATE TABLE dg_imp_tmp (seq NUMBER, piece BLOB, blocks NUMBER)'; END;\n/\n")
    try:
        raw = text.encode('utf-8')
        pieces = [raw[i:i + PIECE] for i in range(0, len(raw), PIECE)]
        for n, p in enumerate(pieces, 1):
            post(f"BEGIN INSERT INTO dg_imp_tmp (seq, piece) VALUES ({n}, utl_encode.base64_decode("
                 f"utl_raw.cast_to_raw('{base64.b64encode(p).decode()}'))); COMMIT; END;\n/\n")
        got = post('SELECT SUM(dbms_lob.getlength(piece)) n FROM dg_imp_tmp WHERE seq > 0')[0]['resultSet']['items'][0]['n']
        if int(got) != len(raw):
            sys.exit(f'staging does not match: {got} of {len(raw)} bytes')
        post("INSERT INTO dg_imp_tmp (seq) VALUES (0);\n" + RUN + "\n/\n", statements=2)
        ran = post('SELECT blocks n FROM dg_imp_tmp WHERE seq = 0')[0]['resultSet']['items'][0]['n']
        print(f'{len(raw):,} bytes in {len(pieces)} pieces, {sent} blocks sent, {ran} run')
        sys.exit(0 if int(ran or 0) == sent else 1)
    finally:
        post("BEGIN EXECUTE IMMEDIATE 'DROP TABLE dg_imp_tmp'; END;\n/\n")
