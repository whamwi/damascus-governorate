#!/usr/bin/env python3
"""Write the first DG pages of APEX app 111 into the split export, ready to install.

    python3 tools/build_apex_pages.py apex/f111
    python3 tools/install_apex.py apex/f111
    python3 tools/fetch_apex_export.py apex       # APEX's own version replaces these files

Writes pages 1, 10, 11, 20, 21, 30, 31, 40, the hierarchy-chart plugin (NIB's
export, header retargeted to this workspace and application), the navigation
menu entries, and adds them all to install.sql. Component ids are fixed, so a
rerun replaces rather than duplicates. The page plan is apex/README.md §4.

Once installed and exported again, the export is the source; this script is
how the first version was made, and how to rebuild it from scratch.
"""
import pathlib, re, sys

ROOT = pathlib.Path(sys.argv[1])
APP, WS, OWNER = 111, 40385165731532876, 'WKSP_DG'
NIB_PLUGIN = pathlib.Path('/Users/wassim/DMS/apex/f135/application/shared_components/'
                          'plugins/region_type/com_apexhierarchychart_plugin.sql')

# Universal Theme 42 template ids, as listed by apex_application_temp_* for app 111
T_PAGE, T_MODAL = 4073832297226169690, 2101883943284197310
T_STD, T_BLANK, T_IR = 4073835273271169698, 4502917002193490937, 2102002977963900996
T_BTN = 4073839297780169708
L_OPT, L_REQ, L_HIDDEN = 1610598304472262251, 1610598484065263269, 2042262243893469891
R_STD, R_BADGE, R_VAP = 2540130677583398057, 2106120299521025145, 2101991461423792139

ASIS = "(SELECT scenario_id FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS')"
SCEN_LOV = "SELECT name_ar AS d, scenario_id AS r FROM org_scenario ORDER BY scenario_type, scenario_id"
PLUGIN_ID_SHIFT = 7000000000
SCEN_DEFAULT = "SELECT scenario_id FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS'"


# ---------------------------------------------------------------- writing --
def q(v):
    if v is None: return 'null'
    if v is True: return 'true'
    if v is False: return 'false'
    if isinstance(v, int): return str(v)
    if isinstance(v, Raw): return v.s
    s = str(v)
    if '\n' in s:
        return 'wwv_flow_string.join(wwv_flow_t_varchar2(\n' + ',\n'.join(
            "'" + l.replace("'", "''") + "'" for l in s.split('\n')) + '))'
    return "'" + s.replace("'", "''") + "'"


class Raw:
    def __init__(self, s): self.s = s


def iid(n): return Raw(f'wwv_flow_imp.id({n})')


def attrs(**kv):
    return Raw('wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(\n' + ',\n'.join(
        f"  '{k}', {q(v)}" for k, v in kv.items()) + ')).to_clob')


def call(api, **p):
    items = [(k, v) for k, v in p.items() if v is not None]
    return (f'{api}(\n' + '\n'.join((' ' if i == 0 else ',') + f'p_{k}=>{q(v)}'
                                    for i, (k, v) in enumerate(items)) + '\n);')


def component_file(prompt, body):
    return (f'prompt --application/{prompt}\nbegin\n--   Manifest\n--   Manifest End\n'
            f"wwv_flow_imp.component_begin (\n p_version_yyyy_mm_dd=>'2026.03.30'\n"
            f",p_release=>'26.1.5'\n,p_default_workspace_id=>{WS}\n,p_default_application_id=>{APP}\n"
            f",p_default_id_offset=>0\n,p_default_owner=>'{OWNER}'\n);\n"
            + '\n'.join(body) + '\nwwv_flow_imp.component_end;\nend;\n/\n')


class Page:
    """Collects the calls of one page; ids are 7000000000000 + page * 100000 + n."""
    def __init__(self, pid, name, alias, template=T_PAGE, **extra):
        self.pid, self.n, self.body = pid, 0, []
        self.body.append(call('wwv_flow_imp_page.create_page', id=pid, name=name, alias=alias,
                              step_title=name, autocomplete_on_off='OFF', step_template=template,
                              page_template_options='#DEFAULT#', protection_level='C', **extra))

    def nid(self):
        self.n += 1
        return 7000000000000 + self.pid * 100000 + self.n

    def add(self, api, **p):
        i = self.nid()
        self.body.append(call(api, id=iid(i), **p))
        return i

    def plug(self, name, seq, template=T_STD, **p):
        p = {'region_template_options': '#DEFAULT#', **p}
        return self.add('wwv_flow_imp_page.create_page_plug', plug_name=name, plug_template=template,
                        plug_display_sequence=seq, plug_display_point='BODY', plug_item_display_point='ABOVE', **p)

    def static(self, name, seq, html, template=T_STD, **p):
        return self.plug(name, seq, template, plug_source=html, plug_source_type='NATIVE_STATIC',
                         attributes=attrs(expand_shortcuts='N', output_as='HTML'), **p)

    def classic(self, name, seq, sql, cols, row_template=R_STD, template=T_STD, no_data='لا توجد بيانات', **p):
        """cols: (alias, heading, align, hidden)"""
        self.add('wwv_flow_imp_page.create_report_region', name=name, template=template, display_sequence=seq,
                 region_template_options='#DEFAULT#', component_template_options='#DEFAULT#',
                 source_type='NATIVE_SQL_REPORT', query_type='SQL', source=sql, ajax_enabled='Y',
                 lazy_loading=False, query_row_template=row_template, query_num_rows=50,
                 query_options='DERIVED_REPORT_COLUMNS', query_no_data_found=no_data,
                 query_num_rows_type='NEXT_PREVIOUS_LINKS', pagination_display_position='BOTTOM_RIGHT',
                 csv_output='N', prn_output='N', sort_null='L', plug_query_strip_html='N', **p)
        for n, (alias, head, align, hidden) in enumerate(cols, 1):
            self.add('wwv_flow_imp_page.create_report_columns', query_column_id=n, column_alias=alias,
                     column_display_sequence=n, column_heading=head, column_alignment=align,
                     heading_alignment=align, hidden_column='Y' if hidden else None,
                     derived_column='N', include_in_export='Y')

    def ir(self, name, seq, sql, cols, link=None, link_text=None, **p):
        """cols: (name, label, type, hidden)"""
        rid = self.plug(name, seq, T_IR, query_type='SQL', plug_source=sql, plug_source_type='NATIVE_IR',
                        region_template_options='#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc', **p)
        wid = self.nid()
        self.body.append(call('wwv_flow_imp_page.create_worksheet', id=iid(wid),
                              max_row_count_message='الحد الأقصى #MAX_ROW_COUNT# صف. ضيّق البحث.',
                              no_data_found_message='لا توجد بيانات', pagination_type='ROWS_X_TO_Y',
                              pagination_display_pos='BOTTOM_RIGHT', report_list_mode='TABS', lazy_loading=False,
                              show_detail_link='C' if link else 'N', detail_link=link, detail_link_text=link_text,
                              show_notify='Y', download_formats='CSV:HTML:XLSX:PDF', enable_mail_download='Y',
                              internal_uid=wid))
        shown = []
        for n, (col, label, typ, hidden) in enumerate(cols):
            self.add('wwv_flow_imp_page.create_worksheet_column', db_column_name=col, display_order=n + 1,
                     column_identifier=chr(65 + n) if n < 26 else 'A' + chr(65 + n - 26), column_label=label,
                     column_type=typ, display_text_as='HIDDEN' if hidden else None,
                     heading_alignment='LEFT', column_alignment='RIGHT' if typ == 'NUMBER' else None,
                     use_as_row_header='N')
            if not hidden: shown.append(col)
        self.add('wwv_flow_imp_page.create_worksheet_rpt', application_user='APXWS_DEFAULT', report_seq=10,
                 report_alias='primary', status='PUBLIC', is_default='Y', report_columns=':'.join(shown))
        return rid

    def item(self, name, plug, seq, display_as, prompt=None, template=L_OPT, **p):
        p = {'is_persistent': 'N', **p}
        return self.add('wwv_flow_imp_page.create_page_item', name=name, item_sequence=seq, item_plug_id=iid(plug),
                        prompt=prompt, display_as=display_as, field_template=template,
                        item_template_options='#DEFAULT#', **p)

    def scenario_item(self, plug, seq):
        return self.item(f'P{self.pid}_SCENARIO_ID', plug, seq, 'NATIVE_SELECT_LIST', 'السيناريو',
                         item_default=SCEN_DEFAULT, item_default_type='SQL_QUERY', lov=SCEN_LOV,
                         lov_display_null='NO', cHeight=1, is_persistent='Y',
                         attributes=attrs(page_action_on_selection='REDIRECT_SET_VALUE'))

    def button(self, name, plug, seq, label, action='SUBMIT', position='NEXT', hot=False, **p):
        return self.add('wwv_flow_imp_page.create_page_button', button_sequence=seq, button_plug_id=iid(plug),
                        button_name=name, button_action=action, button_template_options='#DEFAULT#',
                        button_template_id=T_BTN, button_is_hot='Y' if hot else None, button_image_alt=label,
                        button_position=position, **p)

    def process(self, name, seq, point, ptype, **p):
        i = self.nid()
        self.body.append(call('wwv_flow_imp_page.create_page_process', id=iid(i), process_sequence=seq,
                              process_point=point, process_type=ptype, process_name=name,
                              error_display_location='INLINE_IN_NOTIFICATION', internal_uid=i, **p))
        return i

    def write(self, root):
        f = root / 'application' / 'pages' / f'page_{self.pid:05d}.sql'
        f.write_text(component_file(f'pages/page_{self.pid:05d}', self.body), encoding='utf-8')
        return f'@@application/pages/page_{self.pid:05d}.sql'


def chart(p, name, seq, sql, span=6, new_row=True):
    rid = p.plug(name, seq, plug_source_type='NATIVE_JET_CHART', plug_grid_column_span=span,
                 plug_new_grid_row=new_row)
    cid = p.add('wwv_flow_imp_page.create_jet_chart', region_id=iid(rid), chart_type='bar',
                animation_on_display='auto', animation_on_data_change='auto', orientation='horizontal',
                data_cursor='auto', data_cursor_behavior='auto', hover_behavior='dim', stack='off',
                stack_label='off', connect_nulls='Y', fill_multi_series_gaps=True, zoom_and_scroll='off',
                tooltip_rendered='Y', show_series_name=False, show_group_name=True, show_value=True,
                legend_rendered='off', legend_position='auto', overview_rendered='off', time_axis_type='auto')
    p.add('wwv_flow_imp_page.create_jet_chart_series', chart_id=iid(cid), seq=10, name='البطاقات',
          data_source_type='SQL', data_source=sql, max_row_count=50, series_type='bar',
          items_value_column_name='VALUE', items_label_column_name='LABEL', assigned_to_y2='off',
          items_label_rendered=True, items_label_position='auto', items_label_display_as='LABEL',
          threshold_display='onIndicator')
    for axis in ('x', 'y'):
        p.add('wwv_flow_imp_page.create_jet_chart_axis', chart_id=iid(cid), axis=axis, is_rendered='on',
              format_scaling='auto', scaling='linear', baseline_scaling='zero', major_tick_rendered='on',
              minor_tick_rendered='off', tick_label_rendered='on', tick_label_rotation='auto',
              tick_label_position='outside')


# ------------------------------------------------------- hierarchy charts --
NODE = '''<div style="width:{w}px;height:{h}px;box-sizing:border-box;background:#fff;border-radius:8px;border-top:6px solid ${{cardColor}};box-shadow:0 2px 6px rgba(0,0,0,.15);font-family:inherit;direction:rtl;text-align:center;padding:8px 10px;display:flex;flex-direction:column;justify-content:center;gap:4px;">
  <div style="color:${{cardColor}};font-size:13px;font-weight:700;line-height:1.3;">${{EMPLOYEENAME}}</div>
  <div style="color:#333;font-size:12px;line-height:1.3;">${{POSITIONNAME}}</div>
  <div style="color:#666;font-size:11px;">${{OFFICE}}</div>
  <div style="color:${{cardColor}};font-size:11px;">${{DESCRIPTION}}</div>
</div>'''


def nib_button_template():
    """The expand / collapse button of NIB pages 10–11, as the README asks."""
    t = (NIB_PLUGIN.parent.parent.parent.parent / 'pages' / 'page_00010.sql').read_text(encoding='utf-8')
    m = re.search(r"'node_button_template', (wwv_flow_string\.join\(wwv_flow_t_varchar2\(.*?\)\)),\n  'node_height'", t, re.S)
    return Raw(m.group(1))


def org_chart(p, name, view, w, h):
    top = p.plug('السيناريو', 10, T_BLANK)
    p.scenario_item(top, 10)
    p.plug(name, 20,
           region_template_options='#DEFAULT#:js-showMaximizeButton:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody',
           query_type='SQL', plug_source=(
               'SELECT id, parentid, "LEVEL", employeename, imageurl, office, positionname,\n'
               '       description, category_color\n'
               f'  FROM {view}\n'
               f' WHERE scenario_id = :P{p.pid}_SCENARIO_ID\n'
               ' ORDER BY sib'),
           plug_source_type='PLUGIN_COM.APEXHIERARCHYCHART.PLUGIN', ajax_items_to_submit=f'P{p.pid}_SCENARIO_ID',
           attributes=Raw('wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(\n'
                          "  'id_column', 'ID',\n"
                          "  'last_node_level_to_be_expanded', '2',\n"
                          f"  'node_button_template', {nib_button_template().s},\n"
                          f"  'node_height', '{h}',\n"
                          "  'node_level_column', 'LEVEL',\n"
                          f"  'node_template', {q(NODE.format(w=w, h=h))},\n"
                          "  'node_template_column', 'EMPLOYEENAME,POSITIONNAME,OFFICE,DESCRIPTION,CATEGORY_COLOR',\n"
                          f"  'node_width', '{w}',\n"
                          "  'parent_id_column', 'PARENTID',\n"
                          "  'partial_data_load', 'N')).to_clob"))


def legend(items):
    return '<div style="display:flex;flex-wrap:wrap;gap:16px;font-size:12px;">' + ''.join(
        f'<span><span style="display:inline-block;width:12px;height:12px;border-radius:3px;background:{c};'
        f'margin-inline-end:6px;vertical-align:middle;"></span>{t}</span>' for c, t in items) + '</div>'


# ------------------------------------------------------------------ pages --
def pages():
    out = []

    # 1 — الرئيسية
    p = Page(1, 'الرئيسية', 'HOME')
    p.classic('الأرقام', 10,
              'SELECT (SELECT COUNT(*) FROM org_unit WHERE scenario_id = s.id)     AS units,\n'
              '       (SELECT COUNT(*) FROM org_position WHERE scenario_id = s.id) AS positions,\n'
              '       (SELECT COUNT(*) FROM jd_card)                               AS cards,\n'
              '       (SELECT COUNT(*) FROM jd_card_task)                          AS tasks,\n'
              '       (SELECT COUNT(*) FROM org_v_review WHERE scenario_id = s.id) AS review,\n'
              '       (SELECT SUM(staff) FROM dg_staff_count)                      AS staff\n'
              "  FROM (SELECT scenario_id AS id FROM org_scenario WHERE scenario_code = 'DG_ASIS_CARDS') s",
              [('UNITS', 'الوحدات', 'CENTER', False), ('POSITIONS', 'الوظائف', 'CENTER', False),
               ('CARDS', 'بطاقات الوصف', 'CENTER', False), ('TASKS', 'المهام', 'CENTER', False),
               ('REVIEW', 'بانتظار المراجعة', 'CENTER', False), ('STAFF', 'العاملون في جدول التوزيع', 'CENTER', False)],
              row_template=R_BADGE)
    chart(p, 'البطاقات حسب التصنيف', 20,
          "SELECT NVL(c.name_ar, 'غير مصنّف') AS label, COUNT(*) AS value\n"
          '  FROM jd_card j LEFT JOIN jd_class c ON c.class_code = j.class_code\n'
          ' GROUP BY c.name_ar, c.sort_order\n ORDER BY c.sort_order NULLS LAST')
    chart(p, 'البطاقات حسب المؤهل العلمي', 30,
          "SELECT NVL(l.name_ar, 'غير محدد') AS label, COUNT(*) AS value\n"
          '  FROM jd_card j LEFT JOIN jd_qual_level l ON l.qual_level_code = j.qual_level_code\n'
          ' GROUP BY l.name_ar, l.sort_order\n ORDER BY l.sort_order NULLS LAST', new_row=False)
    p.classic('العاملون حسب الوحدة', 40,
              'SELECT row_label, university, institute, secondary, total\n'
              '  FROM dg_v_staff_by_unit\n ORDER BY total DESC NULLS LAST',
              [('ROW_LABEL', 'الوحدة كما وردت في جدول التوزيع', 'LEFT', False),
               ('UNIVERSITY', 'جامعي', 'CENTER', False), ('INSTITUTE', 'معهد', 'CENTER', False),
               ('SECONDARY', 'ثانوي ومهني', 'CENTER', False), ('TOTAL', 'المجموع', 'CENTER', False)])
    p.static('عن هذا الجدول', 35, '<p>جدول «توزيع العاملين» كما أرسلته المحافظة: لا يُعدّ فيه من دون الشهادة '
             'الثانوية، فهو ليس عدد العاملين الكامل.</p>', T_BLANK)
    out.append(p)

    # 10 — الهيكل التنظيمي
    p = Page(10, 'الهيكل التنظيمي', 'ORG-UNITS')
    org_chart(p, 'الهيكل التنظيمي', 'org_v_chart_unit', 230, 120)
    p.static('دليل الألوان', 30, legend([('#134074', 'مديرية'), ('#2B6CA3', 'دائرة'), ('#4A88BD', 'شعبة'),
                                          ('#8A2432', 'لا بطاقة لرئيس الوحدة'),
                                          ('#8C6D1F', 'من مسودة قرار غير صادر')]))
    out.append(p)

    # 11 — الهيكل الوظيفي
    p = Page(11, 'الهيكل الوظيفي', 'ORG-POSITIONS')
    org_chart(p, 'الهيكل الوظيفي', 'org_v_chart_position', 220, 120)
    p.static('دليل الألوان', 30, legend([('#2B6CA3', 'ربط ورد في البطاقة'),
                                          ('#9A5B00', 'ربط تقريبي أو مستنتج: يحتاج تأكيداً'),
                                          ('#8A2432', 'وظيفة لا بطاقة لها')]))
    out.append(p)

    # 20 — بطاقات الوصف
    p = Page(20, 'بطاقات الوصف', 'CARDS')
    p.ir('بطاقات الوصف', 10,
         'SELECT card_id, card_code, title_ar, class_ar, qual_ar, specialisation,\n'
         '       loc_directorate, unit_ar, reports_to_ar, link_confidence,\n'
         "       DECODE(status, 'IMPORTED', 'مستوردة', 'UNDER_REVIEW', 'قيد المراجعة', 'REVIEWED', 'روجعت',\n"
         "                      'APPROVED', 'معتمدة', 'RETIRED', 'ملغاة', status) AS status_ar,\n"
         '       task_count, bylaws_article, source_file\n'
         '  FROM jd_v_card\n'
         f' WHERE scenario_id = {ASIS} OR scenario_id IS NULL',
         [('CARD_ID', 'المعرّف', 'NUMBER', True), ('CARD_CODE', 'الرمز', 'STRING', False),
          ('TITLE_AR', 'المسمى الوظيفي', 'STRING', False), ('CLASS_AR', 'التصنيف', 'STRING', False),
          ('QUAL_AR', 'المؤهل', 'STRING', False), ('SPECIALISATION', 'الاختصاص', 'STRING', False),
          ('LOC_DIRECTORATE', 'المديرية', 'STRING', False), ('UNIT_AR', 'الوحدة', 'STRING', False),
          ('REPORTS_TO_AR', 'الرئيس المباشر', 'STRING', False), ('LINK_CONFIDENCE', 'ثقة الربط', 'STRING', False),
          ('STATUS_AR', 'الحالة', 'STRING', False), ('TASK_COUNT', 'المهام', 'NUMBER', False),
          ('BYLAWS_ARTICLE', 'المادة', 'STRING', False), ('SOURCE_FILE', 'الملف', 'STRING', True)],
         link='f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:21:P21_CARD_ID:#CARD_ID#',
         link_text='<span class="fa fa-edit" aria-hidden="true"></span>')
    out.append(p)

    # 21 — البطاقة
    p = Page(21, 'البطاقة', 'CARD')
    form = p.plug('البطاقة', 10, query_type='TABLE', query_table='JD_CARD', include_rowid_column=False,
                  is_editable=True, edit_operations='u', lost_update_check_type='VALUES', plug_source_type='NATIVE_FORM')
    fi = dict(item_source_plug_id=iid(form))
    disp = lambda: attrs(based_on='VALUE', format='TEXT', send_on_page_submit='N', show_line_breaks='Y')
    text = lambda: attrs(disabled='N', submit_when_enter_pressed='N', subtype='TEXT', trim_spaces='BOTH')
    area = lambda: attrs(auto_height='Y', character_counter='N', resizable='Y', trim_spaces='BOTH')
    seq = iter(range(10, 1000, 10))
    p.item('P21_CARD_ID', form, next(seq), 'NATIVE_HIDDEN', template=None, source='CARD_ID',
           source_data_type='NUMBER', is_primary_key=True, is_query_only=True, protection_level='S',
           attributes=attrs(value_protected='Y'), **fi)
    p.item('P21_CARD_CODE', form, next(seq), 'NATIVE_DISPLAY_ONLY', 'الرمز', source='CARD_CODE',
           source_data_type='VARCHAR2', is_query_only=True, attributes=disp(), **fi)
    p.item('P21_STATUS', form, next(seq), 'NATIVE_SELECT_LIST', 'الحالة', template=L_REQ, source='STATUS',
           source_data_type='VARCHAR2', is_required=True, begin_on_new_line='N',
           lov='STATIC2:مستوردة;IMPORTED,قيد المراجعة;UNDER_REVIEW,روجعت;REVIEWED,معتمدة;APPROVED,ملغاة;RETIRED',
           lov_display_null='NO', cHeight=1, attributes=attrs(page_action_on_selection='NONE'), **fi)
    p.item('P21_TITLE_AR', form, next(seq), 'NATIVE_TEXT_FIELD', 'المسمى الوظيفي', template=L_REQ,
           source='TITLE_AR', source_data_type='VARCHAR2', is_required=True, cMaxlength=400, attributes=text(), **fi)
    for col, prompt, lov in (('CLASS_CODE', 'التصنيف', 'SELECT name_ar d, class_code r FROM jd_class ORDER BY sort_order'),
                             ('QUAL_LEVEL_CODE', 'المؤهل العلمي', 'SELECT name_ar d, qual_level_code r FROM jd_qual_level ORDER BY sort_order'),
                             ('EFFORT_CODE', 'نوع الجهد', 'SELECT name_ar d, effort_code r FROM jd_effort ORDER BY sort_order')):
        p.item(f'P21_{col}', form, next(seq), 'NATIVE_SELECT_LIST', prompt, source=col, source_data_type='VARCHAR2',
               lov=lov, lov_display_null='YES', lov_null_text='— غير محدد —', cHeight=1,
               attributes=attrs(page_action_on_selection='NONE'), **fi)
        raw = col.replace('_LEVEL_CODE', '_RAW').replace('_CODE', '_RAW')
        p.item(f'P21_{raw}', form, next(seq), 'NATIVE_DISPLAY_ONLY', 'كما ورد في البطاقة', source=raw,
               source_data_type='VARCHAR2', is_query_only=True, begin_on_new_line='N', attributes=disp(), **fi)
    p.item('P21_SPECIALISATION', form, next(seq), 'NATIVE_TEXT_FIELD', 'الاختصاص', source='SPECIALISATION',
           source_data_type='VARCHAR2', cMaxlength=400, attributes=text(), **fi)
    p.item('P21_EXPERIENCE_YEARS', form, next(seq), 'NATIVE_NUMBER_FIELD', 'سنوات الخبرة', source='EXPERIENCE_YEARS',
           source_data_type='NUMBER', cMaxlength=3, attributes=attrs(number_alignment='left', virtual_keyboard='decimal'), **fi)
    p.item('P21_EXPERIENCE_RAW', form, next(seq), 'NATIVE_DISPLAY_ONLY', 'الخبرة كما وردت', source='EXPERIENCE_RAW',
           source_data_type='VARCHAR2', is_query_only=True, begin_on_new_line='N', attributes=disp(), **fi)
    for col, prompt in (('TRAINING', 'التدريب'), ('OTHER_KNOWLEDGE', 'معارف أخرى')):
        p.item(f'P21_{col}', form, next(seq), 'NATIVE_TEXTAREA', prompt, source=col, source_data_type='VARCHAR2',
               cMaxlength=1000, cHeight=2, attributes=area(), **fi)
    for col, prompt in (('LOC_DIRECTORATE', 'المديرية'), ('LOC_DEPARTMENT', 'الدائرة'), ('LOC_SECTION', 'الشعبة'),
                        ('LOC_OFFICE', 'القسم / المكتب'), ('SUPERVISOR_RAW', 'الرئيس المباشر كما ورد'),
                        ('SOURCE_FILE', 'الملف'), ('SOURCE_SEQ', 'ترتيبها في الملف')):
        p.item(f'P21_{col}', form, next(seq), 'NATIVE_DISPLAY_ONLY', prompt, source=col,
               source_data_type='NUMBER' if col == 'SOURCE_SEQ' else 'VARCHAR2', is_query_only=True,
               begin_on_new_line='N' if col in ('LOC_DEPARTMENT', 'LOC_OFFICE', 'SOURCE_SEQ') else None,
               attributes=disp(), **fi)
    p.item('P21_REVIEW_NOTE', form, next(seq), 'NATIVE_TEXTAREA', 'ملاحظات المراجعة', source='REVIEW_NOTE',
           source_data_type='VARCHAR2', cMaxlength=4000, cHeight=3, attributes=area(), **fi)
    save = p.button('SAVE', form, 10, 'حفظ', hot=True, database_action='UPDATE')
    p.button('CANCEL', form, 20, 'عودة إلى القائمة', action='REDIRECT_PAGE', position='PREVIOUS',
             button_redirect_url='f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::')
    p.classic('موقعها في الهيكل', 20,
              'SELECT unit_ar, reports_to_ar, link_method_ar, position_code\n'
              '  FROM jd_v_card\n'
              f' WHERE card_id = :P21_CARD_ID AND (scenario_id = {ASIS} OR scenario_id IS NULL)',
              [('UNIT_AR', 'الوحدة', 'LEFT', False), ('REPORTS_TO_AR', 'الرئيس المباشر', 'LEFT', False),
               ('LINK_METHOD_AR', 'كيف حُدِّد', 'LEFT', False), ('POSITION_CODE', 'رمز الوظيفة', 'LEFT', False)],
              row_template=R_VAP, ajax_items_to_submit='P21_CARD_ID')
    grid = p.plug('المهام', 30, T_IR, query_type='SQL',
                  plug_source='SELECT task_id, card_id, seq, task_ar, is_generic\n'
                              '  FROM jd_card_task\n WHERE card_id = :P21_CARD_ID',
                  plug_source_type='NATIVE_IG', ajax_items_to_submit='P21_CARD_ID', include_rowid_column=False)
    gcols = {}
    gcols['APEX$ROW_ACTION'] = p.add('wwv_flow_imp_page.create_region_column', name='APEX$ROW_ACTION',
                                     session_state_data_type='VARCHAR2', item_type='NATIVE_ROW_ACTION', display_sequence=10)
    gcols['TASK_ID'] = p.add('wwv_flow_imp_page.create_region_column', name='TASK_ID', source_type='DB_COLUMN',
                             source_expression='TASK_ID', data_type='NUMBER', session_state_data_type='VARCHAR2',
                             is_query_only=True, item_type='NATIVE_HIDDEN', display_sequence=20,
                             attributes=attrs(value_protected='Y'), use_as_row_header=False, is_primary_key=True,
                             include_in_export=False)
    gcols['CARD_ID'] = p.add('wwv_flow_imp_page.create_region_column', name='CARD_ID', source_type='DB_COLUMN',
                             source_expression='CARD_ID', data_type='NUMBER', session_state_data_type='VARCHAR2',
                             is_query_only=False, item_type='NATIVE_HIDDEN', display_sequence=30,
                             attributes=attrs(value_protected='Y'), use_as_row_header=False, is_primary_key=False,
                             default_type='ITEM', default_expression='P21_CARD_ID', include_in_export=False)
    gcols['SEQ'] = p.add('wwv_flow_imp_page.create_region_column', name='SEQ', source_type='DB_COLUMN',
                         source_expression='SEQ', data_type='NUMBER', session_state_data_type='VARCHAR2',
                         is_query_only=False, item_type='NATIVE_NUMBER_FIELD', heading='الترتيب',
                         heading_alignment='CENTER', display_sequence=40, value_alignment='CENTER',
                         attributes=attrs(number_alignment='center', virtual_keyboard='decimal'),
                         is_required=True, enable_filter=True, filter_lov_type='NONE', use_as_row_header=False,
                         enable_sort_group=True, enable_hide=True, is_primary_key=False, duplicate_value=True,
                         include_in_export=True)
    gcols['TASK_AR'] = p.add('wwv_flow_imp_page.create_region_column', name='TASK_AR', source_type='DB_COLUMN',
                             source_expression='TASK_AR', data_type='VARCHAR2', session_state_data_type='VARCHAR2',
                             is_query_only=False, item_type='NATIVE_TEXTAREA', heading='المهمة',
                             heading_alignment='LEFT', display_sequence=50, value_alignment='LEFT',
                             attributes=attrs(auto_height='Y', character_counter='N', resizable='Y', trim_spaces='BOTH'),
                             is_required=True, max_length=4000, enable_filter=True,
                             filter_operators='C:S:CASE_INSENSITIVE:REGEXP', filter_text_case='MIXED',
                             filter_lov_type='NONE', use_as_row_header=False, enable_sort_group=False,
                             enable_hide=True, is_primary_key=False, duplicate_value=True, include_in_export=True)
    gcols['IS_GENERIC'] = p.add('wwv_flow_imp_page.create_region_column', name='IS_GENERIC', source_type='DB_COLUMN',
                                source_expression='IS_GENERIC', data_type='VARCHAR2', session_state_data_type='VARCHAR2',
                                is_query_only=False, item_type='NATIVE_SELECT_LIST', heading='عامة',
                                heading_alignment='CENTER', display_sequence=60, value_alignment='CENTER',
                                is_required=True, lov_type='STATIC', lov_source='STATIC2:لا;N,نعم;Y',
                                lov_display_extra=False, lov_display_null=False, default_type='STATIC',
                                default_expression='N', enable_filter=True, filter_exact_match=True,
                                filter_lov_type='LOV', use_as_row_header=False, enable_sort_group=True,
                                enable_hide=True, is_primary_key=False, duplicate_value=True, include_in_export=True)
    ig = p.nid()
    p.body.append(call('wwv_flow_imp_page.create_interactive_grid', id=iid(ig), internal_uid=ig, is_editable=True,
                       edit_operations='i:u:d', lost_update_check_type='VALUES', add_row_if_empty=False,
                       lazy_loading=False, requires_filter=False, select_first_row=False, fixed_row_height=False,
                       pagination_type='SCROLL', show_total_row_count=True, show_toolbar=True,
                       enable_save_public_report=False, enable_subscriptions=False, enable_flashback=False,
                       define_chart_view=False, enable_download=True, download_formats='CSV:HTML:XLSX',
                       enable_mail_download=False, fixed_header='PAGE', show_icon_view=False, show_detail_view=False))
    rep = p.add('wwv_flow_imp_page.create_ig_report', interactive_grid_id=iid(ig), static_id='primary', type='PRIMARY',
                default_view='GRID', show_row_number=False, settings_area_expanded=False)
    view = p.add('wwv_flow_imp_page.create_ig_report_view', report_id=iid(rep), view_type='GRID',
                 stretch_columns=True, srv_exclude_null_values=False, srv_only_display_columns=True, edit_mode=False)
    for n, c in enumerate(('APEX$ROW_ACTION', 'SEQ', 'TASK_AR', 'IS_GENERIC'), 1):
        p.add('wwv_flow_imp_page.create_ig_report_column', view_id=iid(view), display_seq=n,
              column_id=iid(gcols[c]), is_visible=True, is_frozen=False,
              width={'SEQ': 80, 'IS_GENERIC': 80, 'APEX$ROW_ACTION': 40}.get(c))
    p.process('تهيئة البطاقة', 10, 'BEFORE_HEADER', 'NATIVE_FORM_INIT', region_id=iid(form),
              attributes=attrs(current_row_total_item='', next_primary_key_items='', previous_primary_key_items=''))
    p.process('حفظ البطاقة', 10, 'AFTER_SUBMIT', 'NATIVE_FORM_DML', region_id=iid(form),
              attributes=attrs(lock_row='Y', prevent_lost_updates='Y', return_primary_keys_after_insert='Y',
                               target_type='REGION_SOURCE'),
              process_when_button_id=iid(save), process_success_message='حُفظت البطاقة.')
    p.process('حفظ المهام', 20, 'AFTER_SUBMIT', 'NATIVE_IG_DML', region_id=iid(grid),
              attributes=attrs(lock_row='Y', prevent_lost_updates='Y', return_primary_keys_after_insert='Y',
                               target_type='REGION_SOURCE'))
    p.add('wwv_flow_imp_page.create_page_branch', branch_name='البقاء في البطاقة',
          branch_action='f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.::P21_CARD_ID:&P21_CARD_ID.&success_msg=#SUCCESS_MSG#',
          branch_point='AFTER_PROCESSING', branch_type='REDIRECT_URL', branch_sequence=10)
    out.append(p)

    # 30 — المراجعة
    p = Page(30, 'المراجعة', 'REVIEW')
    top = p.plug('السيناريو', 10, T_BLANK)
    p.scenario_item(top, 10)
    p.classic('ما يحتاج تأكيداً', 20,
              "SELECT SUM(CASE issue WHEN 'NO_CARD' THEN 1 END)       AS no_card,\n"
              "       SUM(CASE issue WHEN 'NO_SUPERVISOR' THEN 1 END) AS no_supervisor,\n"
              "       SUM(CASE issue WHEN 'APPROXIMATE' THEN 1 END)   AS approximate,\n"
              "       SUM(CASE issue WHEN 'INFERRED' THEN 1 END)      AS inferred,\n"
              '       COUNT(*)                                        AS total\n'
              '  FROM org_v_review\n WHERE scenario_id = :P30_SCENARIO_ID',
              [('NO_CARD', 'وظيفة بلا بطاقة', 'CENTER', False), ('NO_SUPERVISOR', 'بلا رئيس مباشر', 'CENTER', False),
               ('APPROXIMATE', 'ربط تقريبي', 'CENTER', False), ('INFERRED', 'ربط مستنتج', 'CENTER', False),
               ('TOTAL', 'المجموع', 'CENTER', False)],
              row_template=R_BADGE, ajax_items_to_submit='P30_SCENARIO_ID')
    queue = p.ir('قائمة المراجعة', 30,
                 'SELECT position_id, issue_ar, title_ar, unit_ar, bylaws_article, card_code,\n'
                 '       supervisor_raw, linked_to_ar, reports\n'
                 '  FROM org_v_review\n WHERE scenario_id = :P30_SCENARIO_ID',
                 [('POSITION_ID', 'المعرّف', 'NUMBER', True), ('ISSUE_AR', 'ما يحتاج تأكيداً', 'STRING', False),
                  ('TITLE_AR', 'الوظيفة', 'STRING', False), ('UNIT_AR', 'الوحدة', 'STRING', False),
                  ('BYLAWS_ARTICLE', 'المادة', 'STRING', False), ('CARD_CODE', 'البطاقة', 'STRING', False),
                  ('SUPERVISOR_RAW', 'الرئيس كما ورد في البطاقة', 'STRING', False),
                  ('LINKED_TO_AR', 'رُبطت حالياً بـ', 'STRING', False), ('REPORTS', 'مرؤوسون', 'NUMBER', False)],
                 link='f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:31:P31_POSITION_ID:#POSITION_ID#',
                 link_text='<span class="fa fa-wrench" aria-hidden="true" title="تصحيح"></span>',
                 ajax_items_to_submit='P30_SCENARIO_ID')
    ev = p.add('wwv_flow_imp_page.create_page_da_event', name='تحديث بعد التصحيح', event_sequence=10,
               triggering_element_type='REGION', triggering_region_id=iid(queue), bind_type='bind',
               execution_type='IMMEDIATE', bind_event_type='apexafterclosedialog')
    p.add('wwv_flow_imp_page.create_page_da_action', event_id=iid(ev), event_result='TRUE', action_sequence=10,
          execute_on_page_init='N', action='NATIVE_SUBMIT_PAGE', attributes=attrs(show_processing='Y'))
    out.append(p)

    # 31 — تأكيد الرئيس المباشر (dialog)
    p = Page(31, 'تأكيد الرئيس المباشر', 'CONFIRM-LINE', template=T_MODAL, page_mode='MODAL', dialog_width='720')
    p.classic('ما ورد في البطاقة', 10,
              'SELECT title_ar, unit_ar, issue_ar, card_code, supervisor_raw, linked_to_ar\n'
              '  FROM org_v_review WHERE position_id = :P31_POSITION_ID',
              [('TITLE_AR', 'الوظيفة', 'LEFT', False), ('UNIT_AR', 'الوحدة', 'LEFT', False),
               ('ISSUE_AR', 'ما يحتاج تأكيداً', 'LEFT', False), ('CARD_CODE', 'البطاقة', 'LEFT', False),
               ('SUPERVISOR_RAW', 'الرئيس كما ورد في البطاقة', 'LEFT', False),
               ('LINKED_TO_AR', 'رُبطت حالياً بـ', 'LEFT', False)],
              row_template=R_VAP, no_data='أُكّد هذا الربط من قبل.')
    form = p.plug('التصحيح', 20, query_type='TABLE', query_table='ORG_POSITION', include_rowid_column=False,
                  is_editable=True, edit_operations='u', lost_update_check_type='VALUES', plug_source_type='NATIVE_FORM')
    fi = dict(item_source_plug_id=iid(form))
    p.item('P31_POSITION_ID', form, 10, 'NATIVE_HIDDEN', template=None, source='POSITION_ID', source_data_type='NUMBER',
           is_primary_key=True, is_query_only=True, protection_level='S', attributes=attrs(value_protected='Y'), **fi)
    p.item('P31_SCENARIO_ID', form, 20, 'NATIVE_HIDDEN', template=None, source='SCENARIO_ID', source_data_type='NUMBER',
           is_query_only=True, attributes=attrs(value_protected='Y'), **fi)
    p.item('P31_LINK_METHOD_CODE', form, 30, 'NATIVE_HIDDEN', template=None, source='LINK_METHOD_CODE',
           source_data_type='VARCHAR2', attributes=attrs(value_protected='N'), **fi)
    rep_to = p.item('P31_REPORTS_TO_POS_ID', form, 40, 'NATIVE_SELECT_LIST', 'الرئيس المباشر الصحيح', template=L_REQ,
                    source='REPORTS_TO_POS_ID', source_data_type='NUMBER', is_required=True,
                    lov="SELECT p.title_ar || ' — ' || u.name_ar AS d, p.position_id AS r\n"
                        '  FROM org_position p JOIN org_unit u ON u.unit_id = p.unit_id\n'
                        ' WHERE p.scenario_id = :P31_SCENARIO_ID AND p.position_id <> :P31_POSITION_ID\n'
                        ' ORDER BY u.unit_code, p.sort_order',
                    lov_display_null='YES', lov_null_text='— اختر —', cHeight=1,
                    attributes=attrs(page_action_on_selection='NONE'), **fi)
    p.item('P31_NOTES', form, 50, 'NATIVE_TEXTAREA', 'ملاحظة (من أكّد ومتى)', source='NOTES',
           source_data_type='VARCHAR2', cMaxlength=4000, cHeight=3,
           attributes=attrs(auto_height='Y', character_counter='N', resizable='Y', trim_spaces='BOTH'), **fi)
    save = p.button('SAVE', form, 10, 'تأكيد', hot=True, database_action='UPDATE')
    p.button('CANCEL', form, 20, 'إلغاء', action='REDIRECT_URL', position='PREVIOUS',
             button_redirect_url='javascript:apex.navigation.dialog.cancel(true);')
    p.add('wwv_flow_imp_page.create_page_validation', validation_name='لا دورة في الهيكل', validation_sequence=10,
          validation='SELECT 1 FROM org_position\n'
                     ' WHERE position_id = :P31_REPORTS_TO_POS_ID\n'
                     ' START WITH position_id = :P31_POSITION_ID\n'
                     ' CONNECT BY NOCYCLE PRIOR position_id = reports_to_pos_id',
          validation_type='NOT_EXISTS',
          error_message='لا يصح: الرئيس المختار يتبع هذه الوظيفة نفسها، فيصير الهيكل دائرة.',
          when_button_pressed=iid(save), associated_item=iid(rep_to),
          error_display_location='INLINE_WITH_FIELD_AND_NOTIFICATION')
    p.process('تهيئة', 10, 'BEFORE_HEADER', 'NATIVE_FORM_INIT', region_id=iid(form),
              attributes=attrs(current_row_total_item='', next_primary_key_items='', previous_primary_key_items=''))
    p.process('وسم الربط مؤكَّداً', 5, 'AFTER_SUBMIT', 'NATIVE_PLSQL',
              process_sql_clob=":P31_LINK_METHOD_CODE := 'CONFIRMED_DG';", process_clob_language='PLSQL',
              process_when_button_id=iid(save))
    p.process('حفظ', 10, 'AFTER_SUBMIT', 'NATIVE_FORM_DML', region_id=iid(form),
              attributes=attrs(lock_row='Y', prevent_lost_updates='Y', return_primary_keys_after_insert='Y',
                               target_type='REGION_SOURCE'), process_when_button_id=iid(save))
    p.process('إغلاق', 20, 'AFTER_SUBMIT', 'NATIVE_CLOSE_WINDOW', process_when_button_id=iid(save))
    out.append(p)

    # 40 — السيناريوهات
    p = Page(40, 'السيناريوهات', 'SCENARIOS')
    p.classic('السيناريوهات', 10,
              "SELECT s.scenario_code, s.name_ar, DECODE(s.scenario_type, 'AS_IS', 'القائم', 'المقترح') AS type_ar,\n"
              '       s.status, f.scenario_code AS cloned_from,\n'
              '       (SELECT COUNT(*) FROM org_unit u WHERE u.scenario_id = s.scenario_id)     AS units,\n'
              '       (SELECT COUNT(*) FROM org_position o WHERE o.scenario_id = s.scenario_id) AS positions,\n'
              "       TO_CHAR(s.created_on, 'YYYY-MM-DD') AS created_on\n"
              '  FROM org_scenario s LEFT JOIN org_scenario f ON f.scenario_id = s.cloned_from_id\n'
              ' ORDER BY s.scenario_id',
              [('SCENARIO_CODE', 'الرمز', 'LEFT', False), ('NAME_AR', 'الاسم', 'LEFT', False),
               ('TYPE_AR', 'النوع', 'LEFT', False), ('STATUS', 'الحالة', 'LEFT', False),
               ('CLONED_FROM', 'منسوخ من', 'LEFT', False), ('UNITS', 'الوحدات', 'CENTER', False),
               ('POSITIONS', 'الوظائف', 'CENTER', False), ('CREATED_ON', 'أُنشئ', 'CENTER', False)])
    clone = p.plug('نسخ سيناريو', 20,
                   plug_header='النسخة شجرة مستقلة تحمل الرموز نفسها، فتُقارن بأصلها وحدةً بوحدة.')
    p.item('P40_SOURCE_ID', clone, 10, 'NATIVE_SELECT_LIST', 'المصدر', template=L_REQ, item_default=SCEN_DEFAULT,
           item_default_type='SQL_QUERY', lov=SCEN_LOV, lov_display_null='NO', cHeight=1, is_required=True,
           attributes=attrs(page_action_on_selection='NONE'))
    p.item('P40_NEW_CODE', clone, 20, 'NATIVE_TEXT_FIELD', 'رمز النسخة', template=L_REQ, is_required=True,
           cMaxlength=30, begin_on_new_line='N',
           attributes=attrs(disabled='N', submit_when_enter_pressed='N', subtype='TEXT', text_case='UPPER',
                            trim_spaces='BOTH'))
    p.item('P40_NEW_NAME', clone, 30, 'NATIVE_TEXT_FIELD', 'اسم النسخة', template=L_REQ, is_required=True,
           cMaxlength=200, begin_on_new_line='N',
           attributes=attrs(disabled='N', submit_when_enter_pressed='N', subtype='TEXT', trim_spaces='BOTH'))
    btn = p.button('CLONE', clone, 10, 'نسخ', hot=True)
    p.process('نسخ السيناريو', 10, 'AFTER_SUBMIT', 'NATIVE_PLSQL',
              process_sql_clob='DECLARE\n  l_id NUMBER;\nBEGIN\n'
                               '  l_id := org_scenario_pkg.clone_scenario(:P40_SOURCE_ID, :P40_NEW_CODE, :P40_NEW_NAME);\n'
                               'END;',
              process_clob_language='PLSQL', process_when_button_id=iid(btn),
              process_success_message='أُنشئت النسخة.')
    check = p.plug('التحقق من سيناريو', 30)
    p.item('P40_CHECK_ID', check, 10, 'NATIVE_SELECT_LIST', 'السيناريو', item_default=SCEN_DEFAULT,
           item_default_type='SQL_QUERY', lov=SCEN_LOV, lov_display_null='NO', cHeight=1, is_persistent='Y',
           attributes=attrs(page_action_on_selection='REDIRECT_SET_VALUE'))
    p.classic('نتيجة التحقق', 40,
              "SELECT DECODE(REGEXP_SUBSTR(column_value, '^[A-Z_]+'),\n"
              "              'NO_HEAD', 'وحدة بلا رئيس (تذكرها بطاقات موظفيها ولا بطاقة لرئيسها)',\n"
              "              REGEXP_SUBSTR(column_value, '^[A-Z_]+')) AS kind,\n"
              "       REGEXP_REPLACE(column_value, '^[A-Z_]+:\\s*') AS detail\n"
              '  FROM TABLE(org_scenario_pkg."VALIDATE"(:P40_CHECK_ID))',
              [('KIND', 'المشكلة', 'LEFT', False), ('DETAIL', 'التفاصيل', 'LEFT', False)],
              no_data='لا مشكلات: السيناريو شجرة سليمة.', ajax_items_to_submit='P40_CHECK_ID')
    out.append(p)
    return out


# ------------------------------------------------------- shared components --
MENU = [(10, 'الرئيسية', 1, 'fa-home', None), (20, 'الهيكل التنظيمي', 10, 'fa-sitemap', None),
        (30, 'الهيكل الوظيفي', 11, 'fa-users', None), (40, 'بطاقات الوصف', 20, 'fa-file-text-o', '20,21'),
        (50, 'المراجعة', 30, 'fa-check-square-o', '30,31'), (60, 'السيناريوهات', 40, 'fa-clone', None)]


def menu(root):
    f = root / 'application/shared_components/navigation/lists/navigation_menu.sql'
    t = f.read_text(encoding='utf-8')
    list_id = re.search(r'create_list\(\n p_id=>wwv_flow_imp\.id\((\d+)\)', t).group(1)
    items = re.findall(r'wwv_flow_imp_shared\.create_list_item\(\n.*?\n\);\n', t, re.S)
    keep = [i for i in items if "'f?p=&APP_ID.:10000:" in i]               # الإدارة, from the wizard
    keep = [i.replace("p_list_item_link_text=>'Administration'", "p_list_item_link_text=>'الإدارة'") for i in keep]
    new = [call('wwv_flow_imp_shared.create_list_item', id=iid(7000000000000 + 900000 + n), list_item_display_sequence=n,
                list_item_link_text=label, list_item_link_target=f'f?p=&APP_ID.:{pg}:&APP_SESSION.::&DEBUG.:::',
                list_item_icon=icon,
                list_item_current_type='COLON_DELIMITED_PAGE_LIST' if pages else 'TARGET_PAGE',
                list_item_current_for_pages=pages) + '\n'
           for n, label, pg, icon, pages in MENU]
    start = t.index(items[0]); end = t.index(items[-1]) + len(items[-1])
    f.write_text(t[:start] + ''.join(new + keep) + t[end:], encoding='utf-8')
    assert list_id


def plugin(root):
    t = NIB_PLUGIN.read_text(encoding='utf-8')
    t = (t.replace('p_default_workspace_id=>11553455087239366', f'p_default_workspace_id=>{WS}')
          .replace('p_default_application_id=>135', f'p_default_application_id=>{APP}')
          .replace("p_default_owner=>'WKSP_NIB'", f"p_default_owner=>'{OWNER}'"))
    # plugin ids are unique across the instance, and NIB's app 135 holds these: shift every one
    t = re.sub(r'wwv_flow_imp\.id\((\d+)\)', lambda m: f'wwv_flow_imp.id({int(m.group(1)) + PLUGIN_ID_SHIFT})', t)
    assert t.count(f'p_default_workspace_id=>{WS}') == 1 and 'WKSP_NIB' not in t and '11553455087239366' not in t
    f = root / 'application/shared_components/plugins/region_type/com_apexhierarchychart_plugin.sql'
    f.parent.mkdir(parents=True, exist_ok=True)
    f.write_text(t, encoding='utf-8')
    return '@@application/shared_components/plugins/region_type/com_apexhierarchychart_plugin.sql'


def install(root, plugin_ref, page_refs):
    f = root / 'install.sql'
    lines = [l for l in f.read_text(encoding='utf-8').splitlines() if l not in page_refs and l != plugin_ref]
    lines.insert(lines.index('@@application/plugin_settings.sql'), plugin_ref)
    end = lines.index('@@application/end_environment.sql')
    existing = [l for l in lines if l.startswith('@@application/pages/page_')]
    allp = sorted(set(existing) | set(page_refs))
    lines = [l for l in lines if l not in existing]
    end = lines.index('@@application/end_environment.sql')
    lines[end:end] = allp
    f.write_text('\n'.join(lines) + '\n', encoding='utf-8')


if __name__ == '__main__':
    ref = plugin(ROOT)
    menu(ROOT)
    install(ROOT, ref, [p.write(ROOT) for p in pages()])
    print('pages written:', ', '.join(str(p) for p in (1, 10, 11, 20, 21, 30, 31, 40)))
