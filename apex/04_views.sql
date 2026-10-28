--------------------------------------------------------------------------------
-- 04_views.sql — views for the charts, the card pages and the review queue
--
-- The two chart views are shaped for COM.APEXHIERARCHYCHART.PLUGIN, the same
-- plugin and column names as the NIB application: ID, PARENTID, LEVEL,
-- EMPLOYEENAME, IMAGEURL, OFFICE, POSITIONNAME, DESCRIPTION, CATEGORY_COLOR.
--
-- In both, the CONNECT BY runs alone in an inline view and the joins are made
-- outside it. Joining inside the hierarchical block makes Oracle resolve the
-- join first and the hierarchy second, which silently produces a wrong tree.
--------------------------------------------------------------------------------

-- الهيكل التنظيمي — units only: المحافظة > مديرية > (قسم) > دائرة > شعبة
CREATE OR REPLACE VIEW org_v_chart_unit AS
SELECT h.scenario_id,
       TO_CHAR(h.unit_id)                               AS id,
       TO_CHAR(h.parent_unit_id)                        AS parentid,
       h.lvl                                            AS "LEVEL",
       u.name_ar                                        AS employeename,   -- the box heading
       CAST(NULL AS VARCHAR2(1))                        AS imageurl,
       ut.name_ar                                       AS office,
       COALESCE(hp.title_ar, 'لا توجد بطاقة لرئيس الوحدة') AS positionname,
       (SELECT COUNT(*) FROM org_position p
         WHERE p.scenario_id = u.scenario_id AND p.unit_id = u.unit_id)
         || ' وظيفة'                                    AS description,
       CASE WHEN u.source_type_code = 'DRAFT_DECISION' THEN '#8C6D1F'
            WHEN hp.position_id IS NULL OR hp.is_placeholder = 'Y' THEN '#8A2432'
            ELSE ut.display_colour END                  AS category_color,
       u.unit_code, u.unit_type_code, u.bylaws_article, u.source_type_code, h.sib
  FROM (SELECT unit_id, parent_unit_id, scenario_id, LEVEL AS lvl, ROWNUM AS sib
          FROM org_unit
         START WITH parent_unit_id IS NULL
         CONNECT BY PRIOR unit_id = parent_unit_id
         ORDER SIBLINGS BY sort_order) h
  JOIN org_unit      u  ON u.unit_id = h.unit_id
  JOIN org_unit_type ut ON ut.unit_type_code = u.unit_type_code
  LEFT JOIN org_position hp ON hp.scenario_id = u.scenario_id
                           AND hp.unit_id = u.unit_id AND hp.heads_unit = 'Y';

-- الهيكل الوظيفي — every position, under the position it reports to
CREATE OR REPLACE VIEW org_v_chart_position AS
SELECT h.scenario_id,
       TO_CHAR(h.position_id)                           AS id,
       TO_CHAR(h.reports_to_pos_id)                     AS parentid,
       h.lvl                                            AS "LEVEL",
       p.title_ar                                       AS employeename,
       CAST(NULL AS VARCHAR2(1))                        AS imageurl,
       u.name_ar                                        AS office,
       COALESCE(c.name_ar, 'غير محدد')                  AS positionname,
       CASE lm.confidence
         WHEN 'APPROXIMATE' THEN 'ربط تقريبي: ' || lm.name_ar
         WHEN 'INFERRED'    THEN 'ربط مستنتج: ' || lm.name_ar
       END
       || CASE WHEN p.is_placeholder = 'Y' THEN ' · لا توجد بطاقة' END AS description,
       -- colour carries the question the reviewer asks: is this box backed by a card,
       -- and is its line stated or inferred? The grade is already in POSITIONNAME.
       CASE WHEN p.is_placeholder = 'Y'          THEN '#8A2432'
            WHEN lm.confidence <> 'STATED'       THEN '#9A5B00'
            ELSE COALESCE(c.display_colour, '#2B6CA3') END AS category_color,
       p.position_code, p.card_id, j.card_code, p.heads_unit, p.is_placeholder,
       lm.confidence AS link_confidence, u.unit_code, h.sib
  FROM (SELECT position_id, reports_to_pos_id, scenario_id, LEVEL AS lvl, ROWNUM AS sib
          FROM org_position
         START WITH reports_to_pos_id IS NULL
         CONNECT BY PRIOR position_id = reports_to_pos_id
         ORDER SIBLINGS BY sort_order) h
  JOIN org_position    p  ON p.position_id = h.position_id
  JOIN org_unit        u  ON u.unit_id = p.unit_id
  JOIN org_link_method lm ON lm.link_method_code = p.link_method_code
  LEFT JOIN jd_card    j  ON j.card_id = p.card_id
  LEFT JOIN jd_class   c  ON c.class_code = j.class_code;

-- one row per card, with its place in each scenario that uses it
CREATE OR REPLACE VIEW jd_v_card AS
SELECT j.card_id, j.card_code, j.bylaws_article, j.title_ar,
       c.name_ar  AS class_ar,  j.class_raw,
       q.name_ar  AS qual_ar,   j.qual_raw, j.specialisation,
       j.experience_years, j.experience_raw, j.training, j.other_knowledge,
       e.name_ar  AS effort_ar, j.effort_raw,
       j.loc_directorate, j.loc_department, j.loc_section, j.loc_office, j.supervisor_raw,
       j.status, j.source_file, j.source_seq, b.batch_code,
       (SELECT COUNT(*) FROM jd_card_task t WHERE t.card_id = j.card_id) AS task_count,
       p.scenario_id, p.position_id, p.position_code, u.unit_code, u.name_ar AS unit_ar,
       sp.title_ar AS reports_to_ar, lm.name_ar AS link_method_ar, lm.confidence AS link_confidence
  FROM jd_card j
  JOIN dg_batch b ON b.batch_id = j.batch_id
  LEFT JOIN jd_class      c ON c.class_code = j.class_code
  LEFT JOIN jd_qual_level q ON q.qual_level_code = j.qual_level_code
  LEFT JOIN jd_effort     e ON e.effort_code = j.effort_code
  LEFT JOIN org_position  p ON p.card_id = j.card_id
  LEFT JOIN org_unit      u ON u.unit_id = p.unit_id
  LEFT JOIN org_position sp ON sp.position_id = p.reports_to_pos_id
  LEFT JOIN org_link_method lm ON lm.link_method_code = p.link_method_code;

-- what a person from DG has to confirm: every box or line not stated by a card
CREATE OR REPLACE VIEW org_v_review AS
SELECT p.scenario_id, p.position_id, p.position_code, p.title_ar,
       u.name_ar AS unit_ar, u.bylaws_article,
       CASE WHEN p.is_placeholder = 'Y'          THEN 'NO_CARD'
            WHEN lm.confidence = 'NONE'          THEN 'NO_SUPERVISOR'
            ELSE lm.confidence END               AS issue,
       CASE WHEN p.is_placeholder = 'Y'          THEN 'وحدة يشير إليها غيرها ولا توجد بطاقة لرئيسها'
            WHEN lm.confidence = 'NONE'          THEN 'لم يُحدَّد الرئيس المباشر'
            ELSE lm.name_ar END                  AS issue_ar,
       j.card_code, j.supervisor_raw, sp.title_ar AS linked_to_ar,
       (SELECT COUNT(*) FROM org_position k WHERE k.reports_to_pos_id = p.position_id) AS reports
  FROM org_position p
  JOIN org_unit        u  ON u.unit_id = p.unit_id
  JOIN org_link_method lm ON lm.link_method_code = p.link_method_code
  LEFT JOIN jd_card      j  ON j.card_id = p.card_id
  LEFT JOIN org_position sp ON sp.position_id = p.reports_to_pos_id
 WHERE p.is_placeholder = 'Y' OR lm.confidence <> 'STATED';

-- DG's staff sheet against the units, for the dashboard
CREATE OR REPLACE VIEW dg_v_staff_by_unit AS
SELECT s.batch_id, s.row_label, s.unit_code, s.match_kind,
       SUM(CASE WHEN s.edu_category IN ('ENG','HUMANITIES','BASIC_SCI','MEDICAL') THEN s.staff END) AS university,
       SUM(CASE WHEN s.edu_category = 'INSTITUTE' THEN s.staff END)                               AS institute,
       SUM(CASE WHEN s.edu_category IN ('SECONDARY','VOCATIONAL') THEN s.staff END)               AS secondary,
       SUM(s.staff)                                                                               AS total
  FROM dg_staff_count s
 GROUP BY s.batch_id, s.row_label, s.unit_code, s.match_kind;

-- a scenario against the one it was built from, unit by unit, as recorded in
-- org_unit_lineage. Counts are of each unit's whole subtree, in its own scenario.
CREATE OR REPLACE VIEW org_v_scenario_compare AS
SELECT l.lineage_id, l.scenario_id, l.source_scenario_id,
       l.unit_code, u.name_ar AS unit_ar,
       CASE WHEN u.unit_type_code IN ('SECTOR','GOVERNORATE') THEN u.name_ar
            WHEN pu.unit_type_code = 'SECTOR' THEN pu.name_ar
            WHEN u.unit_id IS NOT NULL THEN 'يتبع المحافظ مباشرة'
       END AS sector_ar,
       CASE WHEN u.unit_type_code IN ('SECTOR','GOVERNORATE') THEN u.sort_order
            WHEN pu.unit_type_code = 'SECTOR' THEN pu.sort_order
            WHEN u.unit_id IS NOT NULL THEN 0 ELSE 9999 END AS sector_sort,
       l.relation,
       DECODE(l.relation, 'SAME', 'كما هي', 'RENAMED', 'تغيّر اسمها', 'MERGED', 'دُمجت',
                          'SPLIT', 'فُصلت', 'NEW', 'جديدة', 'ABOLISHED', 'لم توضع') AS relation_ar,
       l.confidence, l.is_open, l.note,
       l.source_unit_code, su.name_ar AS source_unit_ar,
       (SELECT COUNT(*) FROM org_position p
         WHERE p.scenario_id = l.source_scenario_id
           AND p.unit_id IN (SELECT unit_id FROM org_unit
                              START WITH scenario_id = l.source_scenario_id AND unit_code = l.source_unit_code
                              CONNECT BY PRIOR unit_id = parent_unit_id))           AS source_positions,
       (SELECT COUNT(p.card_id) FROM org_position p
         WHERE p.scenario_id = l.source_scenario_id
           AND p.unit_id IN (SELECT unit_id FROM org_unit
                              START WITH scenario_id = l.source_scenario_id AND unit_code = l.source_unit_code
                              CONNECT BY PRIOR unit_id = parent_unit_id))           AS source_cards,
       (SELECT COUNT(*) FROM org_position p
         WHERE p.scenario_id = l.scenario_id
           AND p.unit_id IN (SELECT unit_id FROM org_unit
                              START WITH scenario_id = l.scenario_id AND unit_code = l.unit_code
                              CONNECT BY PRIOR unit_id = parent_unit_id))           AS positions
  FROM org_unit_lineage l
  LEFT JOIN org_unit u  ON u.scenario_id = l.scenario_id AND u.unit_code = l.unit_code
  LEFT JOIN org_unit pu ON pu.unit_id = u.parent_unit_id
  LEFT JOIN org_unit su ON su.scenario_id = l.source_scenario_id AND su.unit_code = l.source_unit_code;
