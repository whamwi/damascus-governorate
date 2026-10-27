# DG — the structure as the job cards show it

Outputs:
- `analysis/2026-10-27_org_tree.html` — collapsible tree, searchable. Open it in a browser.
- `analysis/2026-10-27_hierarchy.xlsx` — one row per position with its parent and how it was linked.

Rebuild: `tools/convert.sh`, then `tools/build_hierarchy.py <work>/docx analysis/unit_map.csv analysis/<date>_hierarchy.xlsx`.

This is the structure **as described by the cards**, not an approved chart.
It should be checked against the organisation chart in pages 1–30 of the
bylaws once DG sends them.

## How a card is linked

Every card carries two fields:

- **موقع الوظيفة في التنظيم** — المديرية / الدائرة / الشعبة, sometimes a قسم,
  مكتب or فرع. This gives the unit path.
- **اسم عمل الرئيس المباشر** — the supervisor, written as a **role**, not a
  name: «رئيس الدائرة», «المدير», «المحافظ».

The role is resolved against the card's own path. «رئيس الدائرة» on a card in
دائرة الديوان of مكتب المحافظ points to the card that heads that دائرة. When
the supervisor names a unit («رئيس دائرة المشاتل», «ر.ش. التقاعد»), that unit
is matched by name inside the same directorate.

When a unit is referenced but no card describes its head, a **placeholder head**
is created. That is a gap in the card set, not a guess about people.

## Results

| | Cards |
|---|---|
| Cards | 848 |
| Linked to a supervisor | 819 (96%) |
| — directly from the card's own fields | 767 |
| — approximate or inferred from the structure (flagged) | 52 |
| Not linked | 29 |
| Placeholder heads (unit referenced, no head card) | 21 |

No cycles. At most five levels below the Governor. 34 positions report directly
to the Governor: the directorate heads, أمين السر and سكرتير المحافظ.

**Flagged links (52)** are of three kinds, each marked in the tree:
- «معاون المدير» when a directorate has several deputies and the card does not
  say which (26) → linked to the director;
- the supervisor is «رئيس الشعبة» but the card names only its دائرة (15) →
  linked to the head of the دائرة;
- no supervisor written, but the card heads a unit (11) → linked to the head of
  the unit above. The whole of the 2020 reconstruction directorate is like this,
  because its template has no supervisor field.

**Not linked (29)** — the cards themselves are incomplete:
- 13 name a supervisor by function: «محاسب النفقات الادارية» (seven in الشؤون
  المالية), «رئيس لجنة الشراء», «محاسب الادارة»;
- 6 have no supervisor and head nothing (engineers in الخدمات الفنية, a كاتب);
- 5 give a supervisor at a level the card does not state;
- 5 name as supervisor the unit they head themselves. Example: «رئيس غرفة
  العمليات» reports to «رئيس الفرع» without saying which فرع.

## Spelling variants

The same unit is often spelt several ways: «الخزينة», «الخزينة والإيرادات»,
«الخزينة والإرادات». Eleven clear cases are merged through
`analysis/unit_aliases.csv`, a file reviewed by hand. The card text itself is
never changed. Merging them cut the placeholder heads from 29 to 21, because
the merged units then found their head cards. Similar names that may well be
different units (القضاء العادي / الإداري, الحسابات / الصندوق, المراقبة /
مراقبة الدوام) are left separate until DG confirms.

## Two directorates are not built like the others

The usual order is المدير → دائرة → شعبة. The cards show two exceptions:

- **17 الخدمات الفنية**: المدير → **قسم** (three, each headed by «معاون مدير
  ورئيس قسم») → دائرة → شعبة.
- **38 فوج الإطفاء**: قائد الفوج → **فرع** → شعبة / ورشة / غرفة, with military
  ranks alongside (قائد السرية, آمر زمرة, آمر فئة).

## Findings from the tree

- **21 units have no head card**. Examples: دائرة الشؤون الإدارية in الشؤون
  الصحية (6 positions under it), دائرة محاسبة المشاريع and دائرة الرواتب
  والأجور in الشؤون المالية, شعبة الخدمات in دار الكرامة (4 positions), and
  شعبة الإدارية in دوائر الخدمات (3). The full list is in the tree, in red.
- **2020 reconstruction**: the cards add a «دائرة الديوان» that is not in
  article 2 of the draft decision (2 دوائر, 4 شعب). The director's card uses a
  newer template (الفئة الوظيفية, عدد مراكز العمل) that no other card uses.
- **17 الخدمات الفنية**: the card for رئيس دائرة الشؤون القانونية reports to
  the director, while the cards of its شعب place them inside قسم الشؤون
  الإدارية والقانونية والمالية. One of the two is wrong.
- **Deputies are not tied to units.** In most directorates «معاون المدير» is a
  card without a portfolio. Cards that report to the deputy cannot say which
  one, which is why 26 links fall back to the director.
