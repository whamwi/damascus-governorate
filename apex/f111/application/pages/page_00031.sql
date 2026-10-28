prompt --application/pages/page_00031
begin
--   Manifest
--     PAGE: 00031
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
 p_id=>31
,p_name=>unistr('\062A\0623\0643\064A\062F \0627\0644\0631\0626\064A\0633 \0627\0644\0645\0628\0627\0634\0631')
,p_alias=>'CONFIRM-LINE'
,p_page_mode=>'MODAL'
,p_step_title=>unistr('\062A\0623\0643\064A\062F \0627\0644\0631\0626\064A\0633 \0627\0644\0645\0628\0627\0634\0631')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2101883943284197310
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'720'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000003100008)
,p_plug_name=>unistr('\0627\0644\062A\0635\062D\064A\062D')
,p_static_id=>unistr('\0627\0644\062A\0635\062D\064A\062D')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'TABLE'
,p_query_table=>'ORG_POSITION'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'u'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000003100001)
,p_name=>unistr('\0645\0627 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_static_id=>unistr('\0645\0627-\0648\0631\062F-\0641\064A-\0627\0644\0628\0637\0627\0642\0629')
,p_template=>4073835273271169698
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT title_ar, unit_ar, issue_ar, card_code, supervisor_raw, linked_to_ar',
'  FROM org_v_review WHERE position_id = :P31_POSITION_ID'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2101991461423792139
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>unistr('\0623\064F\0643\0651\062F \0647\0630\0627 \0627\0644\0631\0628\0637 \0645\0646 \0642\0628\0644.')
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003100005)
,p_query_column_id=>4
,p_column_alias=>'CARD_CODE'
,p_column_display_sequence=>4
,p_column_heading=>unistr('\0627\0644\0628\0637\0627\0642\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003100004)
,p_query_column_id=>3
,p_column_alias=>'ISSUE_AR'
,p_column_display_sequence=>3
,p_column_heading=>unistr('\0645\0627 \064A\062D\062A\0627\062C \062A\0623\0643\064A\062F\0627\064B')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003100007)
,p_query_column_id=>6
,p_column_alias=>'LINKED_TO_AR'
,p_column_display_sequence=>6
,p_column_heading=>unistr('\0631\064F\0628\0637\062A \062D\0627\0644\064A\0627\064B \0628\0640')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003100006)
,p_query_column_id=>5
,p_column_alias=>'SUPERVISOR_RAW'
,p_column_display_sequence=>5
,p_column_heading=>unistr('\0627\0644\0631\0626\064A\0633 \0643\0645\0627 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003100002)
,p_query_column_id=>1
,p_column_alias=>'TITLE_AR'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0627\0644\0648\0638\064A\0641\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003100003)
,p_query_column_id=>2
,p_column_alias=>'UNIT_AR'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\0627\0644\0648\062D\062F\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(7000003100015)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(7000003100008)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>unistr('\0625\0644\063A\0627\0621')
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'javascript:apex.navigation.dialog.cancel(true);'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(7000003100014)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(7000003100008)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\062A\0623\0643\064A\062F')
,p_button_position=>'NEXT'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000003100011)
,p_name=>'P31_LINK_METHOD_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(7000003100008)
,p_item_source_plug_id=>wwv_flow_imp.id(7000003100008)
,p_source=>'LINK_METHOD_CODE'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000003100013)
,p_name=>'P31_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(7000003100008)
,p_item_source_plug_id=>wwv_flow_imp.id(7000003100008)
,p_prompt=>unistr('\0645\0644\0627\062D\0638\0629 (\0645\0646 \0623\0643\0651\062F \0648\0645\062A\0649)')
,p_source=>'NOTES'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cMaxlength=>4000
,p_cHeight=>3
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000003100009)
,p_name=>'P31_POSITION_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000003100008)
,p_item_source_plug_id=>wwv_flow_imp.id(7000003100008)
,p_source=>'POSITION_ID'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000003100012)
,p_name=>'P31_REPORTS_TO_POS_ID'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(7000003100008)
,p_item_source_plug_id=>wwv_flow_imp.id(7000003100008)
,p_prompt=>unistr('\0627\0644\0631\0626\064A\0633 \0627\0644\0645\0628\0627\0634\0631 \0627\0644\0635\062D\064A\062D')
,p_source=>'REPORTS_TO_POS_ID'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT p.title_ar || '' \2014 '' || u.name_ar AS d, p.position_id AS r'),
'  FROM org_position p JOIN org_unit u ON u.unit_id = p.unit_id',
' WHERE p.scenario_id = :P31_SCENARIO_ID AND p.position_id <> :P31_POSITION_ID',
' ORDER BY u.unit_code, p.sort_order'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('\2014 \0627\062E\062A\0631 \2014')
,p_cHeight=>1
,p_field_template=>1610598484065263269
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000003100010)
,p_name=>'P31_SCENARIO_ID'
,p_source_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(7000003100008)
,p_item_source_plug_id=>wwv_flow_imp.id(7000003100008)
,p_source=>'SCENARIO_ID'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(7000003100016)
,p_validation_name=>unistr('\0644\0627 \062F\0648\0631\0629 \0641\064A \0627\0644\0647\064A\0643\0644')
,p_static_id=>unistr('\0644\0627-\062F\0648\0631\0629-\0641\064A-\0627\0644\0647\064A\0643\0644')
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1 FROM org_position',
' WHERE position_id = :P31_REPORTS_TO_POS_ID',
' START WITH position_id = :P31_POSITION_ID',
' CONNECT BY NOCYCLE PRIOR position_id = reports_to_pos_id'))
,p_validation_type=>'NOT_EXISTS'
,p_error_message=>unistr('\0644\0627 \064A\0635\062D: \0627\0644\0631\0626\064A\0633 \0627\0644\0645\062E\062A\0627\0631 \064A\062A\0628\0639 \0647\0630\0647 \0627\0644\0648\0638\064A\0641\0629 \0646\0641\0633\0647\0627\060C \0641\064A\0635\064A\0631 \0627\0644\0647\064A\0643\0644 \062F\0627\0626\0631\0629.')
,p_when_button_pressed=>wwv_flow_imp.id(7000003100014)
,p_associated_item=>wwv_flow_imp.id(7000003100012)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000003100020)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>unistr('\0625\063A\0644\0627\0642')
,p_static_id=>unistr('\0625\063A\0644\0627\0642')
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(7000003100014)
,p_internal_uid=>7000003100020
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000003100017)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(7000003100008)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>unistr('\062A\0647\064A\0626\0629')
,p_static_id=>unistr('\062A\0647\064A\0626\0629')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'current_row_total_item', '',
  'next_primary_key_items', '',
  'previous_primary_key_items', '')).to_clob
,p_internal_uid=>7000003100017
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000003100019)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(7000003100008)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>unistr('\062D\0641\0638')
,p_static_id=>unistr('\062D\0641\0638')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'lock_row', 'Y',
  'prevent_lost_updates', 'Y',
  'return_primary_keys_after_insert', 'Y',
  'target_type', 'REGION_SOURCE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(7000003100014)
,p_internal_uid=>7000003100019
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000003100018)
,p_process_sequence=>5
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>unistr('\0648\0633\0645 \0627\0644\0631\0628\0637 \0645\0624\0643\064E\0651\062F\0627\064B')
,p_static_id=>unistr('\0648\0633\0645-\0627\0644\0631\0628\0637-\0645\0624\0643\064E\0651\062F\0627\064B')
,p_process_sql_clob=>':P31_LINK_METHOD_CODE := ''CONFIRMED_DG'';'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(7000003100014)
,p_internal_uid=>7000003100018
);
wwv_flow_imp.component_end;
end;
/
