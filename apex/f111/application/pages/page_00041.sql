prompt --application/pages/page_00041
begin
--   Manifest
--     PAGE: 00041
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
 p_id=>41
,p_name=>unistr('\0645\0642\0627\0631\0646\0629 \0627\0644\0647\064A\0643\0644\064A\0629 \0627\0644\0645\0642\062A\0631\062D\0629')
,p_alias=>'COMPARE'
,p_step_title=>unistr('\0645\0642\0627\0631\0646\0629 \0627\0644\0647\064A\0643\0644\064A\0629 \0627\0644\0645\0642\062A\0631\062D\0629')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004100012)
,p_plug_name=>unistr('\0627\0644\0645\0642\0627\0631\0646\0629')
,p_static_id=>unistr('\0627\0644\0645\0642\0627\0631\0646\0629')
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2102002977963900996
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT sector_sort, lineage_id, sector_ar, unit_ar, relation_ar, source_unit_ar,',
'       source_positions, source_cards, positions,',
unistr('       CASE is_open WHEN ''Y'' THEN ''\0628\0627\0646\062A\0638\0627\0631 \0642\0631\0627\0631'' END AS open_ar,'),
unistr('       DECODE(confidence, ''HIGH'', ''\0639\0627\0644\064A\0629'', ''MEDIUM'', ''\0645\062A\0648\0633\0637\0629'', ''LOW'', ''\0645\0646\062E\0641\0636\0629'') AS confidence_ar,'),
'       note, unit_code, source_unit_code',
'  FROM org_v_scenario_compare',
' WHERE scenario_id = :P41_SCENARIO_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P41_SCENARIO_ID'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(7000004100013)
,p_max_row_count_message=>unistr('\0627\0644\062D\062F \0627\0644\0623\0642\0635\0649 #MAX_ROW_COUNT# \0635\0641. \0636\064A\0651\0642 \0627\0644\0628\062D\062B.')
,p_no_data_found_message=>unistr('\0644\0627 \062A\0648\062C\062F \0628\064A\0627\0646\0627\062A')
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_internal_uid=>7000004100013
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100024)
,p_db_column_name=>'CONFIDENCE_AR'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>unistr('\0627\0644\062B\0642\0629 \0641\064A \0627\0644\0645\0637\0627\0628\0642\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100015)
,p_db_column_name=>'LINEAGE_ID'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>unistr('\0627\0644\0645\0639\0631\0651\0641')
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100025)
,p_db_column_name=>'NOTE'
,p_display_order=>12
,p_column_identifier=>'L'
,p_column_label=>unistr('\0645\0644\0627\062D\0638\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100023)
,p_db_column_name=>'OPEN_AR'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>unistr('\0645\0641\062A\0648\062D')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100022)
,p_db_column_name=>'POSITIONS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>unistr('\0648\0638\0627\0626\0641\0647\0627 \0641\064A \0627\0644\0645\0642\062A\0631\062D')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100018)
,p_db_column_name=>'RELATION_AR'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>unistr('\0627\0644\0639\0644\0627\0642\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100016)
,p_db_column_name=>'SECTOR_AR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>unistr('\0627\0644\0642\0637\0627\0639')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100014)
,p_db_column_name=>'SECTOR_SORT'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>unistr('\062A\0631\062A\064A\0628 \0627\0644\0642\0637\0627\0639')
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100021)
,p_db_column_name=>'SOURCE_CARDS'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>unistr('\0628\0637\0627\0642\0627\062A\0647\0627')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100020)
,p_db_column_name=>'SOURCE_POSITIONS'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>unistr('\0648\0638\0627\0626\0641\0647\0627 \0627\0644\064A\0648\0645')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100019)
,p_db_column_name=>'SOURCE_UNIT_AR'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>unistr('\0641\064A \0627\0644\0647\064A\0643\0644 \0627\0644\0642\0627\0626\0645')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100027)
,p_db_column_name=>'SOURCE_UNIT_CODE'
,p_display_order=>14
,p_column_identifier=>'N'
,p_column_label=>unistr('\0627\0644\0631\0645\0632 \0627\0644\0642\0627\0626\0645')
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100017)
,p_db_column_name=>'UNIT_AR'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>unistr('\0641\064A \0627\0644\0645\0642\062A\0631\062D')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004100026)
,p_db_column_name=>'UNIT_CODE'
,p_display_order=>13
,p_column_identifier=>'M'
,p_column_label=>unistr('\0627\0644\0631\0645\0632')
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(7000004100028)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SECTOR_AR:UNIT_AR:RELATION_AR:SOURCE_UNIT_AR:SOURCE_POSITIONS:SOURCE_CARDS:POSITIONS:OPEN_AR:CONFIDENCE_AR:NOTE'
,p_sort_column_1=>'SECTOR_SORT'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'LINEAGE_ID'
,p_sort_direction_2=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004100001)
,p_plug_name=>unistr('\0627\0644\0647\064A\0643\0644\064A\0629 \0627\0644\0645\0642\062A\0631\062D\0629')
,p_static_id=>unistr('\0627\0644\0647\064A\0643\0644\064A\0629-\0627\0644\0645\0642\062A\0631\062D\0629')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4502917002193490937
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004100011)
,p_plug_name=>unistr('\0639\0646 \0627\0644\0645\0642\0627\0631\0646\0629')
,p_static_id=>unistr('\0639\0646-\0627\0644\0645\0642\0627\0631\0646\0629')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4502917002193490937
,p_plug_display_sequence=>25
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>unistr('<p>\0643\0644 \0633\0637\0631 \0648\062D\062F\0629\064C \0641\064A \0627\0644\0647\064A\0643\0644\064A\0629 \0627\0644\0645\0642\062A\0631\062D\0629 \0648\0645\0635\062F\0631\0647\0627 \0641\064A \0627\0644\0647\064A\0643\0644 \0627\0644\0642\0627\0626\0645 \0643\0645\0627 \062A\0635\0641\0647 \0627\0644\0628\0637\0627\0642\0627\062A. \0627\0644\0645\0642\062A\0631\062D \064A\0642\0641 \0639\0646\062F \0645\0633\062A\0648\0649 \0627\0644\0645\062F\064A\0631\064A\0627\062A\060C \0641\0645\0627 \062A\062D\062A\0647\0627 \0641\064A \0627\0644\0645\0642\062A\0631\062D \0645\0646\0642\0648\0644\064C \0645\0646 \0627\0644\0647\064A\0643\0644 \0627\0644\0642\0627\0626\0645. \0627\0644\0648\062D\062F\0629 \0627\0644\0645\062F\0645\0648\062C\0629 \062A\0638\0647\0631 \0641\064A \0633\0637\0631\064A\0646\060C \0633\0637\0631\064D \0644\0643\0644 \0645\0635\062F\0631. \00AB\0628\0627\0646\062A\0638\0627\0631 \0642\0631\0627\0631\00BB \0633\0624\0627\0644\064C \0645\0641\062A\0648\062D \0645\0639 \0627\0644\0645\062D\0627\0641\0638\0629.</p>')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000004100003)
,p_name=>unistr('\0645\0644\062E\0635')
,p_static_id=>unistr('\0645\0644\062E\0635')
,p_template=>4073835273271169698
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noUI:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-BadgeList--large:t-BadgeList--dash:t-BadgeList--fixed'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COUNT(DISTINCT CASE WHEN relation = ''SAME''      THEN unit_code END)        AS same,',
'       COUNT(DISTINCT CASE WHEN relation = ''RENAMED''   THEN unit_code END)        AS renamed,',
'       COUNT(DISTINCT CASE WHEN relation = ''MERGED''    THEN unit_code END)        AS merged,',
'       COUNT(DISTINCT CASE WHEN relation = ''SPLIT''     THEN unit_code END)        AS split,',
'       COUNT(DISTINCT CASE WHEN relation = ''NEW''       THEN unit_code END)        AS new_units,',
'       COUNT(DISTINCT CASE WHEN relation = ''ABOLISHED'' THEN source_unit_code END) AS not_placed,',
'       COUNT(CASE WHEN is_open = ''Y'' THEN 1 END)                                  AS open_items',
'  FROM org_v_scenario_compare',
' WHERE scenario_id = :P41_SCENARIO_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P41_SCENARIO_ID'
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
 p_id=>wwv_flow_imp.id(7000004100006)
,p_query_column_id=>3
,p_column_alias=>'MERGED'
,p_column_display_sequence=>3
,p_column_heading=>unistr('\062F\064F\0645\062C\062A')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004100008)
,p_query_column_id=>5
,p_column_alias=>'NEW_UNITS'
,p_column_display_sequence=>5
,p_column_heading=>unistr('\062C\062F\064A\062F\0629')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004100009)
,p_query_column_id=>6
,p_column_alias=>'NOT_PLACED'
,p_column_display_sequence=>6
,p_column_heading=>unistr('\0644\0645 \062A\0648\0636\0639')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004100010)
,p_query_column_id=>7
,p_column_alias=>'OPEN_ITEMS'
,p_column_display_sequence=>7
,p_column_heading=>unistr('\0628\0627\0646\062A\0638\0627\0631 \0642\0631\0627\0631 \0627\0644\0645\062D\0627\0641\0638\0629')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004100005)
,p_query_column_id=>2
,p_column_alias=>'RENAMED'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\062A\063A\064A\0651\0631 \0627\0633\0645\0647\0627')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004100004)
,p_query_column_id=>1
,p_column_alias=>'SAME'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0643\0645\0627 \0647\064A')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004100007)
,p_query_column_id=>4
,p_column_alias=>'SPLIT'
,p_column_display_sequence=>4
,p_column_heading=>unistr('\0641\064F\0635\0644\062A')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000004100002)
,p_name=>'P41_SCENARIO_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000004100001)
,p_item_default=>'SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_TOBE_3_1'''
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>unistr('\0627\0644\0647\064A\0643\0644\064A\0629 \0627\0644\0645\0642\062A\0631\062D\0629')
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT name_ar AS d, scenario_id AS r FROM org_scenario WHERE scenario_type = ''TO_BE'' ORDER BY scenario_id'
,p_cHeight=>1
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'REDIRECT_SET_VALUE')).to_clob
);
wwv_flow_imp.component_end;
end;
/
