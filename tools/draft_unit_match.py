#!/usr/bin/env python3
"""Draft the match of a structure deck's units to today's units, for review by hand.

    python3 tools/draft_unit_match.py <deck_units.csv> <directorate_map.csv> <asis_subunits.json> <out.csv>

deck_units.csv       tools/read_structure_deck.py output
directorate_map.csv  the reviewed directorate mapping (defacto_code, defacto_name, asis_codes…)
asis_subunits.json   today's units under each directorate: dir_code, unit_code, unit_type_code,
                     name_ar, parent_code, positions (one query, see the README)

Within each directorate only, a unit whose normalised name equals one of today's
is matched (EXACT); the closest of today's above SUGGEST is offered for review
(SUGGESTED); anything else has no card today (NONE). Today's units no box
matched are listed too (NOT_IN_DECK), so nothing drops out silently. This file
proposes; analysis/<date>_defacto_units.csv is what gets reviewed and loaded.
"""
import csv, difflib, json, re, sys, unicodedata

SUGGEST = 0.78


def key(s):
    s = unicodedata.normalize('NFKC', s or '').replace('ـ', '')
    s = re.sub('[أإآ]', 'ا', s).replace('ة', 'ه').replace('ى', 'ي').replace('ؤ', 'و').replace('ئ', 'ي')
    s = re.sub('[\u064B-\u0652\u0670]', '', s)                     # diacritics: ذاتياً = ذاتيا
    s = re.sub(r'[\d١٢٣٤٥٦٧٨٩٠/()،,.\-–]', ' ', s)
    s = re.sub(r'(^|\s)و\s*(?=\S)', ' ', s)                        # «و الأرصفة» = «والأرصفة» = «الأرصفة»
    words = [w[2:] if w.startswith('ال') and len(w) > 3 else w for w in s.split()]
    return ' '.join(w for w in words if w not in ('في', 'من'))


def same(a, b):
    # a missing space («شعبةالتحقيق») is still the same name
    squash = lambda s: re.sub('ال', '', s.replace(' ', ''))
    return a == b or squash(a) == squash(b)


def directorate_of(root, mapping):
    """The mapping row whose name is closest to the chart's root box."""
    r = key(re.sub(r'^(مدير|مسؤول)\s+', '', root))
    # a short title inside a longer name («النظافة» in «النظافة ومعالجة النفايات») wins over a near spelling
    contains = lambda m: all(w in key(m['defacto_name']).split() for w in r.split())
    best = max(mapping, key=lambda m: (contains(m), difflib.SequenceMatcher(None, r, key(m['defacto_name'])).ratio()))
    return best, difflib.SequenceMatcher(None, r, key(best['defacto_name'])).ratio()


if __name__ == '__main__':
    deck_csv, map_csv, asis_json, out = sys.argv[1:5]
    deck = list(csv.DictReader(open(deck_csv, encoding='utf-8')))
    mapping = [m for m in csv.DictReader(open(map_csv, encoding='utf-8')) if m['defacto_code']]
    asis = json.load(open(asis_json, encoding='utf-8'))

    by_slide = {}
    for r in deck:
        by_slide.setdefault(r['slide'], []).append(r)
    rows, used = [], set()
    for slide, units in by_slide.items():
        root = units[0]['directorate']
        if slide == '5':
            continue                    # the top level: grouping, read separately
        m, score = directorate_of(root, mapping)
        srcs = [c for c in m['asis_codes'].split('|') if c]
        pool = [a for a in asis if a['dir_code'] in srcs]
        for u in units:
            if u['type'] == 'PERSON':
                continue
            k = key(u['unit'])
            exact = [a for a in pool if same(key(a['name_ar']), k) and a['unit_code'] not in used]
            if exact:
                a, how, conf = exact[0], 'EXACT', 'high'
            else:
                cands = sorted(((difflib.SequenceMatcher(None, k, key(a['name_ar'])).ratio(), a)
                                for a in pool if a['unit_code'] not in used), key=lambda x: -x[0])
                a, how, conf = (cands[0][1], 'SUGGESTED', 'review') if cands and cands[0][0] >= SUGGEST else (None, 'NONE', 'high')
            if a:
                used.add(a['unit_code'])
            if u['edge'] == 'UNATTACHED':
                conf = 'review'
            rows.append({'slide': slide, 'defacto_dir': m['defacto_code'], 'dir_name': m['defacto_name'],
                         'dir_match_score': f'{score:.2f}', 'unit': u['unit'], 'parent': u['parent'],
                         'type': u['type'], 'edge': u['edge'], 'match': how,
                         'asis_code': a['unit_code'] if a else '', 'asis_name': a['name_ar'] if a else '',
                         'asis_positions': a['positions'] if a else '', 'confidence': conf, 'note': ''})
        for a in pool:
            if a['unit_code'] not in used:
                used.add(a['unit_code'])
                rows.append({'slide': slide, 'defacto_dir': m['defacto_code'], 'dir_name': m['defacto_name'],
                             'dir_match_score': f'{score:.2f}', 'unit': '', 'parent': '', 'type': a['unit_type_code'],
                             'edge': '', 'match': 'NOT_IN_DECK', 'asis_code': a['unit_code'], 'asis_name': a['name_ar'],
                             'asis_positions': a['positions'], 'confidence': 'review', 'note': ''})
    with open(out, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader(); w.writerows(rows)
    from collections import Counter
    print(Counter(r['match'] for r in rows), Counter(r['confidence'] for r in rows))
