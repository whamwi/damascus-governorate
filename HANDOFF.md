# Handoff — DG work so far (27/10/2026)

Written by the cloud session that started this repository, for the session
that continues it on the Mac. Read this first, then `apex/README.md`.

## The project

Damascus Governorate (محافظة دمشق, "DG") is a new client. It is kept
**completely separate from NIB**: own repository (this one), own Oracle schema
and APEX workspace (`DG`, same 26ai instance as NIB). Nothing from
`nib-org-chart` or `qms-document-control` goes here, and the reverse.

## What DG sent (batch 2026-10-27)

`incoming/2026-10-27/OneDrive_1_10-27-2026/`, 79 files, also on the Mac at
`~/Downloads/OneDrive_1_10-27-2026`:
- the bylaws (Decision 623/ن of 2003, amended 504/ن of 2004), articles 16–46,
  one file per directorate. **Pages 1–30 / articles 1–15 were not sent.**
- 848 job description cards (بطاقات وصف) in Word tables;
- `توزيع العاملين.xlsx`: 1,337 staff by unit and education. It is not a
  headcount: nobody below secondary school is counted;
- a draft 2020 ministerial decision adding مديرية إعادة الإعمار والتأهيل (no number).

Findings: `analysis/2026-10-27_first_read.md`. Structure derived from the cards:
`analysis/2026-10-27_hierarchy.md` and `analysis/2026-10-27_org_tree.html`.

## What is built

- `tools/`: convert (LibreOffice) → parse cards → build hierarchy → generate SQL.
- `analysis/unit_map.csv` and `analysis/unit_aliases.csv`: hand-maintained
  matches. Review these before regenerating; never automate them away.
- `apex/`: schema (13 tables, views for the hierarchy-chart plugin, review
  queue, `ORG_SCENARIO_PKG`) and generated load scripts for batch 2026-10-27.
  `apex/install.sql` runs it all.

## Not done yet — start here

1. **The SQL has never been run.** The cloud session had no database. Create
   schema/workspace `DG`, run `apex/install.sql`, fix whatever fails, and check
   the counts in `apex/README.md` §2. If you run over ORDS, configure
   `ords-mcp` (in the NIB repo, `tools/ords-mcp`) with DG's **own** URL and
   credentials, never NIB's.
2. Build the APEX application. The page plan is in `apex/README.md` §4. The
   chart regions use the same plugin settings as NIB app 135 pages 10–11.
3. Questions waiting on DG are at the end of `analysis/2026-10-27_first_read.md`.

## Conventions

- Commit to `main` here. Generated files under `apex/data/` are rebuilt, never
  hand-edited.
- Files in `incoming/` are kept exactly as received.
- Keep each card's original text (`*_RAW`, `LOC_*`) next to any normalised value.
