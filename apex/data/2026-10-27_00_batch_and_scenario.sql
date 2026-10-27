-- run once per batch, before the data files
MERGE INTO dg_batch t USING (SELECT '2026-10-27' c FROM dual) s ON (t.batch_code = s.c)
WHEN NOT MATCHED THEN INSERT (batch_code, received_on, description, repo_path)
VALUES ('2026-10-27', DATE '2026-10-27',
        'OneDrive_1_10-27-2026: النظام الداخلي المواد 16-46، بطاقات الوصف، توزيع العاملين، مسودة قرار 2020',
        'incoming/2026-10-27');

-- The AS-IS from the cards is rebuilt from scratch on each load, children first:
-- positions reference units, so a single cascading delete of the scenario could
-- reach the units before the positions. The last DELETE fails if a TO-BE was
-- cloned from this scenario: reloading under a live draft has to be a decision.
DELETE FROM org_position WHERE scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS');
DELETE FROM org_unit     WHERE scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS');
DELETE FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS';

INSERT INTO org_scenario (scenario_code, name_ar, name_en, scenario_type, status, legal_basis,
                          effective_from, batch_id, description)
SELECT 'DG_ASIS_CARDS', 'الهيكل القائم كما تصفه بطاقات الوصف الوظيفي', 'AS-IS structure as described by the job cards',
       'AS_IS', 'UNDER_REVIEW',
       'القرار 623/ن تاريخ 7/9/2003 المعدل بالقرار 504/ن تاريخ 8/7/2004؛ ومديرية إعادة الإعمار بمسودة قرار غير صادر',
       DATE '2004-07-08', batch_id,
       'مبني آلياً من 848 بطاقة: موقع الوظيفة والرئيس المباشر. الروابط غير المؤكدة في org_v_review.'
  FROM dg_batch WHERE batch_code = '2026-10-27';
COMMIT;
