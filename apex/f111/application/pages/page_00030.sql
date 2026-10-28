prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
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
 p_id=>30
,p_name=>unistr('\0627\0644\0645\0631\0627\062C\0639\0629')
,p_alias=>'REVIEW'
,p_step_title=>unistr('\0627\0644\0645\0631\0627\062C\0639\0629')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000003000001)
,p_plug_name=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_static_id=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4502917002193490937
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000003000009)
,p_plug_name=>unistr('\0642\0627\0626\0645\0629 \0627\0644\0645\0631\0627\062C\0639\0629')
,p_static_id=>unistr('\0642\0627\0626\0645\0629-\0627\0644\0645\0631\0627\062C\0639\0629')
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2102002977963900996
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT position_id, issue_ar, title_ar, unit_ar, bylaws_article, card_code,',
'       supervisor_raw, linked_to_ar, reports',
'  FROM org_v_review',
' WHERE scenario_id = :P30_SCENARIO_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P30_SCENARIO_ID'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(7000003000010)
,p_max_row_count_message=>unistr('\0627\0644\062D\062F \0627\0644\0623\0642\0635\0649 #MAX_ROW_COUNT# \0635\0641. \0636\064A\0651\0642 \0627\0644\0628\062D\062B.')
,p_no_data_found_message=>unistr('\0644\0627 \062A\0648\062C\062F \0628\064A\0627\0646\0627\062A')
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_detail_link=>'f?p=&APP_ID.:31:&APP_SESSION.::&DEBUG.:31:P31_POSITION_ID:#POSITION_ID#'
,p_detail_link_text=>unistr('<span class="fa fa-wrench" aria-hidden="true" title="\062A\0635\062D\064A\062D"></span>')
,p_internal_uid=>7000003000010
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000015)
,p_db_column_name=>'BYLAWS_ARTICLE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>unistr('\0627\0644\0645\0627\062F\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000016)
,p_db_column_name=>'CARD_CODE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>unistr('\0627\0644\0628\0637\0627\0642\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000012)
,p_db_column_name=>'ISSUE_AR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>unistr('\0645\0627 \064A\062D\062A\0627\062C \062A\0623\0643\064A\062F\0627\064B')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000018)
,p_db_column_name=>'LINKED_TO_AR'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>unistr('\0631\064F\0628\0637\062A \062D\0627\0644\064A\0627\064B \0628\0640')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000011)
,p_db_column_name=>'POSITION_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>unistr('\0627\0644\0645\0639\0631\0651\0641')
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000019)
,p_db_column_name=>'REPORTS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>unistr('\0645\0631\0624\0648\0633\0648\0646')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000017)
,p_db_column_name=>'SUPERVISOR_RAW'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>unistr('\0627\0644\0631\0626\064A\0633 \0643\0645\0627 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000013)
,p_db_column_name=>'TITLE_AR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>unistr('\0627\0644\0648\0638\064A\0641\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000003000014)
,p_db_column_name=>'UNIT_AR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>unistr('\0627\0644\0648\062D\062F\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(7000003000020)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ISSUE_AR:TITLE_AR:UNIT_AR:BYLAWS_ARTICLE:CARD_CODE:SUPERVISOR_RAW:LINKED_TO_AR:REPORTS'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000003000003)
,p_name=>unistr('\0645\0627 \064A\062D\062A\0627\062C \062A\0623\0643\064A\062F\0627\064B')
,p_static_id=>unistr('\0645\0627-\064A\062D\062A\0627\062C-\062A\0623\0643\064A\062F\0627\064B')
,p_template=>4073835273271169698
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUM(CASE issue WHEN ''NO_CARD'' THEN 1 END)       AS no_card,',
'       SUM(CASE issue WHEN ''NO_SUPERVISOR'' THEN 1 END) AS no_supervisor,',
'       SUM(CASE issue WHEN ''APPROXIMATE'' THEN 1 END)   AS approximate,',
'       SUM(CASE issue WHEN ''INFERRED'' THEN 1 END)      AS inferred,',
'       COUNT(*)                                        AS total',
'  FROM org_v_review',
' WHERE scenario_id = :P30_SCENARIO_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P30_SCENARIO_ID'
,p_lazy_loading=>false
,p_query_row_template=>2106120299521025145
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
 p_id=>wwv_flow_imp.id(7000003000006)
,p_query_column_id=>3
,p_column_alias=>'APPROXIMATE'
,p_column_display_sequence=>3
,p_column_heading=>unistr('\0631\0628\0637 \062A\0642\0631\064A\0628\064A')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003000007)
,p_query_column_id=>4
,p_column_alias=>'INFERRED'
,p_column_display_sequence=>4
,p_column_heading=>unistr('\0631\0628\0637 \0645\0633\062A\0646\062A\062C')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003000004)
,p_query_column_id=>1
,p_column_alias=>'NO_CARD'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0648\0638\064A\0641\0629 \0628\0644\0627 \0628\0637\0627\0642\0629')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003000005)
,p_query_column_id=>2
,p_column_alias=>'NO_SUPERVISOR'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\0628\0644\0627 \0631\0626\064A\0633 \0645\0628\0627\0634\0631')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000003000008)
,p_query_column_id=>5
,p_column_alias=>'TOTAL'
,p_column_display_sequence=>5
,p_column_heading=>unistr('\0627\0644\0645\062C\0645\0648\0639')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000003000002)
,p_name=>'P30_SCENARIO_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000003000001)
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
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(7000003000021)
,p_name=>unistr('\062A\062D\062F\064A\062B \0628\0639\062F \0627\0644\062A\0635\062D\064A\062D')
,p_static_id=>unistr('\062A\062D\062F\064A\062B-\0628\0639\062F-\0627\0644\062A\0635\062D\064A\062D')
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(7000003000009)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(7000003000022)
,p_event_id=>wwv_flow_imp.id(7000003000021)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-submit-page'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'show_processing', 'Y')).to_clob
);
wwv_flow_imp.component_end;
end;
/
