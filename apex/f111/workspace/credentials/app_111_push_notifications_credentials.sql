prompt --workspace/credentials/app_111_push_notifications_credentials
begin
--   Manifest
--     CREDENTIAL: App 111 Push Notifications Credentials
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>40385165731532876
,p_default_application_id=>111
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DG'
);
wwv_imp_workspace.create_credential(
 p_id=>41205419665998743
,p_name=>'App 111 Push Notifications Credentials'
,p_static_id=>'app-111-push-notifications-credentials'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
wwv_flow_imp.component_end;
end;
/
