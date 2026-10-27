--------------------------------------------------------------------------------
-- 02_triggers.sql — who changed a row, and when
--
-- Only the audit columns. Integrity lives in constraints (01_tables.sql).
--------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER org_scenario_bu
BEFORE UPDATE ON org_scenario FOR EACH ROW
BEGIN
  :new.updated_by := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER);
  :new.updated_on := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER org_unit_bu
BEFORE UPDATE ON org_unit FOR EACH ROW
BEGIN
  :new.updated_by := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER);
  :new.updated_on := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER org_position_bu
BEFORE UPDATE ON org_position FOR EACH ROW
BEGIN
  :new.updated_by := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER);
  :new.updated_on := SYSTIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER jd_card_bu
BEFORE UPDATE ON jd_card FOR EACH ROW
BEGIN
  :new.updated_by := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER);
  :new.updated_on := SYSTIMESTAMP;
END;
/
