prompt --application/pages/page_00021
begin
--   Manifest
--     PAGE: 00021
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
 p_id=>21
,p_name=>unistr('\0627\0644\0628\0637\0627\0642\0629')
,p_alias=>'CARD'
,p_step_title=>unistr('\0627\0644\0628\0637\0627\0642\0629')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000002100001)
,p_plug_name=>unistr('\0627\0644\0628\0637\0627\0642\0629')
,p_static_id=>unistr('\0627\0644\0628\0637\0627\0642\0629')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'TABLE'
,p_query_table=>'JD_CARD'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'u'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000002100032)
,p_plug_name=>unistr('\0627\0644\0645\0647\0627\0645')
,p_static_id=>unistr('\0627\0644\0645\0647\0627\0645')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2102002977963900996
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT task_id, card_id, seq, task_ar, is_generic',
'  FROM jd_card_task',
' WHERE card_id = :P21_CARD_ID'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P21_CARD_ID'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(7000002100033)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>10
,p_use_as_row_header=>false
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(7000002100035)
,p_name=>'CARD_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CARD_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_use_as_row_header=>false
,p_is_primary_key=>false
,p_default_type=>'ITEM'
,p_default_expression=>'P21_CARD_ID'
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(7000002100038)
,p_name=>'IS_GENERIC'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_GENERIC'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>unistr('\0639\0627\0645\0629')
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_is_required=>true
,p_lov_type=>'STATIC'
,p_lov_source=>unistr('STATIC2:\0644\0627;N,\0646\0639\0645;Y')
,p_lov_display_extra=>false
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'N'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(7000002100036)
,p_name=>'SEQ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEQ'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>unistr('\0627\0644\062A\0631\062A\064A\0628')
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'center',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(7000002100037)
,p_name=>'TASK_AR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_AR'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>unistr('\0627\0644\0645\0647\0645\0629')
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(7000002100034)
,p_name=>'TASK_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TASK_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_use_as_row_header=>false
,p_is_primary_key=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(7000002100039)
,p_internal_uid=>7000002100039
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>false
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>false
,p_enable_flashback=>false
,p_define_chart_view=>false
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX'
,p_enable_mail_download=>false
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(7000002100040)
,p_interactive_grid_id=>wwv_flow_imp.id(7000002100039)
,p_static_id=>'primary'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(7000002100041)
,p_report_id=>wwv_flow_imp.id(7000002100040)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(7000002100042)
,p_view_id=>wwv_flow_imp.id(7000002100041)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(7000002100033)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>40
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(7000002100043)
,p_view_id=>wwv_flow_imp.id(7000002100041)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(7000002100036)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(7000002100044)
,p_view_id=>wwv_flow_imp.id(7000002100041)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(7000002100037)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(7000002100045)
,p_view_id=>wwv_flow_imp.id(7000002100041)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(7000002100038)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000002100027)
,p_name=>unistr('\0645\0648\0642\0639\0647\0627 \0641\064A \0627\0644\0647\064A\0643\0644')
,p_static_id=>unistr('\0645\0648\0642\0639\0647\0627-\0641\064A-\0627\0644\0647\064A\0643\0644')
,p_template=>4073835273271169698
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT unit_ar, reports_to_ar, link_method_ar, position_code',
'  FROM jd_v_card',
' WHERE card_id = :P21_CARD_ID AND (scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_ASIS_CARDS'') OR scenario_id IS NULL)'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P21_CARD_ID'
,p_lazy_loading=>false
,p_query_row_template=>2101991461423792139
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
 p_id=>wwv_flow_imp.id(7000002100030)
,p_query_column_id=>3
,p_column_alias=>'LINK_METHOD_AR'
,p_column_display_sequence=>3
,p_column_heading=>unistr('\0643\064A\0641 \062D\064F\062F\0650\0651\062F')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000002100031)
,p_query_column_id=>4
,p_column_alias=>'POSITION_CODE'
,p_column_display_sequence=>4
,p_column_heading=>unistr('\0631\0645\0632 \0627\0644\0648\0638\064A\0641\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000002100029)
,p_query_column_id=>2
,p_column_alias=>'REPORTS_TO_AR'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\0627\0644\0631\0626\064A\0633 \0627\0644\0645\0628\0627\0634\0631')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000002100028)
,p_query_column_id=>1
,p_column_alias=>'UNIT_AR'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0627\0644\0648\062D\062F\0629')
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(7000002100026)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(7000002100001)
,p_button_name=>'CANCEL'
,p_static_id=>'cancel'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_image_alt=>unistr('\0639\0648\062F\0629 \0625\0644\0649 \0627\0644\0642\0627\0626\0645\0629')
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(7000002100025)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(7000002100001)
,p_button_name=>'SAVE'
,p_static_id=>'save'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4073839297780169708
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\062D\0641\0638')
,p_button_position=>'NEXT'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(7000002100049)
,p_branch_name=>unistr('\0627\0644\0628\0642\0627\0621 \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_branch_action=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.::P21_CARD_ID:&P21_CARD_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100003)
,p_name=>'P21_CARD_CODE'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0631\0645\0632')
,p_source=>'CARD_CODE'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100002)
,p_name=>'P21_CARD_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_source=>'CARD_ID'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100006)
,p_name=>'P21_CLASS_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\062A\0635\0646\064A\0641')
,p_source=>'CLASS_CODE'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT name_ar d, class_code r FROM jd_class ORDER BY sort_order'
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('\2014 \063A\064A\0631 \0645\062D\062F\062F \2014')
,p_cHeight=>1
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100007)
,p_name=>'P21_CLASS_RAW'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0643\0645\0627 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_source=>'CLASS_RAW'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100010)
,p_name=>'P21_EFFORT_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0646\0648\0639 \0627\0644\062C\0647\062F')
,p_source=>'EFFORT_CODE'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT name_ar d, effort_code r FROM jd_effort ORDER BY sort_order'
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('\2014 \063A\064A\0631 \0645\062D\062F\062F \2014')
,p_cHeight=>1
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100011)
,p_name=>'P21_EFFORT_RAW'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0643\0645\0627 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_source=>'EFFORT_RAW'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100014)
,p_name=>'P21_EXPERIENCE_RAW'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\062E\0628\0631\0629 \0643\0645\0627 \0648\0631\062F\062A')
,p_source=>'EXPERIENCE_RAW'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100013)
,p_name=>'P21_EXPERIENCE_YEARS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0633\0646\0648\0627\062A \0627\0644\062E\0628\0631\0629')
,p_source=>'EXPERIENCE_YEARS'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cMaxlength=>3
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100018)
,p_name=>'P21_LOC_DEPARTMENT'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\062F\0627\0626\0631\0629')
,p_source=>'LOC_DEPARTMENT'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100017)
,p_name=>'P21_LOC_DIRECTORATE'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0645\062F\064A\0631\064A\0629')
,p_source=>'LOC_DIRECTORATE'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100020)
,p_name=>'P21_LOC_OFFICE'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0642\0633\0645 / \0627\0644\0645\0643\062A\0628')
,p_source=>'LOC_OFFICE'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100019)
,p_name=>'P21_LOC_SECTION'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0634\0639\0628\0629')
,p_source=>'LOC_SECTION'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100016)
,p_name=>'P21_OTHER_KNOWLEDGE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0645\0639\0627\0631\0641 \0623\062E\0631\0649')
,p_source=>'OTHER_KNOWLEDGE'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cMaxlength=>1000
,p_cHeight=>2
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
 p_id=>wwv_flow_imp.id(7000002100008)
,p_name=>'P21_QUAL_LEVEL_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0645\0624\0647\0644 \0627\0644\0639\0644\0645\064A')
,p_source=>'QUAL_LEVEL_CODE'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT name_ar d, qual_level_code r FROM jd_qual_level ORDER BY sort_order'
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('\2014 \063A\064A\0631 \0645\062D\062F\062F \2014')
,p_cHeight=>1
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100009)
,p_name=>'P21_QUAL_RAW'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0643\0645\0627 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_source=>'QUAL_RAW'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100024)
,p_name=>'P21_REVIEW_NOTE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0645\0644\0627\062D\0638\0627\062A \0627\0644\0645\0631\0627\062C\0639\0629')
,p_source=>'REVIEW_NOTE'
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
 p_id=>wwv_flow_imp.id(7000002100022)
,p_name=>'P21_SOURCE_FILE'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0645\0644\0641')
,p_source=>'SOURCE_FILE'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100023)
,p_name=>'P21_SOURCE_SEQ'
,p_source_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\062A\0631\062A\064A\0628\0647\0627 \0641\064A \0627\0644\0645\0644\0641')
,p_source=>'SOURCE_SEQ'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100012)
,p_name=>'P21_SPECIALISATION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0627\062E\062A\0635\0627\0635')
,p_source=>'SPECIALISATION'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cMaxlength=>400
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100004)
,p_name=>'P21_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\062D\0627\0644\0629')
,p_source=>'STATUS'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>unistr('STATIC2:\0645\0633\062A\0648\0631\062F\0629;IMPORTED,\0642\064A\062F \0627\0644\0645\0631\0627\062C\0639\0629;UNDER_REVIEW,\0631\0648\062C\0639\062A;REVIEWED,\0645\0639\062A\0645\062F\0629;APPROVED,\0645\0644\063A\0627\0629;RETIRED')
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1610598484065263269
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100021)
,p_name=>'P21_SUPERVISOR_RAW'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0631\0626\064A\0633 \0627\0644\0645\0628\0627\0634\0631 \0643\0645\0627 \0648\0631\062F')
,p_source=>'SUPERVISOR_RAW'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'TEXT',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000002100005)
,p_name=>'P21_TITLE_AR'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\0645\0633\0645\0649 \0627\0644\0648\0638\064A\0641\064A')
,p_source=>'TITLE_AR'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cMaxlength=>400
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
 p_id=>wwv_flow_imp.id(7000002100015)
,p_name=>'P21_TRAINING'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(7000002100001)
,p_item_source_plug_id=>wwv_flow_imp.id(7000002100001)
,p_prompt=>unistr('\0627\0644\062A\062F\0631\064A\0628')
,p_source=>'TRAINING'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cMaxlength=>1000
,p_cHeight=>2
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000002100046)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(7000002100001)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>unistr('\062A\0647\064A\0626\0629 \0627\0644\0628\0637\0627\0642\0629')
,p_static_id=>unistr('\062A\0647\064A\0626\0629-\0627\0644\0628\0637\0627\0642\0629')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'current_row_total_item', '',
  'next_primary_key_items', '',
  'previous_primary_key_items', '')).to_clob
,p_internal_uid=>7000002100046
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000002100047)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(7000002100001)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>unistr('\062D\0641\0638 \0627\0644\0628\0637\0627\0642\0629')
,p_static_id=>unistr('\062D\0641\0638-\0627\0644\0628\0637\0627\0642\0629')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'lock_row', 'Y',
  'prevent_lost_updates', 'Y',
  'return_primary_keys_after_insert', 'Y',
  'target_type', 'REGION_SOURCE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(7000002100025)
,p_process_success_message=>unistr('\062D\064F\0641\0638\062A \0627\0644\0628\0637\0627\0642\0629.')
,p_internal_uid=>7000002100047
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7000002100048)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(7000002100032)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>unistr('\062D\0641\0638 \0627\0644\0645\0647\0627\0645')
,p_static_id=>unistr('\062D\0641\0638-\0627\0644\0645\0647\0627\0645')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'lock_row', 'Y',
  'prevent_lost_updates', 'Y',
  'return_primary_keys_after_insert', 'Y',
  'target_type', 'REGION_SOURCE')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>7000002100048
);
wwv_flow_imp.component_end;
end;
/
