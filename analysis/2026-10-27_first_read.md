# DG — first read of the 27/10/2026 batch

Source: `incoming/2026-10-27/OneDrive_1_10-27-2026/`, 79 files.
Register: `analysis/2026-10-27_register.xlsx` (sheets الوحدات, البطاقات, جدول العاملين).
Rebuild with `tools/convert.sh` then `tools/build_register.py`.

## What was sent

Three different things:

| What | Files | Content |
|---|---|---|
| Bylaws, functional tasks | 38 | One file per unit: its article, tasks, and the دوائر/شعب it is made of |
| Job description cards (بطاقات وصف) | 40 | **847 cards**, 5,972 task lines |
| Staff distribution | 1 xlsx | 38 units × 7 education categories, **1,337 staff** |

The bylaws are **Decision 623/ن of 7/9/2003, amended by 504/ن of 8/7/2004**
(النظام الداخلي لمحافظة دمشق). Named in the 2020 file.

What we have is **Part 4 (الباب الرابع), articles 16–46**, without a gap. The
folder names carry the page ranges of the source document (31–46, 47–53,
54–168, 169, 172). So **pages 1–30 were not sent**: articles 1–15, the
general provisions, and presumably the governor, the council and the
executive office, plus the organisation chart itself if there is one.

- Article 16 — أمانة السر, seven directorates/departments (files 16/1–7) and a card for أمين السر.
- Article 17 — الخدمات الفنية.
- Articles 18–44 — القطاع البلدي, 27 directorates.
- Articles 45–46 — دار الكرامة, الأنشطة الرياضية.
- **2020 مديرية إعادة الإعمار والتأهيل** — a **draft** decision of the Minister of
  Local Administration, number left blank, adding the directorate to 623/ن with
  two دوائر and four شعب, and 7 cards. It is not part of the bylaws until issued.

## Each card

One Word table per card, always the same four columns: الموقع في التنظيم
(directorate/department/section + direct supervisor), المسمى, التصنيف, الشروط
(qualification, specialisation, experience, training, effort type). Tasks follow
as a list.

| Classification | Cards |
|---|---|
| إداري | 318 |
| إدارة وسطى | 299 |
| إدارة عليا | 89 |
| فني | 75 |
| خدمي | 62 |
| other / blank | 4 |

| Required qualification | Cards |
|---|---|
| جامعي | 664 |
| معهد | 62 |
| ثانوي | 51 |
| ابتدائي / محو أمية | 41 |
| إعدادي | 18 |
| كلية عسكرية / شرطة | 9 |

The classification is written 58 different ways, and the effort type 19 ("فكري + جسدي", "فكري – جسدي",
"إداري+ فني", "ادراة وسطى"…). The register keeps the original text and adds a
normalised column beside it.

## Reconciling the three sources

The full table is sheet الوحدات. Units are joined by hand in
`analysis/unit_map.csv`, because the three sources name units differently.

**Units in the bylaws with no staff row** — 16.4 الشؤون العامة والقانونية,
16.7 المراسلات والمتابعة, 37 الميكانيك والكهرباء, 41 قسم الشرطة, **44 الإنتاج
(31 cards)**.

**Staff rows with no article and no cards** — 120 staff in all:

| Staff row | Staff |
|---|---|
| مراكز خدمة المواطن | 84 |
| تنفيذ المرسوم /66/ | 24 |
| قسم الجاهزية | 6 |
| دعم القرار والتخطيط الإقليمي | 5 |
| الشكاوي والتظلم | 1 |
| التنمية المحلية | 0 |

These are units created after 2004 and never written into the bylaws we have.

**Assumed matches, to confirm with DG**
- التنمية الإدارية (63 staff) ↔ both HR units in the bylaws, 16.3 شؤون العاملين
  and 22 الشؤون الإدارية وشؤون العاملين. The register shows the 63 on both rows;
  do not add them up.
- البيئة (15) ↔ 40 معالجة مخلفات الدباغة.
- الصيانة والإنارة ↔ 34 الصيانة, perhaps also 37 الميكانيك والكهرباء.

**Cards against people.** Several units have more cards than staff:
دار الكرامة 44 cards / 12 staff, مكتب المحافظ 23 / 6, العلاقات العامة 13 / 1,
الصحافة 10 / 1, المركبات 31 / 14. Either the cards describe positions that are
vacant, or the staff sheet is incomplete. The next point suggests the second.

## The staff sheet is not a headcount

- Its seven columns are education categories from secondary school up.
  **Nobody below secondary is counted**, yet 59 cards ask for إعدادي, ابتدائي
  or محو أمية. So النظافة at 51 staff and الحدائق at 68 leave out the field
  workers who make up most of those directorates.
- Every cell is a `COUNTIF` over an external HR file (`[1]data!AT:AT`) that was
  not sent. That file is the real staff list, and we should ask for it.
- Internally consistent: the 38 rows sum to exactly the total row (1,337).

## Content that is out of date

The bylaws and cards predate 2025 and still assign work tied to the Ba'ath
party, in four units:
- 16.1 المجالس المحلية — mail from «فرع دمشق لحزب البعث» (article and cards);
- 18 مكتب المحافظ — «البريد الحزبي» (article and cards);
- 33 دوائر الخدمات — «ممثلي الفرق الحزبية في الحي» (cards);
- 37 الميكانيك والكهرباء — «الفرق الحزبية» (article).

Any revision will have to remove or replace these.

## Data-quality notes on the cards

- 17 cards have no directorate filled in; the article is known from the file.
- 10 cards repeat an earlier one exactly, same unit and title. Several are
  blank generic templates (رئيس دائرة ×3, رئيس شعبة ×4).
- 38 cards state no experience, and 75 no effort type.
- Article 41 (police section) has no cards at all.

## To ask DG

1. Pages 1–30 of the bylaws (articles 1–15) and the current organisation chart.
2. The HR file behind the staff sheet (`data`, column AT), or any staff list
   with unit, job title and grade.
3. Whether the 2020 reconstruction decision was issued, and its number.
4. The decisions creating مراكز خدمة المواطن, تنفيذ المرسوم 66, دعم القرار,
   قسم الجاهزية, الشكاوي والتظلم and التنمية المحلية.
5. Whether التنمية الإدارية replaced both HR units, and whether الإنتاج,
   الميكانيك والكهرباء and قسم الشرطة still exist.
6. What the engagement is meant to produce: a new structure, revised cards,
   a manpower plan, or something else.
