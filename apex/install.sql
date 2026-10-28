-- DG schema: run from SQLcl or SQL Developer connected as the DG schema owner,
-- from the apex/ directory. APEX SQL Workshop > SQL Scripts runs each file too.
-- Every file is rerunnable.
@01_tables.sql
@02_triggers.sql
@03_lookups.sql
@04_views.sql
@05_package.sql

-- data, one batch at a time, in file order
@data/2026-10-27_00_batch_and_scenario.sql
@data/2026-10-27_01_units.sql
@data/2026-10-27_02_cards.sql
@data/2026-10-27_03_tasks.sql
@data/2026-10-27_04_positions.sql
@data/2026-10-27_05_reporting_lines.sql
@data/2026-10-27_06_staff_counts.sql

-- the proposed structure 3.1 (TO-BE), built from the batch above
@data/2026-10-28_tobe_3_1.sql

-- the de facto structure (deck of 28/10) and DG's headcount of 30/9
@data/2026-10-28_defacto.sql
@data/2026-09-30_headcount.sql

-- expect no rows. VALIDATE is a reserved word in SQL (ORA-01747), so the call
-- needs quotes here; PL/SQL callers can write it plainly.
SELECT column_value AS problem
  FROM TABLE(org_scenario_pkg."VALIDATE"(
         (SELECT scenario_id FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS')))
 WHERE column_value NOT LIKE 'NO_HEAD:%';
