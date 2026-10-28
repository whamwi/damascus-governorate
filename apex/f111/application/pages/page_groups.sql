prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 111
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>40385165731532876
,p_default_application_id=>111
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DG'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(40996471169997380)
,p_group_name=>'Administration'
,p_static_id=>'administration'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(41198070195998704)
,p_group_name=>'User Settings'
,p_static_id=>'user-settings'
);
wwv_flow_imp.component_end;
end;
/
