--------------------------------------------------------------------------------
-- 05_package.sql — ORG_SCENARIO_PKG: copy a scenario, and check one
--
-- CLONE_SCENARIO is how a restructuring starts: copy the AS-IS, then edit the
-- copy. Codes are kept, ids are new, and every parent / supervisor id is
-- remapped through the code, so the copy is a separate tree that can be
-- compared with its source box by box.
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE org_scenario_pkg AS
  FUNCTION clone_scenario (p_source_id   IN NUMBER,
                           p_new_code    IN VARCHAR2,
                           p_new_name_ar IN VARCHAR2,
                           p_type        IN VARCHAR2 DEFAULT 'TO_BE') RETURN NUMBER;

  -- one line per problem; an empty result means the scenario is a clean tree
  FUNCTION validate (p_scenario_id IN NUMBER) RETURN sys.odcivarchar2list;
END org_scenario_pkg;
/

CREATE OR REPLACE PACKAGE BODY org_scenario_pkg AS

  FUNCTION clone_scenario (p_source_id   IN NUMBER,
                           p_new_code    IN VARCHAR2,
                           p_new_name_ar IN VARCHAR2,
                           p_type        IN VARCHAR2 DEFAULT 'TO_BE') RETURN NUMBER IS
    l_new   NUMBER;
    l_src   org_scenario%ROWTYPE;
  BEGIN
    -- INSERT ... SELECT cannot RETURN INTO, so read the source first
    SELECT * INTO l_src FROM org_scenario WHERE scenario_id = p_source_id;
    INSERT INTO org_scenario (scenario_code, name_ar, scenario_type, status, legal_basis,
                              cloned_from_id, description)
    VALUES (p_new_code, p_new_name_ar, p_type, 'DRAFT', l_src.legal_basis, l_src.scenario_id,
            'نسخة من ' || l_src.scenario_code)
    RETURNING scenario_id INTO l_new;

    -- units without parents first, then the parents by code
    INSERT INTO org_unit (scenario_id, unit_code, unit_type_code, name_ar, name_en, bylaws_article,
                          legal_basis, source_type_code, source_ref, is_active, sort_order, notes)
    SELECT l_new, unit_code, unit_type_code, name_ar, name_en, bylaws_article,
           legal_basis, source_type_code, source_ref, is_active, sort_order, notes
      FROM org_unit WHERE scenario_id = p_source_id;

    MERGE INTO org_unit t
    USING (SELECT c.unit_id, np.unit_id AS new_parent
             FROM org_unit s
             JOIN org_unit sp ON sp.unit_id = s.parent_unit_id
             JOIN org_unit c  ON c.scenario_id = l_new AND c.unit_code = s.unit_code
             JOIN org_unit np ON np.scenario_id = l_new AND np.unit_code = sp.unit_code
            WHERE s.scenario_id = p_source_id) m
    ON (t.unit_id = m.unit_id)
    WHEN MATCHED THEN UPDATE SET t.parent_unit_id = m.new_parent;

    INSERT INTO org_position (scenario_id, position_code, unit_id, card_id, title_ar, heads_unit,
                              is_deputy, is_placeholder, link_method_code, headcount, status,
                              sort_order, source_type_code, notes)
    SELECT l_new, p.position_code, nu.unit_id, p.card_id, p.title_ar, p.heads_unit,
           p.is_deputy, p.is_placeholder, p.link_method_code, p.headcount, p.status,
           p.sort_order, p.source_type_code, p.notes
      FROM org_position p
      JOIN org_unit su ON su.unit_id = p.unit_id
      JOIN org_unit nu ON nu.scenario_id = l_new AND nu.unit_code = su.unit_code
     WHERE p.scenario_id = p_source_id;

    MERGE INTO org_position t
    USING (SELECT c.position_id, nr.position_id AS new_rep
             FROM org_position s
             JOIN org_position sr ON sr.position_id = s.reports_to_pos_id
             JOIN org_position c  ON c.scenario_id = l_new AND c.position_code = s.position_code
             JOIN org_position nr ON nr.scenario_id = l_new AND nr.position_code = sr.position_code
            WHERE s.scenario_id = p_source_id) m
    ON (t.position_id = m.position_id)
    WHEN MATCHED THEN UPDATE SET t.reports_to_pos_id = m.new_rep;

    RETURN l_new;
  END clone_scenario;

  FUNCTION validate (p_scenario_id IN NUMBER) RETURN sys.odcivarchar2list IS
    l_out sys.odcivarchar2list := sys.odcivarchar2list();
    PROCEDURE add (p VARCHAR2) IS BEGIN l_out.EXTEND; l_out(l_out.COUNT) := SUBSTR(p, 1, 4000); END;
  BEGIN
    FOR r IN (SELECT position_code FROM (
                SELECT position_code, CONNECT_BY_ISCYCLE cyc FROM org_position
                 WHERE scenario_id = p_scenario_id
                 START WITH scenario_id = p_scenario_id
                 CONNECT BY NOCYCLE PRIOR position_id = reports_to_pos_id
                        AND scenario_id = p_scenario_id) WHERE cyc = 1) LOOP
      add('CYCLE: ' || r.position_code || ' تقع في حلقة تبعية');
    END LOOP;

    FOR r IN (SELECT COUNT(*) n FROM org_position
               WHERE scenario_id = p_scenario_id AND reports_to_pos_id IS NULL HAVING COUNT(*) > 1) LOOP
      add('ROOTS: ' || r.n || ' وظيفة بلا رئيس — يجب أن يكون للهيكل رأس واحد');
    END LOOP;

    FOR r IN (SELECT u.unit_code, u.name_ar FROM org_unit u
               WHERE u.scenario_id = p_scenario_id AND u.parent_unit_id IS NOT NULL
                 AND NOT EXISTS (SELECT 1 FROM org_position p
                                  WHERE p.unit_id = u.unit_id AND p.heads_unit = 'Y')) LOOP
      add('NO_HEAD: ' || r.unit_code || ' ' || r.name_ar || ' — لا رئيس لها');
    END LOOP;

    FOR r IN (SELECT u.unit_code, COUNT(*) n FROM org_position p JOIN org_unit u ON u.unit_id = p.unit_id
               WHERE p.scenario_id = p_scenario_id AND p.heads_unit = 'Y'
               GROUP BY u.unit_code HAVING COUNT(*) > 1) LOOP
      add('TWO_HEADS: ' || r.unit_code || ' — ' || r.n || ' رؤساء');
    END LOOP;
    RETURN l_out;
  END validate;

END org_scenario_pkg;
/
