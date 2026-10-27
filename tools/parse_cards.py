"""Parse job description cards (بطاقات وصف) from .docx: one table per card,
header row labels the columns in any order; tasks follow as paragraphs."""
import re, sys, json, pathlib, collections, docx
from docx.table import Table
from docx.text.paragraph import Paragraph

def norm(s): return re.sub(r'\s+', ' ', (s or '').replace('ـ', '')).strip()
COLS = {'loc': 'موقع', 'title': 'مسمى', 'cls': 'تصنيف', 'req': 'الشروط'}
REQ = {'qual': 'المؤهل', 'spec': 'الاختصاص', 'exp': 'الخبر', 'train': 'التدريب',
       'other': 'معارف', 'effort': 'نوع الجهد'}

def uniq(cells):
    out, seen = [], set()
    for c in cells:
        if id(c._tc) not in seen: seen.add(id(c._tc)); out.append(c)
    return out

def kv(text, key):
    m = re.search(key + r'[^:\n]*:[ \t]*([^\n]*)', text)
    v = norm(m.group(1)) if m else None
    return None if not v or v.endswith(':') else v

def parse_table(t):
    rows = t.rows
    hdr = [norm(c.text) for c in rows[0].cells]
    col = {}
    for k, w in COLS.items():
        for i, h in enumerate(hdr):
            if w in h: col[k] = i; break
    if len(col) < 3: return None
    body = rows[1:]
    g = lambda k: norm(body[0].cells[col[k]].text) if k in col and body else ''
    raw_loc = body[0].cells[col['loc']].text if 'loc' in col else ''
    raw_title = body[0].cells[col['title']].text if 'title' in col else ''
    c = {'dir': kv(raw_loc, 'المديرية'), 'dept': kv(raw_loc, 'الدائرة'),
         'sec': kv(raw_loc, 'الشعبة'), 'boss': kv(raw_loc, 'الرئيس المباشر'),
         'title': norm(raw_title), 'cls': g('cls')}
    # supervisor sometimes sits on its own line after the label
    if not c['boss']:
        lines = [norm(l) for l in raw_loc.splitlines() if norm(l)]
        for i, l in enumerate(lines):
            if 'الرئيس المباشر' in l and i + 1 < len(lines): c['boss'] = lines[i + 1]
    req = ' \n'.join(norm(r.cells[col['req']].text) for r in body) if 'req' in col else ''
    for k, w in REQ.items(): c[k] = kv(req, w)
    return c

def cards(path):
    d = docx.Document(path)
    out, cur = [], None
    for el in d.element.body.iterchildren():
        tag = el.tag.split('}')[1]
        if tag == 'tbl':
            c = parse_table(Table(el, d))
            if c: cur = c; cur['tasks'] = []; out.append(cur)
        elif tag == 'p' and cur is not None:
            txt = norm(Paragraph(el, d).text)
            if not txt or re.match(r'(ال)?مهام', txt) or re.search(r'بطاقة\s*(ال)?وصف', txt): continue
            cur['tasks'].append(re.sub(r'^[-–•\d\.\)\(]+\s*', '', txt))
    return out

if __name__ == '__main__':
    root, dst = pathlib.Path(sys.argv[1]), sys.argv[2]
    allc = []
    for f in sorted(root.rglob('*.docx')):
        for i, c in enumerate(cards(f), 1):
            allc.append({'file': f.parent.name + '/' + f.stem, 'n': i, **c})
    json.dump(allc, open(dst, 'w'), ensure_ascii=False, indent=1)
    print(len(allc), 'cards')
    for k, v in collections.Counter(c['file'] for c in allc).items(): print(v, k)
