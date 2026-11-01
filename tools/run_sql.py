#!/usr/bin/env python3
"""Run SQL scripts against the DG schema through ORDS, one statement per request.

    python3 tools/run_sql.py apex/03_lookups.sql apex/data/2026-10-28_defacto.sql
    python3 tools/run_sql.py -c "select count(*) from org_unit"

Each statement goes alone and must come back as exactly one item with no error:
ORDS answers HTTP 200 even when it skips a statement, so zero items stops the
run. DEFINE is off, as ORDS otherwise substitutes &names. Statements over
32,767 characters are refused before sending (ORDS would skip them silently);
for an APEX import use tools/install_apex.py. The password comes from the
macOS keychain item dg-ords.
"""
import base64, json, re, subprocess, sys, time, urllib.request

BASE = 'https://apps.excellencors.com/ords/dg/_/sql'
USER = 'WKSP_DG'
PLSQL_START = re.compile(r'^\s*(DECLARE|BEGIN|CREATE\s+(OR\s+REPLACE\s+)?(TRIGGER|PACKAGE|FUNCTION|PROCEDURE|TYPE))\b', re.I)

_pw = subprocess.run(['security', 'find-generic-password', '-s', 'dg-ords', '-w'],
                     capture_output=True, text=True, check=True).stdout.strip()
_auth = 'Basic ' + base64.b64encode(f'{USER}:{_pw}'.encode()).decode()


def post(sql):
    req = urllib.request.Request(BASE, data=('SET DEFINE OFF\n' + sql).encode('utf-8'), method='POST',
                                 headers={'Content-Type': 'application/sql', 'Authorization': _auth})
    with urllib.request.urlopen(req, timeout=900) as r:
        return [i for i in json.loads(r.read()).get('items', []) if i.get('statementType') != 'sqlplus']


def split(text):
    stmts, cur, plsql = [], [], False
    for line in text.splitlines():
        if not cur:
            if not line.strip() or line.lstrip().startswith('--'):
                continue
            plsql = bool(PLSQL_START.match(line))
        if plsql and line.strip() == '/':
            stmts.append(('\n'.join(cur), True)); cur = []
            continue
        cur.append(line)
        if not plsql and line.rstrip().endswith(';'):
            stmts.append(('\n'.join(cur).rstrip()[:-1], False)); cur = []
    if any(l.strip() and not l.lstrip().startswith('--') for l in cur):
        sys.exit(f'unterminated statement: {cur[0][:80]}')
    return stmts


def show(items):
    for i in items:
        res = i.get('resultSet')
        if res:
            cols = [m['jsonColumnName'] for m in res['metadata']]
            for row in res['items']:
                print(' | '.join(str(row.get(c)) for c in cols))


if __name__ == '__main__':
    if sys.argv[1] == '-c':
        items = post(sys.argv[2])
        show(items)
        errs = [i for i in items if i.get('errorCode') or i.get('errorDetails')]
        for e in errs:
            print('ERR', str(e.get('errorDetails'))[:400])
        sys.exit(1 if errs else 0)
    for path in sys.argv[1:]:
        stmts = split(open(path, encoding='utf-8').read())
        t0 = time.time()
        for n, (body, plsql) in enumerate(stmts, 1):
            if len(body) > 32000:
                sys.exit(f'{path} stmt {n}: {len(body)} characters, over what ORDS accepts')
            items = post(body + ('\n/\n' if plsql else ';\n'))
            errs = [i for i in items if i.get('errorCode') or i.get('errorDetails')
                    or 'Substitution cancelled' in str(i.get('response'))]
            if len(items) != 1 or errs:
                detail = str(errs[0].get('errorDetails') or errs[0].get('response'))[:400] if errs else f'{len(items)} items'
                sys.exit(f'FAIL {path} stmt {n}/{len(stmts)}: {body.strip().splitlines()[0][:100]}\n  {detail}')
        print(f'ok  {path}: {len(stmts)} statements, {time.time() - t0:.0f}s')
