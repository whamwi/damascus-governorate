prompt --application/pages/page_00042
begin
--   Manifest
--     PAGE: 00042
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
 p_id=>42
,p_name=>unistr('\0627\0644\0647\064A\0627\0643\0644 \0627\0644\062B\0644\0627\062B\0629')
,p_alias=>'THREE-WAY'
,p_step_title=>unistr('\0627\0644\0647\064A\0627\0643\0644 \0627\0644\062B\0644\0627\062B\0629')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004200012)
,p_plug_name=>unistr('\0627\0644\0645\062F\064A\0631\064A\0627\062A \0641\064A \0627\0644\0647\064A\0627\0643\0644 \0627\0644\062B\0644\0627\062B\0629')
,p_static_id=>unistr('\0627\0644\0645\062F\064A\0631\064A\0627\062A-\0641\064A-\0627\0644\0647\064A\0627\0643\0644-\0627\0644\062B\0644\0627\062B\0629')
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2102002977963900996
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT unit_code, asis_ar, defacto_fate, tobe_fate, tobe_sector,',
'       asis_cards, defacto_units, defacto_no_card, cards_only_units, staff',
'  FROM org_v_three_way_dir'))
,p_plug_source_type=>'NATIVE_IR'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(7000004200013)
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
,p_detail_link=>'f?p=&APP_ID.:42:&APP_SESSION.::&DEBUG.::P42_DIR:#UNIT_CODE#'
,p_detail_link_text=>unistr('<span class="fa fa-search-plus" aria-hidden="true" title="\0648\062D\062F\0627\062A\0647\0627"></span>')
,p_internal_uid=>7000004200013
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200015)
,p_db_column_name=>'ASIS_AR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>unistr('\0641\064A \0627\0644\0628\0637\0627\0642\0627\062A (2003)')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200019)
,p_db_column_name=>'ASIS_CARDS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>unistr('\0628\0637\0627\0642\0627\062A\0647\0627')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200022)
,p_db_column_name=>'CARDS_ONLY_UNITS'
,p_display_order=>9
,p_column_identifier=>'I'
,p_column_label=>unistr('\0648\062D\062F\0627\062A \0641\064A \0627\0644\0628\0637\0627\0642\0627\062A \0644\0627 \0641\064A \0627\0644\0639\0631\0636')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200016)
,p_db_column_name=>'DEFACTO_FATE'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>unistr('\0641\0639\0644\064A\0627\064B \0627\0644\064A\0648\0645')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200021)
,p_db_column_name=>'DEFACTO_NO_CARD'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>unistr('\0645\0646\0647\0627 \0628\0644\0627 \0628\0637\0627\0642\0629')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200020)
,p_db_column_name=>'DEFACTO_UNITS'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>unistr('\0648\062D\062F\0627\062A\0647\0627 \0641\0639\0644\064A\0627\064B')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200023)
,p_db_column_name=>'STAFF'
,p_display_order=>10
,p_column_identifier=>'J'
,p_column_label=>unistr('\0627\0644\0639\0627\0645\0644\0648\0646 (30/9)')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200017)
,p_db_column_name=>'TOBE_FATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>unistr('\0641\064A \0627\0644\0645\0642\062A\0631\062D 3.1')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200018)
,p_db_column_name=>'TOBE_SECTOR'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>unistr('\0642\0637\0627\0639\0647\0627 \0641\064A \0627\0644\0645\0642\062A\0631\062D')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200014)
,p_db_column_name=>'UNIT_CODE'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>unistr('\0627\0644\0631\0645\0632')
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(7000004200024)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ASIS_AR:DEFACTO_FATE:TOBE_FATE:TOBE_SECTOR:ASIS_CARDS:DEFACTO_UNITS:DEFACTO_NO_CARD:CARDS_ONLY_UNITS:STAFF'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004200010)
,p_plug_name=>unistr('\0627\0644\0645\062F\064A\0631\064A\0629')
,p_static_id=>unistr('\0627\0644\0645\062F\064A\0631\064A\0629')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4502917002193490937
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004200009)
,p_plug_name=>unistr('\0639\0646 \0627\0644\0635\0641\062D\0629')
,p_static_id=>unistr('\0639\0646-\0627\0644\0635\0641\062D\0629')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4502917002193490937
,p_plug_display_sequence=>15
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>unistr('<p>\062B\0644\0627\062B\0629 \0647\064A\0627\0643\0644 \062C\0646\0628\0627\064B \0625\0644\0649 \062C\0646\0628: <b>\0627\0644\0628\0637\0627\0642\0627\062A</b> (\0627\0644\0646\0638\0627\0645 \0627\0644\062F\0627\062E\0644\064A \0644\0639\0627\0645 2003 \0643\0645\0627 \062A\0635\0641\0647 \0628\0637\0627\0642\0627\062A \0627\0644\0648\0635\0641)\060C \0648<b>\0627\0644\0647\064A\0643\0644 \0627\0644\0641\0639\0644\064A</b> (\0639\0631\0636 \00AB\0647\064A\0643\0644\064A\0627\062A \0645\062F\064A\0631\064A\0627\062A \0645\062D\0627\0641\0638\0629 \062F\0645\0634\0642\00BB\060C \0645\062F\064A\0631\064A\0629 \0627\0644\062A\0646\0645\064A\0629 \0627\0644\0625\062F\0627\0631\064A\0629 28/10)\060C \0648<b>\0627\0644\0645\0642\062A\0631\062D 3.1</b>. \0627\0644\0648\062D\062F\0629 \0627\0644\0645\0637\0627\0628\0642\0629 \0641\064A \0623\0643\062B\0631 \0645\0646 \0647\064A\0643\0644 \062A\062D\0645\0644 \0627\0644\0631\0645\0632 ')
||unistr('\0646\0641\0633\0647\061B \0648\062D\064A\062B \062A\063A\064A\0628 \0627\0644\0648\062D\062F\0629 \064A\0642\0648\0644 \0627\0644\062D\0642\0644 \0645\0627 \0635\0627\0631 \0625\0644\064A\0647\0627. \0627\0644\0645\0642\062A\0631\062D \064A\0642\0641 \0639\0646\062F \0627\0644\0645\062F\064A\0631\064A\0627\062A\060C \0641\0645\0627 \062A\062D\062A\0647\0627 \0641\064A\0647 \0645\0646\0642\0648\0644 \0645\0646 \0627\0644\0628\0637\0627\0642\0627\062A.</p><p>\0623\0639\062F\0627\062F \0627\0644\0639\0627\0645\0644\064A\0646 \0645\0646 \00AB\0625\062D\0635\0627\0626\064A\0629 \0645\062D\0627\0641\0638\0629 \062F\0645\0634\0642 30-9-2026\00BB: \0645\062C\0645\0648\0639 \0627\0644\0645\062F\064A\0631\064A\0627\062A 9222\060C \0648\0645\062C\0645\0648\0639 \0627\0644\0645\062D\0627\0641\0638\0629 \0641\064A \0645\0644\062E\0635 \0627\0644\0625\062D\0635\0627\0626\064A\0629 9925\061B \0627\0644\0641\0631\0642 703 \0645\062A\0639\0627\0642\062F\064A\0646 \0633\0646\0648\064A')
||unistr('\064A\0646 (\0627\0644\0642\0627\0646\0648\0646 53) \0644\0645 \064A\0648\0632\064E\0651\0639\0648\0627 \0639\0644\0649 \0627\0644\0645\062F\064A\0631\064A\0627\062A \0644\0623\0646 \0641\0631\0632\0647\0645 \062C\0627\0631\064D.</p>')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7000004200001)
,p_name=>unistr('\0645\0644\062E\0635')
,p_static_id=>unistr('\0645\0644\062E\0635')
,p_template=>4073835273271169698
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noUI:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-BadgeList--large:t-BadgeList--dash:t-BadgeList--fixed'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT (SELECT COUNT(*) FROM org_unit WHERE scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_ASIS_CARDS'')) AS units_cards,',
'       (SELECT COUNT(*) FROM org_unit WHERE scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_DEFACTO''))    AS units_defacto,',
'       (SELECT COUNT(*) FROM org_unit WHERE scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_TOBE_3_1''))   AS units_tobe,',
'       (SELECT COUNT(*) FROM org_v_three_way',
'         WHERE status = ''DEFACTO_NO_CARD'' AND unit_type_code <> ''DIRECTORATE'')     AS no_card,',
'       (SELECT COUNT(*) FROM org_v_three_way WHERE status = ''CARDS_ONLY'')            AS cards_only,',
'       (SELECT COUNT(p.card_id) FROM org_position p',
'         WHERE p.scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_ASIS_CARDS'')',
'           AND NOT EXISTS (SELECT 1 FROM org_position q',
'                            WHERE q.scenario_id = (SELECT scenario_id FROM org_scenario WHERE scenario_code = ''DG_DEFACTO'')',
'                              AND q.position_code = p.position_code))          AS cards_out,',
'       (SELECT SUM(total) FROM dg_headcount',
'         WHERE as_of = (SELECT MAX(as_of) FROM dg_headcount))                     AS staff',
'  FROM dual'))
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_imp.id(7000004200006)
,p_query_column_id=>5
,p_column_alias=>'CARDS_ONLY'
,p_column_display_sequence=>5
,p_column_heading=>unistr('\0648\062D\062F\0627\062A \0641\064A \0627\0644\0628\0637\0627\0642\0627\062A \0644\0627 \0641\064A \0627\0644\0639\0631\0636')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004200007)
,p_query_column_id=>6
,p_column_alias=>'CARDS_OUT'
,p_column_display_sequence=>6
,p_column_heading=>unistr('\0628\0637\0627\0642\0627\062A \0644\0627 \0645\0643\0627\0646 \0644\0647\0627 \0641\0639\0644\064A\0627\064B')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004200005)
,p_query_column_id=>4
,p_column_alias=>'NO_CARD'
,p_column_display_sequence=>4
,p_column_heading=>unistr('\0648\062D\062F\0627\062A \0641\0639\0644\064A\0629 \0628\0644\0627 \0628\0637\0627\0642\0629')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004200008)
,p_query_column_id=>7
,p_column_alias=>'STAFF'
,p_column_display_sequence=>7
,p_column_heading=>unistr('\0627\0644\0639\0627\0645\0644\0648\0646 \0641\064A \0627\0644\0645\062F\064A\0631\064A\0627\062A (30/9)')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004200002)
,p_query_column_id=>1
,p_column_alias=>'UNITS_CARDS'
,p_column_display_sequence=>1
,p_column_heading=>unistr('\0648\062D\062F\0627\062A \0627\0644\0628\0637\0627\0642\0627\062A (2003)')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004200003)
,p_query_column_id=>2
,p_column_alias=>'UNITS_DEFACTO'
,p_column_display_sequence=>2
,p_column_heading=>unistr('\0648\062D\062F\0627\062A \0627\0644\0647\064A\0643\0644 \0627\0644\0641\0639\0644\064A')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(7000004200004)
,p_query_column_id=>3
,p_column_alias=>'UNITS_TOBE'
,p_column_display_sequence=>3
,p_column_heading=>unistr('\0648\062D\062F\0627\062A \0627\0644\0645\0642\062A\0631\062D 3.1')
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000004200025)
,p_plug_name=>unistr('\0648\062D\062F\0627\062A \0627\0644\0645\062F\064A\0631\064A\0629')
,p_static_id=>unistr('\0648\062D\062F\0627\062A-\0627\0644\0645\062F\064A\0631\064A\0629')
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2102002977963900996
,p_plug_display_sequence=>40
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT unit_code, unit_type_ar, asis_ar, defacto_fate, tobe_fate, asis_cards,',
unistr('       DECODE(status, ''BOTH'', ''\0641\064A \0627\0644\0628\0637\0627\0642\0627\062A \0648\0641\0639\0644\064A\0627\064B'', ''DEFACTO_NO_CARD'', ''\0641\0639\0644\064A\0627\064B\060C \0628\0644\0627 \0628\0637\0627\0642\0629'','),
unistr('              ''DEFACTO_ONLY'', ''\0641\0639\0644\064A\0627\064B \0641\0642\0637'', ''CARDS_ONLY'', ''\0641\064A \0627\0644\0628\0637\0627\0642\0627\062A\060C \0644\0627 \0645\0631\0628\0639 \0644\0647\0627 \0641\064A \0627\0644\0639\0631\0636'','),
unistr('              ''PROPOSAL_ONLY'', ''\0641\064A \0627\0644\0645\0642\062A\0631\062D \0641\0642\0637'') AS status_ar'),
'  FROM org_v_three_way',
' WHERE dir_code = :P42_DIR AND unit_code <> :P42_DIR'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P42_DIR'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P42_DIR'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(7000004200026)
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
,p_internal_uid=>7000004200026
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200029)
,p_db_column_name=>'ASIS_AR'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>unistr('\0641\064A \0627\0644\0628\0637\0627\0642\0627\062A (2003)')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200032)
,p_db_column_name=>'ASIS_CARDS'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>unistr('\0628\0637\0627\0642\0627\062A\0647\0627')
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200030)
,p_db_column_name=>'DEFACTO_FATE'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>unistr('\0641\0639\0644\064A\0627\064B \0627\0644\064A\0648\0645')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200033)
,p_db_column_name=>'STATUS_AR'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>unistr('\0627\0644\062D\0627\0644\0629')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200031)
,p_db_column_name=>'TOBE_FATE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>unistr('\0641\064A \0627\0644\0645\0642\062A\0631\062D 3.1')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200027)
,p_db_column_name=>'UNIT_CODE'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>unistr('\0627\0644\0631\0645\0632')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(7000004200028)
,p_db_column_name=>'UNIT_TYPE_AR'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>unistr('\0627\0644\0646\0648\0639')
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
,p_available_clientside=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(7000004200034)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'primary'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'UNIT_CODE:UNIT_TYPE_AR:ASIS_AR:DEFACTO_FATE:TOBE_FATE:ASIS_CARDS:STATUS_AR'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000004200011)
,p_name=>'P42_DIR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000004200010)
,p_prompt=>unistr('\062A\0641\0627\0635\064A\0644 \0645\062F\064A\0631\064A\0629')
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT COALESCE(CASE WHEN defacto_fate NOT LIKE ''\062F\064F\0645\062C\062A%'' AND defacto_fate NOT LIKE ''\063A\064A\0631 \0642\0627\0626\0645\0629%'''),
'                         THEN defacto_fate END, asis_ar, tobe_fate) AS d, unit_code AS r',
'  FROM org_v_three_way_dir ORDER BY 1'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('\2014 \0627\062E\062A\0631 \0645\062F\064A\0631\064A\0629 \0644\0639\0631\0636 \0648\062D\062F\0627\062A\0647\0627 \2014')
,p_cHeight=>1
,p_field_template=>1610598304472262251
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'REDIRECT_SET_VALUE')).to_clob
);
wwv_flow_imp.component_end;
end;
/
