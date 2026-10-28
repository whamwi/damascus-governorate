#!/usr/bin/env python3
"""Read the org charts of a structure deck (one directorate per slide) into a unit list.

    python3 tools/read_structure_deck.py <deck.pptx> <out.csv>

DG draws each chart as boxes joined by connectors. A connector glued to two
boxes (stCxn / endCxn) is read as a parent-child edge, the upper box being the
parent. Loose segments that touch form one bus line; the boxes at its free
ends (within SNAP) hang on it, the highest being the parent. Anything that
cannot be attached is reported, never guessed. SmartArt slides are
read from their data model. Boxes that name a person rather than a unit
(«معاون المدير», «مدير المكتب»…) pass their children up to their own parent.

Output, one row per unit box: slide, directorate (the chart's root), the
unit, its parent, the type read from the first word, and how the edge was
found (CONNECTOR / BUS / SMARTART / UNATTACHED), with the box ids that make
the parent unambiguous where a name repeats (ROOT: the directorate itself).
"""
import csv, math, re, sys, unicodedata
from pptx import Presentation

EMU_IN = 914400
SNAP = int(0.12 * EMU_IN)
NS = {'a': 'http://schemas.openxmlformats.org/drawingml/2006/main',
      'p': 'http://schemas.openxmlformats.org/presentationml/2006/main',
      'dgm': 'http://schemas.openxmlformats.org/drawingml/2006/diagram'}

TYPES = [('مديرية', 'DIRECTORATE'), ('مديريـة', 'DIRECTORATE'), ('دائرة', 'DEPARTMENT'), ('دائـرة', 'DEPARTMENT'),
         ('الدائرة', 'DEPARTMENT'), ('شعبة', 'SECTION'), ('شعبـة', 'SECTION'), ('الشعبة', 'SECTION'),
         ('مكتب', 'OFFICE'), ('ورشة', 'WORKSHOP'), ('قسم', 'QISM'), ('مركز', 'UNIT'), ('مراكز', 'UNIT'),
         ('غرفة', 'ROOM'), ('فرع', 'BRANCH')]
PERSON = re.compile(r'^(ال)?(معاون|مدير|رئيس|أمين|السكرتاري|سكرتير|ممثل|مسؤول|المحافظ|كاتب|مستثمر|حاسب|السائق)')


def norm(s):
    s = unicodedata.normalize('NFKC', s or '').replace('ـ', '')
    return re.sub(r'\s+', ' ', s).strip()


def kind(label):
    if PERSON.match(label) and not label.startswith(('مدير ية', 'مديرية')):
        return 'PERSON'
    for word, t in TYPES:
        if label.startswith(word):
            return t
    return 'UNIT'


class Box:
    def __init__(self, sid, label, x, y, w, h):
        self.id, self.label, self.x, self.y, self.w, self.h = sid, label, x, y, w, h

    def dist(self, px, py):
        dx = max(self.x - px, 0, px - (self.x + self.w))
        dy = max(self.y - py, 0, py - (self.y + self.h))
        return (dx * dx + dy * dy) ** 0.5


def shapes_abs(shapes, tf=(0, 0, 1.0, 1.0)):
    """Yield (shape, x, y, w, h) in slide coordinates, through nested groups."""
    ox, oy, sx, sy = tf
    for s in shapes:
        x = ox + (s.left or 0) * sx; y = oy + (s.top or 0) * sy
        w = (s.width or 0) * sx; h = (s.height or 0) * sy
        if s.shape_type == 6:      # group: child coordinates map through chOff/chExt
            xfrm = s._element.find('.//a:xfrm', NS)
            ch_off = xfrm.find('a:chOff', NS); ch_ext = xfrm.find('a:chExt', NS)
            cx, cy = int(ch_off.get('x')), int(ch_off.get('y'))
            cw, chh = int(ch_ext.get('cx')) or 1, int(ch_ext.get('cy')) or 1
            gsx, gsy = w / cw, h / chh
            yield from shapes_abs(s.shapes, (x - cx * gsx, y - cy * gsy, gsx, gsy))
        else:
            yield s, x, y, w, h


def read_slide(slide):
    boxes, lines = {}, []
    for s, x, y, w, h in shapes_abs(slide.shapes):
        el = s._element
        if el.tag.endswith('}cxnSp') or s.shape_type == 9:
            st = el.find('.//a:stCxn', NS); en = el.find('.//a:endCxn', NS)
            flip = el.find('.//a:xfrm', NS)
            fh = flip is not None and flip.get('flipH') == '1'; fv = flip is not None and flip.get('flipV') == '1'
            x1, x2 = (x + w, x) if fh else (x, x + w); y1, y2 = (y + h, y) if fv else (y, y + h)
            # an elbow connector is often drawn rotated: its ends turn about the centre (rot is clockwise)
            rot = int(flip.get('rot') or 0) / 60000 if flip is not None else 0
            if rot:
                c, sn = math.cos(math.radians(rot)), math.sin(math.radians(rot))
                mx, my = x + w / 2, y + h / 2
                turn = lambda px, py: (mx + (px - mx) * c - (py - my) * sn, my + (px - mx) * sn + (py - my) * c)
                (x1, y1), (x2, y2) = turn(x1, y1), turn(x2, y2)
            lines.append((st.get('id') if st is not None else None, en.get('id') if en is not None else None,
                          (x1, y1), (x2, y2)))
        elif getattr(s, 'has_text_frame', False) and s.has_text_frame:
            label = norm(' '.join(p.text for p in s.text_frame.paragraphs))
            if label and not s.is_placeholder:
                boxes[str(s.shape_id)] = Box(str(s.shape_id), label, x, y, w, h)
    edges, unresolved = [], 0
    loose = []
    for a, b, p1, p2 in lines:
        if a in boxes and b in boxes and a != b:
            pa, pb = boxes[a], boxes[b]
            parent, child = (pa, pb) if pa.y + pa.h / 2 < pb.y + pb.h / 2 else (pb, pa)
            edges.append((parent.id, child.id, 'CONNECTOR'))
        else:
            loose.append((a if a in boxes else None, b if b in boxes else None, p1, p2))

    # bus lines: segments that touch form one bus; every box at a free end hangs on it,
    # the highest box is the parent of the others
    def seg_dist(pt, s):
        (x1, y1), (x2, y2) = s
        dx, dy = x2 - x1, y2 - y1
        L = dx * dx + dy * dy
        u = 0 if L == 0 else max(0, min(1, ((pt[0] - x1) * dx + (pt[1] - y1) * dy) / L))
        cx, cy = x1 + u * dx, y1 + u * dy
        return ((pt[0] - cx) ** 2 + (pt[1] - cy) ** 2) ** 0.5

    comp = list(range(len(loose)))
    def find(i):
        while comp[i] != i:
            comp[i] = comp[comp[i]]; i = comp[i]
        return i
    for i, (_, _, a1, a2) in enumerate(loose):
        for j, (_, _, b1, b2) in enumerate(loose):
            if i < j and min(seg_dist(a1, (b1, b2)), seg_dist(a2, (b1, b2)),
                             seg_dist(b1, (a1, a2)), seg_dist(b2, (a1, a2))) <= SNAP:
                comp[find(i)] = find(j)
    buses = {}
    for i, (ga, gb, p1, p2) in enumerate(loose):
        bus = buses.setdefault(find(i), set())
        for glued, pt in ((ga, p1), (gb, p2)):
            if glued:
                bus.add(glued)
            else:
                near = min(boxes.values(), key=lambda bx: bx.dist(*pt), default=None)
                if near and near.dist(*pt) <= SNAP:
                    bus.add(near.id)
    for members in buses.values():
        if len(members) < 2:
            unresolved += 1
            continue
        top = min(members, key=lambda i: boxes[i].y + boxes[i].h / 2)
        for m in members:
            if m != top:
                edges.append((top, m, 'BUS'))
    return boxes, edges, unresolved


def read_smartart(slide, part):
    """SmartArt keeps the hierarchy in its data model: parOf connections between text points."""
    rel = [r for r in part.rels.values() if r.reltype.endswith('/diagramData')]
    if not rel:
        return None
    dm = rel[0].target_part._element if hasattr(rel[0].target_part, '_element') else None
    from lxml import etree
    dm = etree.fromstring(rel[0].target_part.blob)
    text = {}
    for pt in dm.iter('{%s}pt' % NS['dgm']):
        t = norm(''.join(pt.itertext()))
        if t and pt.get('type') in (None, 'node'):
            text[pt.get('modelId')] = t
    edges = [(c.get('srcId'), c.get('destId'), 'SMARTART') for c in dm.iter('{%s}cxn' % NS['dgm'])
             if c.get('type') in (None, 'parOf') and c.get('srcId') in text and c.get('destId') in text]
    boxes = {k: Box(k, v, 0, 0, 0, 0) for k, v in text.items()}
    return boxes, edges, 0


def tree_rows(n, boxes, edges):
    parent = {}
    for p, c, how in edges:
        parent.setdefault(c, (p, how))
    roots = [b for b in boxes.values() if b.id not in parent]
    root = min(roots, key=lambda b: (0 if kind(b.label) == 'DIRECTORATE' else 1, b.y)) if roots else None
    rows = []

    def unit_parent(bid):
        # walk up through boxes that name a person
        seen = set()
        while bid in parent and bid not in seen:
            seen.add(bid)
            bid = parent[bid][0]
            if kind(boxes[bid].label) != 'PERSON':
                return bid
        return None

    for b in sorted(boxes.values(), key=lambda b: (b.y, -b.x)):
        if root and b.id == root.id:
            continue
        k = kind(b.label)
        if k == 'PERSON':
            rows.append([n, root.label if root else '', b.label, '', k, 'PERSON', b.id, ''])
            continue
        up = unit_parent(b.id)
        how = parent[b.id][1] if b.id in parent else 'UNATTACHED'
        up_label = boxes[up].label if up else ''
        if up and root and up == root.id:
            up_label = '(المديرية)'
        up_id = 'ROOT' if up and root and up == root.id else (up or '')
        rows.append([n, root.label if root else '', b.label, up_label, k, how, b.id, up_id])
    return rows


if __name__ == '__main__':
    deck, out = sys.argv[1:3]
    prs = Presentation(deck)
    rows, report = [], []
    for n, slide in enumerate(prs.slides, 1):
        sa = read_smartart(slide, slide.part) if any(
            r.reltype.endswith('/diagramData') for r in slide.part.rels.values()) else None
        boxes, edges, unresolved = sa if sa else read_slide(slide)
        if len(boxes) < 3 or not edges:
            continue          # a text slide, not a chart
        r = tree_rows(n, boxes, edges)
        rows += r
        report.append((n, len(boxes), len(edges), unresolved, sum(1 for x in r if x[5] == 'UNATTACHED')))
    with open(out, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f)
        w.writerow(['slide', 'directorate', 'unit', 'parent', 'type', 'edge', 'box_id', 'parent_box_id'])
        w.writerows(rows)
    print('slide boxes edges unresolved_lines unattached_boxes')
    for r in report:
        print(*r)
    print(f'{len(rows)} rows -> {out}')
