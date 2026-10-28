prompt --application/pages/page_00040
begin
--   Manifest
--     PAGE: 00040
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>40385165731532876
,p_default_application_id=>111
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DG'
);
wwv_flow_imp_page.create_page(
 p_id=>40
,p_name=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648\0647\0627\062A')
,p_alias=>'SCENARIOS'
,p_step_title=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648\0647\0627\062A')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004000016)
,p_plug_name=>unistr('\0627\0644\062A\062D\0642\0642 \0645\0646 \0633\064A\0646\0627\0631\064A\0648')
,p_static_id=>unistr('\0627\0644\062A\062D\0642\0642-\0645\0646-\0633\064A\0646\0627\0631\064A\0648')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000004000001)
,p_name=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648\0647\0627\062A')
,p_static_id=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648\0647\0627\062A')
,p_template=>4073835273271169698
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT s.scenario_code, s.name_ar, DECODE(s.scenario_type, ''AS_IS'', ''\0627\0644\0642\0627\0626\0645'', ''\0627\0644\0645\0642\062A\0631\062D'') AS type_ar,'),
'       s.status, f.scenario_code AS cloned_from,',
'       (SELECT COUNT(*) FROM org_unit u WHERE u.scenario_id = s.scenario_id)     AS units,',
'       (SELECT COUNT(*) FROM org_position o WHERE o.scenario_id = s.scenario_id) AS positions,',
'       TO_CHAR(s.created_on, ''YYYY-MM-DD'') AS created_on',
'  FROM org_scenario s LEFT JOIN org_scenario f ON f.scenario_id = s.cloned_from_id',
' ORDER BY s.scenario_id'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>unistr('\0644\0627 \062A\0648\062C\062F \0628\064A\0627\0646\0627\062A')
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000006)
,p_query_column_id=>5
,p_column_alias=>'CLONED_FROM'
,p_column_display_sequence=>5
,p_column_heading=>unistr('\0645\0646\0633\0648\062E \0645\0646')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000009)
,p_query_column_id=>8
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>8
,p_column_heading=>unistr('\0623\064F\0646\0634\0626')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000003)
,p_query_column_id=>2
,p_column_alias=>'NAME_AR'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\0627\0644\0627\0633\0645')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000008)
,p_query_column_id=>7
,p_column_alias=>'POSITIONS'
,p_column_display_sequence=>7
,p_column_heading=>unistr('\0627\0644\0648\0638\0627\0626\0641')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000002)
,p_query_column_id=>1
,p_column_alias=>'SCENARIO_CODE'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0627\0644\0631\0645\0632')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000005)
,p_query_column_id=>4
,p_column_alias=>'STATUS'
,p_column_display_sequence=>4
,p_column_heading=>unistr('\0627\0644\062D\0627\0644\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000004)
,p_query_column_id=>3
,p_column_alias=>'TYPE_AR'
,p_column_display_sequence=>3
,p_column_heading=>unistr('\0627\0644\0646\0648\0639')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000007)
,p_query_column_id=>6
,p_column_alias=>'UNITS'
,p_column_display_sequence=>6
,p_column_heading=>unistr('\0627\0644\0648\062D\062F\0627\062A')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000004000018)
,p_name=>unistr('\0646\062A\064A\062C\0629 \0627\0644\062A\062D\0642\0642')
,p_static_id=>unistr('\0646\062A\064A\062C\0629-\0627\0644\062A\062D\0642\0642')
,p_template=>4073835273271169698
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DECODE(REGEXP_SUBSTR(column_value, ''^[A-Z_]+''),',
unistr('              ''NO_HEAD'', ''\0648\062D\062F\0629 \0628\0644\0627 \0631\0626\064A\0633 (\062A\0630\0643\0631\0647\0627 \0628\0637\0627\0642\0627\062A \0645\0648\0638\0641\064A\0647\0627 \0648\0644\0627 \0628\0637\0627\0642\0629 \0644\0631\0626\064A\0633\0647\0627)'','),
'              REGEXP_SUBSTR(column_value, ''^[A-Z_]+'')) AS kind,',
'       REGEXP_REPLACE(column_value, ''^[A-Z_]+:\s*'') AS detail',
'  FROM TABLE(org_scenario_pkg."VALIDATE"(:P40_CHECK_ID))'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P40_CHECK_ID'
,p_lazy_loading=>false
,p_query_row_template=>2540130677583398057
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>unistr('\0644\0627 \0645\0634\0643\0644\0627\062A: \0627\0644\0633\064A\0646\0627\0631\064A\0648 \0634\062C\0631\0629 \0633\0644\064A\0645\0629.')
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000020)
,p_query_column_id=>2
,p_column_alias=>'DETAIL'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\0627\0644\062A\0641\0627\0635\064A\0644')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004000019)
,p_query_column_id=>1
,p_column_alias=>'KIND'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0627\0644\0645\0634\0643\0644\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004000010)
,p_plug_name=>unistr('\0646\0633\062E \0633\064A\0646\0627\0631\064A\0648')
,p_static_id=>unistr('\0646\0633\062E-\0633\064A\0646\0627\0631\064A\0648')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_plug_header=>unistr('\0627\0644\0646\0633\062E\0629 \0634\062C\0631\0629 \0645\0633\062A\0642\0644\0629 \062A\062D\0645\0644 \0627\0644\0631\0645\0648\0632 \0646\0641\0633\0647\0627\060C \0641\062A\064F\0642\0627\0631\0646 \0628\0623\0635\0644\0647\0627 \0648\062D\062F\0629\064B \0628\0648\062D\062F\0629.')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(7000004000014)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(7000004000010)
,p_button_name=>'CLONE'
,p_static_id=>'clone'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\0646\0633\062E')
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000004000017)
,p_name=>'P40_CHECK_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000004000016)
,p_item_default=>'SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_ASIS_CARDS'''
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT name_ar AS d, scenario_id AS r FROM org_scenario ORDER BY scenario_type, scenario_id'
,p_cHeight=>1
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'REDIRECT_SET_VALUE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000004000012)
,p_name=>'P40_NEW_CODE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(7000004000010)
,p_prompt=>unistr('\0631\0645\0632 \0627\0644\0646\0633\062E\0629')
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cMaxlength=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1610598484065263269
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'text_case', 'UPPER',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000004000013)
,p_name=>'P40_NEW_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(7000004000010)
,p_prompt=>unistr('\0627\0633\0645 \0627\0644\0646\0633\062E\0629')
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_field_template=>1610598484065263269
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000004000011)
,p_name=>'P40_SOURCE_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000004000010)
,p_item_default=>'SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_ASIS_CARDS'''
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>unistr('\0627\0644\0645\0635\062F\0631')
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT name_ar AS d, scenario_id AS r FROM org_scenario ORDER BY scenario_type, scenario_id'
,p_cHeight=>1
,p_field_template=>1610598484065263269
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000004000015)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>unistr('\0646\0633\062E \0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_static_id=>unistr('\0646\0633\062E-\0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_id NUMBER;',
'BEGIN',
'  l_id := org_scenario_pkg.clone_scenario(:P40_SOURCE_ID, :P40_NEW_CODE, :P40_NEW_NAME);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(7000004000014)
,p_process_success_message=>unistr('\0623\064F\0646\0634\0626\062A \0627\0644\0646\0633\062E\0629.')
,p_internal_uid=>7000004000015
);
wwv_flow_imp.component_end;
end;
/
