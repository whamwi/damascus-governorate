#!/usr/bin/env python3
"""Generate the load of a de facto structure from its two reviewed mappings.

    python3 tools/gen_defacto_sql.py analysis/2026-10-28_defacto_map.csv \
        analysis/2026-10-28_defacto_units.csv DG_DEFACTO \
        'الهيكل الفعلي (عرض التنمية الإدارية 28/10)' apex/data/2026-10-28_defacto.sql

The directorate map (one row per directorate) and the unit match (one row per
box of the deck, and per unit of today's cards the deck does not draw) are
both maintained by hand; nothing is matched here.

The scenario is built from the deck, not cloned. A unit matched to a unit of
DG_ASIS_CARDS keeps that unit's code, which is what lines the three structures
up, and brings the positions of its cards; a unit with no match gets a code
F-<slide>-<box> and no positions, so the gap shows. A directorate with no chart
in the deck brings its units below from the cards (CARRY_SUBTREE). A position
whose supervisor did not come across reports to the head of its nearest unit
above (link FROM_STRUCTURE). Every row is also written to ORG_UNIT_LINEAGE.
The file is rerunnable: it drops the scenario and builds it again.
"""
import csv, hashlib, re, sys, unicodedata

dir_csv, unit_csv, code, name_ar, out = sys.argv[1:6]
dirs = list(csv.DictReader(open(dir_csv, encoding='utf-8')))
units = list(csv.DictReader(open(unit_csv, encoding='utf-8')))
TYPES = {'GOVERNORATE', 'SECTOR', 'SECRETARIAT', 'DIRECTORATE', 'QISM', 'BRANCH', 'DEPARTMENT', 'SECTION',
         'OFFICE', 'WORKSHOP', 'ROOM', 'UNIT'}


def q(s):
    return 'NULL' if s is None or s == '' else "'" + str(s).replace("'", "''") + "'"


def key(s):
    s = unicodedata.normalize('NFKC', s or '').replace('ـ', '')
    s = re.sub('[أإآ]', 'ا', s).replace('ة', 'ه').replace('ى', 'ي')
    return re.sub(r'\s+', '', s)      # the type word stays: «مكتب الإعلام» is not «مديرية الإعلام»


rows = []          # dicts in the column order of ORG_LOAD_UNIT


def short(box_id):
    # a SmartArt box's id is a GUID: 8 hex characters of it keep a unit code under 40
    return box_id if box_id.isdigit() else hashlib.md5(box_id.encode()).hexdigest()[:8]


def add(kind, unit=None, parent=None, utype=None, name=None, src=None, rel=None, conf='high', open_='N',
        note='', carry='N'):
    rows.append(dict(row_kind=kind, unit_code=unit, parent_code=parent, unit_type_code=utype, name_ar=name,
                     source_unit_code=src, relation=rel, confidence=conf.upper(), is_open=open_, note=note,
                     carry_subtree=carry))


charted = {u['defacto_dir'] for u in units if u['unit']}
placed_by_deck = {}            # a directorate of the map the deck draws inside another (مكتب لجان الأحياء)
dir_names = {key(d['defacto_name']): d['defacto_code'] for d in dirs if d['defacto_code']}
for u in units:
    if u['unit'] and dir_names.get(key(u['unit'])) not in (None, u['defacto_dir']):
        placed_by_deck[dir_names[key(u['unit'])]] = u

# the top, the two groupings, the directorates
for d in dirs:
    if d['relation'] == 'abolished':
        continue
    srcs = [c for c in d['asis_codes'].split('|') if c]
    c = d['defacto_code']
    open_ = 'Y' if d['confidence'] == 'low' or c in ('U-16', 'D-MUN') else 'N'
    note = d['note_ar']
    if c == 'U-GOV':
        add('UNIT', c, None, 'GOVERNORATE', d['defacto_name'], 'U-GOV', 'SAME', note=note)
        continue
    if c in ('U-16', 'D-MUN'):
        add('UNIT', c, 'U-GOV', 'SECRETARIAT', d['defacto_name'], srcs[0] if srcs else None,
            d['relation'].upper(), d['confidence'], 'Y',
            note + ' لا تذكر الشريحة 5 أيّ المديريات تتبعه، فوُضعت المديريات تحت المحافظ مباشرة.')
        continue
    parent, utype = 'U-GOV', 'DIRECTORATE'
    if c in placed_by_deck:
        parent, utype = placed_by_deck[c]['defacto_dir'], 'OFFICE'
        note += ' العرض يرسمه داخل ' + placed_by_deck[c]['dir_name'] + '، فوُضع هناك.'
    carry = 'Y' if c not in charted and srcs and c not in placed_by_deck else 'N'
    if carry == 'Y':
        note += ' لا شريحة لها في العرض: ما تحتها منقول من البطاقات كما هو.'
    add('UNIT', c, parent, utype, d['defacto_name'], srcs[0] if srcs else None, d['relation'].upper(),
        d['confidence'].upper(), open_, note, carry)
    for s in srcs[1:]:
        add('SOURCE', c, None, None, None, s, 'MERGED', d['confidence'].upper(), open_, note)
for d in dirs:
    if d['relation'] == 'abolished':
        for s in d['asis_codes'].split('|'):
            add('GONE', None, None, None, None, s, 'ABOLISHED', d['confidence'].upper(),
                'Y' if d['confidence'] == 'low' else 'N', d['note_ar'])

# the deck's units, parents first
box_code = {}
for u in units:
    if u['unit'] and u['defacto_dir'] not in placed_by_deck:
        box_code[(u['slide'], u['box_id'])] = (u['asis_code'] if u['decision'] == 'Y'
                                               else f"F-{u['slide']}-{short(u['box_id'])}")
drawn = [u for u in units if u['unit'] and (u['slide'], u['box_id']) in box_code
         and not any(u is p for p in placed_by_deck.values())]


def depth(u, seen=()):
    pb = u['parent_box_id']
    if pb in ('ROOT', ''):
        return 1
    parent = next((x for x in drawn if x['slide'] == u['slide'] and x['box_id'] == pb), None)
    return 1 if parent is None or parent in seen else 1 + depth(parent, seen + (u,))


rejected = []
for u in sorted(drawn, key=lambda u: (depth(u), int(u['slide']), u['box_id'].zfill(40))):
    pb = u['parent_box_id']
    parent = u['defacto_dir'] if pb in ('ROOT', '') else box_code[(u['slide'], pb)]
    matched = u['decision'] == 'Y'
    rel = 'NEW' if not matched else ('SAME' if key(u['unit']) == key(u['asis_name']) else 'RENAMED')
    add('UNIT', box_code[(u['slide'], u['box_id'])], parent, u['type'] if u['type'] in TYPES else 'UNIT', u['unit'],
        u['asis_code'] if matched else None, rel, 'HIGH' if u['match'] != 'SUGGESTED' else 'MEDIUM', 'N',
        u['note_ar'] or ('لا بطاقة لهذه الوحدة' if not matched else ''))
    if u['decision'] == 'N' and u['asis_code']:
        rejected.append(u)
for u in units:
    if u['match'] == 'NOT_IN_DECK':
        add('GONE', None, None, None, None, u['asis_code'], 'ABOLISHED', 'MEDIUM', 'N', u['note_ar'])
for u in rejected:
    add('GONE', None, None, None, None, u['asis_code'], 'ABOLISHED', 'MEDIUM', 'N',
        'وحدة في البطاقات لا مربع لها في العرض (شبيهها «' + u['unit'] + '» وحدة أخرى)')

codes = [r['unit_code'] for r in rows if r['row_kind'] == 'UNIT']
assert len(codes) == len(set(codes)), 'duplicate unit codes'
srcs = [r['source_unit_code'] for r in rows if r['source_unit_code'] and r['source_unit_code'] != 'U-GOV']
assert len(srcs) == len(set(srcs)), 'a unit of today used twice'

# staging: blocks of at most ~12,000 characters
cols = ['seq', 'row_kind', 'unit_code', 'parent_code', 'unit_type_code', 'name_ar', 'source_unit_code',
        'relation', 'confidence', 'is_open', 'note', 'carry_subtree']
ins, blocks, cur = [], [], []
for i, r in enumerate(rows, 1):
    vals = [str(i)] + [q(r[c]) for c in cols[1:]]
    s = (f"  INSERT INTO org_load_unit (load_code, {', '.join(cols)}) VALUES ({q(code)}, " + ', '.join(vals) + ');')
    if cur and sum(map(len, cur)) + len(s) > 12000:
        blocks.append(cur); cur = []
    cur.append(s)
blocks.append(cur)
stage = [f"DELETE FROM org_load_unit WHERE load_code = {q(code)};\nCOMMIT;\n"]
stage += ['BEGIN\n' + '\n'.join(b) + '\n  COMMIT;\nEND;\n/\n' for b in blocks]

build = f'''
DECLARE
  l_src  NUMBER;
  l_new  NUMBER;
  l_rep  NUMBER;
  l_from NUMBER;
  l_parent NUMBER;
  c_load CONSTANT VARCHAR2(30) := {q(code)};

  FUNCTION uid_of (p_code VARCHAR2) RETURN NUMBER IS
    l NUMBER;
  BEGIN
    SELECT MIN(unit_id) INTO l FROM org_unit WHERE scenario_id = l_new AND unit_code = p_code;
    RETURN l;
  END;

  PROCEDURE copy_positions (p_from VARCHAR2, p_to VARCHAR2, p_demote BOOLEAN) IS
    l_to NUMBER := uid_of(p_to);
    l_d  VARCHAR2(1) := CASE WHEN p_demote THEN 'Y' ELSE 'N' END;
  BEGIN
    INSERT INTO org_position (scenario_id, position_code, unit_id, card_id, title_ar, heads_unit, is_deputy,
                              is_placeholder, link_method_code, headcount, status, sort_order, source_type_code, notes)
    SELECT l_new, p.position_code, l_to, p.card_id, p.title_ar,
           CASE WHEN l_d = 'Y' THEN 'N' ELSE p.heads_unit END, p.is_deputy, p.is_placeholder,
           p.link_method_code, p.headcount, p.status, p.sort_order, p.source_type_code, p.notes
      FROM org_position p JOIN org_unit su ON su.unit_id = p.unit_id
     WHERE p.scenario_id = l_src AND su.unit_code = p_from;
  END;

BEGIN
  SELECT scenario_id INTO l_src FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS';

  FOR o IN (SELECT scenario_id FROM org_scenario WHERE scenario_code = c_load) LOOP
    UPDATE org_position SET reports_to_pos_id = NULL WHERE scenario_id = o.scenario_id;
    DELETE FROM org_position WHERE scenario_id = o.scenario_id;
    UPDATE org_unit SET parent_unit_id = NULL WHERE scenario_id = o.scenario_id;
    DELETE FROM org_unit WHERE scenario_id = o.scenario_id;
    DELETE FROM org_unit_lineage WHERE scenario_id = o.scenario_id;
    DELETE FROM org_scenario WHERE scenario_id = o.scenario_id;
  END LOOP;

  INSERT INTO org_scenario (scenario_code, name_ar, scenario_type, status, description)
  VALUES (c_load, {q(name_ar)}, 'AS_IS', 'UNDER_REVIEW',
          'الهيكل كما يعمل اليوم بحسب عرض «هيكليات مديريات محافظة دمشق» (مديرية التنمية الإدارية، 28/10/2026). '
       || 'الوحدات المطابقة لوحدات البطاقات تحمل رموزها ووظائفها؛ ما لا بطاقة له يبقى بلا وظائف.')
  RETURNING scenario_id INTO l_new;

  -- units, parents first
  FOR r IN (SELECT * FROM org_load_unit WHERE load_code = c_load AND row_kind = 'UNIT' ORDER BY seq) LOOP
    l_parent := uid_of(r.parent_code);          -- local functions cannot be called from SQL
    INSERT INTO org_unit (scenario_id, unit_code, parent_unit_id, unit_type_code, name_ar, source_type_code,
                          source_ref, sort_order, notes)
    VALUES (l_new, r.unit_code, l_parent, r.unit_type_code, r.name_ar, 'DEFACTO',
            'هيكليات مديريات محافظة دمشق.pptx', r.seq, r.note);
  END LOOP;

  -- a directorate with no chart: its units below, as the cards have them
  FOR r IN (SELECT unit_code, source_unit_code FROM org_load_unit
             WHERE load_code = c_load AND carry_subtree = 'Y') LOOP
    FOR c IN (SELECT u.unit_code, u.unit_type_code, u.name_ar, p.unit_code AS parent_code, u.sort_order
                FROM org_unit u JOIN org_unit p ON p.unit_id = u.parent_unit_id
               WHERE u.scenario_id = l_src AND u.unit_code <> r.source_unit_code
               START WITH u.scenario_id = l_src AND u.unit_code = r.source_unit_code
               CONNECT BY PRIOR u.unit_id = u.parent_unit_id
               ORDER SIBLINGS BY u.sort_order) LOOP
      l_parent := uid_of(CASE WHEN c.parent_code = r.source_unit_code THEN r.unit_code ELSE c.parent_code END);
      INSERT INTO org_unit (scenario_id, unit_code, parent_unit_id, unit_type_code, name_ar, source_type_code,
                            source_ref, sort_order, notes)
      VALUES (l_new, c.unit_code, l_parent,
              c.unit_type_code, c.name_ar, 'CARDS', NULL, c.sort_order,
              'لا شريحة لمديريتها في العرض: الوحدة منقولة من البطاقات');
      copy_positions(c.unit_code, c.unit_code, FALSE);
    END LOOP;
  END LOOP;

  -- positions of the cards, for every unit that has a source
  FOR r IN (SELECT row_kind, unit_code, source_unit_code FROM org_load_unit
             WHERE load_code = c_load AND row_kind IN ('UNIT', 'SOURCE') AND source_unit_code IS NOT NULL) LOOP
    copy_positions(r.source_unit_code, r.unit_code, r.row_kind = 'SOURCE');
  END LOOP;

  -- reporting lines that came across
  MERGE INTO org_position t
  USING (SELECT c.position_id, nr.position_id AS new_rep
           FROM org_position s
           JOIN org_position sr ON sr.position_id = s.reports_to_pos_id
           JOIN org_position c  ON c.scenario_id = l_new AND c.position_code = s.position_code
           JOIN org_position nr ON nr.scenario_id = l_new AND nr.position_code = sr.position_code
          WHERE s.scenario_id = l_src) m
  ON (t.position_id = m.position_id)
  WHEN MATCHED THEN UPDATE SET t.reports_to_pos_id = m.new_rep;

  -- the rest: to the head of the nearest unit above (a head starts from its unit's parent)
  FOR p IN (SELECT o.position_id, o.unit_id, o.heads_unit, u.parent_unit_id
              FROM org_position o JOIN org_unit u ON u.unit_id = o.unit_id
             WHERE o.scenario_id = l_new AND o.reports_to_pos_id IS NULL
               AND NOT (u.unit_code = 'U-GOV' AND o.heads_unit = 'Y')) LOOP
    l_from := CASE WHEN p.heads_unit = 'Y' THEN p.parent_unit_id ELSE p.unit_id END;
    SELECT MIN(position_id) KEEP (DENSE_RANK FIRST ORDER BY lv) INTO l_rep
      FROM (SELECT h.position_id, a.lv
              FROM (SELECT unit_id, LEVEL AS lv FROM org_unit
                     START WITH unit_id = l_from CONNECT BY PRIOR parent_unit_id = unit_id) a
              JOIN org_position h ON h.unit_id = a.unit_id AND h.heads_unit = 'Y'
             WHERE h.position_id <> p.position_id);
    UPDATE org_position SET reports_to_pos_id = l_rep, link_method_code = 'FROM_STRUCTURE'
     WHERE position_id = p.position_id;
  END LOOP;

  -- lineage: what the comparison pages read
  INSERT INTO org_unit_lineage (scenario_id, unit_code, source_scenario_id, source_unit_code, relation,
                                confidence, is_open, note)
  SELECT l_new, CASE WHEN row_kind = 'GONE' THEN NULL ELSE unit_code END, l_src, source_unit_code,
         relation, confidence, is_open, note
    FROM org_load_unit WHERE load_code = c_load ORDER BY seq;
  COMMIT;
END;
/
'''
open(out, 'w', encoding='utf-8').write(
    f'-- {name_ar} ({code}): generated by tools/gen_defacto_sql.py from {dir_csv} and {unit_csv}; '
    'do not edit by hand\n'
    f"-- {sum(r['row_kind'] == 'UNIT' for r in rows)} units, {sum(r['row_kind'] == 'SOURCE' for r in rows)} "
    f"merged sources, {sum(r['row_kind'] == 'GONE' for r in rows)} of today's units with no place\n\n"
    + ''.join(stage) + build)
from collections import Counter
print(out, Counter(r['row_kind'] for r in rows), 'carried:', [r['unit_code'] for r in rows if r['carry_subtree'] == 'Y'],
      'placed by the deck:', list(placed_by_deck), f'{len(blocks)} staging blocks')
