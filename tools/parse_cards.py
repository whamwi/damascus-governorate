"""Parse job description cards (بطاقات وصف) from .docx: one table per card,
header row labels the columns in any order; tasks follow as paragraphs."""
import re, sys, json, pathlib, collections, unicodedata, docx
from docx.table import Table
from docx.text.paragraph import Paragraph

def norm(s): return re.sub(r'\s+', ' ', (s or '').replace('ـ', '')).strip()
COLS = {'loc': 'موقع|الجهة', 'title': 'مسمى', 'cls': 'تصنيف', 'req': 'الشروط'}
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

LEVEL = [('dir', r'المديرية'), ('dept', r'(ال)?دائرة'), ('sec', r'(ال)?شعبة'),
         ('sub', r'(ال)?(قسم|مكتب|فرع)')]

def location(raw):
    """The location cell, line by line: المديرية / الدائرة / الشعبة, sometimes a
    قسم, مكتب or فرع, then the supervisor's title under its own label. An
    unlabelled line before the supervisor is a unit name (e.g. «المكتب الخاص»)."""
    out = {'dir': None, 'dept': None, 'sec': None, 'sub': None, 'boss': None}
    lines = [norm(l) for l in raw.splitlines() if norm(l)]
    for i, l in enumerate(lines):
        if 'الرئيس المباشر' in l:
            v = norm(l.split(':', 1)[1]) if ':' in l else ''
            out['boss'] = v or ' '.join(lines[i + 1:]) or None
            break
        head, _, val = l.partition(':')
        key = next((k for k, w in LEVEL if _ and re.fullmatch(w, norm(head))), None)
        if key:
            v = norm(val)
            if v and not v.endswith(':'): out[key] = v
        elif not _:
            # unlabelled: «دائرة معالجة الأنقاض», «شعبة التقييم», «المكتب الخاص»;
            # the governorate and sector lines above them are not units
            m = re.match(r'(مديرية|دائرة|شعبة)\s+(.*)', l)
            if m: out[{'مديرية': 'dir', 'دائرة': 'dept', 'شعبة': 'sec'}[m.group(1)]] = m.group(2)
            elif not re.match(r'محافظة|القطاع', l): out['sub'] = l
    return out

def parse_new_template(t):
    """The later template (2020): المسمى الوظيفي / الفئة الوظيفية / عدد مراكز العمل,
    with «مسمى وظيفة رئيسه المباشر» as its own field."""
    cells = uniq([c for r in t.rows for c in r.cells])
    txt = '\n'.join(c.text for c in cells)
    c = {'title': kv(txt, 'المسمى الوظيفي'), 'cls': kv(txt, 'الفئة الوظيفية'),
         'dir': kv(txt, 'المديرية'), 'dept': kv(txt, r'الدائرة'), 'sec': kv(txt, r'الشعبة'),
         'sub': None, 'boss': kv(txt, 'رئيسه المباشر')}
    for k, w in REQ.items(): c[k] = kv(txt, w)
    c['exp'] = c['exp'] or kv(txt, 'سنوات الخبرة')
    return c

def parse_table(t):
    rows = t.rows
    if norm(rows[0].cells[0].text).startswith('المسمى الوظيفي'): return parse_new_template(t)
    hdr = [norm(c.text) for c in rows[0].cells]
    col = {}
    for k, w in COLS.items():
        for i, h in enumerate(hdr):
            if re.search(w, h): col[k] = i; break
    if len(col) < 3: return None
    body = rows[1:]
    g = lambda k: norm(body[0].cells[col[k]].text) if k in col and body else ''
    raw_loc = body[0].cells[col['loc']].text if 'loc' in col else ''
    raw_title = body[0].cells[col['title']].text if 'title' in col else ''
    c = {'title': norm(raw_title), 'cls': g('cls'), **location(raw_loc)}
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

def card_key(f):
    """Article key of a card file: '16 .../3 بطاقات' -> 16.3, '20-1 بطاقات' -> 20."""
    nf = lambda x: unicodedata.normalize('NFKC', x)  # some names arrive in presentation forms
    stem, parent = nf(f.stem), nf(f.parent.name)
    if 'أمين السر' in stem: return '16.0'
    if stem.startswith('2020'): return '2020'
    n = re.match(r'(\d+)', stem).group(1)
    return f'16.{n}' if parent.startswith('16 ') else n


if __name__ == '__main__':
    root, dst = pathlib.Path(sys.argv[1]), sys.argv[2]
    allc = []
    for f in sorted(root.rglob('*.docx')):
        for i, c in enumerate(cards(f), 1):
            allc.append({'file': f.parent.name + '/' + f.stem, 'n': i, **c})
    json.dump(allc, open(dst, 'w'), ensure_ascii=False, indent=1)
    print(len(allc), 'cards')
    for k, v in collections.Counter(c['file'] for c in allc).items(): print(v, k)
