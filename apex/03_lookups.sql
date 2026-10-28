--------------------------------------------------------------------------------
-- 03_lookups.sql — reference values. MERGE, so it can be rerun.
--------------------------------------------------------------------------------

MERGE INTO org_unit_type t USING (
  SELECT 'GOVERNORATE' c, 'المحافظة'      ar, 'Governorate'    en, 1 lv, '#0B2545' col, 10 so FROM dual UNION ALL
  SELECT 'SECRETARIAT',   'أمانة السر',    'Secretariat',        2,    '#13315C',     20    FROM dual UNION ALL
  SELECT 'DIRECTORATE',   'مديرية',        'Directorate',        2,    '#134074',     30    FROM dual UNION ALL
  SELECT 'QISM',          'قسم',           'Division',           3,    '#1D5C8A',     40    FROM dual UNION ALL
  SELECT 'BRANCH',        'فرع',           'Branch',             3,    '#1D5C8A',     45    FROM dual UNION ALL
  SELECT 'DEPARTMENT',    'دائرة',         'Department',         3,    '#2B6CA3',     50    FROM dual UNION ALL
  SELECT 'SECTION',       'شعبة',          'Section',            4,    '#4A88BD',     60    FROM dual UNION ALL
  SELECT 'OFFICE',        'مكتب',          'Office',             4,    '#6A9FCC',     70    FROM dual UNION ALL
  SELECT 'WORKSHOP',      'ورشة',          'Workshop',           5,    '#6A9FCC',     80    FROM dual UNION ALL
  SELECT 'ROOM',          'غرفة',          'Room',               5,    '#6A9FCC',     90    FROM dual UNION ALL
  SELECT 'UNIT',          'وحدة',          'Unit (unlabelled)',  5,    '#8FB5D9',     99    FROM dual
) s ON (t.unit_type_code = s.c)
WHEN MATCHED THEN UPDATE SET t.name_ar = s.ar, t.name_en = s.en, t.level_hint = s.lv,
                             t.display_colour = s.col, t.sort_order = s.so
WHEN NOT MATCHED THEN INSERT (unit_type_code, name_ar, name_en, level_hint, display_colour, sort_order)
                      VALUES (s.c, s.ar, s.en, s.lv, s.col, s.so);

MERGE INTO org_source_type t USING (
  SELECT 'BYLAWS' c,       'النظام الداخلي (القرار 623/ن والقرار 504/ن)' ar, 'Bylaws' en FROM dual UNION ALL
  SELECT 'CARDS',          'بطاقات الوصف الوظيفي',                     'Job description cards'    FROM dual UNION ALL
  SELECT 'DRAFT_DECISION', 'مسودة قرار غير صادر',                      'Draft decision, not issued' FROM dual UNION ALL
  SELECT 'MANUAL',         'إدخال يدوي',                               'Manual entry'             FROM dual
) s ON (t.source_type_code = s.c)
WHEN MATCHED THEN UPDATE SET t.name_ar = s.ar, t.name_en = s.en
WHEN NOT MATCHED THEN INSERT (source_type_code, name_ar, name_en) VALUES (s.c, s.ar, s.en);

-- One row per rule in tools/build_hierarchy.py. Keep the two in step.
MERGE INTO org_link_method t USING (
  SELECT 'GOVERNOR' c,         'المحافظ كما ورد في البطاقة'                              ar, 'STATED' cf FROM dual UNION ALL
  SELECT 'SECRETARY',          'أمين السر كما ورد في البطاقة',                              'STATED'      FROM dual UNION ALL
  SELECT 'DIRECTOR',           'المدير كما ورد في البطاقة',                                 'STATED'      FROM dual UNION ALL
  SELECT 'UNIT_FROM_CARD',     'رئيس الوحدة من موقع البطاقة',                              'STATED'      FROM dual UNION ALL
  SELECT 'UNIT_BY_NAME',       'رئيس الوحدة المسمّاة في البطاقة',                          'STATED'      FROM dual UNION ALL
  SELECT 'DEPUTY',             'معاون المدير (واحد في المديرية)',                           'STATED'      FROM dual UNION ALL
  SELECT 'DEPUTY_BY_NAME',     'معاون المدير المسمّى',                                     'STATED'      FROM dual UNION ALL
  SELECT 'TITLE_MATCH',        'مسمى مطابق لبطاقة أخرى في المديرية',                       'STATED'      FROM dual UNION ALL
  SELECT 'UNIT_NO_CARD',       'رئيس وحدة لا بطاقة له',                                    'STATED'      FROM dual UNION ALL
  SELECT 'DEPUTY_UNSPECIFIED', 'معاون المدير غير محدد، رُبط بالمدير',                      'APPROXIMATE' FROM dual UNION ALL
  SELECT 'NEAREST_UNIT',       'الرئيس في وحدة لم تذكرها البطاقة، رُبط بأقرب وحدة مذكورة', 'APPROXIMATE' FROM dual UNION ALL
  SELECT 'FROM_STRUCTURE',     'لا رئيس في البطاقة، رُبط برئيس الوحدة الأعلى',             'INFERRED'    FROM dual UNION ALL
  SELECT 'PLACEHOLDER_UP',     'رئيس وحدة بلا بطاقة، رُبط بالوحدة الأعلى',                 'INFERRED'    FROM dual UNION ALL
  SELECT 'TOP',                'رأس الهيكل',                                               'STATED'      FROM dual UNION ALL
  SELECT 'CONFIRMED_DG',       'أكّدته المحافظة في المراجعة',                              'STATED'      FROM dual UNION ALL
  SELECT 'UNLINKED',           'لم يُحدَّد الرئيس؛ وُضعت تحت مدير المديرية للعرض فقط',       'NONE'        FROM dual
) s ON (t.link_method_code = s.c)
WHEN MATCHED THEN UPDATE SET t.name_ar = s.ar, t.confidence = s.cf
WHEN NOT MATCHED THEN INSERT (link_method_code, name_ar, confidence) VALUES (s.c, s.ar, s.cf);

MERGE INTO jd_class t USING (
  SELECT 'TOP_MGMT' c, 'إدارة عليا' ar, 'Senior management' en, '#0B2545' col, 10 so FROM dual UNION ALL
  SELECT 'MID_MGMT',   'إدارة وسطى',    'Middle management',    '#2B6CA3',     20    FROM dual UNION ALL
  SELECT 'ADMIN',      'إداري',         'Administrative',       '#4F7CAC',     30    FROM dual UNION ALL
  SELECT 'TECHNICAL',  'فني',           'Technical',            '#2E7D6B',     40    FROM dual UNION ALL
  SELECT 'SERVICE',    'خدمي',          'Service',              '#8C6D1F',     50    FROM dual UNION ALL
  SELECT 'UNSPECIFIED','غير محدد',      'Not stated',           '#8A8F98',     99    FROM dual
) s ON (t.class_code = s.c)
WHEN MATCHED THEN UPDATE SET t.name_ar = s.ar, t.name_en = s.en, t.display_colour = s.col, t.sort_order = s.so
WHEN NOT MATCHED THEN INSERT (class_code, name_ar, name_en, display_colour, sort_order)
                      VALUES (s.c, s.ar, s.en, s.col, s.so);

MERGE INTO jd_qual_level t USING (
  SELECT 'POSTGRAD' c, 'دراسات عليا' ar, 'Postgraduate' en, 10 so FROM dual UNION ALL
  SELECT 'UNIVERSITY',  'إجازة جامعية',   'University degree',     20 FROM dual UNION ALL
  SELECT 'MILITARY',    'كلية عسكرية / شرطة', 'Military or police college', 25 FROM dual UNION ALL
  SELECT 'INSTITUTE',   'معهد متوسط',     'Intermediate institute', 30 FROM dual UNION ALL
  SELECT 'SECONDARY',   'ثانوية',         'Secondary',             40 FROM dual UNION ALL
  SELECT 'PREPARATORY', 'إعدادية',        'Preparatory',           50 FROM dual UNION ALL
  SELECT 'PRIMARY',     'ابتدائية / محو أمية', 'Primary or literacy', 60 FROM dual UNION ALL
  SELECT 'UNSPECIFIED', 'غير محدد',       'Not stated',            99 FROM dual
) s ON (t.qual_level_code = s.c)
WHEN MATCHED THEN UPDATE SET t.name_ar = s.ar, t.name_en = s.en, t.sort_order = s.so
WHEN NOT MATCHED THEN INSERT (qual_level_code, name_ar, name_en, sort_order) VALUES (s.c, s.ar, s.en, s.so);

MERGE INTO jd_effort t USING (
  SELECT 'MENTAL' c, 'فكري' ar, 'Mental' en FROM dual UNION ALL
  SELECT 'MIXED',    'فكري وجسدي', 'Mental and physical' FROM dual UNION ALL
  SELECT 'PHYSICAL', 'جسدي / عضلي', 'Physical'          FROM dual UNION ALL
  SELECT 'UNSPECIFIED', 'غير محدد', 'Not stated'        FROM dual
) s ON (t.effort_code = s.c)
WHEN MATCHED THEN UPDATE SET t.name_ar = s.ar, t.name_en = s.en
WHEN NOT MATCHED THEN INSERT (effort_code, name_ar, name_en) VALUES (s.c, s.ar, s.en);

COMMIT;
