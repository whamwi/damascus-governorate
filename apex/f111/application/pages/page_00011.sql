prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_name=>unistr('\0627\0644\0647\064A\0643\0644 \0627\0644\0648\0638\064A\0641\064A')
,p_alias=>'ORG-POSITIONS'
,p_step_title=>unistr('\0627\0644\0647\064A\0643\0644 \0627\0644\0648\0638\064A\0641\064A')
,p_autocomplete_on_off=>'OFF'
,p_step_template=>4073832297226169690
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000001100001)
,p_plug_name=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_static_id=>unistr('\0627\0644\0633\064A\0646\0627\0631\064A\0648')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4502917002193490937
,p_plug_display_sequence=>10
,p_plug_item_display_point=>'ABOVE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000001100003)
,p_plug_name=>unistr('\0627\0644\0647\064A\0643\0644 \0627\0644\0648\0638\064A\0641\064A')
,p_static_id=>unistr('\0627\0644\0647\064A\0643\0644-\0627\0644\0648\0638\064A\0641\064A')
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>20
,p_plug_item_display_point=>'ABOVE'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT id, parentid, "LEVEL", employeename, imageurl, office, positionname,',
'       description, category_color',
'  FROM org_v_chart_position',
' WHERE scenario_id = :P11_SCENARIO_ID',
' ORDER BY sib'))
,p_plug_source_type=>'PLUGIN_COM.APEXHIERARCHYCHART.PLUGIN'
,p_ajax_items_to_submit=>'P11_SCENARIO_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'id_column', 'ID',
  'last_node_level_to_be_expanded', '2',
  'node_button_template', wwv_flow_string.join(wwv_flow_t_varchar2(
    '<!-- <div class="node-button-div" style="pointer-events: none; display: flex; width: 100%; height: 100%;">',
    '    <div style="border:1px solid #E4E2E9;border-radius:3px;padding:3px;font-size:9px;margin:auto auto;background-color:white">',
    '        <div style="display:flex;">',
    '            <span style="align-items:center;display:flex;">',
    '                <svg width="8" height="8" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">',
    '                    <path d="M19.497 7.98903L12 15.297L4.503 7.98903C4.36905 7.85819 4.18924 7.78495 4.002 7.78495C3.81476 7.78495 3.63495 7.85819 3.501 7.98903C3.43614 8.05257 3.38462 8.12842 3.34944 8.21213C3.31427 8.29584 3.29615 8.38573 3.29615 8'
||'.47653C3.29615 8.56733 3.31427 8.65721 3.34944 8.74092C3.38462 8.82463 3.43614 8.90048 3.501 8.96403L11.4765 16.74C11.6166 16.8765 11.8044 16.953 12 16.953C12.1956 16.953 12.3834 16.8765 12.5235 16.74L20.499 8.96553C20.5643 8.90193 20.6162 8.8259 20.'
||'6517 8.74191C20.6871 8.65792 20.7054 8.56769 20.7054 8.47653C20.7054 8.38537 20.6871 8.29513 20.6517 8.21114C20.6162 8.12715 20.5643 8.05112 20.499 7.98753C20.3651 7.85669 20.1852 7.78345 19.998 7.78345C19.8108 7.78345 19.6309 7.85669 19.497 7.98753V'
||'7.98903Z" fill="#716E7B" stroke="#716E7B">                        ',
    '                    </path>',
    '                </svg>',
    '            </span>',
    '            <span style="margin-left:1px;color:#716E7B">${_directSubordinatesPaging}',
    '            </span>',
    '        </div>',
    '    </div>',
    '</div> -->',
    '<div class="node-button-div" style="pointer-events: none; display: flex; width: 100%; height: 100%;">',
    '    <div style="',
    '        margin: auto auto;',
    '        width: 24px;',
    '        height: 24px;',
    '        border-radius: 50%;',
    '        background: linear-gradient(135deg, #00AAEE 0%, #0099dd 50%, #0077BB 100%);',
    '        box-shadow: 0 2px 6px rgba(0, 153, 221, 0.5), 0 1px 3px rgba(0, 0, 0, 0.3);',
    '        display: flex;',
    '        align-items: center;',
    '        justify-content: center;',
    '        position: relative;',
    '    ">',
    '        <div style="',
    '            display: flex;',
    '            flex-direction: column;',
    '            align-items: center;',
    '            justify-content: center;',
    '        ">',
    '            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" style="margin-bottom: 1px;">',
    '                <path d="M19.497 7.98903L12 15.297L4.503 7.98903C4.36905 7.85819 4.18924 7.78495 4.002 7.78495C3.81476 7.78495 3.63495 7.85819 3.501 7.98903C3.43614 8.05257 3.38462 8.12842 3.34944 8.21213C3.31427 8.29584 3.29615 8.38573 3.29615 8.476'
||'53C3.29615 8.56733 3.31427 8.65721 3.34944 8.74092C3.38462 8.82463 3.43614 8.90048 3.501 8.96403L11.4765 16.74C11.6166 16.8765 11.8044 16.953 12 16.953C12.1956 16.953 12.3834 16.8765 12.5235 16.74L20.499 8.96553C20.5643 8.90193 20.6162 8.8259 20.6517'
||' 8.74191C20.6871 8.65792 20.7054 8.56769 20.7054 8.47653C20.7054 8.38537 20.6871 8.29513 20.6517 8.21114C20.6162 8.12715 20.5643 8.05112 20.499 7.98753C20.3651 7.85669 20.1852 7.78345 19.998 7.78345C19.8108 7.78345 19.6309 7.85669 19.497 7.98753V7.98'
||'903Z" fill="#ffffff" stroke="#ffffff" stroke-width="0.5">                        ',
    '                </path>',
    '            </svg>',
    '            <span style="',
    '                color: #ffffff;',
    '                font-size: 9px;',
    '                font-weight: bold;',
    '                font-family: Arial, sans-serif;',
    '                line-height: 1;',
    '            ">${_directSubordinatesPaging}</span>',
    '        </div>',
    '    </div>',
    '</div>')),
  'node_height', '120',
  'node_level_column', 'LEVEL',
  'node_template', wwv_flow_string.join(wwv_flow_t_varchar2(
    '<div style="width:220px;height:120px;box-sizing:border-box;background:#fff;border-radius:8px;border-top:6px solid ${cardColor};box-shadow:0 2px 6px rgba(0,0,0,.15);font-family:inherit;direction:rtl;text-align:center;padding:8px 10px;display:flex;flex'
||'-direction:column;justify-content:center;gap:4px;">',
    '  <div style="color:${cardColor};font-size:13px;font-weight:700;line-height:1.3;">${EMPLOYEENAME}</div>',
    '  <div style="color:#333;font-size:12px;line-height:1.3;">${POSITIONNAME}</div>',
    '  <div style="color:#666;font-size:11px;">${OFFICE}</div>',
    '  <div style="color:${cardColor};font-size:11px;">${DESCRIPTION}</div>',
    '</div>')),
  'node_template_column', 'EMPLOYEENAME,POSITIONNAME,OFFICE,DESCRIPTION,CATEGORY_COLOR',
  'node_width', '220',
  'parent_id_column', 'PARENTID',
  'partial_data_load', 'N')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(7000001100004)
,p_plug_name=>unistr('\062F\0644\064A\0644 \0627\0644\0623\0644\0648\0627\0646')
,p_static_id=>unistr('\062F\0644\064A\0644-\0627\0644\0623\0644\0648\0627\0646')
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4073835273271169698
,p_plug_display_sequence=>30
,p_plug_item_display_point=>'ABOVE'
,p_plug_source=>unistr('<div style="display:flex;flex-wrap:wrap;gap:16px;font-size:12px;"><span><span style="display:inline-block;width:12px;height:12px;border-radius:3px;background:#2B6CA3;margin-inline-end:6px;vertical-align:middle;"></span>\0631\0628\0637 \0648\0631\062F \0641\064A \0627\0644\0628\0637\0627\0642\0629</span><span>')
||unistr('<span style="display:inline-block;width:12px;height:12px;border-radius:3px;background:#9A5B00;margin-inline-end:6px;vertical-align:middle;"></span>\0631\0628\0637 \062A\0642\0631\064A\0628\064A \0623\0648 \0645\0633\062A\0646\062A\062C: \064A\062D\062A\0627\062C \062A\0623\0643\064A\062F\0627\064B</span><span><span style="display:inline-block;width:12px;height:12p')
||unistr('x;border-radius:3px;background:#8A2432;margin-inline-end:6px;vertical-align:middle;"></span>\0648\0638\064A\0641\0629 \0644\0627 \0628\0637\0627\0642\0629 \0644\0647\0627</span></div>')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7000001100002)
,p_name=>'P11_SCENARIO_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(7000001100001)
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
wwv_flow_imp.component_end;
end;
/
