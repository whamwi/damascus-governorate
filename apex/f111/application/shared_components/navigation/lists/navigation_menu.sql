prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>40385165731532876
,p_default_application_id=>111
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DG'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(40988923153997318)
,p_name=>'Navigation Menu'
,p_static_id=>'navigation-menu'
,p_version_scn=>'SH256:y5l0-UqDjFC6wqnlCbiSMY1bzQer7biac0Fr4TjaXKU'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(41180691791998616)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>unistr('\0627\0644\0625\062F\0627\0631\0629')
,p_static_id=>'administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-user-wrench'
,p_security_scheme=>wwv_flow_imp.id(40994845935997361)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900010)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>unistr('\0627\0644\0631\0626\064A\0633\064A\0629')
,p_static_id=>unistr('\0627\0644\0631\0626\064A\0633\064A\0629')
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900060)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648\0647\0627\062A')
,p_static_id=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648\0647\0627\062A')
,p_list_item_link_target=>'f?p=&APP_ID.:40:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-clone'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900050)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>unistr('\0627\0644\0645\0631\0627\062C\0639\0629')
,p_static_id=>unistr('\0627\0644\0645\0631\0627\062C\0639\0629')
,p_list_item_link_target=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-check-square-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'30,31'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900020)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>unistr('\0627\0644\0647\064A\0643\0644 \0627\0644\062A\0646\0638\064A\0645\064A')
,p_static_id=>unistr('\0627\0644\0647\064A\0643\0644-\0627\0644\062A\0646\0638\064A\0645\064A')
,p_list_item_link_target=>'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-sitemap'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900030)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>unistr('\0627\0644\0647\064A\0643\0644 \0627\0644\0648\0638\064A\0641\064A')
,p_static_id=>unistr('\0627\0644\0647\064A\0643\0644-\0627\0644\0648\0638\064A\0641\064A')
,p_list_item_link_target=>'f?p=&APP_ID.:11:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-users'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900040)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>unistr('\0628\0637\0627\0642\0627\062A \0627\0644\0648\0635\0641')
,p_static_id=>unistr('\0628\0637\0627\0642\0627\062A-\0627\0644\0648\0635\0641')
,p_list_item_link_target=>'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-file-text-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'20,21'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7000000900070)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>unistr('\0645\0642\0627\0631\0646\0629 \0627\0644\0647\064A\0643\0644\064A\0627\062A')
,p_static_id=>unistr('\0645\0642\0627\0631\0646\0629-\0627\0644\0647\064A\0643\0644\064A\0627\062A')
,p_list_item_link_target=>'f?p=&APP_ID.:41:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-columns'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
