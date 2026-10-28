prompt --application/shared_components/plugins/region_type/apex_fancytree_select
begin
--   Manifest
--     PLUGIN: APEX.FANCYTREE.SELECT
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>40385165731532876
,p_default_application_id=>111
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DG'
);
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(142832840034600703466)
,p_plugin_type=>'REGION TYPE'
,p_name=>'APEX.FANCYTREE.SELECT'
,p_display_name=>'APEX Fancy Tree'
,p_apexlang_name=>'apexFancyTree'
,p_image_prefix=>nvl(wwv_flow_application_install.get_static_plugin_file_prefix('REGION TYPE','APEX.FANCYTREE.SELECT'),'')
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION SQL_TO_SYS_REFCURSOR (',
'    P_IN_SQL_STATEMENT   CLOB,',
'    P_IN_BINDS           SYS.DBMS_SQL.VARCHAR2_TABLE',
') RETURN SYS_REFCURSOR AS',
'    VR_CURS         BINARY_INTEGER;',
'    VR_REF_CURSOR   SYS_REFCURSOR;',
'    VR_EXEC         BINARY_INTEGER;',
'    VR_BINDS        VARCHAR(32767);',
'BEGIN',
'    VR_CURS         := DBMS_SQL.OPEN_CURSOR;',
'    DBMS_SQL.PARSE(',
'        VR_CURS,',
'        P_IN_SQL_STATEMENT,',
'        DBMS_SQL.NATIVE',
'    );',
'    IF P_IN_BINDS.COUNT > 0 THEN',
'        FOR I IN 1..P_IN_BINDS.COUNT LOOP',
'            /* TODO find out how to prevent ltrim */',
'            VR_BINDS   := LTRIM(',
'                P_IN_BINDS(I),',
'                '':''',
'            );',
'            DBMS_SQL.BIND_VARIABLE(',
'                VR_CURS,',
'                VR_BINDS,',
'                V(VR_BINDS)',
'            );',
'        END LOOP;',
'    END IF;',
'',
'    VR_EXEC         := DBMS_SQL.EXECUTE(VR_CURS);',
'    VR_REF_CURSOR   := DBMS_SQL.TO_REFCURSOR(VR_CURS);',
'    RETURN VR_REF_CURSOR;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        IF DBMS_SQL.IS_OPEN(VR_CURS) THEN',
'            DBMS_SQL.CLOSE_CURSOR(VR_CURS);',
'        END IF;',
'        RAISE;',
'END;',
'',
'FUNCTION F_AJAX (',
'    P_REGION   IN         APEX_PLUGIN.T_REGION,',
'    P_PLUGIN   IN         APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_REGION_AJAX_RESULT IS',
'    VR_RESULT       APEX_PLUGIN.T_REGION_AJAX_RESULT;',
'    VR_CUR          SYS_REFCURSOR;',
'    VR_BIND_NAMES   SYS.DBMS_SQL.VARCHAR2_TABLE;',
'BEGIN',
'    /* undocumented function of APEX for get all bindings */',
'    VR_BIND_NAMES   := WWV_FLOW_UTILITIES.GET_BINDS(P_REGION.SOURCE);',
'',
'    /* execute binding*/',
'    VR_CUR          := SQL_TO_SYS_REFCURSOR(',
'        RTRIM(',
'            P_REGION.SOURCE,',
'            '';''',
'        ),',
'        VR_BIND_NAMES',
'    );',
'',
'    /* create json */',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(',
'        ''row'',',
'        VR_CUR',
'    );',
'    APEX_JSON.CLOSE_OBJECT;',
'',
'    RETURN VR_RESULT;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_REGION                IN APEX_PLUGIN.T_REGION,',
'    P_PLUGIN                IN APEX_PLUGIN.T_PLUGIN,',
'    P_IS_PRINTER_FRIENDLY   IN BOOLEAN',
') RETURN APEX_PLUGIN.T_REGION_RENDER_RESULT IS',
'    VR_RESULT             APEX_PLUGIN.T_REGION_RENDER_RESULT;',
'    C_CONF_JSON           CONSTANT APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_01%TYPE := P_REGION.ATTRIBUTE_01;',
'    C_SRC_ITEM            CONSTANT APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_02%TYPE := P_REGION.ATTRIBUTE_02;',
'    C_ERR_MSG             CONSTANT APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_03%TYPE := P_REGION.ATTRIBUTE_03;',
'    C_ACTIVE_ID_ITEM      CONSTANT APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_04%TYPE := P_REGION.ATTRIBUTE_04;',
'    C_EXPANDED_NOTES_ITEM CONSTANT APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_07%TYPE := P_REGION.ATTRIBUTE_07;',
'    C_ITEMS2SUBMIT        CONSTANT APEX_APPLICATION_PAGE_REGIONS.AJAX_ITEMS_TO_SUBMIT%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_REGION.AJAX_ITEMS_TO_SUBMIT);',
'    C_REGION_ID           CONSTANT VARCHAR2(200 CHAR) := ''ft-'' || P_REGION.STATIC_ID;',
'    VR_IS_CACHE_VALID     VARCHAR2(4000 CHAR) := ''V1'';',
'    VR_USE_LOCALSTORAGE   APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_05%TYPE := P_REGION.ATTRIBUTE_05;',
'    VR_GET_CACHE_VERSION  APEX_APPLICATION_PAGE_REGIONS.ATTRIBUTE_06%TYPE := P_REGION.ATTRIBUTE_06;',
'BEGIN',
'    APEX_CSS.ADD_FILE(',
'        P_NAME        => ''fancytree.pkgd.min'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''fancytreecsssrc''',
'    );',
'',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME        => ''fancytree.pkgd.min'',',
'        P_DIRECTORY   => P_PLUGIN.FILE_PREFIX,',
'        P_VERSION     => NULL,',
'        P_KEY         => ''fancytreejssrc''',
'    );',
'',
'    SYS.HTP.P( ''<div id="''|| APEX_PLUGIN_UTIL.ESCAPE( C_REGION_ID, TRUE ) || ''" class="fancy-tree-region"></div>'' );',
'    ',
'    IF VR_USE_LOCALSTORAGE = ''Y'' AND VR_GET_CACHE_VERSION IS NOT NULL THEN',
'        VR_IS_CACHE_VALID := APEX_PLUGIN_UTIL.GET_PLSQL_FUNCTION_RESULT(VR_GET_CACHE_VERSION);',
'    END IF;',
'',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE( ''apex.jQuery(window).on("theme42ready", function() { fancyTree(apex, $).initTree(''',
'     || APEX_JAVASCRIPT.ADD_VALUE( ''#'' || C_REGION_ID, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( APEX_PLUGIN.GET_AJAX_IDENTIFIER, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.NO_DATA_FOUND_MESSAGE, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( C_ERR_MSG, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( C_CONF_JSON, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( C_ITEMS2SUBMIT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( P_REGION.ESCAPE_OUTPUT, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( C_SRC_ITEM, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( C_ACTIVE_ID_ITEM, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( VR_USE_LOCALSTORAGE, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( VR_IS_CACHE_VALID, TRUE )',
'     || APEX_JAVASCRIPT.ADD_VALUE( C_EXPANDED_NOTES_ITEM, FALSE )',
'     || ''); });'' );',
'',
'    RETURN VR_RESULT;',
'END;'))
,p_api_version=>1
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:NO_DATA_FOUND_MESSAGE:ESCAPE_OUTPUT'
,p_substitute_attributes=>true
,p_version_scn=>'45585011523417'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This Plug-in is used to draw a FancyTree with select option. Selected item ids could be stored into apex items.</p>',
'<p>To trigger the following actions just fire e.g. on button click a dynamic action with JavaScriptCode:</p>',
'<ul>',
'<li><b>Expand Parents of selected Nodes all: </b>$("#static-tree-region-id-of-the-tree-region").trigger("expandSelected");</li>',
'<li><b>Expand all: </b>$("#static-tree-region-id-of-the-tree-region").trigger("expandAll");</li>',
'<li><b>Collapse all: </b>$("#static-tree-region-id-of-the-tree-region").trigger("collapseAll");</li>',
'<li><b>Select all: </b>$("#static-tree-region-id-of-the-tree-region").trigger("selectAll");</li>',
'<li><b>Unselect all: </b>$("#static-tree-region-id-of-the-tree-region").trigger("unselectAll");</li>',
'<li><b>expand Tree to a specific Level (When you left data then configJSON is used): </b>$("#static-tree-region-id-of-the-tree-region").trigger("expandToLevel", 3);</li>',
'</ul>',
'<p>When expand or collapse a node then also a event is fired on the region:</p>',
'<ul>',
'<li><b>Event on collapse: </b> "collapsed"</li>',
'<li><b>Event on expand: </b> "expanded"</li>',
'</ul>',
'<p>The tree also supports apexbeforerefresh and apexafterefresh event that are available in dynamic actions.</p>'))
,p_version_identifier=>'25.03.17'
,p_about_url=>'https://github.com/RonnyWeiss/Apex-Fancy-Tree-Select'
,p_files_version=>3280
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(142832840191508703480)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'attribute_01'
,p_prompt=>'ConfigJSON'
,p_apexlang_name=>'configjson'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "animationDuration": 200,',
'  "autoExpand2Level": 0,',
'  "checkbox": "fa-square-o",',
'  "checkboxSelected": "fa-check-square",',
'  "checkboxUnknown": "fa-square",',
'  "enableCheckBox": true,',
'  "forceSelectionSet": true,',
'  "forceRefreshEventOnStart": false,',
'  "iconExpanderOpen": "fa-caret-down",',
'  "iconExpanderClosed": "fa-caret-right",',
'  "markNodesWithChildren": false,',
'  "markerModifier": "fam-plus fam-is-info",',
'  "openParentOfActiveNode": true,',
'  "openParentOfSelected": true,',
'  "refresh": 0,',
'  "search": {',
'    "autoExpand": true,',
'    "leavesOnly": false,',
'    "highlight": true,',
'    "counter": true,',
'    "hideUnmatched": true,',
'    "debounce": {',
'      "enabled": true,',
'      "time": 400',
'    }',
'  },',
'  "selectMode": 2,',
'  "selectOnlyOnePerGroup": false,',
'  "setActiveNode": true,',
'  "setItemsOnInit": false,',
'  "typeSettings": [',
'    {',
'      "id": 10,',
'      "storeItem": "P15_TYPE_10",',
'      "icon": "fa-folder-o"',
'    }, {',
'      "id": 20,',
'      "storeItem": "P15_TYPE_20",',
'      "icon": "fa-file-o"',
'    }',
'  ]',
'}'))
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<br>',
'<h3>Explanation:</h3>',
'<ul>',
'<li><b>animationDuration (number): </b>set duration in ms of animations (when set 0 then animations are off)</li>',
'<li><b>autoExpand2Level (number): </b>set how many levels are expanded on startup, if 0 or null then tree is not expanded</li>',
'<li><b>checkbox (string)</b>: default icon of checkboxes when unchecked</li>',
'<li><b>checkboxSelected (string): </b>default icon of the checkboxes when selected</li>',
'<li><b>checkboxUnknown (string): </b>default icon of the checkboxes when unknown</li>',
'<li><b>enableCheckBox (boolean): </b>used to en- or disable checkboxen by default</li>',
'<li><b>forceSelectionSet (boolean): </b>Used to set which values should be set when use select mode 3. Only top parents are set as values to items when selected. Because logically the childrens are included when select a parent. If children also shou'
||'ld be set to item this settings need so be set to false</li>',
'<li><b>forceRefreshEventOnStart (boolean): </b>The tree also supports apexbeforerefresh and apexafterefresh event that are available in dynamic actions. On default these events are triggered only on refresh. Set this attribute true to force it also o'
||'n first load.</li>',
'<li><b>iconExpanderOpen (string): </b>Icon for the expander when open</li>',
'<li><b>iconExpanderClosed (string): </b>Icon for the expander when closed</li>',
'<li><b>markNodesWithChildren (boolean): </b>add fa-apex modifier to parent nodes with selected children or the active node - Feature only avail when using font-apex icons</li>',
'<li><b>markerModifier (string): </b>set modifier class for markNodesWithChildren feature</li>',
'<li><b>openParentOfActiveNode(boolean): </b>expand parents of active node on init</li>',
'<li><b>openParentOfSelected (boolean): </b> open parents of selected nodes on init</li>',
'<li><b>refresh (number): </b>set auto refresh of the tree region in seconds. When 0 then autorefresh is off</li>',
'<li><b>search (object):</b>',
'<ul>',
'<li><b>autoExpand (boolean): </b>Expand all branches that contain matches<b><br /></b></li>',
'<li><b>leavesOnly (boolean): </b>Search only leaves<b><br /></b></li>',
'<li><b>highlight (boolean): </b>Highlight matches<b><br /></b></li>',
'<li><b>counter (boolean): </b>show a badge with number of contained matches<b><br /></b></li>',
'<li><b>hideUnmatched (boolean):</b> hide or grayout unmatched items</li>',
'<li><b>debounce(object):</b>',
'<ul>',
'<li><b>enabled (boolean)</b>: enable debounce of search input</b></li>',
'<li><b>time (number): </b>: wait time before executing search after input</li>',
'</ul>',
'</li>',
'</ul>',
'<li><b>selectMode (number): 1</b> - single selection; 2 - multi-selection; 3 - for hierarchical selection</li>',
'<li><b>selectOnlyOnePerGroup (boolean): Enable to select only one entry per group</li>',
'<li><b>setActiveNode (boolean):</b> enable when click on node that Active Node item is set with value of the node. An item has to be set in Active Node ID attribute of the plug-in</li>',
'<li><b>setItemsOnInit (boolean): </b>set values of items that are configured in typeSettings on load. So every node that is set as selected in sql src will be add as value to the items</li>',
'<li><b>typeSettings[i] (object):</b>',
'<ul>',
'<li><b>id (string)</b>: in sql source are types defined. This value is used for mapping of type value in sql source and in this config json</li>',
'<li><b>storeItem (string): </b>: in sql source are types defined. This value is used to define the item name where the values from sql are stored</li>',
'<li><b>icon (string): </b>: in sql source are types defined. This value is used to set an icon for the type when nothing is defined in sql source</li>',
'</ul>',
'</li>',
'</ul>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'{',
'  "animationDuration": 200,',
'  "autoExpand2Level": 0,',
'  "checkbox": "fa-square-o",',
'  "checkboxSelected": "fa-check-square",',
'  "checkboxUnknown": "fa-square",',
'  "enableCheckBox": true,',
'  "forceSelectionSet": true,',
'  "forceRefreshEventOnStart": false,',
'  "iconExpanderOpen": "fa-caret-down",',
'  "iconExpanderClosed": "fa-caret-right",',
'  "markNodesWithChildren": false,',
'  "markerModifier": "fam-plus fam-is-info",',
'  "openParentOfActiveNode": true,',
'  "openParentOfSelected": true,',
'  "refresh": 0,',
'  "search": {',
'    "autoExpand": true,',
'    "leavesOnly": false,',
'    "highlight": true,',
'    "counter": true,',
'    "hideUnmatched": true,',
'    "debounce": {',
'      "enabled": true,',
'      "time": 400',
'    }',
'  },',
'  "selectMode": 2,',
'  "selectOnlyOnePerGroup": false,',
'  "setActiveNode": true,',
'  "setItemsOnInit": false,',
'  "typeSettings": [',
'    {',
'      "id": 10,',
'      "storeItem": "P15_TYPE_10",',
'      "icon": "fa-folder-o"',
'    }, {',
'      "id": 20,',
'      "storeItem": "P15_TYPE_20",',
'      "icon": "fa-file-o"',
'    }',
'  ]',
'}',
'</pre>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(147091546065709768403)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'attribute_02'
,p_prompt=>'Search Item'
,p_apexlang_name=>'searchItem'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Set a textfield item that is used to search in tree'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(147098606587927111044)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'attribute_03'
,p_prompt=>'When Error occured'
,p_apexlang_name=>'whenErrorOccured'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Error occured! Please check browser console for more information.'
,p_is_translatable=>true
,p_help_text=>'This message is shown when any error is occured. Please check Browser console for debug information when this text is shown.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(124522597245775265959)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>21
,p_static_id=>'attribute_04'
,p_prompt=>'Active Node ID'
,p_apexlang_name=>'activeNodeId'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Set Item which value is active node id'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(65966070592130759134)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_static_id=>'attribute_05'
,p_prompt=>'Use Client Side Caching'
,p_apexlang_name=>'useClientSideCaching'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'The Plug-in is able to store the received data from SQL Source in Client. To share local cache use the same static region id for the Plug-in Region. The cache can be cleared by doing the following:',
'<ul>',
'<li>Browser Tab is closed</li>',
'<li>New APEX session</li>',
'<li>Fire region refresh by Dynamic Action</li>',
'<li>Version that is given by following function is different to last version that was set to client</li>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(66035760274768077364)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_static_id=>'attribute_06'
,p_prompt=>'Client Side Cache Version'
,p_apexlang_name=>'clientSideCacheVersion'
,p_attribute_type=>'PLSQL FUNCTION BODY'
,p_is_required=>true
,p_default_value=>'RETURN ''V1'';'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(65966070592130759134)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'RETURN ''V1'';',
'</pre>'))
,p_help_text=>'Used to set a function that returns the version of the client cache. This is used to expire the client side cache if the version changes. The function is executed on page render and validates the stored version number in client with the version that '
||'is returned by this function.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(47799862136267143678)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>22
,p_static_id=>'attribute_07'
,p_prompt=>'Expanded Nodes'
,p_apexlang_name=>'expandedNodes'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Set Item where expanded Nodes are saved.'
);
wwv_flow_imp_shared.create_plugin_std_attribute(
 p_id=>wwv_flow_imp.id(142832840920869703499)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_name=>'SOURCE_SQL'
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'/* REQUIRED - positive number id of the element (should start with 1 or higher) */',
'     ROWNUM AS ID,',
'/* REQUIRED - positive number id of the parent (top parent should be 0) */',
'     CASE',
'         WHEN ROWNUM <= 2 THEN',
'             0',
'         ELSE ROUND( ROWNUM / 6 )',
'     END AS PARENT_ID,',
'/* REQUIRED - title of the item */',
'     ''Item '' || ROWNUM AS TITLE,/* tooltip for the item */',
'/* REQUIRED when use select function - is set to items when selected */',
'     ROWNUM AS VALUE,',
'/* REQUIRED when use select function - is mapping value for typeSettings in config json */',
'     CASE',
'         WHEN ROWNUM <= 8 THEN',
'             10',
'         ELSE 20',
'     END AS TYPE,',
'/* Optional - set tooltip for this item */',
'     ''This is item '' || ROWNUM AS TOOLTIP,',
'/* Optional - set custom icon for item */',
'     CASE',
'         WHEN ROWNUM <= 8 THEN',
'             ''fa fa-folder-o''',
'         ELSE ''fa fa-file-o''',
'     END AS ICON,',
'/* Optional - set which nodes should be selcted on load (0 or null - not selected; 1 - selected)*/',
'     CASE',
'         WHEN ROWNUM <= 8 THEN',
'             1',
'     END AS SELECTED,',
'/* Optional - set if this item is expanded or not (0 or null - not expanded; 1 - expanded)*/',
'     NULL EXPANDED,',
'/* Optional - enable or disable checkbox for this item (0 or null - no checkbox; 1 - checkbox)*/',
'     1 AS CHECKBOX,',
'/* Optional - used to set item read only (0 or null - selectable; 1 - unselectable)*/',
'     0 AS UNSELECTABLE',
'/* activate link on click of the node */',
'     --,''https://linktr.ee/ronny.weiss'' AS LINK',
' FROM',
'     DUAL',
' CONNECT BY',
'     ROWNUM <= 30'))
,p_sql_min_column_count=>3
,p_depending_on_has_to_exist=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'SELECT ',
'/* REQUIRED - positive number id of the element (should start with 1 or higher) */',
'     ROWNUM AS ID,',
'/* REQUIRED - positive number id of the parent (top parent should be 0) */',
'     CASE',
'         WHEN ROWNUM <= 2 THEN',
'             0',
'         ELSE ROUND( ROWNUM / 6 )',
'     END AS PARENT_ID,',
'/* REQUIRED - title of the item */',
'     ''Item '' || ROWNUM AS TITLE,/* tooltip for the item */',
'/* REQUIRED when use select function - is set to items when selected */',
'     ROWNUM AS VALUE,',
'/* REQUIRED when use select function - is mapping value for typeSettings in config json */',
'     CASE',
'         WHEN ROWNUM <= 8 THEN',
'             10',
'         ELSE 20',
'     END AS TYPE,',
'/* Optional - set tooltip for this item */',
'     ''This is item '' || ROWNUM AS TOOLTIP,',
'/* Optional - set custom icon for item */',
'     CASE',
'         WHEN ROWNUM <= 8 THEN',
'             ''fa fa-folder-o''',
'         ELSE ''fa fa-file-o''',
'     END AS ICON,',
'/* Optional - set which nodes should be selcted on load (0 or null - not selected; 1 - selected)*/',
'     CASE',
'         WHEN ROWNUM <= 8 THEN',
'             1',
'     END AS SELECTED,',
'/* Optional - set if this item is expanded or not (0 or null - not expanded; 1 - expanded)*/',
'     NULL EXPANDED,',
'/* Optional - enable or disable checkbox for this item (0 or null - no checkbox; 1 - checkbox)*/',
'     1 AS CHECKBOX,',
'/* Optional - used to set item read only (0 or null - selectable; 1 - unselectable)*/',
'     0 AS UNSELECTABLE',
'/* activate link on click of the node */',
'     --,''https://linktr.ee/ronny.weiss'' AS LINK',
' FROM',
'     DUAL',
' CONNECT BY',
'     ROWNUM <= 30',
'</pre>'))
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '4D4954204C6963656E73650A0A436F7079726967687420286329203230323520526F6E6E792057656973730A0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E79207065';
wwv_flow_imp.g_varchar2_table(2) := '72736F6E206F627461696E696E67206120636F70790A6F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0A';
wwv_flow_imp.g_varchar2_table(3) := '696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730A746F207573652C20636F70792C206D6F646966792C206D';
wwv_flow_imp.g_varchar2_table(4) := '657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F20';
wwv_flow_imp.g_varchar2_table(5) := '77686F6D2074686520536F6674776172652069730A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A0A5468652061626F766520636F70797269676874206E';
wwv_flow_imp.g_varchar2_table(6) := '6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674';
wwv_flow_imp.g_varchar2_table(7) := '776172652E0A0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A494D504C4945442C20494E434C5544494E47';
wwv_flow_imp.g_varchar2_table(8) := '20425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0A4649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E465249';
wwv_flow_imp.g_varchar2_table(9) := '4E47454D454E542E20494E204E4F204556454E54205348414C4C205448450A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845';
wwv_flow_imp.g_varchar2_table(10) := '520A4C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A4F5554204F46204F5220494E20434F4E4E454354';
wwv_flow_imp.g_varchar2_table(11) := '494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A534F4654574152452E0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(156403373303642068505)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_file_name=>'LICENSE'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '46616E6379547265650D0A0D0A4D49540D0A0D0A436F7079726967687420323030382D32303231204D617274696E2057656E64742C0D0A68747470733A2F2F777757656E64742E64652F0D0A0D0A5065726D697373696F6E206973206865726562792067';
wwv_flow_imp.g_varchar2_table(2) := '72616E7465642C2066726565206F66206368617267652C20746F20616E7920706572736F6E206F627461696E696E670D0A6120636F7079206F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F';
wwv_flow_imp.g_varchar2_table(3) := '6E2066696C657320287468650D0A22536F66747761726522292C20746F206465616C20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E670D0A776974686F7574206C696D69746174696F';
wwv_flow_imp.g_varchar2_table(4) := '6E207468652072696768747320746F207573652C20636F70792C206D6F646966792C206D657267652C207075626C6973682C0D0A646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C20636F70696573206F66207468';
wwv_flow_imp.g_varchar2_table(5) := '6520536F6674776172652C20616E6420746F0D0A7065726D697420706572736F6E7320746F2077686F6D2074686520536F667477617265206973206675726E697368656420746F20646F20736F2C207375626A65637420746F0D0A74686520666F6C6C6F';
wwv_flow_imp.g_varchar2_table(6) := '77696E6720636F6E646974696F6E733A0D0A0D0A5468652061626F766520636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C2062650D0A696E636C7564656420696E20616C6C20';
wwv_flow_imp.g_varchar2_table(7) := '636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674776172652E0D0A0D0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E54';
wwv_flow_imp.g_varchar2_table(8) := '59204F4620414E59204B494E442C0D0A45585052455353204F5220494D504C4945442C20494E434C5544494E4720425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F460D0A4D45524348414E544142494C4954592C';
wwv_flow_imp.g_varchar2_table(9) := '204649544E45535320464F52204120504152544943554C415220505552504F534520414E440D0A4E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54205348414C4C2054484520415554484F5253204F5220434F505952494748542048';
wwv_flow_imp.g_varchar2_table(10) := '4F4C444552532042450D0A4C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F54484552204C494142494C4954592C205748455448455220494E20414E20414354494F4E0D0A4F4620434F4E54524143542C20544F5254';
wwv_flow_imp.g_varchar2_table(11) := '204F52204F54484552574953452C2041524953494E472046524F4D2C204F5554204F46204F5220494E20434F4E4E454354494F4E0D0A574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E4753';
wwv_flow_imp.g_varchar2_table(12) := '20494E2054484520534F4654574152452E0D0A0D0A0D0A6C7A2D737472696E670D0A0D0A68747470733A2F2F6769746875622E636F6D2F706965726F78792F6C7A2D737472696E670D0A0D0A4D4954204C6963656E73650D0A0D0A436F70797269676874';
wwv_flow_imp.g_varchar2_table(13) := '20286329203230313320706965726F78790D0A0D0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E7920706572736F6E206F627461696E696E67206120636F70790D0A6F';
wwv_flow_imp.g_varchar2_table(14) := '66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0D0A696E2074686520536F66747761726520776974686F75';
wwv_flow_imp.g_varchar2_table(15) := '74207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730D0A746F207573652C20636F70792C206D6F646966792C206D657267652C207075626C6973682C20646973747269';
wwv_flow_imp.g_varchar2_table(16) := '627574652C207375626C6963656E73652C20616E642F6F722073656C6C0D0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F2077686F6D2074686520536F667477617265206973';
wwv_flow_imp.g_varchar2_table(17) := '0D0A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0D0A0D0A5468652061626F766520636F70797269676874206E6F7469636520616E642074686973207065';
wwv_flow_imp.g_varchar2_table(18) := '726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0D0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674776172652E0D0A0D0A54484520534F46';
wwv_flow_imp.g_varchar2_table(19) := '54574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520D0A494D504C4945442C20494E434C5544494E4720425554204E4F54204C494D49';
wwv_flow_imp.g_varchar2_table(20) := '54454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0D0A4649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E4652494E47454D454E542E20494E20';
wwv_flow_imp.g_varchar2_table(21) := '4E4F204556454E54205348414C4C205448450D0A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845520D0A4C494142494C4954';
wwv_flow_imp.g_varchar2_table(22) := '592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0D0A4F5554204F46204F5220494E20434F4E4E454354494F4E205749544820';
wwv_flow_imp.g_varchar2_table(23) := '54484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450D0A534F4654574152452E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(156403373645336068508)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_file_name=>'LICENSE4LIBS'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A202A2046616E6379747265652022617765736F6D652220736B696E2E202A202A20444F4E2754204544495420544845204353532046494C45204449524543544C592C2073696E6365206974206973206175746F6D61746963616C6C792067656E6572';
wwv_flow_imp.g_varchar2_table(2) := '617465642066726F6D202A20746865204C4553532074656D706C617465732E202A2F2E66616E6379747265652D68656C7065722D68696464656E7B646973706C61793A6E6F6E657D2E66616E6379747265652D68656C7065722D696E64657465726D696E';
wwv_flow_imp.g_varchar2_table(3) := '6174652D63627B636F6C6F723A233737377D2E66616E6379747265652D68656C7065722D64697361626C65647B636F6C6F723A73696C7665727D2E66616E6379747265652D68656C7065722D7370696E7B2D7765626B69742D616E696D6174696F6E3A73';
wwv_flow_imp.g_varchar2_table(4) := '70696E20313030306D7320696E66696E697465206C696E6561723B616E696D6174696F6E3A7370696E20313030306D7320696E66696E697465206C696E6561727D402D7765626B69742D6B65796672616D6573207370696E7B30257B2D7765626B69742D';
wwv_flow_imp.g_varchar2_table(5) := '7472616E73666F726D3A726F746174652830293B7472616E73666F726D3A726F746174652830297D313030257B2D7765626B69742D7472616E73666F726D3A726F7461746528333539646567293B7472616E73666F726D3A726F74617465283335396465';
wwv_flow_imp.g_varchar2_table(6) := '67297D7D406B65796672616D6573207370696E7B30257B2D7765626B69742D7472616E73666F726D3A726F746174652830293B7472616E73666F726D3A726F746174652830297D313030257B2D7765626B69742D7472616E73666F726D3A726F74617465';
wwv_flow_imp.g_varchar2_table(7) := '28333539646567293B7472616E73666F726D3A726F7461746528333539646567297D7D756C2E66616E6379747265652D636F6E7461696E65727B77686974652D73706163653A6E6F777261703B70616464696E673A3370783B6D617267696E3A303B6261';
wwv_flow_imp.g_varchar2_table(8) := '636B67726F756E642D636F6C6F723A77686974653B626F726465723A303B6D696E2D6865696768743A303B706F736974696F6E3A72656C61746976653B6F75746C696E653A307D756C2E66616E6379747265652D636F6E7461696E657220756C7B706164';
wwv_flow_imp.g_varchar2_table(9) := '64696E673A302030203020313070743B6D617267696E3A307D756C2E66616E6379747265652D636F6E7461696E657220756C3E6C693A6265666F72657B636F6E74656E743A6E6F6E657D756C2E66616E6379747265652D636F6E7461696E6572206C697B';
wwv_flow_imp.g_varchar2_table(10) := '6C6973742D7374796C652D696D6167653A6E6F6E653B6C6973742D7374796C652D706F736974696F6E3A6F7574736964653B6C6973742D7374796C652D747970653A6E6F6E653B2D6D6F7A2D6261636B67726F756E642D636C69703A626F726465723B2D';
wwv_flow_imp.g_varchar2_table(11) := '6D6F7A2D6261636B67726F756E642D696E6C696E652D706F6C6963793A636F6E74696E756F75733B2D6D6F7A2D6261636B67726F756E642D6F726967696E3A70616464696E673B6261636B67726F756E642D6174746163686D656E743A7363726F6C6C3B';
wwv_flow_imp.g_varchar2_table(12) := '6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B6261636B67726F756E642D706F736974696F6E3A3020303B6261636B67726F756E642D7265706561743A7265706561742D793B6261636B67726F756E642D696D6167653A6E6F6E';
wwv_flow_imp.g_varchar2_table(13) := '653B6D617267696E3A307D756C2E66616E6379747265652D636F6E7461696E6572206C692E66616E6379747265652D6C6173747369627B6261636B67726F756E642D696D6167653A6E6F6E657D2E75692D66616E6379747265652D64697361626C656420';
wwv_flow_imp.g_varchar2_table(14) := '756C2E66616E6379747265652D636F6E7461696E65727B6F7061636974793A2E353B6261636B67726F756E642D636F6C6F723A73696C7665727D756C2E66616E6379747265652D636F6E6E6563746F72732E66616E6379747265652D636F6E7461696E65';
wwv_flow_imp.g_varchar2_table(15) := '72206C697B6261636B67726F756E642D696D6167653A75726C28222E2E2F736B696E2D617765736F6D652F766C696E652E67696622293B6261636B67726F756E642D706F736974696F6E3A3020307D756C2E66616E6379747265652D636F6E7461696E65';
wwv_flow_imp.g_varchar2_table(16) := '72206C692E66616E6379747265652D6C6173747369622C756C2E66616E6379747265652D6E6F2D636F6E6E6563746F723E6C697B6261636B67726F756E642D696D6167653A6E6F6E657D6C692E66616E6379747265652D616E696D6174696E677B706F73';
wwv_flow_imp.g_varchar2_table(17) := '6974696F6E3A72656C61746976657D7370616E2E66616E6379747265652D656D7074792C7370616E2E66616E6379747265652D766C696E652C7370616E2E66616E6379747265652D657870616E6465722C7370616E2E66616E6379747265652D69636F6E';
wwv_flow_imp.g_varchar2_table(18) := '2C7370616E2E66616E6379747265652D636865636B626F782C7370616E2E66616E6379747265652D647261672D68656C7065722D696D672C2366616E6379747265652D64726F702D6D61726B65727B77696474683A313070743B6865696768743A313070';
wwv_flow_imp.g_varchar2_table(19) := '743B646973706C61793A696E6C696E652D626C6F636B3B766572746963616C2D616C69676E3A746F703B6261636B67726F756E642D7265706561743A6E6F2D7265706561743B6261636B67726F756E642D706F736974696F6E3A6C6566743B6261636B67';
wwv_flow_imp.g_varchar2_table(20) := '726F756E642D706F736974696F6E3A3020307D7370616E2E66616E6379747265652D69636F6E2C7370616E2E66616E6379747265652D636865636B626F782C7370616E2E66616E6379747265652D657870616E6465722C7370616E2E66616E6379747265';
wwv_flow_imp.g_varchar2_table(21) := '652D637573746F6D2D69636F6E7B6D617267696E2D746F703A3270783B77696474683A313670783B666F6E742D73697A653A313670787D7370616E2E66616E6379747265652D637573746F6D2D69636F6E7B646973706C61793A696E6C696E652D626C6F';
wwv_flow_imp.g_varchar2_table(22) := '636B3B6D617267696E2D6C6566743A3370783B6261636B67726F756E642D706F736974696F6E3A3020307D696D672E66616E6379747265652D69636F6E7B77696474683A313070743B6865696768743A313070743B6D617267696E2D6C6566743A337078';
wwv_flow_imp.g_varchar2_table(23) := '3B6D617267696E2D746F703A303B766572746963616C2D616C69676E3A746F703B626F726465722D7374796C653A6E6F6E657D7370616E2E66616E6379747265652D657870616E6465727B637572736F723A706F696E7465723B666F6E742D73697A653A';
wwv_flow_imp.g_varchar2_table(24) := '323070783B6C696E652D6865696768743A313470787D2E66616E6379747265652D6578702D6E207370616E2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D6578702D6E6C207370616E2E66616E6379747265652D65787061';
wwv_flow_imp.g_varchar2_table(25) := '6E6465727B6261636B67726F756E642D696D6167653A6E6F6E653B637572736F723A64656661756C747D2E66616E6379747265652D636F6E6E6563746F7273202E66616E6379747265652D6578702D6E207370616E2E66616E6379747265652D65787061';
wwv_flow_imp.g_varchar2_table(26) := '6E6465722C2E66616E6379747265652D636F6E6E6563746F7273202E66616E6379747265652D6578702D6E6C207370616E2E66616E6379747265652D657870616E6465727B6D617267696E2D746F703A307D2E66616E6379747265652D666164652D6578';
wwv_flow_imp.g_varchar2_table(27) := '70616E646572207370616E2E66616E6379747265652D657870616E6465727B7472616E736974696F6E3A6F70616369747920312E35733B6F7061636974793A307D2E66616E6379747265652D666164652D657870616E6465723A686F766572207370616E';
wwv_flow_imp.g_varchar2_table(28) := '2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D666164652D657870616E6465722E66616E6379747265652D74726565666F637573207370616E2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D';
wwv_flow_imp.g_varchar2_table(29) := '666164652D657870616E646572202E66616E6379747265652D74726565666F637573207370616E2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D666164652D657870616E646572205B636C6173732A3D2766616E63797472';
wwv_flow_imp.g_varchar2_table(30) := '65652D7374617475736E6F64652D275D207370616E2E66616E6379747265652D657870616E6465727B7472616E736974696F6E3A6F706163697479202E36733B6F7061636974793A317D7370616E2E66616E6379747265652D636865636B626F787B6D61';
wwv_flow_imp.g_varchar2_table(31) := '7267696E2D6C6566743A3370787D2E66616E6379747265652D756E73656C65637461626C65207370616E2E66616E6379747265652D636865636B626F787B6F7061636974793A2E343B66696C7465723A616C706861286F7061636974793D3430297D7370';
wwv_flow_imp.g_varchar2_table(32) := '616E2E66616E6379747265652D69636F6E7B6D617267696E2D6C6566743A3370787D2E66616E6379747265652D6C6F6164696E67207370616E2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D6C6F6164696E67207370616E';
wwv_flow_imp.g_varchar2_table(33) := '2E66616E6379747265652D657870616E6465723A686F7665722C2E66616E6379747265652D7374617475736E6F64652D6C6F6164696E67207370616E2E66616E6379747265652D69636F6E2C2E66616E6379747265652D7374617475736E6F64652D6C6F';
wwv_flow_imp.g_varchar2_table(34) := '6164696E67207370616E2E66616E6379747265652D69636F6E3A686F7665727B6261636B67726F756E642D696D6167653A6E6F6E657D7370616E2E66616E6379747265652D6E6F64657B646973706C61793A696E68657269743B77696474683A31303025';
wwv_flow_imp.g_varchar2_table(35) := '3B6D617267696E2D746F703A3170783B6D696E2D6865696768743A313070747D7370616E2E66616E6379747265652D7469746C657B636F6C6F723A233030303B637572736F723A706F696E7465723B646973706C61793A696E6C696E652D626C6F636B3B';
wwv_flow_imp.g_varchar2_table(36) := '766572746963616C2D616C69676E3A746F703B6D696E2D6865696768743A313070743B70616464696E673A3270782032707820337078203270783B6D617267696E3A3020302030203370783B626F726465723A31707820736F6C6964207472616E737061';
wwv_flow_imp.g_varchar2_table(37) := '72656E743B2D7765626B69742D626F726465722D7261646975733A303B2D6D6F7A2D626F726465722D7261646975733A303B2D6D732D626F726465722D7261646975733A303B2D6F2D626F726465722D7261646975733A303B626F726465722D72616469';
wwv_flow_imp.g_varchar2_table(38) := '75733A303B6C696E652D6865696768743A313570783B666F6E742D73697A653A313370783B77686974652D73706163653A627265616B2D7370616365733B776F72642D627265616B3A627265616B2D776F72643B6D61782D77696474683A63616C632831';
wwv_flow_imp.g_varchar2_table(39) := '303025202D2033357078297D7370616E2E66616E6379747265652D6E6F64652E66616E6379747265652D6572726F72207370616E2E66616E6379747265652D7469746C657B636F6C6F723A7265647D7370616E2E66616E6379747265652D6368696C6463';
wwv_flow_imp.g_varchar2_table(40) := '6F756E7465727B636F6C6F723A236666663B6261636B67726F756E643A233333376162373B626F726465723A31707820736F6C696420677261793B626F726465722D7261646975733A313070783B70616464696E673A3270783B746578742D616C69676E';
wwv_flow_imp.g_varchar2_table(41) := '3A63656E7465727D6469762E66616E6379747265652D647261672D68656C706572207370616E2E66616E6379747265652D6368696C64636F756E7465722C6469762E66616E6379747265652D647261672D68656C706572207370616E2E66616E63797472';
wwv_flow_imp.g_varchar2_table(42) := '65652D646E642D6D6F6469666965727B646973706C61793A696E6C696E652D626C6F636B3B636F6C6F723A236666663B6261636B67726F756E643A233333376162373B626F726465723A31707820736F6C696420677261793B6D696E2D77696474683A31';
wwv_flow_imp.g_varchar2_table(43) := '3770783B6865696768743A313770783B6C696E652D6865696768743A313B766572746963616C2D616C69676E3A626173656C696E653B626F726465722D7261646975733A313070783B70616464696E673A3270783B746578742D616C69676E3A63656E74';
wwv_flow_imp.g_varchar2_table(44) := '65723B666F6E742D73697A653A3970787D6469762E66616E6379747265652D647261672D68656C706572207370616E2E66616E6379747265652D6368696C64636F756E7465727B706F736974696F6E3A6162736F6C7574653B746F703A2D3670783B7269';
wwv_flow_imp.g_varchar2_table(45) := '6768743A2D3670787D6469762E66616E6379747265652D647261672D68656C706572207370616E2E66616E6379747265652D646E642D6D6F6469666965727B6261636B67726F756E643A233563623835633B626F726465723A303B666F6E742D77656967';
wwv_flow_imp.g_varchar2_table(46) := '68743A626F6C6465727D2366616E6379747265652D64726F702D6D61726B65727B77696474683A323070743B706F736974696F6E3A6162736F6C7574653B6D617267696E3A307D2366616E6379747265652D64726F702D6D61726B65722E66616E637974';
wwv_flow_imp.g_varchar2_table(47) := '7265652D64726F702D61667465722C2366616E6379747265652D64726F702D6D61726B65722E66616E6379747265652D64726F702D6265666F72657B77696474683A343070747D7370616E2E66616E6379747265652D647261672D736F757263652E6661';
wwv_flow_imp.g_varchar2_table(48) := '6E6379747265652D647261672D72656D6F76657B6F7061636974793A2E31357D2E66616E6379747265652D636F6E7461696E65722E66616E6379747265652D72746C202E66616E6379747265652D6578702D6E207370616E2E66616E6379747265652D65';
wwv_flow_imp.g_varchar2_table(49) := '7870616E6465722C2E66616E6379747265652D636F6E7461696E65722E66616E6379747265652D72746C202E66616E6379747265652D6578702D6E6C207370616E2E66616E6379747265652D657870616E6465727B6261636B67726F756E642D696D6167';
wwv_flow_imp.g_varchar2_table(50) := '653A6E6F6E657D756C2E66616E6379747265652D636F6E7461696E65722E66616E6379747265652D72746C20756C7B70616464696E673A302031367078203020307D756C2E66616E6379747265652D636F6E7461696E65722E66616E6379747265652D72';
wwv_flow_imp.g_varchar2_table(51) := '746C2E66616E6379747265652D636F6E6E6563746F7273206C697B6261636B67726F756E642D706F736974696F6E3A726967687420303B6261636B67726F756E642D696D6167653A75726C28222E2E2F736B696E2D617765736F6D652F766C696E652D72';
wwv_flow_imp.g_varchar2_table(52) := '746C2E67696622297D756C2E66616E6379747265652D636F6E7461696E65722E66616E6379747265652D72746C206C692E66616E6379747265652D6C6173747369622C756C2E66616E6379747265652D636F6E7461696E65722E66616E6379747265652D';
wwv_flow_imp.g_varchar2_table(53) := '72746C2E66616E6379747265652D6E6F2D636F6E6E6563746F723E6C697B6261636B67726F756E642D696D6167653A6E6F6E657D7461626C652E66616E6379747265652D6578742D7461626C657B626F726465722D636F6C6C617073653A636F6C6C6170';
wwv_flow_imp.g_varchar2_table(54) := '73657D7461626C652E66616E6379747265652D6578742D7461626C65207370616E2E66616E6379747265652D6E6F64657B646973706C61793A696E6C696E652D626C6F636B3B626F782D73697A696E673A626F726465722D626F787D7461626C652E6661';
wwv_flow_imp.g_varchar2_table(55) := '6E6379747265652D6578742D7461626C652074642E66616E6379747265652D7374617475732D6D65726765647B746578742D616C69676E3A63656E7465723B666F6E742D7374796C653A6974616C69633B636F6C6F723A73696C7665727D7461626C652E';
wwv_flow_imp.g_varchar2_table(56) := '66616E6379747265652D6578742D7461626C652074722E66616E6379747265652D7374617475736E6F64652D6572726F722074642E66616E6379747265652D7374617475732D6D65726765647B636F6C6F723A7265647D7461626C652E66616E63797472';
wwv_flow_imp.g_varchar2_table(57) := '65652D6578742D636F6C756D6E766965772074626F64792074722074647B706F736974696F6E3A72656C61746976653B626F726465723A31707820736F6C696420677261793B766572746963616C2D616C69676E3A746F703B6F766572666C6F773A6175';
wwv_flow_imp.g_varchar2_table(58) := '746F7D7461626C652E66616E6379747265652D6578742D636F6C756D6E766965772074626F64792074722074643E756C7B70616464696E673A307D7461626C652E66616E6379747265652D6578742D636F6C756D6E766965772074626F64792074722074';
wwv_flow_imp.g_varchar2_table(59) := '643E756C206C697B6C6973742D7374796C652D696D6167653A6E6F6E653B6C6973742D7374796C652D706F736974696F6E3A6F7574736964653B6C6973742D7374796C652D747970653A6E6F6E653B2D6D6F7A2D6261636B67726F756E642D636C69703A';
wwv_flow_imp.g_varchar2_table(60) := '626F726465723B2D6D6F7A2D6261636B67726F756E642D696E6C696E652D706F6C6963793A636F6E74696E756F75733B2D6D6F7A2D6261636B67726F756E642D6F726967696E3A70616464696E673B6261636B67726F756E642D6174746163686D656E74';
wwv_flow_imp.g_varchar2_table(61) := '3A7363726F6C6C3B6261636B67726F756E642D636F6C6F723A7472616E73706172656E743B6261636B67726F756E642D706F736974696F6E3A3020303B6261636B67726F756E642D7265706561743A7265706561742D793B6261636B67726F756E642D69';
wwv_flow_imp.g_varchar2_table(62) := '6D6167653A6E6F6E653B6D617267696E3A307D7461626C652E66616E6379747265652D6578742D636F6C756D6E76696577207370616E2E66616E6379747265652D6E6F64657B706F736974696F6E3A72656C61746976653B646973706C61793A696E6C69';
wwv_flow_imp.g_varchar2_table(63) := '6E652D626C6F636B7D7461626C652E66616E6379747265652D6578742D636F6C756D6E76696577207370616E2E66616E6379747265652D6E6F64652E66616E6379747265652D657870616E6465647B6261636B67726F756E642D636F6C6F723A23636265';
wwv_flow_imp.g_varchar2_table(64) := '3866367D7461626C652E66616E6379747265652D6578742D636F6C756D6E76696577202E66616E6379747265652D6861732D6368696C6472656E207370616E2E66616E6379747265652D63762D72696768747B706F736974696F6E3A6162736F6C757465';
wwv_flow_imp.g_varchar2_table(65) := '3B72696768743A3370787D2E66616E6379747265652D6578742D66696C7465722D64696D6D207370616E2E66616E6379747265652D6E6F6465207370616E2E66616E6379747265652D7469746C657B636F6C6F723A73696C7665723B666F6E742D776569';
wwv_flow_imp.g_varchar2_table(66) := '6768743A6C6967687465727D2E66616E6379747265652D6578742D66696C7465722D64696D6D2074722E66616E6379747265652D7375626D61746368207370616E2E66616E6379747265652D7469746C652C2E66616E6379747265652D6578742D66696C';
wwv_flow_imp.g_varchar2_table(67) := '7465722D64696D6D207370616E2E66616E6379747265652D6E6F64652E66616E6379747265652D7375626D61746368207370616E2E66616E6379747265652D7469746C657B636F6C6F723A626C61636B3B666F6E742D7765696768743A6E6F726D616C7D';
wwv_flow_imp.g_varchar2_table(68) := '2E66616E6379747265652D6578742D66696C7465722D64696D6D2074722E66616E6379747265652D6D61746368207370616E2E66616E6379747265652D7469746C652C2E66616E6379747265652D6578742D66696C7465722D64696D6D207370616E2E66';
wwv_flow_imp.g_varchar2_table(69) := '616E6379747265652D6E6F64652E66616E6379747265652D6D61746368207370616E2E66616E6379747265652D7469746C657B636F6C6F723A626C61636B3B666F6E742D7765696768743A626F6C647D2E66616E6379747265652D6578742D66696C7465';
wwv_flow_imp.g_varchar2_table(70) := '722D686964652074722E66616E6379747265652D686964652C2E66616E6379747265652D6578742D66696C7465722D68696465207370616E2E66616E6379747265652D6E6F64652E66616E6379747265652D686964657B646973706C61793A6E6F6E657D';
wwv_flow_imp.g_varchar2_table(71) := '2E66616E6379747265652D6578742D66696C7465722D686964652074722E66616E6379747265652D7375626D61746368207370616E2E66616E6379747265652D7469746C652C2E66616E6379747265652D6578742D66696C7465722D6869646520737061';
wwv_flow_imp.g_varchar2_table(72) := '6E2E66616E6379747265652D6E6F64652E66616E6379747265652D7375626D61746368207370616E2E66616E6379747265652D7469746C657B636F6C6F723A73696C7665723B666F6E742D7765696768743A6C6967687465727D2E66616E637974726565';
wwv_flow_imp.g_varchar2_table(73) := '2D6578742D66696C7465722D686964652074722E66616E6379747265652D6D61746368207370616E2E66616E6379747265652D7469746C652C2E66616E6379747265652D6578742D66696C7465722D68696465207370616E2E66616E6379747265652D6E';
wwv_flow_imp.g_varchar2_table(74) := '6F64652E66616E6379747265652D6D61746368207370616E2E66616E6379747265652D7469746C657B636F6C6F723A626C61636B3B666F6E742D7765696768743A6E6F726D616C7D2E66616E6379747265652D6578742D66696C7465722D686964652D65';
wwv_flow_imp.g_varchar2_table(75) := '7870616E646572732074722E66616E6379747265652D6D61746368207370616E2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D6578742D66696C7465722D686964652D657870616E64657273207370616E2E66616E637974';
wwv_flow_imp.g_varchar2_table(76) := '7265652D6E6F64652E66616E6379747265652D6D61746368207370616E2E66616E6379747265652D657870616E6465727B7669736962696C6974793A68696464656E7D2E66616E6379747265652D6578742D66696C7465722D686964652D657870616E64';
wwv_flow_imp.g_varchar2_table(77) := '6572732074722E66616E6379747265652D7375626D61746368207370616E2E66616E6379747265652D657870616E6465722C2E66616E6379747265652D6578742D66696C7465722D686964652D657870616E64657273207370616E2E66616E6379747265';
wwv_flow_imp.g_varchar2_table(78) := '652D6E6F64652E66616E6379747265652D7375626D61746368207370616E2E66616E6379747265652D657870616E6465727B7669736962696C6974793A76697369626C657D2E66616E6379747265652D6578742D6368696C64636F756E74657220737061';
wwv_flow_imp.g_varchar2_table(79) := '6E2E66616E6379747265652D69636F6E2C2E66616E6379747265652D6578742D66696C746572207370616E2E66616E6379747265652D69636F6E2C2E66616E6379747265652D6578742D6368696C64636F756E746572207370616E2E66616E6379747265';
wwv_flow_imp.g_varchar2_table(80) := '652D637573746F6D2D69636F6E2C2E66616E6379747265652D6578742D66696C746572207370616E2E66616E6379747265652D637573746F6D2D69636F6E7B706F736974696F6E3A72656C61746976657D2E66616E6379747265652D6578742D6368696C';
wwv_flow_imp.g_varchar2_table(81) := '64636F756E746572207370616E2E66616E6379747265652D6368696C64636F756E7465722C2E66616E6379747265652D6578742D66696C746572207370616E2E66616E6379747265652D6368696C64636F756E7465727B636F6C6F723A236666663B6261';
wwv_flow_imp.g_varchar2_table(82) := '636B67726F756E643A233737373B626F726465723A31707820736F6C696420677261793B706F736974696F6E3A6162736F6C7574653B746F703A303B72696768743A2D3170783B6D696E2D77696474683A313870783B6865696768743A313870783B6C69';
wwv_flow_imp.g_varchar2_table(83) := '6E652D6865696768743A313470783B626F726465722D7261646975733A3530253B70616464696E673A303B746578742D616C69676E3A63656E7465723B666F6E742D73697A653A313070787D756C2E66616E6379747265652D6578742D776964657B706F';
wwv_flow_imp.g_varchar2_table(84) := '736974696F6E3A72656C61746976653B6D696E2D77696474683A313030253B7A2D696E6465783A323B2D7765626B69742D626F782D73697A696E673A626F726465722D626F783B2D6D6F7A2D626F782D73697A696E673A626F726465722D626F783B626F';
wwv_flow_imp.g_varchar2_table(85) := '782D73697A696E673A626F726465722D626F787D756C2E66616E6379747265652D6578742D77696465207370616E2E66616E6379747265652D6E6F64653E7370616E7B706F736974696F6E3A72656C61746976653B7A2D696E6465783A327D756C2E6661';
wwv_flow_imp.g_varchar2_table(86) := '6E6379747265652D6578742D77696465207370616E2E66616E6379747265652D6E6F6465207370616E2E66616E6379747265652D7469746C657B706F736974696F6E3A6162736F6C7574653B7A2D696E6465783A313B6C6566743A303B6D696E2D776964';
wwv_flow_imp.g_varchar2_table(87) := '74683A313030253B6D617267696E2D6C6566743A303B6D617267696E2D72696768743A303B2D7765626B69742D626F782D73697A696E673A626F726465722D626F783B2D6D6F7A2D626F782D73697A696E673A626F726465722D626F783B626F782D7369';
wwv_flow_imp.g_varchar2_table(88) := '7A696E673A626F726465722D626F787D2E66616E6379747265652D6578742D66697865642D77726170706572202E66616E6379747265652D6578742D66697865642D68696464656E7B646973706C61793A6E6F6E657D2E66616E6379747265652D657874';
wwv_flow_imp.g_varchar2_table(89) := '2D66697865642D77726170706572206469762E66616E6379747265652D6578742D66697865642D7363726F6C6C2D626F726465722D626F74746F6D7B626F726465722D626F74746F6D3A33707820736F6C6964207267626128302C302C302C302E373529';
wwv_flow_imp.g_varchar2_table(90) := '7D2E66616E6379747265652D6578742D66697865642D77726170706572206469762E66616E6379747265652D6578742D66697865642D7363726F6C6C2D626F726465722D72696768747B626F726465722D72696768743A33707820736F6C696420726762';
wwv_flow_imp.g_varchar2_table(91) := '6128302C302C302C302E3735297D2E66616E6379747265652D6578742D66697865642D77726170706572206469762E66616E6379747265652D6578742D66697865642D777261707065722D746C7B706F736974696F6E3A6162736F6C7574653B6F766572';
wwv_flow_imp.g_varchar2_table(92) := '666C6F773A68696464656E3B7A2D696E6465783A333B746F703A303B6C6566743A307D2E66616E6379747265652D6578742D66697865642D77726170706572206469762E66616E6379747265652D6578742D66697865642D777261707065722D74727B70';
wwv_flow_imp.g_varchar2_table(93) := '6F736974696F6E3A6162736F6C7574653B6F766572666C6F773A68696464656E3B7A2D696E6465783A323B746F703A307D2E66616E6379747265652D6578742D66697865642D77726170706572206469762E66616E6379747265652D6578742D66697865';
wwv_flow_imp.g_varchar2_table(94) := '642D777261707065722D626C7B706F736974696F6E3A6162736F6C7574653B6F766572666C6F773A68696464656E3B7A2D696E6465783A323B6C6566743A307D2E66616E6379747265652D6578742D66697865642D77726170706572206469762E66616E';
wwv_flow_imp.g_varchar2_table(95) := '6379747265652D6578742D66697865642D777261707065722D62727B706F736974696F6E3A6162736F6C7574653B6F766572666C6F773A7363726F6C6C3B7A2D696E6465783A317D7370616E2E66616E6379747265652D7469746C657B626F726465723A';
wwv_flow_imp.g_varchar2_table(96) := '31707820736F6C6964207472616E73706172656E743B626F726465722D7261646975733A307D7370616E2E66616E6379747265652D666F6375736564207370616E2E66616E6379747265652D7469746C657B6F75746C696E653A31707820646F74746564';
wwv_flow_imp.g_varchar2_table(97) := '20626C61636B7D7370616E2E66616E6379747265652D616374697665207370616E2E66616E6379747265652D7469746C657B666F6E742D7765696768743A626F6C643B6261636B67726F756E643A236464647D2E66616E6379747265652D74726565666F';
wwv_flow_imp.g_varchar2_table(98) := '637573207370616E2E66616E6379747265652D616374697665207370616E2E66616E6379747265652D7469746C657B666F6E742D7765696768743A626F6C643B6261636B67726F756E642D636F6C6F723A236363637D7461626C652E66616E6379747265';
wwv_flow_imp.g_varchar2_table(99) := '652D6578742D7461626C657B626F726465722D636F6C6C617073653A636F6C6C617073657D7461626C652E66616E6379747265652D6578742D7461626C652074626F64792074722E66616E6379747265652D666F63757365647B6261636B67726F756E64';
wwv_flow_imp.g_varchar2_table(100) := '2D636F6C6F723A233939646566647D7461626C652E66616E6379747265652D6578742D7461626C652074626F64792074722E66616E6379747265652D6163746976657B6261636B67726F756E642D636F6C6F723A726F79616C626C75657D7461626C652E';
wwv_flow_imp.g_varchar2_table(101) := '66616E6379747265652D6578742D636F6C756D6E766965772074626F64792074722074647B626F726465723A31707820736F6C696420677261797D7461626C652E66616E6379747265652D6578742D636F6C756D6E76696577207370616E2E66616E6379';
wwv_flow_imp.g_varchar2_table(102) := '747265652D6E6F64652E66616E6379747265652D657870616E6465647B6261636B67726F756E642D636F6C6F723A236363637D7461626C652E66616E6379747265652D6578742D636F6C756D6E76696577207370616E2E66616E6379747265652D6E6F64';
wwv_flow_imp.g_varchar2_table(103) := '652E66616E6379747265652D6163746976657B6261636B67726F756E642D636F6C6F723A726F79616C626C75657D2E66616E6379747265652D7469746C653E6D61726B7B666F6E742D7765696768743A626F6C643B6261636B67726F756E642D636F6C6F';
wwv_flow_imp.g_varchar2_table(104) := '723A696E68657269747D7370616E2E66616E6379747265652D7469746C657B636F6C6F723A696E68657269747D756C2E66616E6379747265652D636F6E7461696E65727B6261636B67726F756E642D636F6C6F723A7472616E73706172656E747D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(156403374642802069705)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_file_name=>'fancytree.pkgd.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A210A202A206A71756572792E66616E6379747265652E6A730A202A2054726565207669657720636F6E74726F6C207769746820737570706F727420666F72206C617A79206C6F6164696E6720616E64206D756368206D6F72652E0A202A2068747470';
wwv_flow_imp.g_varchar2_table(2) := '733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F0A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A20';
wwv_flow_imp.g_varchar2_table(3) := '52656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E';
wwv_flow_imp.g_varchar2_table(4) := '20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A2166756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E6528';
wwv_flow_imp.g_varchar2_table(5) := '5B226A7175657279222C222E2F6A71756572792E66616E6379747265652E75692D64657073225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572';
wwv_flow_imp.g_varchar2_table(6) := '792E66616E6379747265652E75692D6465707322292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B6966282165';
wwv_flow_imp.g_varchar2_table(7) := '2E75697C7C21652E75692E66616E637974726565297B76617220742C6E2C723D6E756C6C2C693D6E657720526567457870282F5C2E7C5C2F2F292C6F3D2F5B263C3E22272F5D2F672C613D2F5B3C3E22272F5D2F672C733D22247265637572736976655F';
wwv_flow_imp.g_varchar2_table(8) := '72657175657374222C6C3D2224726571756573745F7461726765745F696E76616C6964222C643D7B2226223A2226616D703B222C223C223A22266C743B222C223E223A222667743B222C2722273A222671756F743B222C2227223A22262333393B222C22';
wwv_flow_imp.g_varchar2_table(9) := '2F223A2226237832463B227D2C633D7B31363A21302C31373A21302C31383A21307D2C753D7B383A226261636B7370616365222C393A22746162222C31303A2272657475726E222C31333A2272657475726E222C31393A227061757365222C32303A2263';
wwv_flow_imp.g_varchar2_table(10) := '6170736C6F636B222C32373A22657363222C33323A227370616365222C33333A22706167657570222C33343A2270616765646F776E222C33353A22656E64222C33363A22686F6D65222C33373A226C656674222C33383A227570222C33393A2272696768';
wwv_flow_imp.g_varchar2_table(11) := '74222C34303A22646F776E222C34353A22696E73657274222C34363A2264656C222C35393A223B222C36313A223D222C39363A2230222C39373A2231222C39383A2232222C39393A2233222C3130303A2234222C3130313A2235222C3130323A2236222C';
wwv_flow_imp.g_varchar2_table(12) := '3130333A2237222C3130343A2238222C3130353A2239222C3130363A222A222C3130373A222B222C3130393A222D222C3131303A222E222C3131313A222F222C3131323A226631222C3131333A226632222C3131343A226633222C3131353A226634222C';
wwv_flow_imp.g_varchar2_table(13) := '3131363A226635222C3131373A226636222C3131383A226637222C3131393A226638222C3132303A226639222C3132313A22663130222C3132323A22663131222C3132333A22663132222C3134343A226E756D6C6F636B222C3134353A227363726F6C6C';
wwv_flow_imp.g_varchar2_table(14) := '222C3137333A222D222C3138363A223B222C3138373A223D222C3138383A222C222C3138393A222D222C3139303A222E222C3139313A222F222C3139323A2260222C3231393A225B222C3232303A225C5C222C3232313A225D222C3232323A2227227D2C';
wwv_flow_imp.g_varchar2_table(15) := '663D7B31363A227368696674222C31373A226374726C222C31383A22616C74222C39313A226D657461222C39333A226D657461227D2C703D7B303A22222C313A226C656674222C323A226D6964646C65222C333A227269676874227D2C683D2261637469';
wwv_flow_imp.g_varchar2_table(16) := '766520657870616E64656420666F63757320666F6C646572206C617A7920726164696F67726F75702073656C656374656420756E73656C65637461626C6520756E73656C65637461626C6549676E6F7265222E73706C697428222022292C673D7B7D2C79';
wwv_flow_imp.g_varchar2_table(17) := '3D22636F6C756D6E73207479706573222E73706C697428222022292C763D22636865636B626F7820657870616E646564206578747261436C617373657320666F6C6465722069636F6E2069636F6E546F6F6C746970206B6579206C617A79207061727473';
wwv_flow_imp.g_varchar2_table(18) := '656C20726164696F67726F7570207265664B65792073656C6563746564207374617475734E6F646554797065207469746C6520746F6F6C746970207479706520756E73656C65637461626C6520756E73656C65637461626C6549676E6F726520756E7365';
wwv_flow_imp.g_varchar2_table(19) := '6C65637461626C65537461747573222E73706C697428222022292C6D3D7B7D2C783D7B7D2C623D7B6163746976653A21302C6368696C6472656E3A21302C646174613A21302C666F6375733A21307D3B666F7228743D303B743C682E6C656E6774683B74';
wwv_flow_imp.g_varchar2_table(20) := '2B2B29675B685B745D5D3D21303B666F7228743D303B743C762E6C656E6774683B742B2B296E3D765B745D2C6D5B6E5D3D21302C6E213D3D6E2E746F4C6F776572436173652829262628785B6E2E746F4C6F7765724361736528295D3D6E293B76617220';
wwv_flow_imp.g_varchar2_table(21) := '433D41727261792E697341727261793B72657475726E206B28652E75692C2246616E637974726565207265717569726573206A51756572792055492028687474703A2F2F6A717565727975692E636F6D2922292C446174652E6E6F777C7C28446174652E';
wwv_flow_imp.g_varchar2_table(22) := '6E6F773D66756E6374696F6E28297B72657475726E286E65772044617465292E67657454696D6528297D292C4C2E70726F746F747970653D7B5F66696E644469726563744368696C643A66756E6374696F6E2865297B76617220742C6E2C723D74686973';
wwv_flow_imp.g_varchar2_table(23) := '2E6368696C6472656E3B696628722969662822737472696E67223D3D747970656F662065297B666F7228743D302C6E3D722E6C656E6774683B743C6E3B742B2B29696628725B745D2E6B65793D3D3D652972657475726E20725B745D7D656C73657B6966';
wwv_flow_imp.g_varchar2_table(24) := '28226E756D626572223D3D747970656F6620652972657475726E20746869732E6368696C6472656E5B655D3B696628652E706172656E743D3D3D746869732972657475726E20657D72657475726E206E756C6C7D2C5F7365744368696C6472656E3A6675';
wwv_flow_imp.g_varchar2_table(25) := '6E6374696F6E2865297B6B286526262821746869732E6368696C6472656E7C7C303D3D3D746869732E6368696C6472656E2E6C656E677468292C226F6E6C7920696E697420737570706F7274656422292C746869732E6368696C6472656E3D5B5D3B666F';
wwv_flow_imp.g_varchar2_table(26) := '722876617220743D302C6E3D652E6C656E6774683B743C6E3B742B2B29746869732E6368696C6472656E2E70757368286E6577204C28746869732C655B745D29293B746869732E747265652E5F63616C6C486F6F6B282274726565537472756374757265';
wwv_flow_imp.g_varchar2_table(27) := '4368616E676564222C746869732E747265652C227365744368696C6472656E22297D2C6164644368696C6472656E3A66756E6374696F6E28742C6E297B76617220722C692C6F2C612C733D746869732E67657446697273744368696C6428292C6C3D7468';
wwv_flow_imp.g_varchar2_table(28) := '69732E6765744C6173744368696C6428292C643D5B5D3B666F7228652E6973506C61696E4F626A656374287429262628743D5B745D292C746869732E6368696C6472656E7C7C28746869732E6368696C6472656E3D5B5D292C723D302C693D742E6C656E';
wwv_flow_imp.g_varchar2_table(29) := '6774683B723C693B722B2B29642E70757368286E6577204C28746869732C745B725D29293B696628613D645B305D2C6E756C6C3D3D6E3F746869732E6368696C6472656E3D746869732E6368696C6472656E2E636F6E6361742864293A286E3D74686973';
wwv_flow_imp.g_varchar2_table(30) := '2E5F66696E644469726563744368696C64286E292C6B28286F3D652E696E4172726179286E2C746869732E6368696C6472656E29293E3D302C22696E736572744265666F7265206D75737420626520616E206578697374696E67206368696C6422292C74';
wwv_flow_imp.g_varchar2_table(31) := '6869732E6368696C6472656E2E73706C6963652E6170706C7928746869732E6368696C6472656E2C5B6F2C305D2E636F6E63617428642929292C732626216E297B666F7228723D302C693D642E6C656E6774683B723C693B722B2B29645B725D2E72656E';
wwv_flow_imp.g_varchar2_table(32) := '64657228293B73213D3D746869732E67657446697273744368696C6428292626732E72656E64657253746174757328292C6C213D3D746869732E6765744C6173744368696C64282926266C2E72656E64657253746174757328297D656C73652821746869';
wwv_flow_imp.g_varchar2_table(33) := '732E706172656E747C7C746869732E706172656E742E756C7C7C746869732E7472292626746869732E72656E64657228293B72657475726E20333D3D3D746869732E747265652E6F7074696F6E732E73656C6563744D6F64652626746869732E66697853';
wwv_flow_imp.g_varchar2_table(34) := '656C656374696F6E3346726F6D456E644E6F64657328292C746869732E747269676765724D6F646966794368696C642822616464222C313D3D3D642E6C656E6774683F645B305D3A6E756C6C292C617D2C616464436C6173733A66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(35) := '297B72657475726E20746869732E746F67676C65436C61737328652C2130297D2C6164644E6F64653A66756E6374696F6E28652C74297B73776974636828766F69642030213D3D742626226F76657222213D3D747C7C28743D226368696C6422292C7429';
wwv_flow_imp.g_varchar2_table(36) := '7B63617365226166746572223A72657475726E20746869732E676574506172656E7428292E6164644368696C6472656E28652C746869732E6765744E6578745369626C696E672829293B63617365226265666F7265223A72657475726E20746869732E67';
wwv_flow_imp.g_varchar2_table(37) := '6574506172656E7428292E6164644368696C6472656E28652C74686973293B636173652266697273744368696C64223A766172206E3D746869732E6368696C6472656E3F746869732E6368696C6472656E5B305D3A6E756C6C3B72657475726E20746869';
wwv_flow_imp.g_varchar2_table(38) := '732E6164644368696C6472656E28652C6E293B63617365226368696C64223A63617365226F766572223A72657475726E20746869732E6164644368696C6472656E2865297D6B2821312C22496E76616C6964206D6F64653A20222B74297D2C6164645061';
wwv_flow_imp.g_varchar2_table(39) := '67696E674E6F64653A66756E6374696F6E28742C6E297B76617220722C693B6966286E3D6E7C7C226368696C64222C2131213D3D742972657475726E20743D652E657874656E64287B7469746C653A746869732E747265652E6F7074696F6E732E737472';
wwv_flow_imp.g_varchar2_table(40) := '696E67732E6D6F7265446174612C7374617475734E6F6465547970653A22706167696E67222C69636F6E3A21317D2C74292C746869732E706172746C6F61643D21302C746869732E6164644E6F646528742C6E293B666F7228723D746869732E6368696C';
wwv_flow_imp.g_varchar2_table(41) := '6472656E2E6C656E6774682D313B723E3D303B722D2D2922706167696E67223D3D3D28693D746869732E6368696C6472656E5B725D292E7374617475734E6F6465547970652626746869732E72656D6F76654368696C642869293B746869732E70617274';
wwv_flow_imp.g_varchar2_table(42) := '6C6F61643D21317D2C617070656E645369626C696E673A66756E6374696F6E2865297B72657475726E20746869732E6164644E6F646528652C22616674657222297D2C6170706C79436F6D6D616E643A66756E6374696F6E28652C74297B72657475726E';
wwv_flow_imp.g_varchar2_table(43) := '20746869732E747265652E6170706C79436F6D6D616E6428652C746869732C74297D2C6170706C7950617463683A66756E6374696F6E2865297B6966286E756C6C3D3D3D652972657475726E20746869732E72656D6F766528292C542874686973293B76';
wwv_flow_imp.g_varchar2_table(44) := '617220742C6E2C723D7B6368696C6472656E3A21302C657870616E6465643A21302C706172656E743A21307D3B666F72287420696E2065297728652C74292626286E3D655B745D2C725B745D7C7C53286E297C7C286D5B745D3F746869735B745D3D6E3A';
wwv_flow_imp.g_varchar2_table(45) := '746869732E646174615B745D3D6E29293B72657475726E207728652C226368696C6472656E2229262628746869732E72656D6F76654368696C6472656E28292C652E6368696C6472656E2626746869732E5F7365744368696C6472656E28652E6368696C';
wwv_flow_imp.g_varchar2_table(46) := '6472656E29292C746869732E697356697369626C652829262628746869732E72656E6465725469746C6528292C746869732E72656E6465725374617475732829292C7728652C22657870616E64656422293F746869732E736574457870616E6465642865';
wwv_flow_imp.g_varchar2_table(47) := '2E657870616E646564293A542874686973297D2C636F6C6C617073655369626C696E67733A66756E6374696F6E28297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465436F6C6C617073655369626C696E6773222C7468';
wwv_flow_imp.g_varchar2_table(48) := '6973297D2C636F7079546F3A66756E6374696F6E28652C742C6E297B72657475726E20652E6164644E6F646528746869732E746F446963742821302C6E292C74297D2C636F756E744368696C6472656E3A66756E6374696F6E2865297B76617220742C6E';
wwv_flow_imp.g_varchar2_table(49) := '2C722C693D746869732E6368696C6472656E3B69662821692972657475726E20303B696628723D692E6C656E6774682C2131213D3D6529666F7228743D302C6E3D723B743C6E3B742B2B29722B3D695B745D2E636F756E744368696C6472656E28293B72';
wwv_flow_imp.g_varchar2_table(50) := '657475726E20727D2C64656275673A66756E6374696F6E2865297B746869732E747265652E6F7074696F6E732E64656275674C6576656C3E3D3426262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C';
wwv_flow_imp.g_varchar2_table(51) := '746869732E746F537472696E672829292C4E28226C6F67222C617267756D656E747329297D2C646973636172643A66756E6374696F6E28297B72657475726E20746869732E7761726E282246616E6379747265654E6F64652E6469736361726428292069';
wwv_flow_imp.g_varchar2_table(52) := '7320646570726563617465642073696E636520323031342D30322D31362E20557365202E72657365744C617A79282920696E73746561642E22292C746869732E72657365744C617A7928297D2C646973636172644D61726B75703A66756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(53) := '65297B76617220743D653F226E6F646552656D6F76654D61726B7570223A226E6F646552656D6F76654368696C644D61726B7570223B746869732E747265652E5F63616C6C486F6F6B28742C74686973297D2C6572726F723A66756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(54) := '7B746869732E747265652E6F7074696F6E732E64656275674C6576656C3E3D3126262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E746F537472696E672829292C4E28226572726F7222';
wwv_flow_imp.g_varchar2_table(55) := '2C617267756D656E747329297D2C66696E64416C6C3A66756E6374696F6E2865297B653D532865293F653A462865293B76617220743D5B5D3B72657475726E20746869732E76697369742866756E6374696F6E286E297B65286E292626742E7075736828';
wwv_flow_imp.g_varchar2_table(56) := '6E297D292C747D2C66696E6446697273743A66756E6374696F6E2865297B653D532865293F653A462865293B76617220743D6E756C6C3B72657475726E20746869732E76697369742866756E6374696F6E286E297B69662865286E292972657475726E20';
wwv_flow_imp.g_varchar2_table(57) := '743D6E2C21317D292C747D2C66696E6452656C617465644E6F64653A66756E6374696F6E28652C74297B72657475726E20746869732E747265652E66696E6452656C617465644E6F646528746869732C652C74297D2C5F6368616E676553656C65637453';
wwv_flow_imp.g_varchar2_table(58) := '746174757341747472733A66756E6374696F6E2865297B76617220743D21312C6E3D746869732E747265652E6F7074696F6E732C693D722E6576616C4F7074696F6E2822756E73656C65637461626C65222C746869732C746869732C6E2C2131292C6F3D';
wwv_flow_imp.g_varchar2_table(59) := '722E6576616C4F7074696F6E2822756E73656C65637461626C65537461747573222C746869732C746869732C6E2C766F69642030293B737769746368286926266E756C6C213D6F262628653D6F292C65297B6361736521313A743D746869732E73656C65';
wwv_flow_imp.g_varchar2_table(60) := '637465647C7C746869732E7061727473656C2C746869732E73656C65637465643D21312C746869732E7061727473656C3D21313B627265616B3B6361736521303A743D21746869732E73656C65637465647C7C21746869732E7061727473656C2C746869';
wwv_flow_imp.g_varchar2_table(61) := '732E73656C65637465643D21302C746869732E7061727473656C3D21303B627265616B3B6361736520766F696420303A743D746869732E73656C65637465647C7C21746869732E7061727473656C2C746869732E73656C65637465643D21312C74686973';
wwv_flow_imp.g_varchar2_table(62) := '2E7061727473656C3D21303B627265616B3B64656661756C743A6B2821312C22696E76616C69642073746174653A20222B65297D72657475726E20742626746869732E72656E64657253746174757328292C747D2C66697853656C656374696F6E334166';
wwv_flow_imp.g_varchar2_table(63) := '746572436C69636B3A66756E6374696F6E2865297B76617220743D746869732E697353656C656374656428293B746869732E76697369742866756E6374696F6E2865297B696628652E5F6368616E676553656C6563745374617475734174747273287429';
wwv_flow_imp.g_varchar2_table(64) := '2C652E726164696F67726F75702972657475726E22736B6970227D292C746869732E66697853656C656374696F6E3346726F6D456E644E6F6465732865297D2C66697853656C656374696F6E3346726F6D456E644E6F6465733A66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(65) := '297B76617220743D746869732E747265652E6F7074696F6E733B6B28333D3D3D742E73656C6563744D6F64652C2265787065637465642073656C6563744D6F6465203322292C66756E6374696F6E2065286E297B76617220692C6F2C612C732C6C2C642C';
wwv_flow_imp.g_varchar2_table(66) := '632C752C663D6E2E6368696C6472656E3B696628662626662E6C656E677468297B666F7228643D21302C633D21312C693D302C6F3D662E6C656E6774683B693C6F3B692B2B29733D6528613D665B695D292C722E6576616C4F7074696F6E2822756E7365';
wwv_flow_imp.g_varchar2_table(67) := '6C65637461626C6549676E6F7265222C612C612C742C2131297C7C282131213D3D73262628633D2130292C2130213D3D73262628643D213129293B6C3D2121647C7C2121632626766F696420307D656C7365206C3D6E756C6C3D3D28753D722E6576616C';
wwv_flow_imp.g_varchar2_table(68) := '4F7074696F6E2822756E73656C65637461626C65537461747573222C6E2C6E2C742C766F6964203029293F21216E2E73656C65637465643A2121753B72657475726E206E2E7061727473656C2626216E2E73656C656374656426266E2E6C617A7926266E';
wwv_flow_imp.g_varchar2_table(69) := '756C6C3D3D6E2E6368696C6472656E2626286C3D766F69642030292C6E2E5F6368616E676553656C6563745374617475734174747273286C292C6C7D2874686973292C746869732E7669736974506172656E74732866756E6374696F6E2865297B766172';
wwv_flow_imp.g_varchar2_table(70) := '206E2C692C6F2C612C732C6C3D652E6368696C6472656E2C643D21302C633D21313B666F72286E3D302C693D6C2E6C656E6774683B6E3C693B6E2B2B296F3D6C5B6E5D2C722E6576616C4F7074696F6E2822756E73656C65637461626C6549676E6F7265';
wwv_flow_imp.g_varchar2_table(71) := '222C6F2C6F2C742C2131297C7C282828613D6E756C6C3D3D28733D722E6576616C4F7074696F6E2822756E73656C65637461626C65537461747573222C6F2C6F2C742C766F6964203029293F21216F2E73656C65637465643A212173297C7C6F2E706172';
wwv_flow_imp.g_varchar2_table(72) := '7473656C29262628633D2130292C617C7C28643D213129293B613D2121647C7C2121632626766F696420302C652E5F6368616E676553656C65637453746174757341747472732861297D297D2C66726F6D446963743A66756E6374696F6E2874297B666F';
wwv_flow_imp.g_varchar2_table(73) := '7228766172206E20696E2074296D5B6E5D3F746869735B6E5D3D745B6E5D3A2264617461223D3D3D6E3F652E657874656E6428746869732E646174612C742E64617461293A5328745B6E5D297C7C625B6E5D7C7C28746869732E646174615B6E5D3D745B';
wwv_flow_imp.g_varchar2_table(74) := '6E5D293B742E6368696C6472656E262628746869732E72656D6F76654368696C6472656E28292C746869732E6164644368696C6472656E28742E6368696C6472656E29292C746869732E72656E6465725469746C6528297D2C6765744368696C6472656E';
wwv_flow_imp.g_varchar2_table(75) := '3A66756E6374696F6E28297B696628766F69642030213D3D746869732E6861734368696C6472656E28292972657475726E20746869732E6368696C6472656E7D2C67657446697273744368696C643A66756E6374696F6E28297B72657475726E20746869';
wwv_flow_imp.g_varchar2_table(76) := '732E6368696C6472656E3F746869732E6368696C6472656E5B305D3A6E756C6C7D2C676574496E6465783A66756E6374696F6E28297B72657475726E20652E696E417272617928746869732C746869732E706172656E742E6368696C6472656E297D2C67';
wwv_flow_imp.g_varchar2_table(77) := '6574496E646578486965723A66756E6374696F6E28742C6E297B743D747C7C222E223B76617220722C693D5B5D3B72657475726E20652E6561636828746869732E676574506172656E744C6973742821312C2130292C66756E6374696F6E28652C74297B';
wwv_flow_imp.g_varchar2_table(78) := '723D22222B28742E676574496E64657828292B31292C6E262628723D282230303030303030222B72292E737562737472282D6E29292C692E707573682872297D292C692E6A6F696E2874297D2C6765744B6579506174683A66756E6374696F6E2865297B';
wwv_flow_imp.g_varchar2_table(79) := '76617220743D746869732E747265652E6F7074696F6E732E6B657950617468536570617261746F723B72657475726E20742B746869732E676574506174682821652C226B6579222C74297D2C6765744C6173744368696C643A66756E6374696F6E28297B';
wwv_flow_imp.g_varchar2_table(80) := '72657475726E20746869732E6368696C6472656E3F746869732E6368696C6472656E5B746869732E6368696C6472656E2E6C656E6774682D315D3A6E756C6C7D2C6765744C6576656C3A66756E6374696F6E28297B666F722876617220653D302C743D74';
wwv_flow_imp.g_varchar2_table(81) := '6869732E706172656E743B743B29652B2B2C743D742E706172656E743B72657475726E20657D2C6765744E6578745369626C696E673A66756E6374696F6E28297B696628746869732E706172656E74297B76617220652C742C6E3D746869732E70617265';
wwv_flow_imp.g_varchar2_table(82) := '6E742E6368696C6472656E3B666F7228653D302C743D6E2E6C656E6774682D313B653C743B652B2B296966286E5B655D3D3D3D746869732972657475726E206E5B652B315D7D72657475726E206E756C6C7D2C676574506172656E743A66756E6374696F';
wwv_flow_imp.g_varchar2_table(83) := '6E28297B72657475726E20746869732E706172656E747D2C676574506172656E744C6973743A66756E6374696F6E28652C74297B666F7228766172206E3D5B5D2C723D743F746869733A746869732E706172656E743B723B2928657C7C722E706172656E';
wwv_flow_imp.g_varchar2_table(84) := '742926266E2E756E73686966742872292C723D722E706172656E743B72657475726E206E7D2C676574506174683A66756E6374696F6E28652C742C6E297B653D2131213D3D652C6E3D6E7C7C222F223B76617220722C693D5B5D2C6F3D5328743D747C7C';
wwv_flow_imp.g_varchar2_table(85) := '227469746C6522293B72657475726E20746869732E7669736974506172656E74732866756E6374696F6E2865297B652E706172656E74262628723D6F3F742865293A655B745D2C692E756E7368696674287229297D2C65292C692E6A6F696E286E297D2C';
wwv_flow_imp.g_varchar2_table(86) := '676574507265765369626C696E673A66756E6374696F6E28297B696628746869732E706172656E74297B76617220652C742C6E3D746869732E706172656E742E6368696C6472656E3B666F7228653D312C743D6E2E6C656E6774683B653C743B652B2B29';
wwv_flow_imp.g_varchar2_table(87) := '6966286E5B655D3D3D3D746869732972657475726E206E5B652D315D7D72657475726E206E756C6C7D2C67657453656C65637465644E6F6465733A66756E6374696F6E2865297B76617220743D5B5D3B72657475726E20746869732E7669736974286675';
wwv_flow_imp.g_varchar2_table(88) := '6E6374696F6E286E297B6966286E2E73656C6563746564262628742E70757368286E292C21303D3D3D65292972657475726E22736B6970227D292C747D2C6861734368696C6472656E3A66756E6374696F6E28297B696628746869732E6C617A79297B69';
wwv_flow_imp.g_varchar2_table(89) := '66286E756C6C3D3D746869732E6368696C6472656E2972657475726E3B696628303D3D3D746869732E6368696C6472656E2E6C656E6774682972657475726E21313B696628313D3D3D746869732E6368696C6472656E2E6C656E6774682626746869732E';
wwv_flow_imp.g_varchar2_table(90) := '6368696C6472656E5B305D2E69735374617475734E6F646528292972657475726E3B72657475726E21307D72657475726E212821746869732E6368696C6472656E7C7C21746869732E6368696C6472656E2E6C656E677468297D2C686173436C6173733A';
wwv_flow_imp.g_varchar2_table(91) := '66756E6374696F6E2865297B72657475726E282220222B28746869732E6578747261436C61737365737C7C2222292B222022292E696E6465784F66282220222B652B222022293E3D307D2C686173466F6375733A66756E6374696F6E28297B7265747572';
wwv_flow_imp.g_varchar2_table(92) := '6E20746869732E747265652E686173466F63757328292626746869732E747265652E666F6375734E6F64653D3D3D746869737D2C696E666F3A66756E6374696F6E2865297B746869732E747265652E6F7074696F6E732E64656275674C6576656C3E3D33';
wwv_flow_imp.g_varchar2_table(93) := '26262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E746F537472696E672829292C4E2822696E666F222C617267756D656E747329297D2C69734163746976653A66756E6374696F6E2829';
wwv_flow_imp.g_varchar2_table(94) := '7B72657475726E20746869732E747265652E6163746976654E6F64653D3D3D746869737D2C697342656C6F774F663A66756E6374696F6E2865297B72657475726E20746869732E676574496E6465784869657228222E222C35293E652E676574496E6465';
wwv_flow_imp.g_varchar2_table(95) := '784869657228222E222C35297D2C69734368696C644F663A66756E6374696F6E2865297B72657475726E20746869732E706172656E742626746869732E706172656E743D3D3D657D2C697344657363656E64616E744F663A66756E6374696F6E2874297B';
wwv_flow_imp.g_varchar2_table(96) := '69662821747C7C742E74726565213D3D746869732E747265652972657475726E21313B666F7228766172206E3D746869732E706172656E743B6E3B297B6966286E3D3D3D742972657475726E21303B6E3D3D3D6E2E706172656E742626652E6572726F72';
wwv_flow_imp.g_varchar2_table(97) := '282252656375727369766520706172656E74206C696E6B3A20222B6E292C6E3D6E2E706172656E747D72657475726E21317D2C6973457870616E6465643A66756E6374696F6E28297B72657475726E2121746869732E657870616E6465647D2C69734669';
wwv_flow_imp.g_varchar2_table(98) := '7273745369626C696E673A66756E6374696F6E28297B76617220653D746869732E706172656E743B72657475726E21657C7C652E6368696C6472656E5B305D3D3D3D746869737D2C6973466F6C6465723A66756E6374696F6E28297B72657475726E2121';
wwv_flow_imp.g_varchar2_table(99) := '746869732E666F6C6465727D2C69734C6173745369626C696E673A66756E6374696F6E28297B76617220653D746869732E706172656E743B72657475726E21657C7C652E6368696C6472656E5B652E6368696C6472656E2E6C656E6774682D315D3D3D3D';
wwv_flow_imp.g_varchar2_table(100) := '746869737D2C69734C617A793A66756E6374696F6E28297B72657475726E2121746869732E6C617A797D2C69734C6F616465643A66756E6374696F6E28297B72657475726E21746869732E6C617A797C7C766F69642030213D3D746869732E6861734368';
wwv_flow_imp.g_varchar2_table(101) := '696C6472656E28297D2C69734C6F6164696E673A66756E6374696F6E28297B72657475726E2121746869732E5F69734C6F6164696E677D2C6973526F6F743A66756E6374696F6E28297B72657475726E20746869732E6973526F6F744E6F646528297D2C';
wwv_flow_imp.g_varchar2_table(102) := '69735061727473656C3A66756E6374696F6E28297B72657475726E21746869732E73656C656374656426262121746869732E7061727473656C7D2C6973506172746C6F61643A66756E6374696F6E28297B72657475726E2121746869732E706172746C6F';
wwv_flow_imp.g_varchar2_table(103) := '61647D2C6973526F6F744E6F64653A66756E6374696F6E28297B72657475726E20746869732E747265652E726F6F744E6F64653D3D3D746869737D2C697353656C65637465643A66756E6374696F6E28297B72657475726E2121746869732E73656C6563';
wwv_flow_imp.g_varchar2_table(104) := '7465647D2C69735374617475734E6F64653A66756E6374696F6E28297B72657475726E2121746869732E7374617475734E6F6465547970657D2C6973506167696E674E6F64653A66756E6374696F6E28297B72657475726E22706167696E67223D3D3D74';
wwv_flow_imp.g_varchar2_table(105) := '6869732E7374617475734E6F6465547970657D2C6973546F704C6576656C3A66756E6374696F6E28297B72657475726E20746869732E747265652E726F6F744E6F64653D3D3D746869732E706172656E747D2C6973556E646566696E65643A66756E6374';
wwv_flow_imp.g_varchar2_table(106) := '696F6E28297B72657475726E20766F696420303D3D3D746869732E6861734368696C6472656E28297D2C697356697369626C653A66756E6374696F6E28297B76617220652C742C6E3D746869732E747265652E656E61626C6546696C7465722C723D7468';
wwv_flow_imp.g_varchar2_table(107) := '69732E676574506172656E744C6973742821312C2131293B6966286E262621746869732E6D61746368262621746869732E7375624D61746368436F756E742972657475726E21313B666F7228653D302C743D722E6C656E6774683B653C743B652B2B2969';
wwv_flow_imp.g_varchar2_table(108) := '662821725B655D2E657870616E6465642972657475726E21313B72657475726E21307D2C6C617A794C6F61643A66756E6374696F6E2874297B652E6572726F72282246616E6379747265654E6F64652E6C617A794C6F6164282920697320646570726563';
wwv_flow_imp.g_varchar2_table(109) := '617465642073696E636520323031342D30322D31362E20557365202E6C6F6164282920696E73746561642E22297D2C6C6F61643A66756E6374696F6E2865297B76617220742C6E2C723D746869732C693D746869732E6973457870616E64656428293B72';
wwv_flow_imp.g_varchar2_table(110) := '657475726E206B28746869732E69734C617A7928292C226C6F616428292072657175697265732061206C617A79206E6F646522292C657C7C746869732E6973556E646566696E656428293F28746869732E69734C6F6164656428292626746869732E7265';
wwv_flow_imp.g_varchar2_table(111) := '7365744C617A7928292C21313D3D3D286E3D746869732E747265652E5F747269676765724E6F64654576656E7428226C617A794C6F6164222C7468697329293F542874686973293A286B2822626F6F6C65616E22213D747970656F66206E2C226C617A79';
wwv_flow_imp.g_varchar2_table(112) := '4C6F6164206576656E74206D7573742072657475726E20736F7572636520696E20646174612E726573756C7422292C743D746869732E747265652E5F63616C6C486F6F6B28226E6F64654C6F61644368696C6472656E222C746869732C6E292C693F2874';
wwv_flow_imp.g_varchar2_table(113) := '6869732E657870616E6465643D21302C742E616C776179732866756E6374696F6E28297B722E72656E64657228297D29293A742E616C776179732866756E6374696F6E28297B722E72656E64657253746174757328297D292C7429293A54287468697329';
wwv_flow_imp.g_varchar2_table(114) := '7D2C6D616B6556697369626C653A66756E6374696F6E2874297B766172206E2C723D746869732C693D5B5D2C6F3D6E657720652E44656665727265642C613D746869732E676574506172656E744C6973742821312C2131292C733D612E6C656E6774682C';
wwv_flow_imp.g_varchar2_table(115) := '6C3D212874262621303D3D3D742E6E6F416E696D6174696F6E292C643D212874262621313D3D3D742E7363726F6C6C496E746F56696577293B666F72286E3D732D313B6E3E3D303B6E2D2D29692E7075736828615B6E5D2E736574457870616E64656428';
wwv_flow_imp.g_varchar2_table(116) := '21302C7429293B72657475726E20652E7768656E2E6170706C7928652C69292E646F6E652866756E6374696F6E28297B643F722E7363726F6C6C496E746F56696577286C292E646F6E652866756E6374696F6E28297B6F2E7265736F6C766528297D293A';
wwv_flow_imp.g_varchar2_table(117) := '6F2E7265736F6C766528297D292C6F2E70726F6D69736528297D2C6D6F7665546F3A66756E6374696F6E28742C6E2C72297B766F696420303D3D3D6E7C7C226F766572223D3D3D6E3F6E3D226368696C64223A2266697273744368696C64223D3D3D6E26';
wwv_flow_imp.g_varchar2_table(118) := '2628742E6368696C6472656E2626742E6368696C6472656E2E6C656E6774683F286E3D226265666F7265222C743D742E6368696C6472656E5B305D293A6E3D226368696C6422293B76617220692C6F3D746869732E747265652C613D746869732E706172';
wwv_flow_imp.g_varchar2_table(119) := '656E742C733D226368696C64223D3D3D6E3F743A742E706172656E743B69662874686973213D3D74297B696628746869732E706172656E743F732E697344657363656E64616E744F662874686973292626652E6572726F72282243616E6E6F74206D6F76';
wwv_flow_imp.g_varchar2_table(120) := '652061206E6F646520746F20697473206F776E2064657363656E64616E7422293A652E6572726F72282243616E6E6F74206D6F76652073797374656D20726F6F7422292C73213D3D612626612E747269676765724D6F646966794368696C64282272656D';
wwv_flow_imp.g_varchar2_table(121) := '6F7665222C74686973292C313D3D3D746869732E706172656E742E6368696C6472656E2E6C656E677468297B696628746869732E706172656E743D3D3D732972657475726E3B746869732E706172656E742E6368696C6472656E3D746869732E70617265';
wwv_flow_imp.g_varchar2_table(122) := '6E742E6C617A793F5B5D3A6E756C6C2C746869732E706172656E742E657870616E6465643D21317D656C7365206B2828693D652E696E417272617928746869732C746869732E706172656E742E6368696C6472656E29293E3D302C22696E76616C696420';
wwv_flow_imp.g_varchar2_table(123) := '736F7572636520706172656E7422292C746869732E706172656E742E6368696C6472656E2E73706C69636528692C31293B696628746869732E706172656E743D732C732E6861734368696C6472656E282929737769746368286E297B6361736522636869';
wwv_flow_imp.g_varchar2_table(124) := '6C64223A732E6368696C6472656E2E707573682874686973293B627265616B3B63617365226265666F7265223A6B2828693D652E696E417272617928742C732E6368696C6472656E29293E3D302C22696E76616C69642074617267657420706172656E74';
wwv_flow_imp.g_varchar2_table(125) := '22292C732E6368696C6472656E2E73706C69636528692C302C74686973293B627265616B3B63617365226166746572223A6B2828693D652E696E417272617928742C732E6368696C6472656E29293E3D302C22696E76616C696420746172676574207061';
wwv_flow_imp.g_varchar2_table(126) := '72656E7422292C732E6368696C6472656E2E73706C69636528692B312C302C74686973293B627265616B3B64656661756C743A652E6572726F722822496E76616C6964206D6F646520222B6E297D656C736520732E6368696C6472656E3D5B746869735D';
wwv_flow_imp.g_varchar2_table(127) := '3B722626742E766973697428722C2130292C733D3D3D613F732E747269676765724D6F646966794368696C6428226D6F7665222C74686973293A732E747269676765724D6F646966794368696C642822616464222C74686973292C6F213D3D742E747265';
wwv_flow_imp.g_varchar2_table(128) := '65262628746869732E7761726E282243726F73732D74726565206D6F7665546F206973206578706572696D656E74616C2122292C746869732E76697369742866756E6374696F6E2865297B652E747265653D742E747265657D2C213029292C6F2E5F6361';
wwv_flow_imp.g_varchar2_table(129) := '6C6C486F6F6B2822747265655374727563747572654368616E676564222C6F2C226D6F7665546F22292C612E697344657363656E64616E744F662873297C7C612E72656E64657228292C732E697344657363656E64616E744F662861297C7C733D3D3D61';
wwv_flow_imp.g_varchar2_table(130) := '7C7C732E72656E64657228297D7D2C6E617669676174653A66756E6374696F6E28742C6E297B76617220722C693D652E75692E6B6579436F64653B7377697463682874297B63617365226C656674223A6361736520692E4C4546543A696628746869732E';
wwv_flow_imp.g_varchar2_table(131) := '657870616E6465642972657475726E20746869732E736574457870616E646564282131293B627265616B3B63617365227269676874223A6361736520692E52494748543A69662821746869732E657870616E646564262628746869732E6368696C647265';
wwv_flow_imp.g_varchar2_table(132) := '6E7C7C746869732E6C617A79292972657475726E20746869732E736574457870616E64656428297D696628723D746869732E66696E6452656C617465644E6F6465287429297B7472797B722E6D616B6556697369626C65287B7363726F6C6C496E746F56';
wwv_flow_imp.g_varchar2_table(133) := '6965773A21317D297D63617463682865297B7D72657475726E21313D3D3D6E3F28722E736574466F63757328292C542829293A722E73657441637469766528297D72657475726E20746869732E7761726E2822436F756C64206E6F742066696E64207265';
wwv_flow_imp.g_varchar2_table(134) := '6C61746564206E6F64652027222B742B22272E22292C5428297D2C72656D6F76653A66756E6374696F6E28297B72657475726E20746869732E706172656E742E72656D6F76654368696C642874686973297D2C72656D6F76654368696C643A66756E6374';
wwv_flow_imp.g_varchar2_table(135) := '696F6E2865297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F646552656D6F76654368696C64222C746869732C65297D2C72656D6F76654368696C6472656E3A66756E6374696F6E28297B72657475726E20746869732E74';
wwv_flow_imp.g_varchar2_table(136) := '7265652E5F63616C6C486F6F6B28226E6F646552656D6F76654368696C6472656E222C74686973297D2C72656D6F7665436C6173733A66756E6374696F6E2865297B72657475726E20746869732E746F67676C65436C61737328652C2131297D2C72656E';
wwv_flow_imp.g_varchar2_table(137) := '6465723A66756E6374696F6E28652C74297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F646552656E646572222C746869732C652C74297D2C72656E6465725469746C653A66756E6374696F6E28297B72657475726E2074';
wwv_flow_imp.g_varchar2_table(138) := '6869732E747265652E5F63616C6C486F6F6B28226E6F646552656E6465725469746C65222C74686973297D2C72656E6465725374617475733A66756E6374696F6E28297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465';
wwv_flow_imp.g_varchar2_table(139) := '52656E646572537461747573222C74686973297D2C7265706C616365576974683A66756E6374696F6E286E297B76617220722C693D746869732E706172656E742C6F3D652E696E417272617928746869732C692E6368696C6472656E292C613D74686973';
wwv_flow_imp.g_varchar2_table(140) := '3B72657475726E206B28746869732E6973506167696E674E6F646528292C227265706C6163655769746828292063757272656E746C79207265717569726573206120706167696E6720737461747573206E6F646522292C28723D746869732E747265652E';
wwv_flow_imp.g_varchar2_table(141) := '5F63616C6C486F6F6B28226E6F64654C6F61644368696C6472656E222C746869732C6E29292E646F6E652866756E6374696F6E2865297B766172206E3D612E6368696C6472656E3B666F7228743D303B743C6E2E6C656E6774683B742B2B296E5B745D2E';
wwv_flow_imp.g_varchar2_table(142) := '706172656E743D693B692E6368696C6472656E2E73706C6963652E6170706C7928692E6368696C6472656E2C5B6F2B312C305D2E636F6E636174286E29292C612E6368696C6472656E3D6E756C6C2C612E72656D6F766528292C692E72656E6465722829';
wwv_flow_imp.g_varchar2_table(143) := '7D292E6661696C2866756E6374696F6E28297B612E736574457870616E64656428297D292C727D2C72657365744C617A793A66756E6374696F6E28297B746869732E72656D6F76654368696C6472656E28292C746869732E657870616E6465643D21312C';
wwv_flow_imp.g_varchar2_table(144) := '746869732E6C617A793D21302C746869732E6368696C6472656E3D766F696420302C746869732E72656E64657253746174757328297D2C7363686564756C65416374696F6E3A66756E6374696F6E28742C6E297B746869732E747265652E74696D657226';
wwv_flow_imp.g_varchar2_table(145) := '2628636C65617254696D656F757428746869732E747265652E74696D6572292C746869732E747265652E64656275672822636C65617254696D656F757428256F29222C746869732E747265652E74696D657229292C746869732E747265652E74696D6572';
wwv_flow_imp.g_varchar2_table(146) := '3D6E756C6C3B76617220723D746869733B7377697463682874297B636173652263616E63656C223A627265616B3B6361736522657870616E64223A746869732E747265652E74696D65723D73657454696D656F75742866756E6374696F6E28297B722E74';
wwv_flow_imp.g_varchar2_table(147) := '7265652E6465627567282273657454696D656F75743A207472696767657220657870616E6422292C722E736574457870616E646564282130297D2C6E293B627265616B3B63617365226163746976617465223A746869732E747265652E74696D65723D73';
wwv_flow_imp.g_varchar2_table(148) := '657454696D656F75742866756E6374696F6E28297B722E747265652E6465627567282273657454696D656F75743A207472696767657220616374697661746522292C722E736574416374697665282130297D2C6E293B627265616B3B64656661756C743A';
wwv_flow_imp.g_varchar2_table(149) := '652E6572726F722822496E76616C6964206D6F646520222B74297D7D2C7363726F6C6C496E746F566965773A66756E6374696F6E28742C6E297B696628766F69642030213D3D6E26262828723D6E292E747265652626766F69642030213D3D722E737461';
wwv_flow_imp.g_varchar2_table(150) := '7475734E6F64655479706529297468726F77204572726F7228227363726F6C6C496E746F56696577282920776974682027746F704E6F646527206F7074696F6E20697320646570726563617465642073696E636520323031342D30352D30382E20557365';
wwv_flow_imp.g_varchar2_table(151) := '20276F7074696F6E732E746F704E6F64652720696E73746561642E22293B76617220722C693D652E657874656E64287B656666656374733A21303D3D3D743F7B6475726174696F6E3A3230302C71756575653A21317D3A742C7363726F6C6C4F66733A74';
wwv_flow_imp.g_varchar2_table(152) := '6869732E747265652E6F7074696F6E732E7363726F6C6C4F66732C7363726F6C6C506172656E743A746869732E747265652E6F7074696F6E732E7363726F6C6C506172656E742C746F704E6F64653A6E756C6C7D2C6E292C6F3D692E7363726F6C6C5061';
wwv_flow_imp.g_varchar2_table(153) := '72656E742C613D746869732E747265652E24636F6E7461696E65722C733D612E63737328226F766572666C6F772D7922293B6F3F6F2E6A71756572797C7C286F3D65286F29293A6F3D746869732E747265652E74626F64793F612E7363726F6C6C506172';
wwv_flow_imp.g_varchar2_table(154) := '656E7428293A227363726F6C6C223D3D3D737C7C226175746F223D3D3D733F613A612E7363726F6C6C506172656E7428292C6F5B305D213D3D646F63756D656E7426266F5B305D213D3D646F63756D656E742E626F64797C7C28746869732E6465627567';
wwv_flow_imp.g_varchar2_table(155) := '28227363726F6C6C496E746F5669657728293A206E6F726D616C697A696E67207363726F6C6C506172656E7420746F202777696E646F77273A222C6F5B305D292C6F3D652877696E646F7729293B766172206C2C642C632C753D6E657720652E44656665';
wwv_flow_imp.g_varchar2_table(156) := '727265642C663D746869732C703D6528746869732E7370616E292E68656967687428292C683D692E7363726F6C6C4F66732E746F707C7C302C673D692E7363726F6C6C4F66732E626F74746F6D7C7C302C793D6F2E68656967687428292C763D6F2E7363';
wwv_flow_imp.g_varchar2_table(157) := '726F6C6C546F7028292C6D3D6F2C783D6F5B305D3D3D3D77696E646F772C623D692E746F704E6F64657C7C6E756C6C2C433D6E756C6C3B72657475726E20746869732E6973526F6F744E6F646528297C7C21746869732E697356697369626C6528293F28';
wwv_flow_imp.g_varchar2_table(158) := '746869732E696E666F28227363726F6C6C496E746F5669657728293A206E6F646520697320696E76697369626C652E22292C542829293A28783F28643D6528746869732E7370616E292E6F666673657428292E746F702C6C3D622626622E7370616E3F65';
wwv_flow_imp.g_varchar2_table(159) := '28622E7370616E292E6F666673657428292E746F703A302C6D3D65282268746D6C2C626F64792229293A286B286F5B305D213D3D646F63756D656E7426266F5B305D213D3D646F63756D656E742E626F64792C227363726F6C6C506172656E742073686F';
wwv_flow_imp.g_varchar2_table(160) := '756C6420626520612073696D706C6520656C656D656E74206F72206077696E646F77602C206E6F7420646F63756D656E74206F7220626F64792E22292C633D6F2E6F666673657428292E746F702C643D6528746869732E7370616E292E6F666673657428';
wwv_flow_imp.g_varchar2_table(161) := '292E746F702D632B762C6C3D623F6528622E7370616E292E6F666673657428292E746F702D632B763A302C792D3D4D6174682E6D617828302C6F2E696E6E657248656967687428292D6F5B305D2E636C69656E7448656967687429292C643C762B683F43';
wwv_flow_imp.g_varchar2_table(162) := '3D642D683A642B703E762B792D67262628433D642B702D792B672C622626286B28622E6973526F6F744E6F646528297C7C622E697356697369626C6528292C22746F704E6F6465206D7573742062652076697369626C6522292C6C3C43262628433D6C2D';
wwv_flow_imp.g_varchar2_table(163) := '682929292C6E756C6C3D3D3D433F752E7265736F6C7665576974682874686973293A692E656666656374733F28692E656666656374732E636F6D706C6574653D66756E6374696F6E28297B752E7265736F6C7665576974682866297D2C6D2E73746F7028';
wwv_flow_imp.g_varchar2_table(164) := '2130292E616E696D617465287B7363726F6C6C546F703A437D2C692E6566666563747329293A286D5B305D2E7363726F6C6C546F703D432C752E7265736F6C766557697468287468697329292C752E70726F6D6973652829297D2C736574416374697665';
wwv_flow_imp.g_varchar2_table(165) := '3A66756E6374696F6E28652C74297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465536574416374697665222C746869732C652C74297D2C736574457870616E6465643A66756E6374696F6E28652C74297B7265747572';
wwv_flow_imp.g_varchar2_table(166) := '6E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465536574457870616E646564222C746869732C652C74297D2C736574466F6375733A66756E6374696F6E2865297B72657475726E20746869732E747265652E5F63616C6C486F6F6B2822';
wwv_flow_imp.g_varchar2_table(167) := '6E6F6465536574466F637573222C746869732C65297D2C73657453656C65637465643A66756E6374696F6E28652C74297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F646553657453656C6563746564222C746869732C65';
wwv_flow_imp.g_varchar2_table(168) := '2C74297D2C7365745374617475733A66756E6374696F6E28652C742C6E297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465536574537461747573222C746869732C652C742C6E297D2C7365745469746C653A66756E63';
wwv_flow_imp.g_varchar2_table(169) := '74696F6E2865297B746869732E7469746C653D652C746869732E72656E6465725469746C6528292C746869732E747269676765724D6F64696679282272656E616D6522297D2C736F72744368696C6472656E3A66756E6374696F6E28652C74297B766172';
wwv_flow_imp.g_varchar2_table(170) := '206E2C722C693D746869732E6368696C6472656E3B69662869297B696628653D657C7C66756E6374696F6E28652C74297B766172206E3D652E7469746C652E746F4C6F7765724361736528292C723D742E7469746C652E746F4C6F776572436173652829';
wwv_flow_imp.g_varchar2_table(171) := '3B72657475726E206E3D3D3D723F303A6E3E723F313A2D317D2C692E736F72742865292C7429666F72286E3D302C723D692E6C656E6774683B6E3C723B6E2B2B29695B6E5D2E6368696C6472656E2626695B6E5D2E736F72744368696C6472656E28652C';
wwv_flow_imp.g_varchar2_table(172) := '22246E6F72656E6465722422293B22246E6F72656E6465722422213D3D742626746869732E72656E64657228292C746869732E747269676765724D6F646966794368696C642822736F727422297D7D2C746F446963743A66756E6374696F6E28742C6E29';
wwv_flow_imp.g_varchar2_table(173) := '7B76617220722C692C6F2C612C733D7B7D2C6C3D746869733B696628652E6561636828762C66756E6374696F6E28652C74297B286C5B745D7C7C21313D3D3D6C5B745D29262628735B745D3D6C5B745D297D292C652E6973456D7074794F626A65637428';
wwv_flow_imp.g_varchar2_table(174) := '746869732E64617461297C7C28732E646174613D652E657874656E64287B7D2C746869732E64617461292C652E6973456D7074794F626A65637428732E6461746129262664656C65746520732E64617461292C6E297B69662821313D3D3D28613D6E2873';
wwv_flow_imp.g_varchar2_table(175) := '2C6C29292972657475726E21313B22736B6970223D3D3D61262628743D2131297D6966287426264328746869732E6368696C6472656E2929666F7228732E6368696C6472656E3D5B5D2C723D302C693D746869732E6368696C6472656E2E6C656E677468';
wwv_flow_imp.g_varchar2_table(176) := '3B723C693B722B2B29286F3D746869732E6368696C6472656E5B725D292E69735374617475734E6F646528297C7C2131213D3D28613D6F2E746F446963742821302C6E29292626732E6368696C6472656E2E707573682861293B72657475726E20737D2C';
wwv_flow_imp.g_varchar2_table(177) := '746F67676C65436C6173733A66756E6374696F6E28742C6E297B76617220722C692C6F3D742E6D61746368282F5C532B2F67297C7C5B5D2C613D302C733D21312C6C3D746869735B746869732E747265652E737461747573436C61737350726F704E616D';
wwv_flow_imp.g_varchar2_table(178) := '655D2C643D2220222B28746869732E6578747261436C61737365737C7C2222292B2220223B666F72286C262665286C292E746F67676C65436C61737328742C6E293B723D6F5B612B2B5D3B29696628693D642E696E6465784F66282220222B722B222022';
wwv_flow_imp.g_varchar2_table(179) := '293E3D302C6E3D766F696420303D3D3D6E3F21693A21216E29697C7C28642B3D722B2220222C733D2130293B656C736520666F72283B642E696E6465784F66282220222B722B222022293E2D313B29643D642E7265706C616365282220222B722B222022';
wwv_flow_imp.g_varchar2_table(180) := '2C222022293B72657475726E20746869732E6578747261436C61737365733D5F2864292C737D2C746F67676C65457870616E6465643A66756E6374696F6E28297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465546F67';
wwv_flow_imp.g_varchar2_table(181) := '676C65457870616E646564222C74686973297D2C746F67676C6553656C65637465643A66756E6374696F6E28297B72657475726E20746869732E747265652E5F63616C6C486F6F6B28226E6F6465546F67676C6553656C6563746564222C74686973297D';
wwv_flow_imp.g_varchar2_table(182) := '2C746F537472696E673A66756E6374696F6E28297B72657475726E2246616E6379747265654E6F646540222B746869732E6B65792B225B7469746C653D27222B746869732E7469746C652B22275D227D2C747269676765724D6F646966794368696C643A';
wwv_flow_imp.g_varchar2_table(183) := '66756E6374696F6E28742C6E2C72297B76617220692C6F3D746869732E747265652E6F7074696F6E732E6D6F646966794368696C643B6F2626286E26266E2E706172656E74213D3D746869732626652E6572726F7228226368696C644E6F646520222B6E';
wwv_flow_imp.g_varchar2_table(184) := '2B22206973206E6F742061206368696C64206F6620222B74686973292C693D7B6E6F64653A746869732C747265653A746869732E747265652C6F7065726174696F6E3A742C6368696C644E6F64653A6E7C7C6E756C6C7D2C722626652E657874656E6428';
wwv_flow_imp.g_varchar2_table(185) := '692C72292C6F287B747970653A226D6F646966794368696C64227D2C6929297D2C747269676765724D6F646966793A66756E6374696F6E28652C74297B746869732E706172656E742E747269676765724D6F646966794368696C6428652C746869732C74';
wwv_flow_imp.g_varchar2_table(186) := '297D2C76697369743A66756E6374696F6E28652C74297B766172206E2C722C693D21302C6F3D746869732E6368696C6472656E3B69662821303D3D3D7426262821313D3D3D28693D65287468697329297C7C22736B6970223D3D3D69292972657475726E';
wwv_flow_imp.g_varchar2_table(187) := '20693B6966286F29666F72286E3D302C723D6F2E6C656E6774683B6E3C7226262131213D3D28693D6F5B6E5D2E766973697428652C213029293B6E2B2B293B72657475726E20697D2C7669736974416E644C6F61643A66756E6374696F6E28742C6E2C72';
wwv_flow_imp.g_varchar2_table(188) := '297B76617220692C6F2C612C733D746869733B72657475726E21747C7C2130213D3D6E7C7C2131213D3D286F3D7428732929262622736B697022213D3D6F3F732E6368696C6472656E7C7C732E6C617A793F28693D6E657720652E44656665727265642C';
wwv_flow_imp.g_varchar2_table(189) := '613D5B5D2C732E6C6F616428292E646F6E652866756E6374696F6E28297B666F7228766172206E3D302C723D732E6368696C6472656E2E6C656E6774683B6E3C723B6E2B2B297B69662821313D3D3D286F3D732E6368696C6472656E5B6E5D2E76697369';
wwv_flow_imp.g_varchar2_table(190) := '74416E644C6F616428742C21302C21302929297B692E72656A65637428293B627265616B7D22736B697022213D3D6F2626612E70757368286F297D652E7768656E2E6170706C7928746869732C61292E7468656E2866756E6374696F6E28297B692E7265';
wwv_flow_imp.g_varchar2_table(191) := '736F6C766528297D297D292C692E70726F6D6973652829293A5428293A723F6F3A5428297D2C7669736974506172656E74733A66756E6374696F6E28652C74297B69662874262621313D3D3D652874686973292972657475726E21313B666F7228766172';
wwv_flow_imp.g_varchar2_table(192) := '206E3D746869732E706172656E743B6E3B297B69662821313D3D3D65286E292972657475726E21313B6E3D6E2E706172656E747D72657475726E21307D2C76697369745369626C696E67733A66756E6374696F6E28652C74297B766172206E2C722C692C';
wwv_flow_imp.g_varchar2_table(193) := '6F3D746869732E706172656E742E6368696C6472656E3B666F72286E3D302C723D6F2E6C656E6774683B6E3C723B6E2B2B29696628693D6F5B6E5D2C28747C7C69213D3D7468697329262621313D3D3D652869292972657475726E21313B72657475726E';
wwv_flow_imp.g_varchar2_table(194) := '21307D2C7761726E3A66756E6374696F6E2865297B746869732E747265652E6F7074696F6E732E64656275674C6576656C3E3D3226262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E74';
wwv_flow_imp.g_varchar2_table(195) := '6F537472696E672829292C4E28227761726E222C617267756D656E747329297D7D2C502E70726F746F747970653D7B5F6D616B65486F6F6B436F6E746578743A66756E6374696F6E28742C6E2C72297B76617220692C6F3B72657475726E20766F696420';
wwv_flow_imp.g_varchar2_table(196) := '30213D3D742E6E6F64653F286E2626742E6F726967696E616C4576656E74213D3D6E2626652E6572726F722822696E76616C6964206172677322292C693D74293A742E747265653F693D7B6E6F64653A742C747265653A6F3D742E747265652C77696467';
wwv_flow_imp.g_varchar2_table(197) := '65743A6F2E7769646765742C6F7074696F6E733A6F2E7769646765742E6F7074696F6E732C6F726967696E616C4576656E743A6E2C74797065496E666F3A6F2E74797065735B742E747970655D7C7C7B7D7D3A742E7769646765743F693D7B6E6F64653A';
wwv_flow_imp.g_varchar2_table(198) := '6E756C6C2C747265653A742C7769646765743A742E7769646765742C6F7074696F6E733A742E7769646765742E6F7074696F6E732C6F726967696E616C4576656E743A6E7D3A652E6572726F722822696E76616C6964206172677322292C722626652E65';
wwv_flow_imp.g_varchar2_table(199) := '7874656E6428692C72292C697D2C5F63616C6C486F6F6B3A66756E6374696F6E28742C6E2C72297B76617220693D746869732E5F6D616B65486F6F6B436F6E74657874286E292C6F3D746869735B745D2C613D41727261792E70726F746F747970652E73';
wwv_flow_imp.g_varchar2_table(200) := '6C6963652E63616C6C28617267756D656E74732C32293B72657475726E2053286F297C7C652E6572726F7228225F63616C6C486F6F6B2827222B742B222729206973206E6F7420612066756E6374696F6E22292C612E756E73686966742869292C6F2E61';
wwv_flow_imp.g_varchar2_table(201) := '70706C7928746869732C61297D2C5F7365744578706972696E6756616C75653A66756E6374696F6E28652C742C6E297B746869732E5F74656D7043616368655B655D3D7B76616C75653A742C6578706972653A446174652E6E6F7728292B282B6E7C7C35';
wwv_flow_imp.g_varchar2_table(202) := '30297D7D2C5F6765744578706972696E6756616C75653A66756E6374696F6E2865297B76617220743D746869732E5F74656D7043616368655B655D3B72657475726E20742626742E6578706972653E446174652E6E6F7728293F742E76616C75653A2864';
wwv_flow_imp.g_varchar2_table(203) := '656C65746520746869732E5F74656D7043616368655B655D2C6E756C6C297D2C5F75736573457874656E73696F6E3A66756E6374696F6E2874297B72657475726E20652E696E417272617928742C746869732E6F7074696F6E732E657874656E73696F6E';
wwv_flow_imp.g_varchar2_table(204) := '73293E3D307D2C5F72657175697265457874656E73696F6E3A66756E6374696F6E28742C6E2C722C69297B6E756C6C213D72262628723D212172293B766172206F3D746869732E5F6C6F63616C2E6E616D652C613D746869732E6F7074696F6E732E6578';
wwv_flow_imp.g_varchar2_table(205) := '74656E73696F6E732C733D652E696E417272617928742C61293C652E696E4172726179286F2C61292C6C3D6E26266E756C6C3D3D746869732E6578745B745D2C643D216C26266E756C6C213D72262672213D3D733B72657475726E206B286F26266F213D';
wwv_flow_imp.g_varchar2_table(206) := '3D742C22696E76616C6964206F722073616D65206E616D652027222B6F2B222720287265717569726520796F757273656C663F2922292C216C262621647C7C28697C7C286C7C7C6E3F28693D2227222B6F2B222720657874656E73696F6E207265717569';
wwv_flow_imp.g_varchar2_table(207) := '7265732027222B742B2227222C64262628692B3D2220746F206265207265676973746572656420222B28723F226265666F7265223A22616674657222292B2220697473656C662229293A693D224966207573656420746F6765746865722C2060222B742B';
wwv_flow_imp.g_varchar2_table(208) := '2260206D757374206265207265676973746572656420222B28723F226265666F7265223A22616674657222292B222060222B6F2B226022292C652E6572726F722869292C2131297D2C61637469766174654B65793A66756E6374696F6E28652C74297B76';
wwv_flow_imp.g_varchar2_table(209) := '6172206E3D746869732E6765744E6F646542794B65792865293B72657475726E206E3F6E2E7365744163746976652821302C74293A746869732E6163746976654E6F64652626746869732E6163746976654E6F64652E7365744163746976652821312C74';
wwv_flow_imp.g_varchar2_table(210) := '292C6E7D2C616464506167696E674E6F64653A66756E6374696F6E28652C74297B72657475726E20746869732E726F6F744E6F64652E616464506167696E674E6F646528652C74297D2C6170706C79436F6D6D616E643A66756E6374696F6E28742C6E2C';
wwv_flow_imp.g_varchar2_table(211) := '72297B76617220693B737769746368286E3D6E7C7C746869732E6765744163746976654E6F646528292C74297B63617365226D6F76655570223A28693D6E2E676574507265765369626C696E672829292626286E2E6D6F7665546F28692C226265666F72';
wwv_flow_imp.g_varchar2_table(212) := '6522292C6E2E7365744163746976652829293B627265616B3B63617365226D6F7665446F776E223A28693D6E2E6765744E6578745369626C696E672829292626286E2E6D6F7665546F28692C22616674657222292C6E2E7365744163746976652829293B';
wwv_flow_imp.g_varchar2_table(213) := '627265616B3B6361736522696E64656E74223A28693D6E2E676574507265765369626C696E672829292626286E2E6D6F7665546F28692C226368696C6422292C692E736574457870616E64656428292C6E2E7365744163746976652829293B627265616B';
wwv_flow_imp.g_varchar2_table(214) := '3B63617365226F757464656E74223A6E2E6973546F704C6576656C28297C7C286E2E6D6F7665546F286E2E676574506172656E7428292C22616674657222292C6E2E7365744163746976652829293B627265616B3B636173652272656D6F7665223A693D';
wwv_flow_imp.g_varchar2_table(215) := '6E2E676574507265765369626C696E6728297C7C6E2E676574506172656E7428292C6E2E72656D6F766528292C692626692E73657441637469766528293B627265616B3B63617365226164644368696C64223A6E2E656469744372656174654E6F646528';
wwv_flow_imp.g_varchar2_table(216) := '226368696C64222C2222293B627265616B3B63617365226164645369626C696E67223A6E2E656469744372656174654E6F646528226166746572222C2222293B627265616B3B636173652272656E616D65223A6E2E65646974537461727428293B627265';
wwv_flow_imp.g_varchar2_table(217) := '616B3B6361736522646F776E223A63617365226669727374223A63617365226C617374223A63617365226C656674223A6361736522706172656E74223A63617365227269676874223A63617365227570223A72657475726E206E2E6E6176696761746528';
wwv_flow_imp.g_varchar2_table(218) := '74293B64656661756C743A652E6572726F722822556E68616E646C656420636F6D6D616E643A2027222B742B222722297D7D2C6170706C7950617463683A66756E6374696F6E2874297B766172206E2C722C692C6F2C612C732C6C3D742E6C656E677468';
wwv_flow_imp.g_varchar2_table(219) := '2C643D5B5D3B666F7228723D303B723C6C3B722B2B296B28323D3D3D28693D745B725D292E6C656E6774682C2270617463684C697374206D75737420626520616E206172726179206F66206C656E6774682D322D61727261797322292C6F3D695B305D2C';
wwv_flow_imp.g_varchar2_table(220) := '613D695B315D2C28733D6E756C6C3D3D3D6F3F746869732E726F6F744E6F64653A746869732E6765744E6F646542794B6579286F29293F286E3D6E657720652E44656665727265642C642E70757368286E292C732E6170706C7950617463682861292E61';
wwv_flow_imp.g_varchar2_table(221) := '6C77617973284F286E2C732929293A746869732E7761726E2822636F756C64206E6F742066696E64206E6F64652077697468206B65792027222B6F2B222722293B72657475726E20652E7768656E2E6170706C7928652C64292E70726F6D69736528297D';
wwv_flow_imp.g_varchar2_table(222) := '2C636C6561723A66756E6374696F6E2865297B746869732E5F63616C6C486F6F6B282274726565436C656172222C74686973297D2C636F756E743A66756E6374696F6E28297B72657475726E20746869732E726F6F744E6F64652E636F756E744368696C';
wwv_flow_imp.g_varchar2_table(223) := '6472656E28297D2C64656275673A66756E6374696F6E2865297B746869732E6F7074696F6E732E64656275674C6576656C3E3D3426262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E74';
wwv_flow_imp.g_varchar2_table(224) := '6F537472696E672829292C4E28226C6F67222C617267756D656E747329297D2C64657374726F793A66756E6374696F6E28297B746869732E7769646765742E64657374726F7928297D2C656E61626C653A66756E6374696F6E2865297B21313D3D3D653F';
wwv_flow_imp.g_varchar2_table(225) := '746869732E7769646765742E64697361626C6528293A746869732E7769646765742E656E61626C6528297D2C656E61626C655570646174653A66756E6374696F6E2865297B72657475726E20653D2131213D3D652C2121746869732E5F656E61626C6555';
wwv_flow_imp.g_varchar2_table(226) := '70646174653D3D2121653F653A28746869732E5F656E61626C655570646174653D652C653F28746869732E64656275672822656E61626C655570646174652874727565293A207265647261772022292C746869732E5F63616C6C486F6F6B282274726565';
wwv_flow_imp.g_varchar2_table(227) := '5374727563747572654368616E676564222C746869732C22656E61626C6555706461746522292C746869732E72656E6465722829293A746869732E64656275672822656E61626C655570646174652866616C7365292E2E2E22292C2165297D2C6572726F';
wwv_flow_imp.g_varchar2_table(228) := '723A66756E6374696F6E2865297B746869732E6F7074696F6E732E64656275674C6576656C3E3D3126262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E746F537472696E672829292C4E';
wwv_flow_imp.g_varchar2_table(229) := '28226572726F72222C617267756D656E747329297D2C657870616E64416C6C3A66756E6374696F6E28652C74297B766172206E3D746869732E656E61626C65557064617465282131293B653D2131213D3D652C746869732E76697369742866756E637469';
wwv_flow_imp.g_varchar2_table(230) := '6F6E286E297B2131213D3D6E2E6861734368696C6472656E282926266E2E6973457870616E6465642829213D3D6526266E2E736574457870616E64656428652C74297D292C746869732E656E61626C65557064617465286E297D2C66696E64416C6C3A66';
wwv_flow_imp.g_varchar2_table(231) := '756E6374696F6E2865297B72657475726E20746869732E726F6F744E6F64652E66696E64416C6C2865297D2C66696E6446697273743A66756E6374696F6E2865297B72657475726E20746869732E726F6F744E6F64652E66696E6446697273742865297D';
wwv_flow_imp.g_varchar2_table(232) := '2C66696E644E6578744E6F64653A66756E6374696F6E28652C74297B766172206E2C723D6E756C6C2C693D746869732E67657446697273744368696C6428293B66756E6374696F6E206F286E297B69662865286E29262628723D6E292C727C7C6E3D3D3D';
wwv_flow_imp.g_varchar2_table(233) := '742972657475726E21317D72657475726E20653D22737472696E67223D3D747970656F6620653F286E3D6E65772052656745787028225E222B652C226922292C66756E6374696F6E2865297B72657475726E206E2E7465737428652E7469746C65297D29';
wwv_flow_imp.g_varchar2_table(234) := '3A652C743D747C7C692C746869732E7669736974526F7773286F2C7B73746172743A742C696E636C75646553656C663A21317D292C727C7C743D3D3D697C7C746869732E7669736974526F7773286F2C7B73746172743A692C696E636C75646553656C66';
wwv_flow_imp.g_varchar2_table(235) := '3A21307D292C727D2C66696E6452656C617465644E6F64653A66756E6374696F6E28742C6E2C72297B76617220693D6E756C6C2C6F3D652E75692E6B6579436F64653B737769746368286E297B6361736522706172656E74223A63617365206F2E424143';
wwv_flow_imp.g_varchar2_table(236) := '4B53504143453A742E706172656E742626742E706172656E742E706172656E74262628693D742E706172656E74293B627265616B3B63617365226669727374223A63617365206F2E484F4D453A746869732E76697369742866756E6374696F6E2865297B';
wwv_flow_imp.g_varchar2_table(237) := '696628652E697356697369626C6528292972657475726E20693D652C21317D293B627265616B3B63617365226C617374223A63617365206F2E454E443A746869732E76697369742866756E6374696F6E2865297B652E697356697369626C652829262628';
wwv_flow_imp.g_varchar2_table(238) := '693D65297D293B627265616B3B63617365226C656674223A63617365206F2E4C4546543A742E657870616E6465643F742E736574457870616E646564282131293A742E706172656E742626742E706172656E742E706172656E74262628693D742E706172';
wwv_flow_imp.g_varchar2_table(239) := '656E74293B627265616B3B63617365227269676874223A63617365206F2E52494748543A742E657870616E6465647C7C21742E6368696C6472656E262621742E6C617A793F742E6368696C6472656E2626742E6368696C6472656E2E6C656E6774682626';
wwv_flow_imp.g_varchar2_table(240) := '28693D742E6368696C6472656E5B305D293A28742E736574457870616E64656428292C693D74293B627265616B3B63617365227570223A63617365206F2E55503A746869732E7669736974526F77732866756E6374696F6E2865297B72657475726E2069';
wwv_flow_imp.g_varchar2_table(241) := '3D652C21317D2C7B73746172743A742C726576657273653A21302C696E636C75646553656C663A21317D293B627265616B3B6361736522646F776E223A63617365206F2E444F574E3A746869732E7669736974526F77732866756E6374696F6E2865297B';
wwv_flow_imp.g_varchar2_table(242) := '72657475726E20693D652C21317D2C7B73746172743A742C696E636C75646553656C663A21317D293B627265616B3B64656661756C743A746869732E747265652E7761726E2822556E6B6E6F776E2072656C6174696F6E2027222B6E2B22272E22297D72';
wwv_flow_imp.g_varchar2_table(243) := '657475726E20697D2C67656E6572617465466F726D456C656D656E74733A66756E6374696F6E28742C6E2C72297B723D727C7C7B7D3B76617220692C6F3D22737472696E67223D3D747970656F6620743F743A2266745F222B746869732E5F69642B225B';
wwv_flow_imp.g_varchar2_table(244) := '5D222C613D22737472696E67223D3D747970656F66206E3F6E3A2266745F222B746869732E5F69642B225F616374697665222C733D2266616E6379747265655F726573756C745F222B746869732E5F69642C6C3D65282223222B73292C643D333D3D3D74';
wwv_flow_imp.g_varchar2_table(245) := '6869732E6F7074696F6E732E73656C6563744D6F646526262131213D3D722E73746F704F6E506172656E74733B66756E6374696F6E20632874297B6C2E617070656E64286528223C696E7075743E222C7B747970653A22636865636B626F78222C6E616D';
wwv_flow_imp.g_varchar2_table(246) := '653A6F2C76616C75653A742E6B65792C636865636B65643A21307D29297D6C2E6C656E6774683F6C2E656D70747928293A6C3D6528223C6469763E222C7B69643A737D292E6869646528292E696E73657274416674657228746869732E24636F6E746169';
wwv_flow_imp.g_varchar2_table(247) := '6E6572292C2131213D3D6E2626746869732E6163746976654E6F646526266C2E617070656E64286528223C696E7075743E222C7B747970653A22726164696F222C6E616D653A612C76616C75653A746869732E6163746976654E6F64652E6B65792C6368';
wwv_flow_imp.g_varchar2_table(248) := '65636B65643A21307D29292C722E66696C7465723F746869732E76697369742866756E6374696F6E2865297B76617220743D722E66696C7465722865293B69662822736B6970223D3D3D742972657475726E20743B2131213D3D742626632865297D293A';
wwv_flow_imp.g_varchar2_table(249) := '2131213D3D74262628693D746869732E67657453656C65637465644E6F6465732864292C652E6561636828692C66756E6374696F6E28652C74297B632874297D29297D2C6765744163746976654E6F64653A66756E6374696F6E28297B72657475726E20';
wwv_flow_imp.g_varchar2_table(250) := '746869732E6163746976654E6F64657D2C67657446697273744368696C643A66756E6374696F6E28297B72657475726E20746869732E726F6F744E6F64652E67657446697273744368696C6428297D2C676574466F6375734E6F64653A66756E6374696F';
wwv_flow_imp.g_varchar2_table(251) := '6E28297B72657475726E20746869732E666F6375734E6F64657D2C6765744F7074696F6E3A66756E6374696F6E2865297B72657475726E20746869732E7769646765742E6F7074696F6E2865297D2C6765744E6F646542794B65793A66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(252) := '28652C74297B766172206E2C723B72657475726E21742626286E3D646F63756D656E742E676574456C656D656E744279496428746869732E6F7074696F6E732E69645072656669782B6529293F6E2E66746E6F64653F6E2E66746E6F64653A6E756C6C3A';
wwv_flow_imp.g_varchar2_table(253) := '28743D747C7C746869732E726F6F744E6F64652C723D6E756C6C2C653D22222B652C742E76697369742866756E6374696F6E2874297B696628742E6B65793D3D3D652972657475726E20723D742C21317D2C2130292C72297D2C676574526F6F744E6F64';
wwv_flow_imp.g_varchar2_table(254) := '653A66756E6374696F6E28297B72657475726E20746869732E726F6F744E6F64657D2C67657453656C65637465644E6F6465733A66756E6374696F6E2865297B72657475726E20746869732E726F6F744E6F64652E67657453656C65637465644E6F6465';
wwv_flow_imp.g_varchar2_table(255) := '732865297D2C686173466F6375733A66756E6374696F6E28297B72657475726E2121746869732E5F686173466F6375737D2C696E666F3A66756E6374696F6E2865297B746869732E6F7074696F6E732E64656275674C6576656C3E3D3326262841727261';
wwv_flow_imp.g_varchar2_table(256) := '792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E746F537472696E672829292C4E2822696E666F222C617267756D656E747329297D2C69734C6F6164696E673A66756E6374696F6E28297B7661722065';
wwv_flow_imp.g_varchar2_table(257) := '3D21313B72657475726E20746869732E726F6F744E6F64652E76697369742866756E6374696F6E2874297B696628742E5F69734C6F6164696E677C7C742E5F7265717565737449642972657475726E20653D21302C21317D2C2130292C657D2C6C6F6164';
wwv_flow_imp.g_varchar2_table(258) := '4B6579506174683A66756E6374696F6E28742C6E297B76617220722C692C6F2C613D746869732C733D6E657720652E44656665727265642C6C3D746869732E676574526F6F744E6F646528292C643D746869732E6F7074696F6E732E6B65795061746853';
wwv_flow_imp.g_varchar2_table(259) := '6570617261746F722C633D5B5D2C753D652E657874656E64287B7D2C6E293B666F72282266756E6374696F6E223D3D747970656F66206E3F723D6E3A6E26266E2E63616C6C6261636B262628723D6E2E63616C6C6261636B292C752E63616C6C6261636B';
wwv_flow_imp.g_varchar2_table(260) := '3D66756E6374696F6E28652C742C6E297B722626722E63616C6C28652C742C6E292C732E6E6F746966795769746828652C5B7B6E6F64653A742C7374617475733A6E7D5D297D2C6E756C6C3D3D752E6D617463684B6579262628752E6D617463684B6579';
wwv_flow_imp.g_varchar2_table(261) := '3D66756E6374696F6E28652C74297B72657475726E20652E6B65793D3D3D747D292C432874297C7C28743D5B745D292C693D303B693C742E6C656E6774683B692B2B29286F3D745B695D292E6368617241742830293D3D3D642626286F3D6F2E73756273';
wwv_flow_imp.g_varchar2_table(262) := '7472283129292C632E70757368286F2E73706C6974286429293B72657475726E2073657454696D656F75742866756E6374696F6E28297B612E5F6C6F61644B657950617468496D706C28732C752C6C2C63292E646F6E652866756E6374696F6E28297B73';
wwv_flow_imp.g_varchar2_table(263) := '2E7265736F6C766528297D297D2C30292C732E70726F6D69736528297D2C5F6C6F61644B657950617468496D706C3A66756E6374696F6E28742C6E2C722C69297B766172206F2C612C732C6C2C642C632C752C662C702C682C673D746869733B66756E63';
wwv_flow_imp.g_varchar2_table(264) := '74696F6E207928652C74297B76617220722C692C6F3D652E6368696C6472656E3B6966286F29666F7228723D302C693D6F2E6C656E6774683B723C693B722B2B296966286E2E6D617463684B6579286F5B725D2C74292972657475726E206F5B725D3B72';
wwv_flow_imp.g_varchar2_table(265) := '657475726E206E756C6C7D666F7228753D7B7D2C613D303B613C692E6C656E6774683B612B2B29666F7228703D695B615D2C663D723B702E6C656E6774683B297B696628733D702E736869667428292C21286C3D7928662C732929297B746869732E7761';
wwv_flow_imp.g_varchar2_table(266) := '726E28226C6F61644B6579506174683A206B6579206E6F7420666F756E643A20222B732B222028706172656E743A20222B662B222922292C6E2E63616C6C6261636B28746869732C732C226572726F7222293B627265616B7D696628303D3D3D702E6C65';
wwv_flow_imp.g_varchar2_table(267) := '6E677468297B6E2E63616C6C6261636B28746869732C6C2C226F6B22293B627265616B7D6966286C2E6C617A792626766F696420303D3D3D6C2E6861734368696C6472656E2829297B6E2E63616C6C6261636B28746869732C6C2C226C6F616465642229';
wwv_flow_imp.g_varchar2_table(268) := '2C755B733D6C2E6B65795D3F755B735D2E706174685365674C6973742E707573682870293A755B735D3D7B706172656E743A6C2C706174685365674C6973743A5B705D7D3B627265616B7D6E2E63616C6C6261636B28746869732C6C2C226C6F61646564';
wwv_flow_imp.g_varchar2_table(269) := '22292C663D6C7D66756E6374696F6E207628652C742C72297B6E2E63616C6C6261636B28672C742C226C6F6164696E6722292C742E6C6F616428292E646F6E652866756E6374696F6E28297B672E5F6C6F61644B657950617468496D706C2E63616C6C28';
wwv_flow_imp.g_varchar2_table(270) := '672C652C6E2C742C72292E616C77617973284F28652C6729297D292E6661696C2866756E6374696F6E2872297B672E7761726E28226C6F61644B6579506174683A206572726F72206C6F6164696E67206C617A7920222B74292C6E2E63616C6C6261636B';
wwv_flow_imp.g_varchar2_table(271) := '28672C6C2C226572726F7222292C652E72656A656374576974682867297D297D666F72286420696E206F3D5B5D2C75297728752C6429262628633D755B645D2C683D6E657720652E44656665727265642C6F2E707573682868292C7628682C632E706172';
wwv_flow_imp.g_varchar2_table(272) := '656E742C632E706174685365674C69737429293B72657475726E20652E7768656E2E6170706C7928652C6F292E70726F6D69736528297D2C726561637469766174653A66756E6374696F6E2865297B76617220742C6E3D746869732E6163746976654E6F';
wwv_flow_imp.g_varchar2_table(273) := '64653B72657475726E206E3F28746869732E6163746976654E6F64653D6E756C6C2C743D6E2E7365744163746976652821302C7B6E6F466F6375733A21307D292C6526266E2E736574466F63757328292C74293A5428297D2C72656C6F61643A66756E63';
wwv_flow_imp.g_varchar2_table(274) := '74696F6E2865297B72657475726E20746869732E5F63616C6C486F6F6B282274726565436C656172222C74686973292C746869732E5F63616C6C486F6F6B2822747265654C6F6164222C746869732C65297D2C72656E6465723A66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(275) := '2C74297B72657475726E20746869732E726F6F744E6F64652E72656E64657228652C74297D2C73656C656374416C6C3A66756E6374696F6E2865297B746869732E76697369742866756E6374696F6E2874297B742E73657453656C65637465642865297D';
wwv_flow_imp.g_varchar2_table(276) := '297D2C736574466F6375733A66756E6374696F6E2865297B72657475726E20746869732E5F63616C6C486F6F6B282274726565536574466F637573222C746869732C65297D2C7365744F7074696F6E3A66756E6374696F6E28652C74297B72657475726E';
wwv_flow_imp.g_varchar2_table(277) := '20746869732E7769646765742E6F7074696F6E28652C74297D2C646562756754696D653A66756E6374696F6E2865297B746869732E6F7074696F6E732E64656275674C6576656C3E3D34262677696E646F772E636F6E736F6C652E74696D652874686973';
wwv_flow_imp.g_varchar2_table(278) := '2B22202D20222B65297D2C646562756754696D65456E643A66756E6374696F6E2865297B746869732E6F7074696F6E732E64656275674C6576656C3E3D34262677696E646F772E636F6E736F6C652E74696D65456E6428746869732B22202D20222B6529';
wwv_flow_imp.g_varchar2_table(279) := '7D2C746F446963743A66756E6374696F6E28652C74297B766172206E3D746869732E726F6F744E6F64652E746F446963742821302C74293B72657475726E20653F6E3A6E2E6368696C6472656E7D2C746F537472696E673A66756E6374696F6E28297B72';
wwv_flow_imp.g_varchar2_table(280) := '657475726E2246616E63797472656540222B746869732E5F69647D2C5F747269676765724E6F64654576656E743A66756E6374696F6E28652C742C6E2C72297B76617220693D746869732E5F6D616B65486F6F6B436F6E7465787428742C6E2C72292C6F';
wwv_flow_imp.g_varchar2_table(281) := '3D746869732E7769646765742E5F7472696767657228652C6E2C69293B72657475726E2131213D3D6F2626766F69642030213D3D692E726573756C743F692E726573756C743A6F7D2C5F74726967676572547265654576656E743A66756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(282) := '652C742C6E297B76617220723D746869732E5F6D616B65486F6F6B436F6E7465787428746869732C742C6E292C693D746869732E7769646765742E5F7472696767657228652C742C72293B72657475726E2131213D3D692626766F69642030213D3D722E';
wwv_flow_imp.g_varchar2_table(283) := '726573756C743F722E726573756C743A697D2C76697369743A66756E6374696F6E2865297B72657475726E20746869732E726F6F744E6F64652E766973697428652C2131297D2C7669736974526F77733A66756E6374696F6E28652C74297B6966282174';
wwv_flow_imp.g_varchar2_table(284) := '6869732E726F6F744E6F64652E6861734368696C6472656E28292972657475726E21313B696628742626742E726576657273652972657475726E2064656C65746520742E726576657273652C746869732E5F7669736974526F7773557028652C74293B76';
wwv_flow_imp.g_varchar2_table(285) := '6172206E2C722C692C6F2C613D302C733D21313D3D3D28743D747C7C7B7D292E696E636C75646553656C662C6C3D2121742E696E636C75646548696464656E2C643D216C2626746869732E656E61626C6546696C7465722C633D742E73746172747C7C74';
wwv_flow_imp.g_varchar2_table(286) := '6869732E726F6F744E6F64652E6368696C6472656E5B305D3B666F7228693D632E706172656E743B693B297B666F72286B2828723D286F3D692E6368696C6472656E292E696E6465784F662863292B61293E3D302C22436F756C64206E6F742066696E64';
wwv_flow_imp.g_varchar2_table(287) := '20222B632B2220696E20706172656E742773206368696C6472656E3A20222B69292C6E3D723B6E3C6F2E6C656E6774683B6E2B2B29696628633D6F5B6E5D2C21647C7C632E6D617463687C7C632E7375624D61746368436F756E74297B69662821732626';
wwv_flow_imp.g_varchar2_table(288) := '21313D3D3D652863292972657475726E21313B696628733D21312C632E6368696C6472656E2626632E6368696C6472656E2E6C656E6774682626286C7C7C632E657870616E64656429262621313D3D3D632E76697369742866756E6374696F6E2874297B';
wwv_flow_imp.g_varchar2_table(289) := '72657475726E21647C7C742E6D617463687C7C742E7375624D61746368436F756E743F2131213D3D652874292626286C7C7C21742E6368696C6472656E7C7C742E657870616E6465643F766F696420303A22736B697022293A22736B6970227D2C213129';
wwv_flow_imp.g_varchar2_table(290) := '2972657475726E21317D633D692C693D692E706172656E742C613D317D72657475726E21307D2C5F7669736974526F777355703A66756E6374696F6E28652C74297B666F7228766172206E2C722C692C6F3D2121742E696E636C75646548696464656E2C';
wwv_flow_imp.g_varchar2_table(291) := '613D742E73746172747C7C746869732E726F6F744E6F64652E6368696C6472656E5B305D3B3B297B696628286E3D28693D612E706172656E74292E6368696C6472656E295B305D3D3D3D61297B6966282128613D69292E706172656E7429627265616B3B';
wwv_flow_imp.g_varchar2_table(292) := '6E3D692E6368696C6472656E7D656C736520666F7228723D6E2E696E6465784F662861292C613D6E5B722D315D3B286F7C7C612E657870616E646564292626612E6368696C6472656E2626612E6368696C6472656E2E6C656E6774683B29693D612C613D';
wwv_flow_imp.g_varchar2_table(293) := '286E3D612E6368696C6472656E295B6E2E6C656E6774682D315D3B696628286F7C7C612E697356697369626C65282929262621313D3D3D652861292972657475726E21317D7D2C7761726E3A66756E6374696F6E2865297B746869732E6F7074696F6E73';
wwv_flow_imp.g_varchar2_table(294) := '2E64656275674C6576656C3E3D3226262841727261792E70726F746F747970652E756E73686966742E63616C6C28617267756D656E74732C746869732E746F537472696E672829292C4E28227761726E222C617267756D656E747329297D7D2C652E6578';
wwv_flow_imp.g_varchar2_table(295) := '74656E6428502E70726F746F747970652C7B6E6F6465436C69636B3A66756E6374696F6E2865297B76617220742C6E2C723D652E746172676574547970652C693D652E6E6F64653B69662822657870616E646572223D3D3D72297B696628692E69734C6F';
wwv_flow_imp.g_varchar2_table(296) := '6164696E6728292972657475726E20766F696420692E64656275672822476F7420326E6420636C69636B207768696C65206C6F6164696E673A2069676E6F72656422293B746869732E5F63616C6C486F6F6B28226E6F6465546F67676C65457870616E64';
wwv_flow_imp.g_varchar2_table(297) := '6564222C65297D656C73652069662822636865636B626F78223D3D3D7229746869732E5F63616C6C486F6F6B28226E6F6465546F67676C6553656C6563746564222C65292C652E6F7074696F6E732E666F6375734F6E53656C6563742626746869732E5F';
wwv_flow_imp.g_varchar2_table(298) := '63616C6C486F6F6B28226E6F6465536574466F637573222C652C2130293B656C73657B6966286E3D21312C743D21302C692E666F6C6465722973776974636828652E6F7074696F6E732E636C69636B466F6C6465724D6F6465297B6361736520323A6E3D';
wwv_flow_imp.g_varchar2_table(299) := '21302C743D21313B627265616B3B6361736520333A743D21302C6E3D21307D74262628746869732E6E6F6465536574466F6375732865292C746869732E5F63616C6C486F6F6B28226E6F6465536574416374697665222C652C213029292C6E2626746869';
wwv_flow_imp.g_varchar2_table(300) := '732E5F63616C6C486F6F6B28226E6F6465546F67676C65457870616E646564222C65297D7D2C6E6F6465436F6C6C617073655369626C696E67733A66756E6374696F6E28652C74297B766172206E2C722C692C6F3D652E6E6F64653B6966286F2E706172';
wwv_flow_imp.g_varchar2_table(301) := '656E7429666F7228723D302C693D286E3D6F2E706172656E742E6368696C6472656E292E6C656E6774683B723C693B722B2B296E5B725D213D3D6F26266E5B725D2E657870616E6465642626746869732E5F63616C6C486F6F6B28226E6F646553657445';
wwv_flow_imp.g_varchar2_table(302) := '7870616E646564222C6E5B725D2C21312C74297D2C6E6F646544626C636C69636B3A66756E6374696F6E2865297B227469746C65223D3D3D652E746172676574547970652626343D3D3D652E6F7074696F6E732E636C69636B466F6C6465724D6F646526';
wwv_flow_imp.g_varchar2_table(303) := '26746869732E5F63616C6C486F6F6B28226E6F6465546F67676C65457870616E646564222C65292C227469746C65223D3D3D652E746172676574547970652626652E6F726967696E616C4576656E742E70726576656E7444656661756C7428297D2C6E6F';
wwv_flow_imp.g_varchar2_table(304) := '64654B6579646F776E3A66756E6374696F6E2874297B766172206E2C692C6F2C613D742E6F726967696E616C4576656E742C733D742E6E6F64652C6C3D742E747265652C643D742E6F7074696F6E732C633D612E77686963682C703D612E6B65797C7C53';
wwv_flow_imp.g_varchar2_table(305) := '7472696E672E66726F6D43686172436F64652863292C683D212128612E616C744B65797C7C612E6374726C4B65797C7C612E6D6574614B6579292C673D21665B635D262621755B635D262621682C793D6528612E746172676574292C763D21302C6D3D21';
wwv_flow_imp.g_varchar2_table(306) := '28612E6374726C4B65797C7C21642E6175746F4163746976617465293B696628737C7C286F3D746869732E6765744163746976654E6F646528297C7C746869732E67657446697273744368696C642829292626286F2E736574466F63757328292C28733D';
wwv_flow_imp.g_varchar2_table(307) := '742E6E6F64653D746869732E666F6375734E6F6465292E646562756728224B6579646F776E20666F72636520666F637573206F6E20616374697665206E6F64652229292C642E717569636B736561726368262667262621792E697328223A696E7075743A';
wwv_flow_imp.g_varchar2_table(308) := '656E61626C656422292972657475726E28693D446174652E6E6F772829292D6C2E6C617374517569636B73656172636854696D653E3530302626286C2E6C617374517569636B7365617263685465726D3D2222292C6C2E6C617374517569636B73656172';
wwv_flow_imp.g_varchar2_table(309) := '636854696D653D692C6C2E6C617374517569636B7365617263685465726D2B3D702C286E3D6C2E66696E644E6578744E6F6465286C2E6C617374517569636B7365617263685465726D2C6C2E6765744163746976654E6F64652829292926266E2E736574';
wwv_flow_imp.g_varchar2_table(310) := '41637469766528292C766F696420612E70726576656E7444656661756C7428293B73776974636828722E6576656E74546F537472696E67286129297B63617365222B223A63617365223D223A6C2E6E6F6465536574457870616E64656428742C2130293B';
wwv_flow_imp.g_varchar2_table(311) := '627265616B3B63617365222D223A6C2E6E6F6465536574457870616E64656428742C2131293B627265616B3B63617365227370616365223A732E6973506167696E674E6F646528293F6C2E5F747269676765724E6F64654576656E742822636C69636B50';
wwv_flow_imp.g_varchar2_table(312) := '6167696E67222C742C61293A722E6576616C4F7074696F6E2822636865636B626F78222C732C732C642C2131293F6C2E6E6F6465546F67676C6553656C65637465642874293A6C2E6E6F646553657441637469766528742C2130293B627265616B3B6361';
wwv_flow_imp.g_varchar2_table(313) := '73652272657475726E223A6C2E6E6F646553657441637469766528742C2130293B627265616B3B6361736522686F6D65223A6361736522656E64223A63617365226261636B7370616365223A63617365226C656674223A63617365227269676874223A63';
wwv_flow_imp.g_varchar2_table(314) := '617365227570223A6361736522646F776E223A732E6E6176696761746528612E77686963682C6D293B627265616B3B64656661756C743A763D21317D762626612E70726576656E7444656661756C7428297D2C6E6F64654C6F61644368696C6472656E3A';
wwv_flow_imp.g_varchar2_table(315) := '66756E6374696F6E28742C6E297B76617220722C692C6F2C613D6E756C6C2C643D21302C633D742E747265652C753D742E6E6F64652C663D752E706172656E742C703D226E6F64654C6F61644368696C6472656E222C683D446174652E6E6F7728293B72';
wwv_flow_imp.g_varchar2_table(316) := '657475726E2053286E2926266B282153286E3D6E2E63616C6C28632C7B747970653A22736F75726365227D2C7429292C22736F757263652063616C6C6261636B206D757374206E6F742072657475726E20616E6F746865722066756E6374696F6E22292C';
wwv_flow_imp.g_varchar2_table(317) := '53286E2E7468656E293F613D6E3A6E2E75726C3F28723D652E657874656E64287B7D2C742E6F7074696F6E732E616A61782C6E29292E646562756744656C61793F28693D722E646562756744656C61792C64656C65746520722E646562756744656C6179';
wwv_flow_imp.g_varchar2_table(318) := '2C43286929262628693D695B305D2B4D6174682E72616E646F6D28292A28695B315D2D695B305D29292C752E7761726E28226E6F64654C6F61644368696C6472656E2077616974696E6720646562756744656C617920222B4D6174682E726F756E642869';
wwv_flow_imp.g_varchar2_table(319) := '292B22206D73202E2E2E22292C613D652E44656665727265642866756E6374696F6E2874297B73657454696D656F75742866756E6374696F6E28297B652E616A61782872292E646F6E652866756E6374696F6E28297B742E7265736F6C76655769746828';
wwv_flow_imp.g_varchar2_table(320) := '746869732C617267756D656E7473297D292E6661696C2866756E6374696F6E28297B742E72656A6563745769746828746869732C617267756D656E7473297D297D2C69297D29293A613D652E616A61782872293A652E6973506C61696E4F626A65637428';
wwv_flow_imp.g_varchar2_table(321) := '6E297C7C43286E293F28613D7B7468656E3A66756E6374696F6E28652C74297B65286E2C6E756C6C2C6E756C6C297D7D2C643D2131293A652E6572726F722822496E76616C696420736F7572636520747970653A20222B6E292C752E5F72657175657374';
wwv_flow_imp.g_varchar2_table(322) := '4964262628752E7761726E2822526563757273697665206C6F616420726571756573742023222B682B22207768696C652023222B752E5F7265717565737449642B222069732070656E64696E672E22292C752E5F7265717565737449643D68292C642626';
wwv_flow_imp.g_varchar2_table(323) := '28632E646562756754696D652870292C632E6E6F646553657453746174757328742C226C6F6164696E672229292C6F3D6E657720652E44656665727265642C612E7468656E2866756E6374696F6E28722C692C61297B76617220642C703B696628226A73';
wwv_flow_imp.g_varchar2_table(324) := '6F6E22213D3D6E2E64617461547970652626226A736F6E7022213D3D6E2E64617461547970657C7C22737472696E6722213D747970656F6620727C7C652E6572726F722822416A617820726571756573742072657475726E6564206120737472696E6720';
wwv_flow_imp.g_varchar2_table(325) := '2864696420796F752067657420746865204A534F4E2064617461547970652077726F6E673F292E22292C752E5F7265717565737449642626752E5F7265717565737449643E68296F2E72656A6563745769746828746869732C5B735D293B656C73652069';
wwv_flow_imp.g_varchar2_table(326) := '66286E756C6C213D3D752E706172656E747C7C6E756C6C3D3D3D66297B696628742E6F7074696F6E732E706F737450726F63657373297B7472797B28703D632E5F747269676765724E6F64654576656E742822706F737450726F63657373222C742C742E';
wwv_flow_imp.g_varchar2_table(327) := '6F726967696E616C4576656E742C7B726573706F6E73653A722C6572726F723A6E756C6C2C64617461547970653A6E2E64617461547970657D29292E6572726F722626632E7761726E2822706F737450726F636573732072657475726E6564206572726F';
wwv_flow_imp.g_varchar2_table(328) := '723A222C70297D63617463682865297B703D7B6572726F723A652C6D6573736167653A22222B652C64657461696C733A22706F737450726F63657373206661696C6564227D7D696628702E6572726F722972657475726E20643D652E6973506C61696E4F';
wwv_flow_imp.g_varchar2_table(329) := '626A65637428702E6572726F72293F702E6572726F723A7B6D6573736167653A702E6572726F727D2C643D632E5F6D616B65486F6F6B436F6E7465787428752C6E756C6C2C64292C766F6964206F2E72656A6563745769746828746869732C5B645D293B';
wwv_flow_imp.g_varchar2_table(330) := '28432870297C7C652E6973506C61696E4F626A65637428702926264328702E6368696C6472656E2929262628723D70297D656C7365207226267728722C226422292626742E6F7074696F6E732E656E61626C654173707826262834323D3D3D742E6F7074';
wwv_flow_imp.g_varchar2_table(331) := '696F6E732E656E61626C65417370782626632E7761726E28225468652064656661756C7420666F7220656E61626C65417370782077696C6C206368616E676520746F206066616C73656020696E207468652066757475747572652E20506173732060656E';
wwv_flow_imp.g_varchar2_table(332) := '61626C65417370783A207472756560206F7220696D706C656D656E7420706F737450726F6365737320746F2073696C656E63652074686973207761726E696E672E22292C723D22737472696E67223D3D747970656F6620722E643F652E70617273654A53';
wwv_flow_imp.g_varchar2_table(333) := '4F4E28722E64293A722E64293B6F2E7265736F6C76655769746828746869732C5B725D297D656C7365206F2E72656A6563745769746828746869732C5B6C5D297D2C66756E6374696F6E28652C742C6E297B76617220723D632E5F6D616B65486F6F6B43';
wwv_flow_imp.g_varchar2_table(334) := '6F6E7465787428752C6E756C6C2C7B6572726F723A652C617267733A41727261792E70726F746F747970652E736C6963652E63616C6C28617267756D656E7473292C6D6573736167653A6E2C64657461696C733A652E7374617475732B223A20222B6E7D';
wwv_flow_imp.g_varchar2_table(335) := '293B6F2E72656A6563745769746828746869732C5B725D297D292C6F2E646F6E652866756E6374696F6E286E297B76617220722C692C6F3B632E6E6F646553657453746174757328742C226F6B22292C652E6973506C61696E4F626A656374286E293F28';
wwv_flow_imp.g_varchar2_table(336) := '6B28752E6973526F6F744E6F646528292C22736F75726365206D6179206F6E6C7920626520616E206F626A65637420666F7220726F6F74206E6F6465732028657870656374696E6720616E206172726179206F66206368696C64206F626A65637473206F';
wwv_flow_imp.g_varchar2_table(337) := '74686572776973652922292C6B2843286E2E6368696C6472656E292C22696620616E206F626A6563742069732070617373656420617320736F757263652C206974206D75737420636F6E7461696E206120276368696C6472656E27206172726179202861';
wwv_flow_imp.g_varchar2_table(338) := '6C6C206F746865722070726F706572746965732061726520616464656420746F2027747265652E64617461272922292C693D6E2C723D6E2E6368696C6472656E2C64656C65746520692E6368696C6472656E2C652E6561636828792C66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(339) := '28652C74297B766F69642030213D3D695B745D262628635B745D3D695B745D2C64656C65746520695B745D297D292C652E657874656E6428632E646174612C6929293A723D6E2C6B28432872292C226578706563746564206172726179206F6620636869';
wwv_flow_imp.g_varchar2_table(340) := '6C6472656E22292C752E5F7365744368696C6472656E2872292C632E6F7074696F6E732E6E6F646174612626303D3D3D722E6C656E6774682626285328632E6F7074696F6E732E6E6F64617461293F6F3D632E6F7074696F6E732E6E6F646174612E6361';
wwv_flow_imp.g_varchar2_table(341) := '6C6C28632C7B747970653A226E6F64617461227D2C74293A21303D3D3D632E6F7074696F6E732E6E6F646174612626752E6973526F6F744E6F646528293F6F3D632E6F7074696F6E732E737472696E67732E6E6F446174613A22737472696E67223D3D74';
wwv_flow_imp.g_varchar2_table(342) := '7970656F6620632E6F7074696F6E732E6E6F646174612626752E6973526F6F744E6F646528292626286F3D632E6F7074696F6E732E6E6F64617461292C6F2626752E73657453746174757328226E6F64617461222C6F29292C632E5F747269676765724E';
wwv_flow_imp.g_varchar2_table(343) := '6F64654576656E7428226C6F61644368696C6472656E222C75297D292E6661696C2866756E6374696F6E2865297B766172206E3B65213D3D733F65213D3D6C3F28652E6E6F64652626652E6572726F722626652E6D6573736167653F6E3D653A225B6F62';
wwv_flow_imp.g_varchar2_table(344) := '6A656374204F626A6563745D223D3D3D286E3D632E5F6D616B65486F6F6B436F6E7465787428752C6E756C6C2C7B6572726F723A652C617267733A41727261792E70726F746F747970652E736C6963652E63616C6C28617267756D656E7473292C6D6573';
wwv_flow_imp.g_varchar2_table(345) := '736167653A653F652E6D6573736167657C7C652E746F537472696E6728293A22227D29292E6D6573736167652626286E2E6D6573736167653D2222292C752E7761726E28224C6F6164206368696C6472656E206661696C65642028222B6E2E6D65737361';
wwv_flow_imp.g_varchar2_table(346) := '67652B2229222C6E292C2131213D3D632E5F747269676765724E6F64654576656E7428226C6F61644572726F72222C6E2C6E756C6C292626632E6E6F646553657453746174757328742C226572726F72222C6E2E6D6573736167652C6E2E64657461696C';
wwv_flow_imp.g_varchar2_table(347) := '7329293A752E7761726E28224C617A7920706172656E74206E6F6465207761732072656D6F766564207768696C65206C6F6164696E673A2064697363617264696E6720726573706F6E73652E22293A752E7761726E282249676E6F72656420726573706F';
wwv_flow_imp.g_varchar2_table(348) := '6E736520666F72206F62736F6C657465206C6F616420726571756573742023222B682B22202865787065637465642023222B752E5F7265717565737449642B222922297D292E616C776179732866756E6374696F6E28297B752E5F726571756573744964';
wwv_flow_imp.g_varchar2_table(349) := '3D6E756C6C2C642626632E646562756754696D65456E642870297D292C6F2E70726F6D69736528297D2C6E6F64654C6F61644B6579506174683A66756E6374696F6E28652C74297B7D2C6E6F646552656D6F76654368696C643A66756E6374696F6E2874';
wwv_flow_imp.g_varchar2_table(350) := '2C6E297B76617220722C693D742E6E6F64652C6F3D652E657874656E64287B7D2C742C7B6E6F64653A6E7D292C613D692E6368696C6472656E3B696628313D3D3D612E6C656E6774682972657475726E206B286E3D3D3D615B305D2C22696E76616C6964';
wwv_flow_imp.g_varchar2_table(351) := '2073696E676C65206368696C6422292C746869732E6E6F646552656D6F76654368696C6472656E2874293B746869732E6163746976654E6F64652626286E3D3D3D746869732E6163746976654E6F64657C7C746869732E6163746976654E6F64652E6973';
wwv_flow_imp.g_varchar2_table(352) := '44657363656E64616E744F66286E29292626746869732E6163746976654E6F64652E736574416374697665282131292C746869732E666F6375734E6F64652626286E3D3D3D746869732E666F6375734E6F64657C7C746869732E666F6375734E6F64652E';
wwv_flow_imp.g_varchar2_table(353) := '697344657363656E64616E744F66286E2929262628746869732E666F6375734E6F64653D6E756C6C292C746869732E6E6F646552656D6F76654D61726B7570286F292C746869732E6E6F646552656D6F76654368696C6472656E286F292C6B2828723D65';
wwv_flow_imp.g_varchar2_table(354) := '2E696E4172726179286E2C6129293E3D302C22696E76616C6964206368696C6422292C692E747269676765724D6F646966794368696C64282272656D6F7665222C6E292C6E2E76697369742866756E6374696F6E2865297B652E706172656E743D6E756C';
wwv_flow_imp.g_varchar2_table(355) := '6C7D2C2130292C746869732E5F63616C6C486F6F6B28227472656552656769737465724E6F6465222C746869732C21312C6E292C612E73706C69636528722C31297D2C6E6F646552656D6F76654368696C644D61726B75703A66756E6374696F6E287429';
wwv_flow_imp.g_varchar2_table(356) := '7B766172206E3D742E6E6F64653B6E2E756C2626286E2E6973526F6F744E6F646528293F65286E2E756C292E656D70747928293A2865286E2E756C292E72656D6F766528292C6E2E756C3D6E756C6C292C6E2E76697369742866756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(357) := '7B652E6C693D652E756C3D6E756C6C7D29297D2C6E6F646552656D6F76654368696C6472656E3A66756E6374696F6E2865297B76617220743D652E747265652C6E3D652E6E6F64653B6E2E6368696C6472656E262628746869732E6163746976654E6F64';
wwv_flow_imp.g_varchar2_table(358) := '652626746869732E6163746976654E6F64652E697344657363656E64616E744F66286E292626746869732E6163746976654E6F64652E736574416374697665282131292C746869732E666F6375734E6F64652626746869732E666F6375734E6F64652E69';
wwv_flow_imp.g_varchar2_table(359) := '7344657363656E64616E744F66286E29262628746869732E666F6375734E6F64653D6E756C6C292C746869732E6E6F646552656D6F76654368696C644D61726B75702865292C6E2E747269676765724D6F646966794368696C64282272656D6F7665222C';
wwv_flow_imp.g_varchar2_table(360) := '6E756C6C292C6E2E76697369742866756E6374696F6E2865297B652E706172656E743D6E756C6C2C742E5F63616C6C486F6F6B28227472656552656769737465724E6F6465222C742C21312C65297D292C6E2E6C617A793F6E2E6368696C6472656E3D5B';
wwv_flow_imp.g_varchar2_table(361) := '5D3A6E2E6368696C6472656E3D6E756C6C2C6E2E6973526F6F744E6F646528297C7C286E2E657870616E6465643D2131292C746869732E6E6F646552656E646572537461747573286529297D2C6E6F646552656D6F76654D61726B75703A66756E637469';
wwv_flow_imp.g_varchar2_table(362) := '6F6E2874297B766172206E3D742E6E6F64653B6E2E6C6926262865286E2E6C69292E72656D6F766528292C6E2E6C693D6E756C6C292C746869732E6E6F646552656D6F76654368696C644D61726B75702874297D2C6E6F646552656E6465723A66756E63';
wwv_flow_imp.g_varchar2_table(363) := '74696F6E28742C6E2C722C692C6F297B76617220612C732C6C2C642C632C752C662C703D742E6E6F64652C683D742E747265652C673D742E6F7074696F6E732C793D672E617269612C763D21312C6D3D702E706172656E742C783D216D2C623D702E6368';
wwv_flow_imp.g_varchar2_table(364) := '696C6472656E2C433D6E756C6C3B6966282131213D3D682E5F656E61626C65557064617465262628787C7C6D2E756C29297B6966286B28787C7C6D2E756C2C22706172656E7420554C206D75737420657869737422292C787C7C28702E6C692626286E7C';
wwv_flow_imp.g_varchar2_table(365) := '7C702E6C692E706172656E744E6F6465213D3D702E706172656E742E756C29262628702E6C692E706172656E744E6F64653D3D3D702E706172656E742E756C3F433D702E6C692E6E6578745369626C696E673A746869732E64656275672822556E6C696E';
wwv_flow_imp.g_varchar2_table(366) := '6B696E6720222B702B2220286D757374206265206368696C64206F6620222B702E706172656E742B222922292C746869732E6E6F646552656D6F76654D61726B7570287429292C702E6C693F746869732E6E6F646552656E646572537461747573287429';
wwv_flow_imp.g_varchar2_table(367) := '3A28763D21302C702E6C693D646F63756D656E742E637265617465456C656D656E7428226C6922292C702E6C692E66746E6F64653D702C702E6B65792626672E67656E6572617465496473262628702E6C692E69643D672E69645072656669782B702E6B';
wwv_flow_imp.g_varchar2_table(368) := '6579292C702E7370616E3D646F63756D656E742E637265617465456C656D656E7428227370616E22292C702E7370616E2E636C6173734E616D653D2266616E6379747265652D6E6F6465222C79262621702E747226266528702E6C69292E617474722822';
wwv_flow_imp.g_varchar2_table(369) := '726F6C65222C22747265656974656D22292C702E6C692E617070656E644368696C6428702E7370616E292C746869732E6E6F646552656E6465725469746C652874292C672E6372656174654E6F64652626672E6372656174654E6F64652E63616C6C2868';
wwv_flow_imp.g_varchar2_table(370) := '2C7B747970653A226372656174654E6F6465227D2C7429292C672E72656E6465724E6F64652626672E72656E6465724E6F64652E63616C6C28682C7B747970653A2272656E6465724E6F6465227D2C7429292C62297B696628787C7C702E657870616E64';
wwv_flow_imp.g_varchar2_table(371) := '65647C7C21303D3D3D72297B666F7228702E756C7C7C28702E756C3D646F63756D656E742E637265617465456C656D656E742822756C22292C282130213D3D697C7C6F292626702E657870616E6465647C7C28702E756C2E7374796C652E646973706C61';
wwv_flow_imp.g_varchar2_table(372) := '793D226E6F6E6522292C7926266528702E756C292E617474722822726F6C65222C2267726F757022292C702E6C693F702E6C692E617070656E644368696C6428702E756C293A702E747265652E246469762E617070656E6428702E756C29292C643D302C';
wwv_flow_imp.g_varchar2_table(373) := '633D622E6C656E6774683B643C633B642B2B29663D652E657874656E64287B7D2C742C7B6E6F64653A625B645D7D292C746869732E6E6F646552656E64657228662C6E2C722C21312C2130293B666F7228613D702E756C2E66697273744368696C643B61';
wwv_flow_imp.g_varchar2_table(374) := '3B29286C3D612E66746E6F64652926266C2E706172656E74213D3D703F28702E646562756728225F666978506172656E743A2072656D6F7665206D697373696E6720222B6C2C61292C753D612E6E6578745369626C696E672C612E706172656E744E6F64';
wwv_flow_imp.g_varchar2_table(375) := '652E72656D6F76654368696C642861292C613D75293A613D612E6E6578745369626C696E673B666F7228613D702E756C2E66697273744368696C642C643D302C633D622E6C656E6774682D313B643C633B642B2B2928733D625B645D293D3D3D286C3D61';
wwv_flow_imp.g_varchar2_table(376) := '2E66746E6F6465293F613D612E6E6578745369626C696E673A702E756C2E696E736572744265666F726528732E6C692C6C2E6C69297D7D656C736520702E756C262628746869732E7761726E282272656D6F7665206368696C64206D61726B757020666F';
wwv_flow_imp.g_varchar2_table(377) := '7220222B70292C746869732E6E6F646552656D6F76654368696C644D61726B7570287429293B787C7C7626266D2E756C2E696E736572744265666F726528702E6C692C43297D7D2C6E6F646552656E6465725469746C653A66756E6374696F6E28742C6E';
wwv_flow_imp.g_varchar2_table(378) := '297B766172206F2C612C732C6C2C642C632C752C663D742E6E6F64652C703D742E747265652C683D742E6F7074696F6E732C673D682E617269612C793D662E6765744C6576656C28292C763D5B5D3B766F69642030213D3D6E262628662E7469746C653D';
wwv_flow_imp.g_varchar2_table(379) := '6E292C662E7370616E26262131213D3D702E5F656E61626C65557064617465262628643D6726262131213D3D662E6861734368696C6472656E28293F2220726F6C653D27627574746F6E27223A22222C793C682E6D696E457870616E644C6576656C3F28';
wwv_flow_imp.g_varchar2_table(380) := '662E6C617A797C7C28662E657870616E6465643D2130292C793E312626762E7075736828223C7370616E20222B642B2220636C6173733D2766616E6379747265652D657870616E6465722066616E6379747265652D657870616E6465722D666978656427';
wwv_flow_imp.g_varchar2_table(381) := '3E3C2F7370616E3E2229293A762E7075736828223C7370616E20222B642B2220636C6173733D2766616E6379747265652D657870616E646572273E3C2F7370616E3E22292C286F3D722E6576616C4F7074696F6E2822636865636B626F78222C662C662C';
wwv_flow_imp.g_varchar2_table(382) := '682C21312929262621662E69735374617475734E6F64652829262628643D673F2220726F6C653D27636865636B626F7827223A22222C613D2266616E6379747265652D636865636B626F78222C2822726164696F223D3D3D6F7C7C662E706172656E7426';
wwv_flow_imp.g_varchar2_table(383) := '26662E706172656E742E726164696F67726F757029262628612B3D222066616E6379747265652D726164696F22292C762E7075736828223C7370616E20222B642B2220636C6173733D27222B612B22273E3C2F7370616E3E2229292C766F69642030213D';
wwv_flow_imp.g_varchar2_table(384) := '3D662E646174612E69636F6E436C617373262628662E69636F6E3F652E6572726F7228222769636F6E436C61737327206E6F6465206F7074696F6E20697320646570726563617465642073696E63652076322E31342E303A20757365202769636F6E2720';
wwv_flow_imp.g_varchar2_table(385) := '6F6E6C7920696E737465616422293A28662E7761726E28222769636F6E436C61737327206E6F6465206F7074696F6E20697320646570726563617465642073696E63652076322E31342E303A20757365202769636F6E2720696E737465616422292C662E';
wwv_flow_imp.g_varchar2_table(386) := '69636F6E3D662E646174612E69636F6E436C61737329292C2131213D3D28733D722E6576616C4F7074696F6E282269636F6E222C662C662C682C21302929262628643D673F2220726F6C653D2770726573656E746174696F6E27223A22222C753D28753D';
wwv_flow_imp.g_varchar2_table(387) := '722E6576616C4F7074696F6E282269636F6E546F6F6C746970222C662C662C682C6E756C6C29293F22207469746C653D27222B6A2875292B2227223A22222C22737472696E67223D3D747970656F6620733F692E746573742873293F28733D222F223D3D';
wwv_flow_imp.g_varchar2_table(388) := '3D732E6368617241742830293F733A28682E696D616765506174687C7C2222292B732C762E7075736828223C696D67207372633D27222B732B222720636C6173733D2766616E6379747265652D69636F6E27222B752B2220616C743D2727202F3E222929';
wwv_flow_imp.g_varchar2_table(389) := '3A762E7075736828223C7370616E20222B642B2220636C6173733D2766616E6379747265652D637573746F6D2D69636F6E20222B732B2227222B752B223E3C2F7370616E3E22293A732E746578743F762E7075736828223C7370616E20222B642B222063';
wwv_flow_imp.g_varchar2_table(390) := '6C6173733D2766616E6379747265652D637573746F6D2D69636F6E20222B28732E616464436C6173737C7C2222292B2227222B752B223E222B722E65736361706548746D6C28732E74657874292B223C2F7370616E3E22293A732E68746D6C3F762E7075';
wwv_flow_imp.g_varchar2_table(391) := '736828223C7370616E20222B642B2220636C6173733D2766616E6379747265652D637573746F6D2D69636F6E20222B28732E616464436C6173737C7C2222292B2227222B752B223E222B732E68746D6C2B223C2F7370616E3E22293A762E707573682822';
wwv_flow_imp.g_varchar2_table(392) := '3C7370616E20222B642B2220636C6173733D2766616E6379747265652D69636F6E27222B752B223E3C2F7370616E3E2229292C6C3D22222C682E72656E6465725469746C652626286C3D682E72656E6465725469746C652E63616C6C28702C7B74797065';
wwv_flow_imp.g_varchar2_table(393) := '3A2272656E6465725469746C65227D2C74297C7C2222292C6C7C7C2821303D3D3D28633D722E6576616C4F7074696F6E2822746F6F6C746970222C662C662C682C6E756C6C2929262628633D662E7469746C65292C6C3D223C7370616E20636C6173733D';
wwv_flow_imp.g_varchar2_table(394) := '2766616E6379747265652D7469746C6527222B28633D633F22207469746C653D27222B6A2863292B2227223A2222292B28682E7469746C65735461626261626C653F2220746162696E6465783D273027223A2222292B223E222B28682E65736361706554';
wwv_flow_imp.g_varchar2_table(395) := '69746C65733F722E65736361706548746D6C28662E7469746C65293A662E7469746C65292B223C2F7370616E3E22292C762E70757368286C292C662E7370616E2E696E6E657248544D4C3D762E6A6F696E282222292C746869732E6E6F646552656E6465';
wwv_flow_imp.g_varchar2_table(396) := '725374617475732874292C682E656E68616E63655469746C65262628742E247469746C653D6528223E7370616E2E66616E6379747265652D7469746C65222C662E7370616E292C6C3D682E656E68616E63655469746C652E63616C6C28702C7B74797065';
wwv_flow_imp.g_varchar2_table(397) := '3A22656E68616E63655469746C65227D2C74297C7C222229297D2C6E6F646552656E6465725374617475733A66756E6374696F6E2874297B766172206E2C693D742E6E6F64652C6F3D742E747265652C613D742E6F7074696F6E732C733D692E68617343';
wwv_flow_imp.g_varchar2_table(398) := '68696C6472656E28292C6C3D692E69734C6173745369626C696E6728292C643D612E617269612C633D612E5F636C6173734E616D65732C753D5B5D2C663D695B6F2E737461747573436C61737350726F704E616D655D3B6626262131213D3D6F2E5F656E';
wwv_flow_imp.g_varchar2_table(399) := '61626C65557064617465262628642626303D3D3D286E3D6528692E74727C7C692E6C6929292E6C656E6774682626286E3D6E756C6C292C752E7075736828632E6E6F6465292C6F2E6163746976654E6F64653D3D3D692626752E7075736828632E616374';
wwv_flow_imp.g_varchar2_table(400) := '697665292C6F2E666F6375734E6F64653D3D3D692626752E7075736828632E666F6375736564292C692E657870616E6465642626752E7075736828632E657870616E646564292C6426266E26262821313D3D3D733F6E2E72656D6F766541747472282261';
wwv_flow_imp.g_varchar2_table(401) := '7269612D657870616E64656422293A6E2E617474722822617269612D657870616E646564222C426F6F6C65616E28692E657870616E6465642929292C692E666F6C6465722626752E7075736828632E666F6C646572292C2131213D3D732626752E707573';
wwv_flow_imp.g_varchar2_table(402) := '6828632E6861734368696C6472656E292C6C2626752E7075736828632E6C617374736962292C692E6C617A7926266E756C6C3D3D692E6368696C6472656E2626752E7075736828632E6C617A79292C692E706172746C6F61642626752E7075736828632E';
wwv_flow_imp.g_varchar2_table(403) := '706172746C6F6164292C692E7061727473656C2626752E7075736828632E7061727473656C292C722E6576616C4F7074696F6E2822756E73656C65637461626C65222C692C692C612C2131292626752E7075736828632E756E73656C65637461626C6529';
wwv_flow_imp.g_varchar2_table(404) := '2C692E5F69734C6F6164696E672626752E7075736828632E6C6F6164696E67292C692E5F6572726F722626752E7075736828632E6572726F72292C692E7374617475734E6F6465547970652626752E7075736828632E7374617475734E6F646550726566';
wwv_flow_imp.g_varchar2_table(405) := '69782B692E7374617475734E6F646554797065292C692E73656C65637465643F28752E7075736828632E73656C6563746564292C6426266E26266E2E617474722822617269612D73656C6563746564222C213029293A6426266E26266E2E617474722822';
wwv_flow_imp.g_varchar2_table(406) := '617269612D73656C6563746564222C2131292C692E6578747261436C61737365732626752E7075736828692E6578747261436C6173736573292C21313D3D3D733F752E7075736828632E636F6D62696E6564457870616E6465725072656669782B226E22';
wwv_flow_imp.g_varchar2_table(407) := '2B286C3F226C223A222229293A752E7075736828632E636F6D62696E6564457870616E6465725072656669782B28692E657870616E6465643F2265223A226322292B28692E6C617A7926266E756C6C3D3D692E6368696C6472656E3F2264223A2222292B';
wwv_flow_imp.g_varchar2_table(408) := '286C3F226C223A222229292C752E7075736828632E636F6D62696E656449636F6E5072656669782B28692E657870616E6465643F2265223A226322292B28692E666F6C6465723F2266223A222229292C662E636C6173734E616D653D752E6A6F696E2822';
wwv_flow_imp.g_varchar2_table(409) := '2022292C692E6C6926266528692E6C69292E746F67676C65436C61737328632E6C6173747369622C6C29297D2C6E6F64655365744163746976653A66756E6374696F6E28742C6E2C72297B723D727C7C7B7D3B76617220692C6F3D742E6E6F64652C613D';
wwv_flow_imp.g_varchar2_table(410) := '742E747265652C733D742E6F7074696F6E732C6C3D21303D3D3D722E6E6F4576656E74732C643D21303D3D3D722E6E6F466F6375732C633D2131213D3D722E7363726F6C6C496E746F566965773B72657475726E206F3D3D3D612E6163746976654E6F64';
wwv_flow_imp.g_varchar2_table(411) := '653D3D3D286E3D2131213D3D6E293F54286F293A28632626742E6F726967696E616C4576656E7426266528742E6F726967696E616C4576656E742E746172676574292E69732822612C3A636865636B626F7822292626286F2E696E666F28224E6F742073';
wwv_flow_imp.g_varchar2_table(412) := '63726F6C6C696E67207768696C6520636C69636B696E6720616E20656D626564646564206C696E6B2E22292C633D2131292C6E2626216C262621313D3D3D746869732E5F747269676765724E6F64654576656E7428226265666F72654163746976617465';
wwv_flow_imp.g_varchar2_table(413) := '222C6F2C742E6F726967696E616C4576656E74293F4D286F2C5B2272656A6563746564225D293A286E3F28612E6163746976654E6F64652626286B28612E6163746976654E6F6465213D3D6F2C226E6F646520776173206163746976652028696E636F6E';
wwv_flow_imp.g_varchar2_table(414) := '73697374656E63792922292C693D652E657874656E64287B7D2C742C7B6E6F64653A612E6163746976654E6F64657D292C612E6E6F646553657441637469766528692C2131292C6B286E756C6C3D3D3D612E6163746976654E6F64652C22646561637469';
wwv_flow_imp.g_varchar2_table(415) := '7661746520776173206F7574206F662073796E633F2229292C732E61637469766556697369626C6526266F2E6D616B6556697369626C65287B7363726F6C6C496E746F566965773A637D292C612E6163746976654E6F64653D6F2C612E6E6F646552656E';
wwv_flow_imp.g_varchar2_table(416) := '6465725374617475732874292C647C7C612E6E6F6465536574466F6375732874292C6C7C7C612E5F747269676765724E6F64654576656E7428226163746976617465222C6F2C742E6F726967696E616C4576656E7429293A286B28612E6163746976654E';
wwv_flow_imp.g_varchar2_table(417) := '6F64653D3D3D6F2C226E6F646520776173206E6F74206163746976652028696E636F6E73697374656E63792922292C612E6163746976654E6F64653D6E756C6C2C746869732E6E6F646552656E6465725374617475732874292C6C7C7C742E747265652E';
wwv_flow_imp.g_varchar2_table(418) := '5F747269676765724E6F64654576656E74282264656163746976617465222C6F2C742E6F726967696E616C4576656E7429292C54286F2929297D2C6E6F6465536574457870616E6465643A66756E6374696F6E28742C6E2C72297B723D727C7C7B7D3B76';
wwv_flow_imp.g_varchar2_table(419) := '617220692C6F2C612C732C6C2C642C633D742E6E6F64652C753D742E747265652C663D742E6F7074696F6E732C703D21303D3D3D722E6E6F416E696D6174696F6E2C683D21303D3D3D722E6E6F4576656E74733B6966286E3D2131213D3D6E2C6528632E';
wwv_flow_imp.g_varchar2_table(420) := '6C69292E686173436C61737328662E5F636C6173734E616D65732E616E696D6174696E67292972657475726E20632E7761726E2822736574457870616E64656428222B6E2B2229207768696C6520616E696D6174696E673A2069676E6F7265642E22292C';
wwv_flow_imp.g_varchar2_table(421) := '4D28632C5B22726563757273696F6E225D293B696628632E657870616E64656426266E7C7C21632E657870616E6465642626216E2972657475726E20542863293B6966286E262621632E6C617A79262621632E6861734368696C6472656E282929726574';
wwv_flow_imp.g_varchar2_table(422) := '75726E20542863293B696628216E2626632E6765744C6576656C28293C662E6D696E457870616E644C6576656C2972657475726E204D28632C5B226C6F636B6564225D293B6966282168262621313D3D3D746869732E5F747269676765724E6F64654576';
wwv_flow_imp.g_varchar2_table(423) := '656E7428226265666F7265457870616E64222C632C742E6F726967696E616C4576656E74292972657475726E204D28632C5B2272656A6563746564225D293B696628707C7C632E697356697369626C6528297C7C28703D722E6E6F416E696D6174696F6E';
wwv_flow_imp.g_varchar2_table(424) := '3D2130292C6F3D6E657720652E44656665727265642C6E262621632E657870616E6465642626662E6175746F436F6C6C61707365297B6C3D632E676574506172656E744C6973742821312C2130292C643D662E6175746F436F6C6C617073653B7472797B';
wwv_flow_imp.g_varchar2_table(425) := '666F7228662E6175746F436F6C6C617073653D21312C613D302C733D6C2E6C656E6774683B613C733B612B2B29746869732E5F63616C6C486F6F6B28226E6F6465436F6C6C617073655369626C696E6773222C6C5B615D2C72297D66696E616C6C797B66';
wwv_flow_imp.g_varchar2_table(426) := '2E6175746F436F6C6C617073653D647D7D72657475726E206F2E646F6E652866756E6374696F6E28297B76617220653D632E6765744C6173744368696C6428293B6E2626662E6175746F5363726F6C6C262621702626652626752E5F656E61626C655570';
wwv_flow_imp.g_varchar2_table(427) := '646174653F652E7363726F6C6C496E746F566965772821302C7B746F704E6F64653A637D292E616C776179732866756E6374696F6E28297B687C7C742E747265652E5F747269676765724E6F64654576656E74286E3F22657870616E64223A22636F6C6C';
wwv_flow_imp.g_varchar2_table(428) := '61707365222C74297D293A687C7C742E747265652E5F747269676765724E6F64654576656E74286E3F22657870616E64223A22636F6C6C61707365222C74297D292C693D66756E6374696F6E2872297B76617220693D662E5F636C6173734E616D65732C';
wwv_flow_imp.g_varchar2_table(429) := '6F3D662E746F67676C654566666563743B696628632E657870616E6465643D6E2C752E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C742C6E3F22657870616E64223A22636F6C6C6170736522292C752E5F63616C6C';
wwv_flow_imp.g_varchar2_table(430) := '486F6F6B28226E6F646552656E646572222C742C21312C21312C2130292C632E756C29696628226E6F6E6522213D3D632E756C2E7374796C652E646973706C61793D3D3D2121632E657870616E64656429632E7761726E28226E6F646553657445787061';
wwv_flow_imp.g_varchar2_table(431) := '6E6465643A20554C2E7374796C652E646973706C617920616C72656164792073657422293B656C73657B6966286F262621702972657475726E206528632E6C69292E616464436C61737328692E616E696D6174696E67292C766F69642853286528632E75';
wwv_flow_imp.g_varchar2_table(432) := '6C295B6F2E6566666563745D293F6528632E756C295B6F2E6566666563745D287B6475726174696F6E3A6F2E6475726174696F6E2C616C776179733A66756E6374696F6E28297B652874686973292E72656D6F7665436C61737328692E616E696D617469';
wwv_flow_imp.g_varchar2_table(433) := '6E67292C6528632E6C69292E72656D6F7665436C61737328692E616E696D6174696E67292C7228297D7D293A286528632E756C292E73746F702821302C2130292C6528632E756C292E706172656E7428292E66696E6428222E75692D656666656374732D';
wwv_flow_imp.g_varchar2_table(434) := '706C616365686F6C64657222292E72656D6F766528292C6528632E756C292E746F67676C65286F2E6566666563742C6F2E6F7074696F6E732C6F2E6475726174696F6E2C66756E6374696F6E28297B652874686973292E72656D6F7665436C6173732869';
wwv_flow_imp.g_varchar2_table(435) := '2E616E696D6174696E67292C6528632E6C69292E72656D6F7665436C61737328692E616E696D6174696E67292C7228297D2929293B632E756C2E7374796C652E646973706C61793D632E657870616E6465647C7C21706172656E743F22223A226E6F6E65';
wwv_flow_imp.g_varchar2_table(436) := '227D7228297D2C6E2626632E6C617A792626766F696420303D3D3D632E6861734368696C6472656E28293F632E6C6F616428292E646F6E652866756E6374696F6E28297B6F2E6E6F746966795769746826266F2E6E6F746966795769746828632C5B226C';
wwv_flow_imp.g_varchar2_table(437) := '6F61646564225D292C692866756E6374696F6E28297B6F2E7265736F6C7665576974682863297D297D292E6661696C2866756E6374696F6E2865297B692866756E6374696F6E28297B6F2E72656A6563745769746828632C5B226C6F6164206661696C65';
wwv_flow_imp.g_varchar2_table(438) := '642028222B652B2229225D297D297D293A692866756E6374696F6E28297B6F2E7265736F6C7665576974682863297D292C6F2E70726F6D69736528297D2C6E6F6465536574466F6375733A66756E6374696F6E28742C6E297B76617220722C693D742E74';
wwv_flow_imp.g_varchar2_table(439) := '7265652C6F3D742E6E6F64652C613D692E6F7074696F6E732C733D2121742E6F726967696E616C4576656E7426266528742E6F726967696E616C4576656E742E746172676574292E697328223A696E70757422293B6966286E3D2131213D3D6E2C692E66';
wwv_flow_imp.g_varchar2_table(440) := '6F6375734E6F6465297B696628692E666F6375734E6F64653D3D3D6F26266E2972657475726E3B723D652E657874656E64287B7D2C742C7B6E6F64653A692E666F6375734E6F64657D292C692E666F6375734E6F64653D6E756C6C2C746869732E5F7472';
wwv_flow_imp.g_varchar2_table(441) := '69676765724E6F64654576656E742822626C7572222C72292C746869732E5F63616C6C486F6F6B28226E6F646552656E646572537461747573222C72297D6966286E297B696628746869732E686173466F63757328297C7C286F2E646562756728226E6F';
wwv_flow_imp.g_varchar2_table(442) := '6465536574466F6375733A20666F7263696E6720636F6E7461696E657220666F63757322292C746869732E5F63616C6C486F6F6B282274726565536574466F637573222C742C21302C7B63616C6C656442794E6F64653A21307D29292C6F2E6D616B6556';
wwv_flow_imp.g_varchar2_table(443) := '697369626C65287B7363726F6C6C496E746F566965773A21317D292C692E666F6375734E6F64653D6F2C612E7469746C65735461626261626C65262628737C7C65286F2E7370616E292E66696E6428222E66616E6379747265652D7469746C6522292E74';
wwv_flow_imp.g_varchar2_table(444) := '7269676765722822666F6375732229292C612E61726961297B766172206C3D65286F2E74727C7C6F2E6C69293B6C2E6C656E6774683E3026266528692E24636F6E7461696E6572292E617474722822617269612D61637469766564657363656E64616E74';
wwv_flow_imp.g_varchar2_table(445) := '222C6C2E756E69717565496428292E61747472282269642229297D746869732E5F747269676765724E6F64654576656E742822666F637573222C74292C646F63756D656E742E616374697665456C656D656E743D3D3D692E24636F6E7461696E65722E67';
wwv_flow_imp.g_varchar2_table(446) := '65742830297C7C6528646F63756D656E742E616374697665456C656D656E742C692E24636F6E7461696E6572292E6C656E6774683E3D317C7C6528692E24636F6E7461696E6572292E747269676765722822666F63757322292C612E6175746F5363726F';
wwv_flow_imp.g_varchar2_table(447) := '6C6C26266F2E7363726F6C6C496E746F5669657728292C746869732E5F63616C6C486F6F6B28226E6F646552656E646572537461747573222C74297D7D2C6E6F646553657453656C65637465643A66756E6374696F6E28652C742C6E297B6E3D6E7C7C7B';
wwv_flow_imp.g_varchar2_table(448) := '7D3B76617220693D652E6E6F64652C6F3D652E747265652C613D652E6F7074696F6E732C733D21303D3D3D6E2E6E6F4576656E74732C6C3D692E706172656E743B696628743D2131213D3D742C21722E6576616C4F7074696F6E2822756E73656C656374';
wwv_flow_imp.g_varchar2_table(449) := '61626C65222C692C692C612C213129297B696628692E5F6C61737453656C656374496E74656E743D742C2121692E73656C65637465643D3D3D7426262833213D3D612E73656C6563744D6F64657C7C21692E7061727473656C7C7C74292972657475726E';
wwv_flow_imp.g_varchar2_table(450) := '20743B6966282173262621313D3D3D746869732E5F747269676765724E6F64654576656E7428226265666F726553656C656374222C692C652E6F726967696E616C4576656E74292972657475726E2121692E73656C65637465643B742626313D3D3D612E';
wwv_flow_imp.g_varchar2_table(451) := '73656C6563744D6F64653F286F2E6C61737453656C65637465644E6F646526266F2E6C61737453656C65637465644E6F64652E73657453656C6563746564282131292C692E73656C65637465643D74293A33213D3D612E73656C6563744D6F64657C7C21';
wwv_flow_imp.g_varchar2_table(452) := '6C7C7C6C2E726164696F67726F75707C7C692E726164696F67726F75703F6C26266C2E726164696F67726F75703F692E76697369745369626C696E67732866756E6374696F6E2865297B652E5F6368616E676553656C6563745374617475734174747273';
wwv_flow_imp.g_varchar2_table(453) := '28742626653D3D3D69297D2C2130293A692E73656C65637465643D743A28692E73656C65637465643D742C692E66697853656C656374696F6E334166746572436C69636B286E29292C746869732E6E6F646552656E6465725374617475732865292C6F2E';
wwv_flow_imp.g_varchar2_table(454) := '6C61737453656C65637465644E6F64653D743F693A6E756C6C2C737C7C6F2E5F747269676765724E6F64654576656E74282273656C656374222C65297D7D2C6E6F64655365745374617475733A66756E6374696F6E28742C6E2C722C69297B766172206F';
wwv_flow_imp.g_varchar2_table(455) := '3D742E6E6F64652C613D742E747265653B66756E6374696F6E2073286E2C72297B76617220693D6F2E6368696C6472656E3F6F2E6368696C6472656E5B305D3A6E756C6C3B72657475726E20692626692E69735374617475734E6F646528293F28652E65';
wwv_flow_imp.g_varchar2_table(456) := '7874656E6428692C6E292C692E7374617475734E6F6465547970653D722C612E5F63616C6C486F6F6B28226E6F646552656E6465725469746C65222C6929293A286F2E5F7365744368696C6472656E285B6E5D292C612E5F63616C6C486F6F6B28227472';
wwv_flow_imp.g_varchar2_table(457) := '65655374727563747572654368616E676564222C742C227365745374617475734E6F646522292C6F2E6368696C6472656E5B305D2E7374617475734E6F6465547970653D722C612E72656E6465722829292C6F2E6368696C6472656E5B305D7D73776974';
wwv_flow_imp.g_varchar2_table(458) := '6368286E297B63617365226F6B223A2166756E6374696F6E28297B76617220653D6F2E6368696C6472656E3F6F2E6368696C6472656E5B305D3A6E756C6C3B696628652626652E69735374617475734E6F64652829297B7472797B6F2E756C2626286F2E';
wwv_flow_imp.g_varchar2_table(459) := '756C2E72656D6F76654368696C6428652E6C69292C652E6C693D6E756C6C297D63617463682865297B7D313D3D3D6F2E6368696C6472656E2E6C656E6774683F6F2E6368696C6472656E3D5B5D3A6F2E6368696C6472656E2E736869667428292C612E5F';
wwv_flow_imp.g_varchar2_table(460) := '63616C6C486F6F6B2822747265655374727563747572654368616E676564222C742C22636C6561725374617475734E6F646522297D7D28292C6F2E5F69734C6F6164696E673D21312C6F2E5F6572726F723D6E756C6C2C6F2E72656E6465725374617475';
wwv_flow_imp.g_varchar2_table(461) := '7328293B627265616B3B63617365226C6F6164696E67223A6F2E706172656E747C7C73287B7469746C653A612E6F7074696F6E732E737472696E67732E6C6F6164696E672B28723F222028222B722B2229223A2222292C636865636B626F783A21312C74';
wwv_flow_imp.g_varchar2_table(462) := '6F6F6C7469703A697D2C6E292C6F2E5F69734C6F6164696E673D21302C6F2E5F6572726F723D6E756C6C2C6F2E72656E64657253746174757328293B627265616B3B63617365226572726F72223A73287B7469746C653A612E6F7074696F6E732E737472';
wwv_flow_imp.g_varchar2_table(463) := '696E67732E6C6F61644572726F722B28723F222028222B722B2229223A2222292C636865636B626F783A21312C746F6F6C7469703A697D2C6E292C6F2E5F69734C6F6164696E673D21312C6F2E5F6572726F723D7B6D6573736167653A722C6465746169';
wwv_flow_imp.g_varchar2_table(464) := '6C733A697D2C6F2E72656E64657253746174757328293B627265616B3B63617365226E6F64617461223A73287B7469746C653A727C7C612E6F7074696F6E732E737472696E67732E6E6F446174612C636865636B626F783A21312C746F6F6C7469703A69';
wwv_flow_imp.g_varchar2_table(465) := '7D2C6E292C6F2E5F69734C6F6164696E673D21312C6F2E5F6572726F723D6E756C6C2C6F2E72656E64657253746174757328293B627265616B3B64656661756C743A652E6572726F722822696E76616C6964206E6F64652073746174757320222B6E297D';
wwv_flow_imp.g_varchar2_table(466) := '7D2C6E6F6465546F67676C65457870616E6465643A66756E6374696F6E2865297B72657475726E20746869732E6E6F6465536574457870616E64656428652C21652E6E6F64652E657870616E646564297D2C6E6F6465546F67676C6553656C6563746564';
wwv_flow_imp.g_varchar2_table(467) := '3A66756E6374696F6E2865297B76617220743D652E6E6F64652C6E3D21742E73656C65637465643B72657475726E20742E7061727473656C262621742E73656C6563746564262621303D3D3D742E5F6C61737453656C656374496E74656E742626286E3D';
wwv_flow_imp.g_varchar2_table(468) := '21312C742E73656C65637465643D2130292C742E5F6C61737453656C656374496E74656E743D6E2C746869732E6E6F646553657453656C656374656428652C6E297D2C74726565436C6561723A66756E6374696F6E2865297B76617220743D652E747265';
wwv_flow_imp.g_varchar2_table(469) := '653B742E6163746976654E6F64653D6E756C6C2C742E666F6375734E6F64653D6E756C6C2C742E246469762E66696E6428223E756C2E66616E6379747265652D636F6E7461696E657222292E656D70747928292C742E726F6F744E6F64652E6368696C64';
wwv_flow_imp.g_varchar2_table(470) := '72656E3D6E756C6C2C742E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C652C22636C65617222297D2C747265654372656174653A66756E6374696F6E2865297B7D2C7472656544657374726F793A66756E6374696F';
wwv_flow_imp.g_varchar2_table(471) := '6E2865297B746869732E246469762E66696E6428223E756C2E66616E6379747265652D636F6E7461696E657222292E72656D6F766528292C746869732E24736F757263652626746869732E24736F757263652E72656D6F7665436C617373282266616E63';
wwv_flow_imp.g_varchar2_table(472) := '79747265652D68656C7065722D68696464656E22297D2C74726565496E69743A66756E6374696F6E2874297B766172206E3D742E747265652C723D6E2E6F7074696F6E733B6E2E24636F6E7461696E65722E617474722822746162696E646578222C722E';
wwv_flow_imp.g_varchar2_table(473) := '746162696E646578292C652E6561636828792C66756E6374696F6E28652C74297B766F69642030213D3D725B745D2626286E2E696E666F28224D6F7665206F7074696F6E20222B742B2220746F207472656522292C6E5B745D3D725B745D2C64656C6574';
wwv_flow_imp.g_varchar2_table(474) := '6520725B745D297D292C722E636865636B626F784175746F4869646526266E2E24636F6E7461696E65722E616464436C617373282266616E6379747265652D636865636B626F782D6175746F2D6869646522292C722E72746C3F6E2E24636F6E7461696E';
wwv_flow_imp.g_varchar2_table(475) := '65722E617474722822444952222C2252544C22292E616464436C617373282266616E6379747265652D72746C22293A6E2E24636F6E7461696E65722E72656D6F766541747472282244495222292E72656D6F7665436C617373282266616E637974726565';
wwv_flow_imp.g_varchar2_table(476) := '2D72746C22292C722E617269612626286E2E24636F6E7461696E65722E617474722822726F6C65222C227472656522292C31213D3D722E73656C6563744D6F646526266E2E24636F6E7461696E65722E617474722822617269612D6D756C746973656C65';
wwv_flow_imp.g_varchar2_table(477) := '637461626C65222C213029292C746869732E747265654C6F61642874297D2C747265654C6F61643A66756E6374696F6E28742C6E297B76617220692C6F2C612C733D742E747265652C6C3D742E7769646765742E656C656D656E742C643D652E65787465';
wwv_flow_imp.g_varchar2_table(478) := '6E64287B7D2C742C7B6E6F64653A746869732E726F6F744E6F64657D293B696628732E726F6F744E6F64652E6368696C6472656E2626746869732E74726565436C6561722874292C6E3D6E7C7C746869732E6F7074696F6E732E736F7572636529227374';
wwv_flow_imp.g_varchar2_table(479) := '72696E67223D3D747970656F66206E2626652E6572726F7228224E6F7420696D706C656D656E74656422293B656C736520737769746368286F3D6C2E6461746128227479706522297C7C2268746D6C22297B636173652268746D6C223A28613D6C2E6669';
wwv_flow_imp.g_varchar2_table(480) := '6E6428223E756C22292E6E6F7428222E66616E6379747265652D636F6E7461696E657222292E66697273742829292E6C656E6774683F28612E616464436C617373282275692D66616E6379747265652D736F757263652066616E6379747265652D68656C';
wwv_flow_imp.g_varchar2_table(481) := '7065722D68696464656E22292C6E3D652E75692E66616E6379747265652E706172736548746D6C2861292C746869732E646174613D652E657874656E6428746869732E646174612C4928612929293A28722E7761726E28224E6F2060736F757263656020';
wwv_flow_imp.g_varchar2_table(482) := '6F7074696F6E207761732070617373656420616E6420636F6E7461696E657220646F6573206E6F7420636F6E7461696E20603C756C3E603A20617373756D696E672060736F757263653A205B5D602E22292C6E3D5B5D293B627265616B3B63617365226A';
wwv_flow_imp.g_varchar2_table(483) := '736F6E223A6E3D652E70617273654A534F4E286C2E746578742829292C6C2E636F6E74656E747328292E66696C7465722866756E6374696F6E28297B72657475726E20333D3D3D746869732E6E6F6465547970657D292E72656D6F766528292C652E6973';
wwv_flow_imp.g_varchar2_table(484) := '506C61696E4F626A656374286E292626286B2843286E2E6368696C6472656E292C22696620616E206F626A6563742069732070617373656420617320736F757263652C206974206D75737420636F6E7461696E206120276368696C6472656E2720617272';
wwv_flow_imp.g_varchar2_table(485) := '61792028616C6C206F746865722070726F706572746965732061726520616464656420746F2027747265652E64617461272922292C693D6E2C6E3D6E2E6368696C6472656E2C64656C65746520692E6368696C6472656E2C652E6561636828792C66756E';
wwv_flow_imp.g_varchar2_table(486) := '6374696F6E28652C74297B766F69642030213D3D695B745D262628735B745D3D695B745D2C64656C65746520695B745D297D292C652E657874656E6428732E646174612C6929293B627265616B3B64656661756C743A652E6572726F722822496E76616C';
wwv_flow_imp.g_varchar2_table(487) := '696420646174612D747970653A20222B6F297D72657475726E20732E5F74726967676572547265654576656E742822707265496E6974222C6E756C6C292C746869732E6E6F64654C6F61644368696C6472656E28642C6E292E646F6E652866756E637469';
wwv_flow_imp.g_varchar2_table(488) := '6F6E28297B732E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C742C226C6F61644368696C6472656E22292C732E72656E64657228292C333D3D3D742E6F7074696F6E732E73656C6563744D6F64652626732E726F6F';
wwv_flow_imp.g_varchar2_table(489) := '744E6F64652E66697853656C656374696F6E3346726F6D456E644E6F64657328292C732E6163746976654E6F64652626732E6F7074696F6E732E61637469766556697369626C652626732E6163746976654E6F64652E6D616B6556697369626C6528292C';
wwv_flow_imp.g_varchar2_table(490) := '732E5F74726967676572547265654576656E742822696E6974222C6E756C6C2C7B7374617475733A21307D297D292E6661696C2866756E6374696F6E28297B732E72656E64657228292C732E5F74726967676572547265654576656E742822696E697422';
wwv_flow_imp.g_varchar2_table(491) := '2C6E756C6C2C7B7374617475733A21317D297D297D2C7472656552656769737465724E6F64653A66756E6374696F6E28652C742C6E297B652E747265652E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C652C743F22';
wwv_flow_imp.g_varchar2_table(492) := '6164644E6F6465223A2272656D6F76654E6F646522297D2C74726565536574466F6375733A66756E6374696F6E28742C6E2C72297B76617220693B286E3D2131213D3D6E29213D3D746869732E686173466F6375732829262628746869732E5F68617346';
wwv_flow_imp.g_varchar2_table(493) := '6F6375733D6E2C216E2626746869732E666F6375734E6F64653F746869732E666F6375734E6F64652E736574466F637573282131293A216E7C7C722626722E63616C6C656442794E6F64657C7C6528746869732E24636F6E7461696E6572292E74726967';
wwv_flow_imp.g_varchar2_table(494) := '6765722822666F63757322292C746869732E24636F6E7461696E65722E746F67676C65436C617373282266616E6379747265652D74726565666F637573222C6E292C746869732E5F74726967676572547265654576656E74286E3F22666F637573547265';
wwv_flow_imp.g_varchar2_table(495) := '65223A22626C75725472656522292C6E262621746869732E6163746976654E6F6465262628693D746869732E5F6C6173744D6F757365646F776E4E6F64657C7C746869732E67657446697273744368696C642829292626692E736574466F637573282929';
wwv_flow_imp.g_varchar2_table(496) := '7D2C747265655365744F7074696F6E3A66756E6374696F6E28742C6E2C72297B76617220693D742E747265652C6F3D21302C613D21312C733D21313B737769746368286E297B636173652261726961223A6361736522636865636B626F78223A63617365';
wwv_flow_imp.g_varchar2_table(497) := '2269636F6E223A63617365226D696E457870616E644C6576656C223A6361736522746162696E646578223A613D21302C733D21303B627265616B3B6361736522636865636B626F784175746F48696465223A692E24636F6E7461696E65722E746F67676C';
wwv_flow_imp.g_varchar2_table(498) := '65436C617373282266616E6379747265652D636865636B626F782D6175746F2D68696465222C212172293B627265616B3B63617365226573636170655469746C6573223A6361736522746F6F6C746970223A733D21303B627265616B3B63617365227274';
wwv_flow_imp.g_varchar2_table(499) := '6C223A21313D3D3D723F692E24636F6E7461696E65722E72656D6F766541747472282244495222292E72656D6F7665436C617373282266616E6379747265652D72746C22293A692E24636F6E7461696E65722E617474722822444952222C2252544C2229';
wwv_flow_imp.g_varchar2_table(500) := '2E616464436C617373282266616E6379747265652D72746C22292C733D21303B627265616B3B6361736522736F75726365223A6F3D21312C692E5F63616C6C486F6F6B2822747265654C6F6164222C692C72292C733D21307D692E646562756728227365';
wwv_flow_imp.g_varchar2_table(501) := '74206F7074696F6E20222B6E2B223D222B722B22203C222B747970656F6620722B223E22292C6F262628746869732E7769646765742E5F73757065723F746869732E7769646765742E5F73757065722E63616C6C28746869732E7769646765742C6E2C72';
wwv_flow_imp.g_varchar2_table(502) := '293A652E5769646765742E70726F746F747970652E5F7365744F7074696F6E2E63616C6C28746869732E7769646765742C6E2C7229292C612626692E5F63616C6C486F6F6B282274726565437265617465222C69292C732626692E72656E646572282130';
wwv_flow_imp.g_varchar2_table(503) := '2C2131297D2C747265655374727563747572654368616E6765643A66756E6374696F6E28652C74297B7D7D292C652E776964676574282275692E66616E637974726565222C7B6F7074696F6E733A7B61637469766556697369626C653A21302C616A6178';
wwv_flow_imp.g_varchar2_table(504) := '3A7B747970653A22474554222C63616368653A21312C64617461547970653A226A736F6E227D2C617269613A21302C6175746F41637469766174653A21302C6175746F436F6C6C617073653A21312C6175746F5363726F6C6C3A21312C636865636B626F';
wwv_flow_imp.g_varchar2_table(505) := '783A21312C636C69636B466F6C6465724D6F64653A342C636F707946756E6374696F6E73546F446174613A21312C64656275674C6576656C3A6E756C6C2C64697361626C65643A21312C656E61626C65417370783A34322C6573636170655469746C6573';
wwv_flow_imp.g_varchar2_table(506) := '3A21312C657874656E73696F6E733A5B5D2C666F6375734F6E53656C6563743A21312C67656E65726174654964733A21312C69636F6E3A21302C69645072656669783A2266745F222C6B6579626F6172643A21302C6B657950617468536570617261746F';
wwv_flow_imp.g_varchar2_table(507) := '723A222F222C6D696E457870616E644C6576656C3A312C6E6F646174613A21302C717569636B7365617263683A21312C72746C3A21312C7363726F6C6C4F66733A7B746F703A302C626F74746F6D3A307D2C7363726F6C6C506172656E743A6E756C6C2C';
wwv_flow_imp.g_varchar2_table(508) := '73656C6563744D6F64653A322C737472696E67733A7B6C6F6164696E673A224C6F6164696E672E2E2E222C6C6F61644572726F723A224C6F6164206572726F7221222C6D6F7265446174613A224D6F72652E2E2E222C6E6F446174613A224E6F20646174';
wwv_flow_imp.g_varchar2_table(509) := '612E227D2C746162696E6465783A2230222C7469746C65735461626261626C653A21312C746F67676C654566666563743A7B6566666563743A22736C696465546F67676C65222C6475726174696F6E3A3230307D2C746F6F6C7469703A21312C74726565';
wwv_flow_imp.g_varchar2_table(510) := '49643A6E756C6C2C5F636C6173734E616D65733A7B6163746976653A2266616E6379747265652D616374697665222C616E696D6174696E673A2266616E6379747265652D616E696D6174696E67222C636F6D62696E6564457870616E6465725072656669';
wwv_flow_imp.g_varchar2_table(511) := '783A2266616E6379747265652D6578702D222C636F6D62696E656449636F6E5072656669783A2266616E6379747265652D69636F2D222C6572726F723A2266616E6379747265652D6572726F72222C657870616E6465643A2266616E6379747265652D65';
wwv_flow_imp.g_varchar2_table(512) := '7870616E646564222C666F63757365643A2266616E6379747265652D666F6375736564222C666F6C6465723A2266616E6379747265652D666F6C646572222C6861734368696C6472656E3A2266616E6379747265652D6861732D6368696C6472656E222C';
wwv_flow_imp.g_varchar2_table(513) := '6C6173747369623A2266616E6379747265652D6C617374736962222C6C617A793A2266616E6379747265652D6C617A79222C6C6F6164696E673A2266616E6379747265652D6C6F6164696E67222C6E6F64653A2266616E6379747265652D6E6F6465222C';
wwv_flow_imp.g_varchar2_table(514) := '706172746C6F61643A2266616E6379747265652D706172746C6F6164222C7061727473656C3A2266616E6379747265652D7061727473656C222C726164696F3A2266616E6379747265652D726164696F222C73656C65637465643A2266616E6379747265';
wwv_flow_imp.g_varchar2_table(515) := '652D73656C6563746564222C7374617475734E6F64655072656669783A2266616E6379747265652D7374617475736E6F64652D222C756E73656C65637461626C653A2266616E6379747265652D756E73656C65637461626C65227D2C6C617A794C6F6164';
wwv_flow_imp.g_varchar2_table(516) := '3A6E756C6C2C706F737450726F636573733A6E756C6C7D2C5F6465707265636174696F6E5761726E696E673A66756E6374696F6E2865297B76617220743D746869732E747265653B742626742E6F7074696F6E732E64656275674C6576656C3E3D332626';
wwv_flow_imp.g_varchar2_table(517) := '742E7761726E28222428292E66616E6379747265652827222B652B222729206973206465707265636174656420287365652068747470733A2F2F777777656E64742E64652F746563682F66616E6379747265652F646F632F6A73646F632F46616E637974';
wwv_flow_imp.g_varchar2_table(518) := '7265655F5769646765742E68746D6C22297D2C5F6372656174653A66756E6374696F6E28297B746869732E747265653D6E657720502874686973292C746869732E24736F757263653D746869732E736F757263657C7C226A736F6E223D3D3D746869732E';
wwv_flow_imp.g_varchar2_table(519) := '656C656D656E742E6461746128227479706522293F746869732E656C656D656E743A746869732E656C656D656E742E66696E6428223E756C22292E666972737428293B76617220742C6E2C722C693D746869732E6F7074696F6E732C6F3D692E65787465';
wwv_flow_imp.g_varchar2_table(520) := '6E73696F6E733B746869732E747265653B666F7228723D303B723C6F2E6C656E6774683B722B2B296E3D6F5B725D2C28743D652E75692E66616E6379747265652E5F657874656E73696F6E735B6E5D297C7C652E6572726F722822436F756C64206E6F74';
wwv_flow_imp.g_varchar2_table(521) := '206170706C7920657874656E73696F6E2027222B6E2B222720286974206973206E6F7420726567697374657265642C2064696420796F7520666F7267657420746F20696E636C7564652069743F2922292C746869732E747265652E6F7074696F6E735B6E';
wwv_flow_imp.g_varchar2_table(522) := '5D3D45287B7D2C742E6F7074696F6E732C746869732E747265652E6F7074696F6E735B6E5D292C6B28766F696420303D3D3D746869732E747265652E6578745B6E5D2C22457874656E73696F6E206E616D65206D757374206E6F74206578697374206173';
wwv_flow_imp.g_varchar2_table(523) := '2046616E6379747265652E657874206174747269627574653A2027222B6E2B222722292C746869732E747265652E6578745B6E5D3D7B7D2C4128746869732E747265652C302C742C6E293B766F69642030213D3D692E69636F6E7326262821303D3D3D69';
wwv_flow_imp.g_varchar2_table(524) := '2E69636F6E3F28746869732E747265652E7761726E28222769636F6E73272074726565206F7074696F6E20697320646570726563617465642073696E63652076322E31342E303A20757365202769636F6E2720696E737465616422292C692E69636F6E3D';
wwv_flow_imp.g_varchar2_table(525) := '692E69636F6E73293A652E6572726F7228222769636F6E73272074726565206F7074696F6E20697320646570726563617465642073696E63652076322E31342E303A20757365202769636F6E27206F6E6C7920696E73746561642229292C766F69642030';
wwv_flow_imp.g_varchar2_table(526) := '213D3D692E69636F6E436C617373262628692E69636F6E3F652E6572726F7228222769636F6E436C617373272074726565206F7074696F6E20697320646570726563617465642073696E63652076322E31342E303A20757365202769636F6E27206F6E6C';
wwv_flow_imp.g_varchar2_table(527) := '7920696E737465616422293A28746869732E747265652E7761726E28222769636F6E436C617373272074726565206F7074696F6E20697320646570726563617465642073696E63652076322E31342E303A20757365202769636F6E2720696E7374656164';
wwv_flow_imp.g_varchar2_table(528) := '22292C692E69636F6E3D692E69636F6E436C61737329292C766F69642030213D3D692E7461626261626C65262628692E746162696E6465783D692E7461626261626C653F2230223A222D31222C746869732E747265652E7761726E282227746162626162';
wwv_flow_imp.g_varchar2_table(529) := '6C65272074726565206F7074696F6E20697320646570726563617465642073696E63652076322E31372E303A207573652027746162696E6465783D27222B692E746162696E6465782B222720696E73746561642229292C746869732E747265652E5F6361';
wwv_flow_imp.g_varchar2_table(530) := '6C6C486F6F6B282274726565437265617465222C746869732E74726565297D2C5F696E69743A66756E6374696F6E28297B746869732E747265652E5F63616C6C486F6F6B282274726565496E6974222C746869732E74726565292C746869732E5F62696E';
wwv_flow_imp.g_varchar2_table(531) := '6428297D2C5F7365744F7074696F6E3A66756E6374696F6E28652C74297B72657475726E20746869732E747265652E5F63616C6C486F6F6B2822747265655365744F7074696F6E222C746869732E747265652C652C74297D2C5F64657374726F793A6675';
wwv_flow_imp.g_varchar2_table(532) := '6E6374696F6E28297B746869732E5F756E62696E6428292C746869732E747265652E5F63616C6C486F6F6B28227472656544657374726F79222C746869732E74726565297D2C5F756E62696E643A66756E6374696F6E28297B76617220743D746869732E';
wwv_flow_imp.g_varchar2_table(533) := '747265652E5F6E733B746869732E656C656D656E742E6F66662874292C746869732E747265652E24636F6E7461696E65722E6F66662874292C6528646F63756D656E74292E6F66662874297D2C5F62696E643A66756E6374696F6E28297B76617220743D';
wwv_flow_imp.g_varchar2_table(534) := '746869732C6E3D746869732E6F7074696F6E732C693D746869732E747265652C6F3D692E5F6E733B746869732E5F756E62696E6428292C692E24636F6E7461696E65722E6F6E2822666F637573696E222B6F2B2220666F6375736F7574222B6F2C66756E';
wwv_flow_imp.g_varchar2_table(535) := '6374696F6E2874297B766172206E3D722E6765744E6F64652874292C6F3D22666F637573696E223D3D3D742E747970653B696628216F26266E26266528742E746172676574292E69732822612229296E2E6465627567282249676E6F72656420666F6375';
wwv_flow_imp.g_varchar2_table(536) := '736F7574206F6E20656D626564646564203C613E20656C656D656E742E22293B656C73657B6966286F297B696628692E5F6765744578706972696E6756616C75652822666F637573696E22292972657475726E20766F696420692E646562756728224967';
wwv_flow_imp.g_varchar2_table(537) := '6E6F72656420646F75626C6520666F637573696E2E22293B692E5F7365744578706972696E6756616C75652822666F637573696E222C21302C3530292C6E7C7C286E3D692E5F6765744578706972696E6756616C756528226D6F757365446F776E4E6F64';
wwv_flow_imp.g_varchar2_table(538) := '652229292626692E646562756728225265636F6E737472756374206D6F7573652074617267657420666F7220666F637573696E2066726F6D20726563656E74206576656E742E22297D6E3F692E5F63616C6C486F6F6B28226E6F6465536574466F637573';
wwv_flow_imp.g_varchar2_table(539) := '222C692E5F6D616B65486F6F6B436F6E74657874286E2C74292C6F293A692E74626F647926266528742E746172676574292E706172656E747328227461626C652E66616E6379747265652D636F6E7461696E6572203E20746865616422292E6C656E6774';
wwv_flow_imp.g_varchar2_table(540) := '683F692E6465627567282249676E6F726520666F637573206576656E74206F757473696465207461626C6520626F64792E222C74293A692E5F63616C6C486F6F6B282274726565536574466F637573222C692C6F297D7D292E6F6E282273656C65637473';
wwv_flow_imp.g_varchar2_table(541) := '74617274222B6F2C227370616E2E66616E6379747265652D7469746C65222C66756E6374696F6E2865297B652E70726576656E7444656661756C7428297D292E6F6E28226B6579646F776E222B6F2C66756E6374696F6E2865297B6966286E2E64697361';
wwv_flow_imp.g_varchar2_table(542) := '626C65647C7C21313D3D3D6E2E6B6579626F6172642972657475726E21303B76617220742C723D692E666F6375734E6F64652C6F3D692E5F6D616B65486F6F6B436F6E7465787428727C7C692C65292C613D692E70686173653B7472797B72657475726E';
wwv_flow_imp.g_varchar2_table(543) := '20692E70686173653D22757365724576656E74222C2270726576656E744E6176223D3D3D28743D723F692E5F747269676765724E6F64654576656E7428226B6579646F776E222C722C65293A692E5F74726967676572547265654576656E7428226B6579';
wwv_flow_imp.g_varchar2_table(544) := '646F776E222C6529293F743D21303A2131213D3D74262628743D692E5F63616C6C486F6F6B28226E6F64654B6579646F776E222C6F29292C747D66696E616C6C797B692E70686173653D617D7D292E6F6E28226D6F757365646F776E222B6F2C66756E63';
wwv_flow_imp.g_varchar2_table(545) := '74696F6E2865297B76617220743D722E6765744576656E745461726765742865293B692E5F6C6173744D6F757365646F776E4E6F64653D743F742E6E6F64653A6E756C6C2C692E5F7365744578706972696E6756616C756528226D6F757365446F776E4E';
wwv_flow_imp.g_varchar2_table(546) := '6F6465222C692E5F6C6173744D6F757365646F776E4E6F6465297D292E6F6E2822636C69636B222B6F2B222064626C636C69636B222B6F2C66756E6374696F6E2865297B6966286E2E64697361626C65642972657475726E21303B76617220692C6F3D72';
wwv_flow_imp.g_varchar2_table(547) := '2E6765744576656E745461726765742865292C613D6F2E6E6F64652C733D742E747265652C6C3D732E70686173653B69662821612972657475726E21303B693D732E5F6D616B65486F6F6B436F6E7465787428612C65293B7472797B7377697463682873';
wwv_flow_imp.g_varchar2_table(548) := '2E70686173653D22757365724576656E74222C652E74797065297B6361736522636C69636B223A72657475726E20692E746172676574547970653D6F2E747970652C612E6973506167696E674E6F646528293F21303D3D3D732E5F747269676765724E6F';
wwv_flow_imp.g_varchar2_table(549) := '64654576656E742822636C69636B506167696E67222C692C65293A2131213D3D732E5F747269676765724E6F64654576656E742822636C69636B222C692C65292626732E5F63616C6C486F6F6B28226E6F6465436C69636B222C69293B63617365226462';
wwv_flow_imp.g_varchar2_table(550) := '6C636C69636B223A72657475726E20692E746172676574547970653D6F2E747970652C2131213D3D732E5F747269676765724E6F64654576656E74282264626C636C69636B222C692C65292626732E5F63616C6C486F6F6B28226E6F646544626C636C69';
wwv_flow_imp.g_varchar2_table(551) := '636B222C69297D7D66696E616C6C797B732E70686173653D6C7D7D297D2C6765744163746976654E6F64653A66756E6374696F6E28297B72657475726E20746869732E5F6465707265636174696F6E5761726E696E6728226765744163746976654E6F64';
wwv_flow_imp.g_varchar2_table(552) := '6522292C746869732E747265652E6163746976654E6F64657D2C6765744E6F646542794B65793A66756E6374696F6E2865297B72657475726E20746869732E5F6465707265636174696F6E5761726E696E6728226765744E6F646542794B657922292C74';
wwv_flow_imp.g_varchar2_table(553) := '6869732E747265652E6765744E6F646542794B65792865297D2C676574526F6F744E6F64653A66756E6374696F6E28297B72657475726E20746869732E5F6465707265636174696F6E5761726E696E672822676574526F6F744E6F646522292C74686973';
wwv_flow_imp.g_varchar2_table(554) := '2E747265652E726F6F744E6F64657D2C676574547265653A66756E6374696F6E28297B72657475726E20746869732E5F6465707265636174696F6E5761726E696E6728226765745472656522292C746869732E747265657D7D292C723D652E75692E6661';
wwv_flow_imp.g_varchar2_table(555) := '6E6379747265652C652E657874656E6428652E75692E66616E6379747265652C7B76657273696F6E3A22322E33382E34222C6275696C64547970653A2270726F64756374696F6E222C64656275674C6576656C3A332C5F6E65787449643A312C5F6E6578';
wwv_flow_imp.g_varchar2_table(556) := '744E6F64654B65793A312C5F657874656E73696F6E733A7B7D2C5F46616E637974726565436C6173733A502C5F46616E6379747265654E6F6465436C6173733A4C2C6A7175657279537570706F7274733A7B706F736974696F6E4D794F66733A66756E63';
wwv_flow_imp.g_varchar2_table(557) := '74696F6E2874297B766172206E2C722C692C6F3D652E6D6170285F2874292E73706C697428222E22292C66756E6374696F6E2865297B72657475726E207061727365496E7428652C3130297D292C613D652E6D61702841727261792E70726F746F747970';
wwv_flow_imp.g_varchar2_table(558) := '652E736C6963652E63616C6C28617267756D656E74732C31292C66756E6374696F6E2865297B72657475726E207061727365496E7428652C3130297D293B666F72286E3D303B6E3C612E6C656E6774683B6E2B2B2969662828723D6F5B6E5D7C7C302921';
wwv_flow_imp.g_varchar2_table(559) := '3D3D28693D615B6E5D7C7C30292972657475726E20723E693B72657475726E21307D28652E75692E76657273696F6E2C312C39297D2C6173736572743A66756E6374696F6E28652C74297B72657475726E206B28652C74297D2C63726561746554726565';
wwv_flow_imp.g_varchar2_table(560) := '3A66756E6374696F6E28742C6E297B76617220693D652874292E66616E637974726565286E293B72657475726E20722E676574547265652869297D2C6465626F756E63653A66756E6374696F6E28652C742C6E2C72297B76617220693B72657475726E20';
wwv_flow_imp.g_varchar2_table(561) := '333D3D3D617267756D656E74732E6C656E677468262622626F6F6C65616E22213D747970656F66206E262628723D6E2C6E3D2131292C66756E6374696F6E28297B766172206F3D617267756D656E74733B723D727C7C746869732C6E262621692626742E';
wwv_flow_imp.g_varchar2_table(562) := '6170706C7928722C6F292C636C65617254696D656F75742869292C693D73657454696D656F75742866756E6374696F6E28297B6E7C7C742E6170706C7928722C6F292C693D6E756C6C7D2C65297D7D2C64656275673A66756E6374696F6E2874297B652E';
wwv_flow_imp.g_varchar2_table(563) := '75692E66616E6379747265652E64656275674C6576656C3E3D3426264E28226C6F67222C617267756D656E7473297D2C6572726F723A66756E6374696F6E2874297B652E75692E66616E6379747265652E64656275674C6576656C3E3D3126264E282265';
wwv_flow_imp.g_varchar2_table(564) := '72726F72222C617267756D656E7473297D2C65736361706548746D6C3A66756E6374696F6E2865297B72657475726E2822222B65292E7265706C616365286F2C66756E6374696F6E2865297B72657475726E20645B655D7D297D2C666978506F73697469';
wwv_flow_imp.g_varchar2_table(565) := '6F6E4F7074696F6E733A66756E6374696F6E2874297B69662828742E6F66667365747C7C2822222B742E6D792B742E6174292E696E6465784F6628222522293E3D30292626652E6572726F7228226578706563746564206E657720706F736974696F6E20';
wwv_flow_imp.g_varchar2_table(566) := '73796E746178202862757420272527206973206E6F7420737570706F727465642922292C21652E75692E66616E6379747265652E6A7175657279537570706F7274732E706F736974696F6E4D794F6673297B766172206E3D2F285C772B29285B2B2D5D3F';
wwv_flow_imp.g_varchar2_table(567) := '5C642B293F5C732B285C772B29285B2B2D5D3F5C642B293F2F2E6578656328742E6D79292C723D2F285C772B29285B2B2D5D3F5C642B293F5C732B285C772B29285B2B2D5D3F5C642B293F2F2E6578656328742E6174292C693D286E5B325D3F2B6E5B32';
wwv_flow_imp.g_varchar2_table(568) := '5D3A30292B28725B325D3F2B725B325D3A30292C6F3D286E5B345D3F2B6E5B345D3A30292B28725B345D3F2B725B345D3A30293B743D652E657874656E64287B7D2C742C7B6D793A6E5B315D2B2220222B6E5B335D2C61743A725B315D2B2220222B725B';
wwv_flow_imp.g_varchar2_table(569) := '335D7D292C28697C7C6F29262628742E6F66667365743D692B2220222B6F297D72657475726E20747D2C6765744576656E745461726765743A66756E6374696F6E2874297B766172206E2C693D742626742E7461726765743F742E7461726765742E636C';
wwv_flow_imp.g_varchar2_table(570) := '6173734E616D653A22222C6F3D7B6E6F64653A746869732E6765744E6F646528742E746172676574292C747970653A766F696420307D3B72657475726E2F5C6266616E6379747265652D7469746C655C622F2E746573742869293F6F2E747970653D2274';
wwv_flow_imp.g_varchar2_table(571) := '69746C65223A2F5C6266616E6379747265652D657870616E6465725C622F2E746573742869293F6F2E747970653D21313D3D3D6F2E6E6F64652E6861734368696C6472656E28293F22707265666978223A22657870616E646572223A2F5C6266616E6379';
wwv_flow_imp.g_varchar2_table(572) := '747265652D636865636B626F785C622F2E746573742869293F6F2E747970653D22636865636B626F78223A2F5C6266616E637974726565282D637573746F6D293F2D69636F6E5C622F2E746573742869293F6F2E747970653D2269636F6E223A2F5C6266';
wwv_flow_imp.g_varchar2_table(573) := '616E6379747265652D6E6F64655C622F2E746573742869293F6F2E747970653D227469746C65223A742626742E746172676574262628286E3D6528742E74617267657429292E69732822756C5B726F6C653D67726F75705D22293F28286F2E6E6F646526';
wwv_flow_imp.g_varchar2_table(574) := '266F2E6E6F64652E747265657C7C72292E6465627567282249676E6F72696E6720636C69636B206F6E206F7574657220554C2E22292C6F2E6E6F64653D6E756C6C293A6E2E636C6F7365737428222E66616E6379747265652D7469746C6522292E6C656E';
wwv_flow_imp.g_varchar2_table(575) := '6774683F6F2E747970653D227469746C65223A6E2E636C6F7365737428222E66616E6379747265652D636865636B626F7822292E6C656E6774683F6F2E747970653D22636865636B626F78223A6E2E636C6F7365737428222E66616E6379747265652D65';
wwv_flow_imp.g_varchar2_table(576) := '7870616E64657222292E6C656E6774682626286F2E747970653D22657870616E6465722229292C6F7D2C6765744576656E74546172676574547970653A66756E6374696F6E2865297B72657475726E20746869732E6765744576656E7454617267657428';
wwv_flow_imp.g_varchar2_table(577) := '65292E747970657D2C6765744E6F64653A66756E6374696F6E2874297B6966287420696E7374616E63656F66204C2972657475726E20743B666F72287420696E7374616E63656F6620653F743D745B305D3A766F69642030213D3D742E6F726967696E61';
wwv_flow_imp.g_varchar2_table(578) := '6C4576656E74262628743D742E746172676574293B743B297B696628742E66746E6F64652972657475726E20742E66746E6F64653B743D742E706172656E744E6F64657D72657475726E206E756C6C7D2C676574547265653A66756E6374696F6E287429';
wwv_flow_imp.g_varchar2_table(579) := '7B766172206E2C723D743B72657475726E207420696E7374616E63656F6620503F743A28766F696420303D3D3D74262628743D30292C226E756D626572223D3D747970656F6620743F743D6528222E66616E6379747265652D636F6E7461696E65722229';
wwv_flow_imp.g_varchar2_table(580) := '2E65712874293A22737472696E67223D3D747970656F6620743F28743D6528222366742D69642D222B72292E6571283029292E6C656E6774687C7C28743D652872292E6571283029293A7420696E7374616E63656F6620456C656D656E747C7C7420696E';
wwv_flow_imp.g_varchar2_table(581) := '7374616E63656F662048544D4C446F63756D656E743F743D652874293A7420696E7374616E63656F6620653F743D742E65712830293A766F69642030213D3D742E6F726967696E616C4576656E74262628743D6528742E74617267657429292C286E3D28';
wwv_flow_imp.g_varchar2_table(582) := '743D742E636C6F7365737428223A75692D66616E6379747265652229292E64617461282275692D66616E63797472656522297C7C742E64617461282266616E6379747265652229293F6E2E747265653A6E756C6C297D2C6576616C4F7074696F6E3A6675';
wwv_flow_imp.g_varchar2_table(583) := '6E6374696F6E28652C742C6E2C722C69297B766172206F2C612C733D742E747265652C6C3D725B655D2C643D6E5B655D3B72657475726E2053286C293F286F3D7B6E6F64653A742C747265653A732C7769646765743A732E7769646765742C6F7074696F';
wwv_flow_imp.g_varchar2_table(584) := '6E733A732E7769646765742E6F7074696F6E732C74797065496E666F3A732E74797065735B742E747970655D7C7C7B7D7D2C6E756C6C3D3D28613D6C2E63616C6C28732C7B747970653A657D2C6F2929262628613D6429293A613D6E756C6C3D3D643F6C';
wwv_flow_imp.g_varchar2_table(585) := '3A642C6E756C6C3D3D61262628613D69292C617D2C7365745370616E49636F6E3A66756E6374696F6E28742C6E2C72297B76617220693D652874293B22737472696E67223D3D747970656F6620723F692E617474722822636C617373222C6E2B2220222B';
wwv_flow_imp.g_varchar2_table(586) := '72293A28722E746578743F692E746578742822222B722E74657874293A722E68746D6C262628742E696E6E657248544D4C3D722E68746D6C292C692E617474722822636C617373222C6E2B2220222B28722E616464436C6173737C7C22222929297D2C65';
wwv_flow_imp.g_varchar2_table(587) := '76656E74546F537472696E673A66756E6374696F6E2865297B76617220743D652E77686963682C6E3D652E747970652C723D5B5D3B72657475726E20652E616C744B65792626722E707573682822616C7422292C652E6374726C4B65792626722E707573';
wwv_flow_imp.g_varchar2_table(588) := '6828226374726C22292C652E6D6574614B65792626722E7075736828226D65746122292C652E73686966744B65792626722E707573682822736869667422292C22636C69636B223D3D3D6E7C7C2264626C636C69636B223D3D3D6E3F722E707573682870';
wwv_flow_imp.g_varchar2_table(589) := '5B652E627574746F6E5D2B6E293A22776865656C223D3D3D6E3F722E70757368286E293A635B745D7C7C722E7075736828755B745D7C7C537472696E672E66726F6D43686172436F64652874292E746F4C6F776572436173652829292C722E6A6F696E28';
wwv_flow_imp.g_varchar2_table(590) := '222B22297D2C696E666F3A66756E6374696F6E2874297B652E75692E66616E6379747265652E64656275674C6576656C3E3D3326264E2822696E666F222C617267756D656E7473297D2C6B65794576656E74546F537472696E673A66756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(591) := '65297B72657475726E20746869732E7761726E28226B65794576656E74546F537472696E67282920697320646570726563617465643A20757365206576656E74546F537472696E67282922292C746869732E6576656E74546F537472696E672865297D2C';
wwv_flow_imp.g_varchar2_table(592) := '6F766572726964654D6574686F643A66756E6374696F6E28742C6E2C722C69297B766172206F2C613D745B6E5D7C7C652E6E6F6F703B745B6E5D3D66756E6374696F6E28297B76617220653D697C7C746869733B7472797B72657475726E206F3D652E5F';
wwv_flow_imp.g_varchar2_table(593) := '73757065722C652E5F73757065723D612C722E6170706C7928652C617267756D656E7473297D66696E616C6C797B652E5F73757065723D6F7D7D7D2C706172736548746D6C3A66756E6374696F6E2874297B766172206E2C722C692C6F2C612C732C6C2C';
wwv_flow_imp.g_varchar2_table(594) := '642C633D742E66696E6428223E6C6922292C753D5B5D3B72657475726E20632E656163682866756E6374696F6E28297B76617220632C662C703D652874686973292C793D702E66696E6428223E7370616E222C74686973292E666972737428292C6D3D79';
wwv_flow_imp.g_varchar2_table(595) := '2E6C656E6774683F6E756C6C3A702E66696E6428223E6122292E666972737428292C623D7B746F6F6C7469703A6E756C6C2C646174613A7B7D7D3B666F7228792E6C656E6774683F622E7469746C653D792E68746D6C28293A6D26266D2E6C656E677468';
wwv_flow_imp.g_varchar2_table(596) := '3F28622E7469746C653D6D2E68746D6C28292C622E646174612E687265663D6D2E6174747228226872656622292C622E646174612E7461726765743D6D2E61747472282274617267657422292C622E746F6F6C7469703D6D2E6174747228227469746C65';
wwv_flow_imp.g_varchar2_table(597) := '2229293A28622E7469746C653D702E68746D6C28292C28613D622E7469746C652E736561726368282F3C756C2F6929293E3D30262628622E7469746C653D622E7469746C652E737562737472696E6728302C612929292C622E7469746C653D5F28622E74';
wwv_flow_imp.g_varchar2_table(598) := '69746C65292C6F3D302C733D682E6C656E6774683B6F3C733B6F2B2B29625B685B6F5D5D3D766F696420303B666F72286E3D746869732E636C6173734E616D652E73706C697428222022292C693D5B5D2C6F3D302C733D6E2E6C656E6774683B6F3C733B';
wwv_flow_imp.g_varchar2_table(599) := '6F2B2B29723D6E5B6F5D2C675B725D3F625B725D3D21303A692E707573682872293B696628622E6578747261436C61737365733D692E6A6F696E28222022292C286C3D702E6174747228227469746C65222929262628622E746F6F6C7469703D6C292C28';
wwv_flow_imp.g_varchar2_table(600) := '6C3D702E6174747228226964222929262628622E6B65793D6C292C702E61747472282268696465436865636B626F782229262628622E636865636B626F783D2131292C28633D4928702929262621652E6973456D7074794F626A656374286329297B666F';
wwv_flow_imp.g_varchar2_table(601) := '72286620696E2078297728632C6629262628635B785B665D5D3D635B665D2C64656C65746520635B665D293B666F72286F3D302C733D762E6C656E6774683B6F3C733B6F2B2B296C3D765B6F5D2C6E756C6C213D28643D635B6C5D2926262864656C6574';
wwv_flow_imp.g_varchar2_table(602) := '6520635B6C5D2C625B6C5D3D64293B652E657874656E6428622E646174612C63297D28743D702E66696E6428223E756C22292E66697273742829292E6C656E6774683F622E6368696C6472656E3D652E75692E66616E6379747265652E70617273654874';
wwv_flow_imp.g_varchar2_table(603) := '6D6C2874293A622E6368696C6472656E3D622E6C617A793F766F696420303A6E756C6C2C752E707573682862297D292C757D2C7265676973746572457874656E73696F6E3A66756E6374696F6E2874297B6B286E756C6C213D742E6E616D652C22657874';
wwv_flow_imp.g_varchar2_table(604) := '656E73696F6E73206D7573742068617665206120606E616D65602070726F70657274792E22292C6B286E756C6C213D742E76657273696F6E2C22657874656E73696F6E73206D75737420686176652061206076657273696F6E602070726F70657274792E';
wwv_flow_imp.g_varchar2_table(605) := '22292C652E75692E66616E6379747265652E5F657874656E73696F6E735B742E6E616D655D3D747D2C7472696D3A5F2C756E65736361706548746D6C3A66756E6374696F6E2865297B76617220743D646F63756D656E742E637265617465456C656D656E';
wwv_flow_imp.g_varchar2_table(606) := '74282264697622293B72657475726E20742E696E6E657248544D4C3D652C303D3D3D742E6368696C644E6F6465732E6C656E6774683F22223A742E6368696C644E6F6465735B305D2E6E6F646556616C75657D2C7761726E3A66756E6374696F6E287429';
wwv_flow_imp.g_varchar2_table(607) := '7B652E75692E66616E6379747265652E64656275674C6576656C3E3D3226264E28227761726E222C617267756D656E7473297D7D292C652E75692E66616E6379747265657D66756E6374696F6E206B28742C6E297B747C7C286E3D2246616E6379747265';
wwv_flow_imp.g_varchar2_table(608) := '6520617373657274696F6E206661696C6564222B286E3D6E3F223A20222B6E3A2222292C652E75692626652E75692E66616E6379747265652626652E75692E66616E6379747265652E6572726F72286E292C652E6572726F72286E29297D66756E637469';
wwv_flow_imp.g_varchar2_table(609) := '6F6E207728652C74297B72657475726E204F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28652C74297D66756E6374696F6E20532865297B72657475726E2266756E6374696F6E223D3D747970656F6620657D';
wwv_flow_imp.g_varchar2_table(610) := '66756E6374696F6E205F2865297B72657475726E206E756C6C3D3D653F22223A652E7472696D28297D66756E6374696F6E204E28652C74297B766172206E2C722C693D77696E646F772E636F6E736F6C653F77696E646F772E636F6E736F6C655B655D3A';
wwv_flow_imp.g_varchar2_table(611) := '6E756C6C3B69662869297472797B692E6170706C792877696E646F772E636F6E736F6C652C74297D63617463682865297B666F7228723D22222C6E3D303B6E3C742E6C656E6774683B6E2B2B29722B3D745B6E5D3B692872297D7D66756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(612) := '4528297B76617220742C6E2C722C692C6F2C613D617267756D656E74735B305D7C7C7B7D2C733D312C6C3D617267756D656E74732E6C656E6774683B696628226F626A656374223D3D747970656F6620617C7C532861297C7C28613D7B7D292C733D3D3D';
wwv_flow_imp.g_varchar2_table(613) := '6C297468726F77204572726F7228226E656564206174206C656173742074776F206172677322293B666F72283B733C6C3B732B2B296966286E756C6C213D28743D617267756D656E74735B735D2929666F72286E20696E2074296966287728742C6E2929';
wwv_flow_imp.g_varchar2_table(614) := '7B696628723D615B6E5D2C613D3D3D28693D745B6E5D2929636F6E74696E75653B692626652E6973506C61696E4F626A6563742869293F286F3D722626652E6973506C61696E4F626A6563742872293F723A7B7D2C615B6E5D3D45286F2C6929293A766F';
wwv_flow_imp.g_varchar2_table(615) := '69642030213D3D69262628615B6E5D3D69297D72657475726E20617D66756E6374696F6E204428652C742C6E2C722C69297B766172206F2C612C732C6C2C642C633D286F3D745B655D2C613D725B655D2C733D742E6578745B695D2C6C3D66756E637469';
wwv_flow_imp.g_varchar2_table(616) := '6F6E28297B72657475726E206F2E6170706C7928742C617267756D656E7473297D2C643D66756E6374696F6E2865297B72657475726E206F2E6170706C7928742C65297D2C66756E6374696F6E28297B76617220653D742E5F6C6F63616C2C6E3D742E5F';
wwv_flow_imp.g_varchar2_table(617) := '73757065722C723D742E5F73757065724170706C793B7472797B72657475726E20742E5F6C6F63616C3D732C742E5F73757065723D6C2C742E5F73757065724170706C793D642C612E6170706C7928742C617267756D656E7473297D66696E616C6C797B';
wwv_flow_imp.g_varchar2_table(618) := '742E5F6C6F63616C3D652C742E5F73757065723D6E2C742E5F73757065724170706C793D727D7D293B72657475726E20637D66756E6374696F6E204128742C6E2C722C69297B666F7228766172206F20696E2072292266756E6374696F6E223D3D747970';
wwv_flow_imp.g_varchar2_table(619) := '656F6620725B6F5D3F2266756E6374696F6E223D3D747970656F6620745B6F5D3F745B6F5D3D44286F2C742C302C722C69293A225F223D3D3D6F2E6368617241742830293F742E6578745B695D5B6F5D3D44286F2C742C302C722C69293A652E6572726F';
wwv_flow_imp.g_varchar2_table(620) := '722822436F756C64206E6F74206F7665727269646520747265652E222B6F2B222E205573652070726566697820275F2720746F2063726561746520747265652E222B692B222E5F222B6F293A226F7074696F6E7322213D3D6F262628742E6578745B695D';
wwv_flow_imp.g_varchar2_table(621) := '5B6F5D3D725B6F5D297D66756E6374696F6E205428742C6E297B72657475726E20766F696420303D3D3D743F652E44656665727265642866756E6374696F6E28297B746869732E7265736F6C766528297D292E70726F6D69736528293A652E4465666572';
wwv_flow_imp.g_varchar2_table(622) := '7265642866756E6374696F6E28297B746869732E7265736F6C76655769746828742C6E297D292E70726F6D69736528297D66756E6374696F6E204D28742C6E297B72657475726E20766F696420303D3D3D743F652E44656665727265642866756E637469';
wwv_flow_imp.g_varchar2_table(623) := '6F6E28297B746869732E72656A65637428297D292E70726F6D69736528293A652E44656665727265642866756E6374696F6E28297B746869732E72656A6563745769746828742C6E297D292E70726F6D69736528297D66756E6374696F6E204F28652C74';
wwv_flow_imp.g_varchar2_table(624) := '297B72657475726E2066756E6374696F6E28297B652E7265736F6C7665576974682874297D7D66756E6374696F6E20492874297B766172206E3D652E657874656E64287B7D2C742E646174612829292C723D6E2E6A736F6E3B72657475726E2064656C65';
wwv_flow_imp.g_varchar2_table(625) := '7465206E2E66616E6379747265652C64656C657465206E2E756946616E6379747265652C7226262864656C657465206E2E6A736F6E2C6E3D652E657874656E64286E2C7229292C6E7D66756E6374696F6E206A2865297B72657475726E2822222B65292E';
wwv_flow_imp.g_varchar2_table(626) := '7265706C61636528612C66756E6374696F6E2865297B72657475726E20645B655D7D297D66756E6374696F6E20462865297B72657475726E20653D652E746F4C6F7765724361736528292C66756E6374696F6E2874297B72657475726E20742E7469746C';
wwv_flow_imp.g_varchar2_table(627) := '652E746F4C6F7765724361736528292E696E6465784F662865293E3D307D7D66756E6374696F6E204C28742C6E297B76617220692C6F2C612C733B666F7228746869732E706172656E743D742C746869732E747265653D742E747265652C746869732E75';
wwv_flow_imp.g_varchar2_table(628) := '6C3D6E756C6C2C746869732E6C693D6E756C6C2C746869732E7374617475734E6F6465547970653D6E756C6C2C746869732E5F69734C6F6164696E673D21312C746869732E5F6572726F723D6E756C6C2C746869732E646174613D7B7D2C693D302C6F3D';
wwv_flow_imp.g_varchar2_table(629) := '762E6C656E6774683B693C6F3B692B2B29746869735B613D765B695D5D3D6E5B615D3B666F72286120696E206E756C6C3D3D746869732E756E73656C65637461626C6549676E6F726526266E756C6C3D3D746869732E756E73656C65637461626C655374';
wwv_flow_imp.g_varchar2_table(630) := '617475737C7C28746869732E756E73656C65637461626C653D2130292C6E2E68696465436865636B626F782626652E6572726F7228222768696465436865636B626F7827206E6F6465206F7074696F6E207761732072656D6F76656420696E2076322E32';
wwv_flow_imp.g_varchar2_table(631) := '332E303A207573652027636865636B626F783A2066616C73652722292C6E2E646174612626652E657874656E6428746869732E646174612C6E2E64617461292C6E296D5B615D7C7C21746869732E747265652E6F7074696F6E732E636F707946756E6374';
wwv_flow_imp.g_varchar2_table(632) := '696F6E73546F44617461262653286E5B615D297C7C625B615D7C7C28746869732E646174615B615D3D6E5B615D293B6E756C6C3D3D746869732E6B65793F746869732E747265652E6F7074696F6E732E64656661756C744B65793F28746869732E6B6579';
wwv_flow_imp.g_varchar2_table(633) := '3D22222B746869732E747265652E6F7074696F6E732E64656661756C744B65792874686973292C6B28746869732E6B65792C2264656661756C744B65792829206D7573742072657475726E206120756E69717565206B65792229293A746869732E6B6579';
wwv_flow_imp.g_varchar2_table(634) := '3D225F222B722E5F6E6578744E6F64654B65792B2B3A746869732E6B65793D22222B746869732E6B65792C6E2E6163746976652626286B286E756C6C3D3D3D746869732E747265652E6163746976654E6F64652C226F6E6C79206F6E6520616374697665';
wwv_flow_imp.g_varchar2_table(635) := '206E6F646520616C6C6F77656422292C746869732E747265652E6163746976654E6F64653D74686973292C6E2E73656C6563746564262628746869732E747265652E6C61737453656C65637465644E6F64653D74686973292C28733D6E2E6368696C6472';
wwv_flow_imp.g_varchar2_table(636) := '656E293F732E6C656E6774683F746869732E5F7365744368696C6472656E2873293A746869732E6368696C6472656E3D746869732E6C617A793F5B5D3A6E756C6C3A746869732E6368696C6472656E3D6E756C6C2C746869732E747265652E5F63616C6C';
wwv_flow_imp.g_varchar2_table(637) := '486F6F6B28227472656552656769737465724E6F6465222C746869732E747265652C21302C74686973297D66756E6374696F6E20502874297B746869732E7769646765743D742C746869732E246469763D742E656C656D656E742C746869732E6F707469';
wwv_flow_imp.g_varchar2_table(638) := '6F6E733D742E6F7074696F6E732C746869732E6F7074696F6E73262628766F69642030213D3D746869732E6F7074696F6E732E6C617A796C6F61642626652E6572726F72282254686520276C617A796C6F616427206576656E7420697320646570726563';
wwv_flow_imp.g_varchar2_table(639) := '617465642073696E636520323031342D30322D32352E2055736520276C617A794C6F61642720287769746820757070657263617365204C2920696E73746561642E22292C766F69642030213D3D746869732E6F7074696F6E732E6C6F61646572726F7226';
wwv_flow_imp.g_varchar2_table(640) := '26652E6572726F72282254686520276C6F61646572726F7227206576656E74207761732072656E616D65642073696E636520323031342D30372D30332E2055736520276C6F61644572726F72272028776974682075707065726361736520452920696E73';
wwv_flow_imp.g_varchar2_table(641) := '746561642E22292C766F69642030213D3D746869732E6F7074696F6E732E66782626652E6572726F7228225468652027667827206F7074696F6E20776173207265706C616365642062792027746F67676C65456666656374272073696E63652032303134';
wwv_flow_imp.g_varchar2_table(642) := '2D31312D33302E22292C766F69642030213D3D746869732E6F7074696F6E732E72656D6F76654E6F64652626652E6572726F722822546865202772656D6F76654E6F646527206576656E7420776173207265706C6163656420627920276D6F6469667943';
wwv_flow_imp.g_varchar2_table(643) := '68696C64272073696E636520322E32302028323031362D30392D3130292E2229292C746869732E6578743D7B7D2C746869732E74797065733D7B7D2C746869732E636F6C756D6E733D7B7D2C746869732E646174613D4928746869732E24646976292C74';
wwv_flow_imp.g_varchar2_table(644) := '6869732E5F69643D22222B28746869732E6F7074696F6E732E7472656549647C7C652E75692E66616E6379747265652E5F6E65787449642B2B292C746869732E5F6E733D222E66616E6379747265652D222B746869732E5F69642C746869732E61637469';
wwv_flow_imp.g_varchar2_table(645) := '76654E6F64653D6E756C6C2C746869732E666F6375734E6F64653D6E756C6C2C746869732E5F686173466F6375733D6E756C6C2C746869732E5F74656D7043616368653D7B7D2C746869732E5F6C6173744D6F757365646F776E4E6F64653D6E756C6C2C';
wwv_flow_imp.g_varchar2_table(646) := '746869732E5F656E61626C655570646174653D21302C746869732E6C61737453656C65637465644E6F64653D6E756C6C2C746869732E73797374656D466F637573456C656D656E743D6E756C6C2C746869732E6C617374517569636B7365617263685465';
wwv_flow_imp.g_varchar2_table(647) := '726D3D22222C746869732E6C617374517569636B73656172636854696D653D302C746869732E76696577706F72743D6E756C6C2C746869732E737461747573436C61737350726F704E616D653D227370616E222C746869732E6172696150726F704E616D';
wwv_flow_imp.g_varchar2_table(648) := '653D226C69222C746869732E6E6F6465436F6E7461696E6572417474724E616D653D226C69222C746869732E246469762E66696E6428223E756C2E66616E6379747265652D636F6E7461696E657222292E72656D6F766528293B766172206E2C693D7B74';
wwv_flow_imp.g_varchar2_table(649) := '7265653A746869737D3B746869732E726F6F744E6F64653D6E6577204C28692C7B7469746C653A22726F6F74222C6B65793A22726F6F745F222B746869732E5F69642C6368696C6472656E3A6E756C6C2C657870616E6465643A21307D292C746869732E';
wwv_flow_imp.g_varchar2_table(650) := '726F6F744E6F64652E706172656E743D6E756C6C2C6E3D6528223C756C3E222C7B69643A2266742D69642D222B746869732E5F69642C636C6173733A2275692D66616E6379747265652066616E6379747265652D636F6E7461696E65722066616E637974';
wwv_flow_imp.g_varchar2_table(651) := '7265652D706C61696E227D292E617070656E64546F28746869732E24646976292C746869732E24636F6E7461696E65723D6E2C746869732E726F6F744E6F64652E756C3D6E5B305D2C6E756C6C3D3D746869732E6F7074696F6E732E64656275674C6576';
wwv_flow_imp.g_varchar2_table(652) := '656C262628746869732E6F7074696F6E732E64656275674C6576656C3D722E64656275674C6576656C297D652E75692E66616E6379747265652E7761726E282246616E6379747265653A2069676E6F726564206475706C696361746520696E636C756465';
wwv_flow_imp.g_varchar2_table(653) := '22297D292C0A2F2A210A202A206A71756572792E66616E6379747265652E6368696C64636F756E7465722E6A730A202A0A202A204164642061206368696C6420636F756E74657220627562626C6520746F2074726565206E6F6465732E0A202A20284578';
wwv_flow_imp.g_varchar2_table(654) := '74656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972696768742028632920323030';
wwv_flow_imp.g_varchar2_table(655) := '382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D';
wwv_flow_imp.g_varchar2_table(656) := '2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(657) := '297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D';
wwv_flow_imp.g_varchar2_table(658) := '6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D';
wwv_flow_imp.g_varchar2_table(659) := '2866756E6374696F6E2865297B2275736520737472696374223B72657475726E20652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E636F756E7453656C65637465643D66756E6374696F6E2865297B';
wwv_flow_imp.g_varchar2_table(660) := '746869732E6F7074696F6E733B72657475726E20746869732E67657453656C65637465644E6F6465732865292E6C656E6774687D2C652E75692E66616E6379747265652E5F46616E6379747265654E6F6465436C6173732E70726F746F747970652E7570';
wwv_flow_imp.g_varchar2_table(661) := '64617465436F756E746572733D66756E6374696F6E28297B76617220743D746869732C6E3D6528227370616E2E66616E6379747265652D6368696C64636F756E746572222C742E7370616E292C723D742E747265652E6F7074696F6E732E6368696C6463';
wwv_flow_imp.g_varchar2_table(662) := '6F756E7465722C693D742E636F756E744368696C6472656E28722E64656570293B742E646174612E6368696C64436F756E7465723D692C21692626722E686964655A65726F737C7C742E6973457870616E64656428292626722E68696465457870616E64';
wwv_flow_imp.g_varchar2_table(663) := '65643F6E2E72656D6F766528293A286E2E6C656E6774687C7C286E3D6528223C7370616E20636C6173733D2766616E6379747265652D6368696C64636F756E746572272F3E22292E617070656E64546F286528227370616E2E66616E6379747265652D69';
wwv_flow_imp.g_varchar2_table(664) := '636F6E2C7370616E2E66616E6379747265652D637573746F6D2D69636F6E222C742E7370616E2929292C6E2E74657874286929292C21722E646565707C7C742E6973546F704C6576656C28297C7C742E6973526F6F744E6F646528297C7C742E70617265';
wwv_flow_imp.g_varchar2_table(665) := '6E742E757064617465436F756E7465727328297D2C652E75692E66616E6379747265652E70726F746F747970652E7769646765744D6574686F64313D66756E6374696F6E2865297B746869732E747265653B72657475726E20657D2C652E75692E66616E';
wwv_flow_imp.g_varchar2_table(666) := '6379747265652E7265676973746572457874656E73696F6E287B6E616D653A226368696C64636F756E746572222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B646565703A21302C686964655A65726F733A21302C68696465457870';
wwv_flow_imp.g_varchar2_table(667) := '616E6465643A21317D2C666F6F3A34322C5F617070656E64436F756E7465723A66756E6374696F6E2865297B7D2C74726565496E69743A66756E6374696F6E2865297B652E6F7074696F6E732C652E6F7074696F6E732E6368696C64636F756E7465723B';
wwv_flow_imp.g_varchar2_table(668) := '746869732E5F73757065724170706C7928617267756D656E7473292C746869732E24636F6E7461696E65722E616464436C617373282266616E6379747265652D6578742D6368696C64636F756E74657222297D2C7472656544657374726F793A66756E63';
wwv_flow_imp.g_varchar2_table(669) := '74696F6E2865297B746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F646552656E6465725469746C653A66756E6374696F6E28742C6E297B76617220723D742E6E6F64652C693D742E6F7074696F6E732E6368696C64636F75';
wwv_flow_imp.g_varchar2_table(670) := '6E7465722C6F3D6E756C6C3D3D722E646174612E6368696C64436F756E7465723F722E636F756E744368696C6472656E28692E64656570293A2B722E646174612E6368696C64436F756E7465723B746869732E5F737570657228742C6E292C216F262669';
wwv_flow_imp.g_varchar2_table(671) := '2E686964655A65726F737C7C722E6973457870616E64656428292626692E68696465457870616E6465647C7C6528227370616E2E66616E6379747265652D69636F6E2C7370616E2E66616E6379747265652D637573746F6D2D69636F6E222C722E737061';
wwv_flow_imp.g_varchar2_table(672) := '6E292E617070656E64286528223C7370616E20636C6173733D2766616E6379747265652D6368696C64636F756E746572272F3E22292E74657874286F29297D2C6E6F6465536574457870616E6465643A66756E6374696F6E28652C742C6E297B76617220';
wwv_flow_imp.g_varchar2_table(673) := '723D652E747265653B652E6E6F64653B72657475726E20746869732E5F73757065724170706C7928617267756D656E7473292E616C776179732866756E6374696F6E28297B722E6E6F646552656E6465725469746C652865297D297D7D292C652E75692E';
wwv_flow_imp.g_varchar2_table(674) := '66616E6379747265657D292C0A2F2A210A202A0A202A206A71756572792E66616E6379747265652E636C6F6E65732E6A730A202A20537570706F727420666173746572206C6F6F6B7570206F66206E6F646573206279206B657920616E64207368617265';
wwv_flow_imp.g_varchar2_table(675) := '64207265662D6964732E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20';
wwv_flow_imp.g_varchar2_table(676) := '436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068';
wwv_flow_imp.g_varchar2_table(677) := '747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30';
wwv_flow_imp.g_varchar2_table(678) := '325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A22';
wwv_flow_imp.g_varchar2_table(679) := '6F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A717565';
wwv_flow_imp.g_varchar2_table(680) := '7279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D652E75692E66616E6379747265652E6173736572743B66756E6374696F6E206E28652C742C6E297B666F722876617220722C69';
wwv_flow_imp.g_varchar2_table(681) := '2C6F3D3326652E6C656E6774682C613D652E6C656E6774682D6F2C733D6E2C6C3D333433323931383335332C643D3436313834353930372C633D303B633C613B29693D32353526652E63686172436F646541742863297C2832353526652E63686172436F';
wwv_flow_imp.g_varchar2_table(682) := '64654174282B2B6329293C3C387C2832353526652E63686172436F64654174282B2B6329293C3C31367C2832353526652E63686172436F64654174282B2B6329293C3C32342C2B2B632C733D32373439322B2836353533352628723D352A283635353335';
wwv_flow_imp.g_varchar2_table(683) := '2628733D28735E3D693D2836353533352628693D28693D2836353533352669292A6C2B282828693E3E3E3136292A6C263635353335293C3C3136292634323934393637323935293C3C31357C693E3E3E313729292A642B282828693E3E3E3136292A6426';
wwv_flow_imp.g_varchar2_table(684) := '3635353335293C3C3136292634323934393637323935293C3C31337C733E3E3E313929292B2828352A28733E3E3E313629263635353335293C3C313629263432393439363732393529292B282828723E3E3E3136292B3538393634263635353335293C3C';
wwv_flow_imp.g_varchar2_table(685) := '3136293B73776974636828693D302C6F297B6361736520333A695E3D2832353526652E63686172436F6465417428632B3229293C3C31363B6361736520323A695E3D2832353526652E63686172436F6465417428632B3129293C3C383B6361736520313A';
wwv_flow_imp.g_varchar2_table(686) := '735E3D693D2836353533352628693D28693D2836353533352628695E3D32353526652E63686172436F6465417428632929292A6C2B282828693E3E3E3136292A6C263635353335293C3C3136292634323934393637323935293C3C31357C693E3E3E3137';
wwv_flow_imp.g_varchar2_table(687) := '29292A642B282828693E3E3E3136292A64263635353335293C3C31362926343239343936373239357D72657475726E20735E3D652E6C656E6774682C733D323234363832323530372A2836353533352628735E3D733E3E3E313629292B28283232343638';
wwv_flow_imp.g_varchar2_table(688) := '32323530372A28733E3E3E313629263635353335293C3C31362926343239343936373239352C733D333236363438393930392A2836353533352628735E3D733E3E3E313329292B2828333236363438393930392A28733E3E3E313629263635353335293C';
wwv_flow_imp.g_varchar2_table(689) := '3C31362926343239343936373239352C735E3D733E3E3E31362C743F282230303030303030222B28733E3E3E30292E746F537472696E6728313629292E737562737472282D38293A733E3E3E307D72657475726E20652E75692E66616E6379747265652E';
wwv_flow_imp.g_varchar2_table(690) := '5F46616E6379747265654E6F6465436C6173732E70726F746F747970652E676574436C6F6E654C6973743D66756E6374696F6E2874297B766172206E2C723D746869732E747265652C693D722E7265664D61705B746869732E7265664B65795D7C7C6E75';
wwv_flow_imp.g_varchar2_table(691) := '6C6C2C6F3D722E6B65794D61703B72657475726E20692626286E3D746869732E6B65792C743F693D652E6D617028692C66756E6374696F6E2865297B72657475726E206F5B655D7D293A28693D652E6D617028692C66756E6374696F6E2865297B726574';
wwv_flow_imp.g_varchar2_table(692) := '75726E20653D3D3D6E3F6E756C6C3A6F5B655D7D29292E6C656E6774683C31262628693D6E756C6C29292C697D2C652E75692E66616E6379747265652E5F46616E6379747265654E6F6465436C6173732E70726F746F747970652E6973436C6F6E653D66';
wwv_flow_imp.g_varchar2_table(693) := '756E6374696F6E28297B76617220653D746869732E7265664B65797C7C6E756C6C2C743D652626746869732E747265652E7265664D61705B655D7C7C6E756C6C3B72657475726E212128742626742E6C656E6774683E31297D2C652E75692E66616E6379';
wwv_flow_imp.g_varchar2_table(694) := '747265652E5F46616E6379747265654E6F6465436C6173732E70726F746F747970652E726552656769737465723D66756E6374696F6E28742C6E297B743D6E756C6C3D3D743F6E756C6C3A22222B742C6E3D6E756C6C3D3D6E3F6E756C6C3A22222B6E3B';
wwv_flow_imp.g_varchar2_table(695) := '76617220723D746869732E747265652C693D746869732E6B65792C6F3D746869732E7265664B65792C613D722E6B65794D61702C733D722E7265664D61702C6C3D735B6F5D7C7C6E756C6C2C643D21313B72657475726E206E756C6C213D74262674213D';
wwv_flow_imp.g_varchar2_table(696) := '3D746869732E6B6579262628615B745D2626652E6572726F7228225B6578742D636C6F6E65735D207265526567697374657228222B742B22293A20616C7265616479206578697374733A20222B74686973292C64656C65746520615B695D2C615B745D3D';
wwv_flow_imp.g_varchar2_table(697) := '746869732C6C262628735B6F5D3D652E6D6170286C2C66756E6374696F6E2865297B72657475726E20653D3D3D693F743A657D29292C746869732E6B65793D742C643D2130292C6E756C6C213D6E26266E213D3D746869732E7265664B65792626286C26';
wwv_flow_imp.g_varchar2_table(698) := '2628313D3D3D6C2E6C656E6774683F64656C65746520735B6F5D3A735B6F5D3D652E6D6170286C2C66756E6374696F6E2865297B72657475726E20653D3D3D693F6E756C6C3A657D29292C735B6E5D3F735B6E5D2E617070656E642874293A735B6E5D3D';
wwv_flow_imp.g_varchar2_table(699) := '5B746869732E6B65795D2C746869732E7265664B65793D6E2C643D2130292C647D2C652E75692E66616E6379747265652E5F46616E6379747265654E6F6465436C6173732E70726F746F747970652E7365745265664B65793D66756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(700) := '7B72657475726E20746869732E72655265676973746572286E756C6C2C65297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E6765744E6F64657342795265663D66756E6374696F6E28742C6E';
wwv_flow_imp.g_varchar2_table(701) := '297B76617220723D746869732E6B65794D61702C693D746869732E7265664D61705B745D7C7C6E756C6C3B72657475726E2069262628693D6E3F652E6D617028692C66756E6374696F6E2865297B76617220743D725B655D3B72657475726E20742E6973';
wwv_flow_imp.g_varchar2_table(702) := '44657363656E64616E744F66286E293F743A6E756C6C7D293A652E6D617028692C66756E6374696F6E2865297B72657475726E20725B655D7D29292E6C656E6774683C31262628693D6E756C6C292C697D2C652E75692E66616E6379747265652E5F4661';
wwv_flow_imp.g_varchar2_table(703) := '6E637974726565436C6173732E70726F746F747970652E6368616E67655265664B65793D66756E6374696F6E28652C74297B766172206E2C723D746869732E6B65794D61702C693D746869732E7265664D61705B655D7C7C6E756C6C3B69662869297B66';
wwv_flow_imp.g_varchar2_table(704) := '6F72286E3D303B6E3C692E6C656E6774683B6E2B2B29725B695B6E5D5D2E7265664B65793D743B64656C65746520746869732E7265664D61705B655D2C746869732E7265664D61705B745D3D697D7D2C652E75692E66616E6379747265652E7265676973';
wwv_flow_imp.g_varchar2_table(705) := '746572457874656E73696F6E287B6E616D653A22636C6F6E6573222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B686967686C69676874416374697665436C6F6E65733A21302C686967686C69676874436C6F6E65733A21317D2C74';
wwv_flow_imp.g_varchar2_table(706) := '7265654372656174653A66756E6374696F6E2865297B746869732E5F73757065724170706C7928617267756D656E7473292C652E747265652E7265664D61703D7B7D2C652E747265652E6B65794D61703D7B7D7D2C74726565496E69743A66756E637469';
wwv_flow_imp.g_varchar2_table(707) := '6F6E2872297B746869732E24636F6E7461696E65722E616464436C617373282266616E6379747265652D6578742D636C6F6E657322292C74286E756C6C3D3D722E6F7074696F6E732E64656661756C744B6579292C722E6F7074696F6E732E6465666175';
wwv_flow_imp.g_varchar2_table(708) := '6C744B65793D66756E6374696F6E2874297B72657475726E2066756E6374696F6E2874297B76617220722C693D652E6D617028742E676574506172656E744C6973742821312C2130292C66756E6374696F6E2865297B72657475726E20652E7265664B65';
wwv_flow_imp.g_varchar2_table(709) := '797C7C652E6B65797D293B72657475726E2269645F222B28723D6E28693D692E6A6F696E28222F22292C213029292B6E28722B692C2130297D2874297D2C746869732E5F73757065724170706C7928617267756D656E7473297D2C74726565436C656172';
wwv_flow_imp.g_varchar2_table(710) := '3A66756E6374696F6E2865297B72657475726E20652E747265652E7265664D61703D7B7D2C652E747265652E6B65794D61703D7B7D2C746869732E5F73757065724170706C7928617267756D656E7473297D2C7472656552656769737465724E6F64653A';
wwv_flow_imp.g_varchar2_table(711) := '66756E6374696F6E286E2C722C69297B766172206F2C612C733D6E2E747265652C6C3D732E6B65794D61702C643D732E7265664D61702C633D692E6B65792C753D6926266E756C6C213D692E7265664B65793F22222B692E7265664B65793A6E756C6C3B';
wwv_flow_imp.g_varchar2_table(712) := '696628692E69735374617475734E6F646528292972657475726E20746869732E5F7375706572286E2C722C69293B69662872297B6966286E756C6C213D6C5B692E6B65795D297B76617220663D6C5B692E6B65795D2C703D22636C6F6E65732E74726565';
wwv_flow_imp.g_varchar2_table(713) := '52656769737465724E6F64653A206475706C6963617465206B65792027222B692E6B65792B22273A202F222B692E67657450617468282130292B22203D3E20222B662E67657450617468282130293B732E6572726F722870292C652E6572726F72287029';
wwv_flow_imp.g_varchar2_table(714) := '7D6C5B635D3D692C75262628286F3D645B755D293F286F2E707573682863292C323D3D3D6F2E6C656E67746826266E2E6F7074696F6E732E636C6F6E65732E686967686C69676874436C6F6E657326266C5B6F5B305D5D2E72656E646572537461747573';
wwv_flow_imp.g_varchar2_table(715) := '2829293A645B755D3D5B635D297D656C7365206E756C6C3D3D6C5B635D2626652E6572726F722822636C6F6E65732E7472656552656769737465724E6F64653A206E6F64652E6B6579206E6F7420726567697374657265643A20222B692E6B6579292C64';
wwv_flow_imp.g_varchar2_table(716) := '656C657465206C5B635D2C752626286F3D645B755D2926262828613D6F2E6C656E677468293C3D313F287428313D3D3D61292C74286F5B305D3D3D3D63292C64656C65746520645B755D293A282166756E6374696F6E28652C74297B766172206E3B666F';
wwv_flow_imp.g_varchar2_table(717) := '72286E3D652E6C656E6774682D313B6E3E3D303B6E2D2D29696628655B6E5D3D3D3D742972657475726E20652E73706C696365286E2C31292C21307D286F2C63292C323D3D3D6126266E2E6F7074696F6E732E636C6F6E65732E686967686C6967687443';
wwv_flow_imp.g_varchar2_table(718) := '6C6F6E657326266C5B6F5B305D5D2E72656E646572537461747573282929293B72657475726E20746869732E5F7375706572286E2C722C69297D2C6E6F646552656E6465725374617475733A66756E6374696F6E2874297B766172206E2C722C693D742E';
wwv_flow_imp.g_varchar2_table(719) := '6E6F64653B72657475726E20723D746869732E5F73757065722874292C742E6F7074696F6E732E636C6F6E65732E686967686C69676874436C6F6E65732626286E3D6528695B742E747265652E737461747573436C61737350726F704E616D655D29292E';
wwv_flow_imp.g_varchar2_table(720) := '6C656E6774682626692E6973436C6F6E65282926266E2E616464436C617373282266616E6379747265652D636C6F6E6522292C727D2C6E6F64655365744163746976653A66756E6374696F6E28742C6E2C72297B76617220692C6F3D742E747265652E73';
wwv_flow_imp.g_varchar2_table(721) := '7461747573436C61737350726F704E616D652C613D742E6E6F64653B72657475726E20693D746869732E5F73757065724170706C7928617267756D656E7473292C742E6F7074696F6E732E636C6F6E65732E686967686C69676874416374697665436C6F';
wwv_flow_imp.g_varchar2_table(722) := '6E65732626612E6973436C6F6E6528292626652E6561636828612E676574436C6F6E654C697374282130292C66756E6374696F6E28742C72297B6528725B6F5D292E746F67676C65436C617373282266616E6379747265652D6163746976652D636C6F6E';
wwv_flow_imp.g_varchar2_table(723) := '65222C2131213D3D6E297D292C697D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E646E642E6A730A202A0A202A20447261672D616E642D64726F7020737570706F727420286A517565';
wwv_flow_imp.g_varchar2_table(724) := '727920554920647261676761626C652F64726F707061626C65292E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66';
wwv_flow_imp.g_varchar2_table(725) := '616E6379747265652F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865';
wwv_flow_imp.g_varchar2_table(726) := '204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A2040646174652032';
wwv_flow_imp.g_varchar2_table(727) := '3032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C226A71756572792D75';
wwv_flow_imp.g_varchar2_table(728) := '692F75692F776964676574732F647261676761626C65222C226A71756572792D75692F75692F776964676574732F64726F707061626C65222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D';
wwv_flow_imp.g_varchar2_table(729) := '6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D';
wwv_flow_imp.g_varchar2_table(730) := '2866756E6374696F6E2865297B2275736520737472696374223B76617220743D21312C6E3D2266616E6379747265652D64726F702D616363657074222C723D2266616E6379747265652D64726F702D6166746572222C693D2266616E6379747265652D64';
wwv_flow_imp.g_varchar2_table(731) := '726F702D6265666F7265222C6F3D2266616E6379747265652D64726F702D72656A656374223B66756E6374696F6E20612865297B72657475726E20303D3D3D653F22223A653E303F222B222B653A22222B657D66756E6374696F6E2073286E297B766172';
wwv_flow_imp.g_varchar2_table(732) := '20723D6E2E6F7074696F6E732E646E647C7C6E756C6C2C693D6E2E6F7074696F6E732E676C7970687C7C6E756C6C3B72262628747C7C28652E75692E706C7567696E2E6164642822647261676761626C65222C22636F6E6E656374546F46616E63797472';
wwv_flow_imp.g_varchar2_table(733) := '6565222C7B73746172743A66756E6374696F6E28742C6E297B76617220723D652874686973292E64617461282275692D647261676761626C6522297C7C652874686973292E646174612822647261676761626C6522292C693D6E2E68656C7065722E6461';
wwv_flow_imp.g_varchar2_table(734) := '746128226674536F757263654E6F646522297C7C6E756C6C3B696628692972657475726E20722E6F66667365742E636C69636B2E746F703D2D322C722E6F66667365742E636C69636B2E6C6566743D31362C692E747265652E6578742E646E642E5F6F6E';
wwv_flow_imp.g_varchar2_table(735) := '447261674576656E7428227374617274222C692C6E756C6C2C742C6E2C72297D2C647261673A66756E6374696F6E28742C6E297B76617220722C693D652874686973292E64617461282275692D647261676761626C6522297C7C652874686973292E6461';
wwv_flow_imp.g_varchar2_table(736) := '74612822647261676761626C6522292C6F3D6E2E68656C7065722E6461746128226674536F757263654E6F646522297C7C6E756C6C2C613D6E2E68656C7065722E64617461282266745461726765744E6F646522297C7C6E756C6C2C733D652E75692E66';
wwv_flow_imp.g_varchar2_table(737) := '616E6379747265652E6765744E6F646528742E746172676574292C6C3D6F26266F2E747265652E6F7074696F6E732E646E643B742E7461726765742626217326266528742E746172676574292E636C6F7365737428226469762E66616E6379747265652D';
wwv_flow_imp.g_varchar2_table(738) := '647261672D68656C7065722C2366616E6379747265652D64726F702D6D61726B657222292E6C656E6774683E303F286F7C7C617C7C652E75692E66616E637974726565292E6465627567282244726167206576656E74206F7665722068656C7065723A20';
wwv_flow_imp.g_varchar2_table(739) := '69676E6F7265642E22293A286E2E68656C7065722E64617461282266745461726765744E6F6465222C73292C6C26266C2E75706461746548656C706572262628723D6F2E747265652E5F6D616B65486F6F6B436F6E74657874286F2C742C7B6F74686572';
wwv_flow_imp.g_varchar2_table(740) := '4E6F64653A732C75693A6E2C647261676761626C653A692C64726F704D61726B65723A6528222366616E6379747265652D64726F702D6D61726B657222297D292C6C2E75706461746548656C7065722E63616C6C286F2E747265652C6F2C7229292C6126';
wwv_flow_imp.g_varchar2_table(741) := '2661213D3D732626612E747265652E6578742E646E642E5F6F6E447261674576656E7428226C65617665222C612C6F2C742C6E2C69292C732626732E747265652E6F7074696F6E732E646E642E6472616744726F70262628733D3D3D617C7C732E747265';
wwv_flow_imp.g_varchar2_table(742) := '652E6578742E646E642E5F6F6E447261674576656E742822656E746572222C732C6F2C742C6E2C69292C732E747265652E6578742E646E642E5F6F6E447261674576656E7428226F766572222C732C6F2C742C6E2C692929297D2C73746F703A66756E63';
wwv_flow_imp.g_varchar2_table(743) := '74696F6E28742C6E297B76617220723D652874686973292E64617461282275692D647261676761626C6522297C7C652874686973292E646174612822647261676761626C6522292C693D6E2E68656C7065722E6461746128226674536F757263654E6F64';
wwv_flow_imp.g_varchar2_table(744) := '6522297C7C6E756C6C2C6F3D6E2E68656C7065722E64617461282266745461726765744E6F646522297C7C6E756C6C2C613D226D6F7573657570223D3D3D742E747970652626313D3D3D742E77686963683B617C7C28697C7C6F7C7C652E75692E66616E';
wwv_flow_imp.g_varchar2_table(745) := '637974726565292E6465627567282244726167207761732063616E63656C6C656422292C6F2626286126266F2E747265652E6578742E646E642E5F6F6E447261674576656E74282264726F70222C6F2C692C742C6E2C72292C6F2E747265652E6578742E';
wwv_flow_imp.g_varchar2_table(746) := '646E642E5F6F6E447261674576656E7428226C65617665222C6F2C692C742C6E2C7229292C692626692E747265652E6578742E646E642E5F6F6E447261674576656E74282273746F70222C692C6E756C6C2C742C6E2C72297D7D292C743D213029292C72';
wwv_flow_imp.g_varchar2_table(747) := '2626722E64726167537461727426266E2E7769646765742E656C656D656E742E647261676761626C6528652E657874656E64287B616464436C61737365733A21312C617070656E64546F3A6E2E24636F6E7461696E65722C636F6E7461696E6D656E743A';
wwv_flow_imp.g_varchar2_table(748) := '21312C64656C61793A302C64697374616E63653A342C7265766572743A21312C7363726F6C6C3A21302C7363726F6C6C53706565643A372C7363726F6C6C53656E73697469766974793A31302C636F6E6E656374546F46616E6379747265653A21302C68';
wwv_flow_imp.g_varchar2_table(749) := '656C7065723A66756E6374696F6E2874297B766172206E2C722C6F2C613D652E75692E66616E6379747265652E6765744E6F646528742E746172676574293B72657475726E20613F286F3D612E747265652E6F7074696F6E732E646E642C723D6528612E';
wwv_flow_imp.g_varchar2_table(750) := '7370616E292C286E3D6528223C64697620636C6173733D2766616E6379747265652D647261672D68656C706572273E3C7370616E20636C6173733D2766616E6379747265652D647261672D68656C7065722D696D6727202F3E3C2F6469763E22292E6373';
wwv_flow_imp.g_varchar2_table(751) := '73287B7A496E6465783A332C706F736974696F6E3A2272656C6174697665227D292E617070656E6428722E66696E6428227370616E2E66616E6379747265652D7469746C6522292E636C6F6E65282929292E6461746128226674536F757263654E6F6465';
wwv_flow_imp.g_varchar2_table(752) := '222C61292C6926266E2E66696E6428222E66616E6379747265652D647261672D68656C7065722D696D6722292E616464436C61737328692E6D61702E5F616464436C6173732B2220222B692E6D61702E6472616748656C706572292C6F2E696E69744865';
wwv_flow_imp.g_varchar2_table(753) := '6C70657226266F2E696E697448656C7065722E63616C6C28612E747265652C612C7B6E6F64653A612C747265653A612E747265652C6F726967696E616C4576656E743A742C75693A7B68656C7065723A6E7D7D292C6E293A223C6469763E4552524F523F';
wwv_flow_imp.g_varchar2_table(754) := '3A2068656C706572207265717565737465642062757420736F757263654E6F6465206E6F7420666F756E643C2F6469763E227D2C73746172743A66756E6374696F6E28652C74297B72657475726E2121742E68656C7065722E6461746128226674536F75';
wwv_flow_imp.g_varchar2_table(755) := '7263654E6F646522297D7D2C6E2E6F7074696F6E732E646E642E647261676761626C6529292C722626722E6472616744726F7026266E2E7769646765742E656C656D656E742E64726F707061626C6528652E657874656E64287B616464436C6173736573';
wwv_flow_imp.g_varchar2_table(756) := '3A21312C746F6C6572616E63653A22696E74657273656374222C6772656564793A21317D2C6E2E6F7074696F6E732E646E642E64726F707061626C6529297D72657475726E20652E75692E66616E6379747265652E7265676973746572457874656E7369';
wwv_flow_imp.g_varchar2_table(757) := '6F6E287B6E616D653A22646E64222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B6175746F457870616E644D533A3165332C647261676761626C653A6E756C6C2C64726F707061626C653A6E756C6C2C666F6375734F6E436C69636B';
wwv_flow_imp.g_varchar2_table(758) := '3A21312C70726576656E74566F69644D6F7665733A21302C70726576656E745265637572736976654D6F7665733A21302C736D6172745265766572743A21302C64726F704D61726B65724F6666736574583A2D32342C64726F704D61726B6572496E7365';
wwv_flow_imp.g_varchar2_table(759) := '72744F6666736574583A2D31362C6472616753746172743A6E756C6C2C6472616753746F703A6E756C6C2C696E697448656C7065723A6E756C6C2C75706461746548656C7065723A6E756C6C2C64726167456E7465723A6E756C6C2C647261674F766572';
wwv_flow_imp.g_varchar2_table(760) := '3A6E756C6C2C64726167457870616E643A6E756C6C2C6472616744726F703A6E756C6C2C647261674C656176653A6E756C6C7D2C74726565496E69743A66756E6374696F6E2874297B766172206E3D742E747265653B746869732E5F7375706572417070';
wwv_flow_imp.g_varchar2_table(761) := '6C7928617267756D656E7473292C6E2E6F7074696F6E732E646E642E64726167537461727426266E2E24636F6E7461696E65722E6F6E28226D6F757365646F776E222C66756E6374696F6E286E297B696628742E6F7074696F6E732E646E642E666F6375';
wwv_flow_imp.g_varchar2_table(762) := '734F6E436C69636B297B76617220723D652E75692E66616E6379747265652E6765744E6F6465286E293B722626722E6465627567282252652D656E61626C6520666F6375732074686174207761732070726576656E746564206279206A51756572792055';
wwv_flow_imp.g_varchar2_table(763) := '4920647261676761626C652E22292C73657454696D656F75742866756E6374696F6E28297B65286E2E746172676574292E636C6F7365737428223A7461626261626C6522292E747269676765722822666F63757322297D2C3130297D7D292C73286E297D';
wwv_flow_imp.g_varchar2_table(764) := '2C5F736574446E645374617475733A66756E6374696F6E28742C732C6C2C642C63297B76617220752C662C703D2263656E746572222C683D746869732E5F6C6F63616C2C673D746869732E6F7074696F6E732E646E642C793D746869732E6F7074696F6E';
wwv_flow_imp.g_varchar2_table(765) := '732E676C7970682C763D743F6528742E7370616E293A6E756C6C2C6D3D6528732E7370616E292C783D6D2E66696E6428227370616E2E66616E6379747265652D7469746C6522293B696628682E2464726F704D61726B65727C7C28682E2464726F704D61';
wwv_flow_imp.g_varchar2_table(766) := '726B65723D6528223C6469762069643D2766616E6379747265652D64726F702D6D61726B6572273E3C2F6469763E22292E6869646528292E637373287B227A2D696E646578223A3165337D292E70726570656E64546F286528746869732E24646976292E';
wwv_flow_imp.g_varchar2_table(767) := '706172656E742829292C792626682E2464726F704D61726B65722E616464436C61737328792E6D61702E5F616464436C6173732B2220222B792E6D61702E64726F704D61726B657229292C226166746572223D3D3D647C7C226265666F7265223D3D3D64';
wwv_flow_imp.g_varchar2_table(768) := '7C7C226F766572223D3D3D64297B73776974636828753D672E64726F704D61726B65724F6666736574587C7C302C64297B63617365226265666F7265223A703D22746F70222C752B3D672E64726F704D61726B6572496E736572744F6666736574587C7C';
wwv_flow_imp.g_varchar2_table(769) := '303B627265616B3B63617365226166746572223A703D22626F74746F6D222C752B3D672E64726F704D61726B6572496E736572744F6666736574587C7C307D663D7B6D793A226C656674222B612875292B222063656E746572222C61743A226C65667420';
wwv_flow_imp.g_varchar2_table(770) := '222B702C6F663A787D2C746869732E6F7074696F6E732E72746C262628662E6D793D227269676874222B61282D75292B222063656E746572222C662E61743D22726967687420222B70292C682E2464726F704D61726B65722E746F67676C65436C617373';
wwv_flow_imp.g_varchar2_table(771) := '28722C226166746572223D3D3D64292E746F67676C65436C617373282266616E6379747265652D64726F702D6F766572222C226F766572223D3D3D64292E746F67676C65436C61737328692C226265666F7265223D3D3D64292E746F67676C65436C6173';
wwv_flow_imp.g_varchar2_table(772) := '73282266616E6379747265652D72746C222C2121746869732E6F7074696F6E732E72746C292E73686F7728292E706F736974696F6E28652E75692E66616E6379747265652E666978506F736974696F6E4F7074696F6E73286629297D656C736520682E24';
wwv_flow_imp.g_varchar2_table(773) := '64726F704D61726B65722E6869646528293B762626762E746F67676C65436C617373286E2C21303D3D3D63292E746F67676C65436C617373286F2C21313D3D3D63292C6D2E746F67676C65436C617373282266616E6379747265652D64726F702D746172';
wwv_flow_imp.g_varchar2_table(774) := '676574222C226166746572223D3D3D647C7C226265666F7265223D3D3D647C7C226F766572223D3D3D64292E746F67676C65436C61737328722C226166746572223D3D3D64292E746F67676C65436C61737328692C226265666F7265223D3D3D64292E74';
wwv_flow_imp.g_varchar2_table(775) := '6F67676C65436C617373286E2C21303D3D3D63292E746F67676C65436C617373286F2C21313D3D3D63292C6C2E746F67676C65436C617373286E2C21303D3D3D63292E746F67676C65436C617373286F2C21313D3D3D63297D2C5F6F6E44726167457665';
wwv_flow_imp.g_varchar2_table(776) := '6E743A66756E6374696F6E28742C6E2C722C692C6F2C61297B76617220732C6C2C642C632C752C662C702C682C672C793D746869732E6F7074696F6E732E646E642C763D746869732E5F6D616B65486F6F6B436F6E74657874286E2C692C7B6F74686572';
wwv_flow_imp.g_varchar2_table(777) := '4E6F64653A722C75693A6F2C647261676761626C653A617D292C6D3D6E756C6C2C783D746869732C623D65286E2E7370616E293B73776974636828792E736D617274526576657274262628612E6F7074696F6E732E7265766572743D22696E76616C6964';
wwv_flow_imp.g_varchar2_table(778) := '22292C74297B63617365227374617274223A6E2E69735374617475734E6F646528293F6D3D21313A792E6472616753746172742626286D3D792E647261675374617274286E2C7629292C21313D3D3D6D3F28746869732E64656275672822747265652E64';
wwv_flow_imp.g_varchar2_table(779) := '726167537461727428292063616E63656C6C656422292C6F2E68656C7065722E7472696767657228226D6F757365757022292E686964652829293A28792E736D617274526576657274262628633D6E5B762E747265652E6E6F6465436F6E7461696E6572';
wwv_flow_imp.g_varchar2_table(780) := '417474724E616D655D2E676574426F756E64696E67436C69656E745265637428292C643D6528612E6F7074696F6E732E617070656E64546F295B305D2E676574426F756E64696E67436C69656E745265637428292C612E6F726967696E616C506F736974';
wwv_flow_imp.g_varchar2_table(781) := '696F6E2E6C6566743D4D6174682E6D617828302C632E6C6566742D642E6C656674292C612E6F726967696E616C506F736974696F6E2E746F703D4D6174682E6D617828302C632E746F702D642E746F7029292C622E616464436C617373282266616E6379';
wwv_flow_imp.g_varchar2_table(782) := '747265652D647261672D736F7572636522292C6528646F63756D656E74292E6F6E28226B6579646F776E2E66616E6379747265652D646E642C6D6F757365646F776E2E66616E6379747265652D646E64222C66756E6374696F6E2874297B28226B657964';
wwv_flow_imp.g_varchar2_table(783) := '6F776E223D3D3D742E747970652626742E77686963683D3D3D652E75692E6B6579436F64652E4553434150457C7C226D6F757365646F776E223D3D3D742E74797065292626782E6578742E646E642E5F63616E63656C4472616728297D29293B62726561';
wwv_flow_imp.g_varchar2_table(784) := '6B3B6361736522656E746572223A6D3D212128673D2821792E70726576656E745265637572736976654D6F7665737C7C216E2E697344657363656E64616E744F6628722929262628792E64726167456E7465723F792E64726167456E746572286E2C7629';
wwv_flow_imp.g_varchar2_table(785) := '3A6E756C6C292926262841727261792E697341727261792867293F7B6F7665723A652E696E417272617928226F766572222C67293E3D302C6265666F72653A652E696E417272617928226265666F7265222C67293E3D302C61667465723A652E696E4172';
wwv_flow_imp.g_varchar2_table(786) := '72617928226166746572222C67293E3D307D3A7B6F7665723A21303D3D3D677C7C226F766572223D3D3D672C6265666F72653A21303D3D3D677C7C226265666F7265223D3D3D672C61667465723A21303D3D3D677C7C226166746572223D3D3D677D292C';
wwv_flow_imp.g_varchar2_table(787) := '6F2E68656C7065722E646174612822656E746572526573706F6E7365222C6D293B627265616B3B63617365226F766572223A683D6E756C6C2C21313D3D3D28703D6F2E68656C7065722E646174612822656E746572526573706F6E73652229297C7C2822';
wwv_flow_imp.g_varchar2_table(788) := '737472696E67223D3D747970656F6620703F683D703A286C3D622E6F666673657428292C663D7B783A28753D7B783A692E70616765582D6C2E6C6566742C793A692E70616765592D6C2E746F707D292E782F622E776964746828292C793A752E792F622E';
wwv_flow_imp.g_varchar2_table(789) := '68656967687428297D2C702E61667465722626662E793E2E37357C7C21702E6F7665722626702E61667465722626662E793E2E353F683D226166746572223A702E6265666F72652626662E793C3D2E32357C7C21702E6F7665722626702E6265666F7265';
wwv_flow_imp.g_varchar2_table(790) := '2626662E793C3D2E353F683D226265666F7265223A702E6F766572262628683D226F76657222292C792E70726576656E74566F69644D6F7665732626286E3D3D3D723F28746869732E646562756728222020202064726F70206F76657220736F75726365';
wwv_flow_imp.g_varchar2_table(791) := '206E6F64652070726576656E74656422292C683D6E756C6C293A226265666F7265223D3D3D6826267226266E3D3D3D722E6765744E6578745369626C696E6728293F28746869732E646562756728222020202064726F7020616674657220736F75726365';
wwv_flow_imp.g_varchar2_table(792) := '206E6F64652070726576656E74656422292C683D6E756C6C293A226166746572223D3D3D6826267226266E3D3D3D722E676574507265765369626C696E6728293F28746869732E646562756728222020202064726F70206265666F726520736F75726365';
wwv_flow_imp.g_varchar2_table(793) := '206E6F64652070726576656E74656422292C683D6E756C6C293A226F766572223D3D3D682626722626722E706172656E743D3D3D6E2626722E69734C6173745369626C696E672829262628746869732E646562756728222020202064726F70206C617374';
wwv_flow_imp.g_varchar2_table(794) := '206368696C64206F766572206F776E20706172656E742070726576656E74656422292C683D6E756C6C29292C6F2E68656C7065722E6461746128226869744D6F6465222C682929292C226265666F7265223D3D3D687C7C226166746572223D3D3D687C7C';
wwv_flow_imp.g_varchar2_table(795) := '21792E6175746F457870616E644D537C7C21313D3D3D6E2E6861734368696C6472656E28297C7C6E2E657870616E6465647C7C792E64726167457870616E64262621313D3D3D792E64726167457870616E64286E2C76297C7C6E2E7363686564756C6541';
wwv_flow_imp.g_varchar2_table(796) := '6374696F6E2822657870616E64222C792E6175746F457870616E644D53292C682626792E647261674F766572262628762E6869744D6F64653D682C6D3D792E647261674F766572286E2C7629292C733D2131213D3D6D26266E756C6C213D3D682C792E73';
wwv_flow_imp.g_varchar2_table(797) := '6D617274526576657274262628612E6F7074696F6E732E7265766572743D2173292C746869732E5F6C6F63616C2E5F736574446E6453746174757328722C6E2C6F2E68656C7065722C682C73293B627265616B3B636173652264726F70223A28683D6F2E';
wwv_flow_imp.g_varchar2_table(798) := '68656C7065722E6461746128226869744D6F64652229292626792E6472616744726F70262628762E6869744D6F64653D682C792E6472616744726F70286E2C7629293B627265616B3B63617365226C65617665223A6E2E7363686564756C65416374696F';
wwv_flow_imp.g_varchar2_table(799) := '6E282263616E63656C22292C6F2E68656C7065722E646174612822656E746572526573706F6E7365222C6E756C6C292C6F2E68656C7065722E6461746128226869744D6F6465222C6E756C6C292C746869732E5F6C6F63616C2E5F736574446E64537461';
wwv_flow_imp.g_varchar2_table(800) := '74757328722C6E2C6F2E68656C7065722C226F7574222C766F69642030292C792E647261674C656176652626792E647261674C65617665286E2C76293B627265616B3B636173652273746F70223A622E72656D6F7665436C617373282266616E63797472';
wwv_flow_imp.g_varchar2_table(801) := '65652D647261672D736F7572636522292C6528646F63756D656E74292E6F666628222E66616E6379747265652D646E6422292C792E6472616753746F702626792E6472616753746F70286E2C76293B627265616B3B64656661756C743A652E6572726F72';
wwv_flow_imp.g_varchar2_table(802) := '2822556E737570706F727465642064726167206576656E743A20222B74297D72657475726E206D7D2C5F63616E63656C447261673A66756E6374696F6E28297B76617220743D652E75692E64646D616E616765722E63757272656E743B742626742E6361';
wwv_flow_imp.g_varchar2_table(803) := '6E63656C28297D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E646E64352E6A730A202A0A202A20447261672D616E642D64726F7020737570706F727420286E61746976652048544D4C';
wwv_flow_imp.g_varchar2_table(804) := '35292E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F7079726967';
wwv_flow_imp.g_varchar2_table(805) := '68742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F';
wwv_flow_imp.g_varchar2_table(806) := '6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A';
wwv_flow_imp.g_varchar2_table(807) := '66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A65637422';
wwv_flow_imp.g_varchar2_table(808) := '3D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A';
wwv_flow_imp.g_varchar2_table(809) := '65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220742C6E2C723D652E75692E66616E6379747265652C693D2F4D61632F2E74657374286E6176696761746F722E706C6174666F726D292C6F3D2266616E';
wwv_flow_imp.g_varchar2_table(810) := '6379747265652D647261672D736F75726365222C613D2266616E6379747265652D647261672D72656D6F7665222C733D2266616E6379747265652D64726F702D616363657074222C6C3D2266616E6379747265652D64726F702D6166746572222C643D22';
wwv_flow_imp.g_varchar2_table(811) := '66616E6379747265652D64726F702D6265666F7265222C633D2266616E6379747265652D64726F702D6F766572222C753D2266616E6379747265652D64726F702D72656A656374222C663D226170706C69636174696F6E2F782D66616E6379747265652D';
wwv_flow_imp.g_varchar2_table(812) := '6E6F6465222C703D6E756C6C2C683D6E756C6C2C673D6E756C6C2C793D6E756C6C2C763D6E756C6C2C6D3D6E756C6C2C783D6E756C6C2C623D6E756C6C2C433D6E756C6C2C6B3D6E756C6C3B66756E6374696F6E207728297B763D6E756C6C2C6B3D6E75';
wwv_flow_imp.g_varchar2_table(813) := '6C6C2C783D6E756C6C2C623D6E756C6C2C6D3D6E756C6C2C683D6E756C6C2C673D6E756C6C2C792626792E72656D6F7665436C617373286F2B2220222B61292C793D6E756C6C2C702626702E6869646528292C6E2626286E2E72656D6F766528292C6E3D';
wwv_flow_imp.g_varchar2_table(814) := '6E756C6C297D66756E6374696F6E20532865297B72657475726E20303D3D3D653F22223A653E303F222B222B653A22222B657D66756E6374696F6E205F28652C74297B766172206E3D742E747265652C723D742E646174615472616E736665723B226472';
wwv_flow_imp.g_varchar2_table(815) := '61677374617274223D3D3D652E747970653F28742E656666656374416C6C6F7765643D6E2E6F7074696F6E732E646E64352E656666656374416C6C6F7765642C742E64726F704566666563743D6E2E6F7074696F6E732E646E64352E64726F7045666665';
wwv_flow_imp.g_varchar2_table(816) := '637444656661756C74293A28742E656666656374416C6C6F7765643D622C742E64726F704566666563743D78292C742E64726F704566666563745375676765737465643D66756E6374696F6E28652C742C6E297B76617220723D6E3B72657475726E2069';
wwv_flow_imp.g_varchar2_table(817) := '3F742E6D6574614B65792626742E616C744B65797C7C742E6374726C4B65793F723D226C696E6B223A742E6D6574614B65793F723D226D6F7665223A742E616C744B6579262628723D22636F707922293A742E6374726C4B65793F723D22636F7079223A';
wwv_flow_imp.g_varchar2_table(818) := '742E73686966744B65793F723D226D6F7665223A742E616C744B6579262628723D226C696E6B22292C72213D3D6D2626652E696E666F28226576616C4566666563744D6F646966696572733A20222B742E747970652B22202D206576616C456666656374';
wwv_flow_imp.g_varchar2_table(819) := '4D6F6469666965727328293A20222B6D2B22202D3E20222B72292C6D3D722C727D286E2C652C6E2E6F7074696F6E732E646E64352E64726F7045666665637444656661756C74292C742E69734D6F76653D226D6F7665223D3D3D742E64726F7045666665';
wwv_flow_imp.g_varchar2_table(820) := '63742C742E66696C65733D722E66696C65737C7C5B5D7D66756E6374696F6E204E28652C742C6E297B76617220723D742E747265652C693D742E646174615472616E736665723B72657475726E2264726167737461727422213D3D652E74797065262662';
wwv_flow_imp.g_varchar2_table(821) := '213D3D742E656666656374416C6C6F7765642626722E7761726E2822656666656374416C6C6F7765642073686F756C64206F6E6C79206265206368616E67656420696E20647261677374617274206576656E743A20222B652E747970652B223A20646174';
wwv_flow_imp.g_varchar2_table(822) := '612E656666656374416C6C6F776564206368616E6765642066726F6D20222B622B22202D3E20222B742E656666656374416C6C6F776564292C21313D3D3D6E262628722E696E666F28226170706C7944726F7045666665637443616C6C6261636B3A2061';
wwv_flow_imp.g_varchar2_table(823) := '6C6C6F7744726F70203D3D3D2066616C736522292C742E656666656374416C6C6F7765643D226E6F6E65222C742E64726F704566666563743D226E6F6E6522292C742E69734D6F76653D226D6F7665223D3D3D742E64726F704566666563742C22647261';
wwv_flow_imp.g_varchar2_table(824) := '677374617274223D3D3D652E74797065262628623D742E656666656374416C6C6F7765642C783D742E64726F70456666656374292C692E656666656374416C6C6F7765643D622C692E64726F704566666563743D782C787D66756E6374696F6E20452874';
wwv_flow_imp.g_varchar2_table(825) := '2C6E297B6966286E2E6F7074696F6E732E646E64352E7363726F6C6C262666756E6374696F6E28742C6E297B76617220722C692C6F3D742E6F7074696F6E732E646E64352C613D742E247363726F6C6C506172656E745B305D2C733D6F2E7363726F6C6C';
wwv_flow_imp.g_varchar2_table(826) := '53656E73697469766974792C6C3D6F2E7363726F6C6C53706565642C643D303B61213D3D646F63756D656E7426262248544D4C22213D3D612E7461674E616D653F28723D742E247363726F6C6C506172656E742E6F666673657428292C693D612E736372';
wwv_flow_imp.g_varchar2_table(827) := '6F6C6C546F702C722E746F702B612E6F66667365744865696768742D6E2E70616765593C733F612E7363726F6C6C4865696768742D742E247363726F6C6C506172656E742E696E6E657248656967687428292D693E30262628612E7363726F6C6C546F70';
wwv_flow_imp.g_varchar2_table(828) := '3D643D692B6C293A693E3026266E2E70616765592D722E746F703C73262628612E7363726F6C6C546F703D643D692D6C29293A28693D6528646F63756D656E74292E7363726F6C6C546F702829293E3026266E2E70616765592D693C733F28643D692D6C';
wwv_flow_imp.g_varchar2_table(829) := '2C6528646F63756D656E74292E7363726F6C6C546F70286429293A652877696E646F77292E68656967687428292D286E2E70616765592D69293C73262628643D692B6C2C6528646F63756D656E74292E7363726F6C6C546F70286429292C642626742E64';
wwv_flow_imp.g_varchar2_table(830) := '6562756728226175746F5363726F6C6C3A20222B642B22707822297D286E2E747265652C74292C216E2E6E6F64652972657475726E206E2E747265652E7761726E282249676E6F72656420647261676F76657220666F72206E6F6E2D6E6F646522292C43';
wwv_flow_imp.g_varchar2_table(831) := '3B76617220692C6F2C612C662C683D6E756C6C2C673D6E2E747265652C793D672E6F7074696F6E732C6D3D792E646E64352C783D6E2E6E6F64652C623D6E2E6F746865724E6F64652C6B3D2263656E746572222C773D6528782E7370616E292C453D772E';
wwv_flow_imp.g_varchar2_table(832) := '66696E6428227370616E2E66616E6379747265652D7469746C6522293B69662821313D3D3D762972657475726E20672E6465627567282249676E6F72656420647261676F7665722C2073696E63652064726167656E7465722072657475726E6564206661';
wwv_flow_imp.g_varchar2_table(833) := '6C73652E22292C21313B2822737472696E67223D3D747970656F6620762626652E6572726F722822617373657274206661696C65643A2064726167656E7465722072657475726E656420737472696E6722292C6F3D772E6F666673657428292C663D2874';
wwv_flow_imp.g_varchar2_table(834) := '2E70616765592D6F2E746F70292F772E68656967687428292C766F696420303D3D3D742E70616765592626672E7761726E28226576656E742E706167655920697320756E646566696E65643A207365652069737375652023313031332E22292C762E6166';
wwv_flow_imp.g_varchar2_table(835) := '7465722626663E2E37357C7C21762E6F7665722626762E61667465722626663E2E353F683D226166746572223A762E6265666F72652626663C3D2E32357C7C21762E6F7665722626762E6265666F72652626663C3D2E353F683D226265666F7265223A76';
wwv_flow_imp.g_varchar2_table(836) := '2E6F766572262628683D226F76657222292C6D2E70726576656E74566F69644D6F7665732626226D6F7665223D3D3D6E2E64726F70456666656374262628783D3D3D623F28782E6465627567282244726F70206F76657220736F75726365206E6F646520';
wwv_flow_imp.g_varchar2_table(837) := '70726576656E7465642E22292C683D6E756C6C293A226265666F7265223D3D3D682626622626783D3D3D622E6765744E6578745369626C696E6728293F28782E6465627567282244726F7020616674657220736F75726365206E6F64652070726576656E';
wwv_flow_imp.g_varchar2_table(838) := '7465642E22292C683D6E756C6C293A226166746572223D3D3D682626622626783D3D3D622E676574507265765369626C696E6728293F28782E6465627567282244726F70206265666F726520736F75726365206E6F64652070726576656E7465642E2229';
wwv_flow_imp.g_varchar2_table(839) := '2C683D6E756C6C293A226F766572223D3D3D682626622626622E706172656E743D3D3D782626622E69734C6173745369626C696E672829262628782E6465627567282244726F70206C617374206368696C64206F766572206F776E20706172656E742070';
wwv_flow_imp.g_varchar2_table(840) := '726576656E7465642E22292C683D6E756C6C29292C6E2E6869744D6F64653D682C6826266D2E647261674F766572292626285F28742C6E292C6D2E647261674F76657228782C6E292C4E28742C6E2C212168292C683D6E2E6869744D6F6465293B696628';
wwv_flow_imp.g_varchar2_table(841) := '433D682C226166746572223D3D3D687C7C226265666F7265223D3D3D687C7C226F766572223D3D3D68297B73776974636828693D6D2E64726F704D61726B65724F6666736574587C7C302C68297B63617365226265666F7265223A6B3D22746F70222C69';
wwv_flow_imp.g_varchar2_table(842) := '2B3D6D2E64726F704D61726B6572496E736572744F6666736574587C7C303B627265616B3B63617365226166746572223A6B3D22626F74746F6D222C692B3D6D2E64726F704D61726B6572496E736572744F6666736574587C7C307D613D7B6D793A226C';
wwv_flow_imp.g_varchar2_table(843) := '656674222B532869292B222063656E746572222C61743A226C65667420222B6B2C6F663A457D2C792E72746C262628612E6D793D227269676874222B53282D69292B222063656E746572222C612E61743D22726967687420222B6B292C702E746F67676C';
wwv_flow_imp.g_varchar2_table(844) := '65436C617373286C2C226166746572223D3D3D68292E746F67676C65436C61737328632C226F766572223D3D3D68292E746F67676C65436C61737328642C226265666F7265223D3D3D68292E73686F7728292E706F736974696F6E28722E666978506F73';
wwv_flow_imp.g_varchar2_table(845) := '6974696F6E4F7074696F6E73286129297D656C736520702E6869646528293B72657475726E206528782E7370616E292E746F67676C65436C617373282266616E6379747265652D64726F702D746172676574222C226166746572223D3D3D687C7C226265';
wwv_flow_imp.g_varchar2_table(846) := '666F7265223D3D3D687C7C226F766572223D3D3D68292E746F67676C65436C617373286C2C226166746572223D3D3D68292E746F67676C65436C61737328642C226265666F7265223D3D3D68292E746F67676C65436C61737328732C226F766572223D3D';
wwv_flow_imp.g_varchar2_table(847) := '3D68292E746F67676C65436C61737328752C21313D3D3D68292C687D66756E6374696F6E20442869297B76617220732C6C3D746869732C643D6C2E6F7074696F6E732E646E64352C633D722E6765744E6F64652869292C753D692E646174615472616E73';
wwv_flow_imp.g_varchar2_table(848) := '6665727C7C692E6F726967696E616C4576656E742E646174615472616E736665722C703D7B747265653A6C2C6E6F64653A632C6F7074696F6E733A6C2E6F7074696F6E732C6F726967696E616C4576656E743A692E6F726967696E616C4576656E742C77';
wwv_flow_imp.g_varchar2_table(849) := '69646765743A6C2E7769646765742C646174615472616E736665723A752C75736544656661756C74496D6167653A21302C64726F704566666563743A766F696420302C64726F704566666563745375676765737465643A766F696420302C656666656374';
wwv_flow_imp.g_varchar2_table(850) := '416C6C6F7765643A766F696420302C66696C65733A766F696420302C697343616E63656C6C65643A766F696420302C69734D6F76653A766F696420307D3B73776974636828692E74797065297B6361736522647261677374617274223A69662821632972';
wwv_flow_imp.g_varchar2_table(851) := '657475726E206C2E696E666F282249676E6F72656420647261677374617274206F6E2061206E6F6E2D6E6F64652E22292C21313B683D632C673D21313D3D3D642E6D756C7469536F757263653F5B635D3A21303D3D3D642E6D756C7469536F757263653F';
wwv_flow_imp.g_varchar2_table(852) := '632E697353656C656374656428293F6C2E67657453656C65637465644E6F64657328293A5B635D3A642E6D756C7469536F7572636528632C70292C28793D6528652E6D617028672C66756E6374696F6E2865297B72657475726E20652E7370616E7D2929';
wwv_flow_imp.g_varchar2_table(853) := '292E616464436C617373286F293B76617220763D632E746F446963742821302C642E736F75726365436F7079486F6F6B293B762E7472656549643D632E747265652E5F69642C733D4A534F4E2E737472696E676966792876293B7472797B752E73657444';
wwv_flow_imp.g_varchar2_table(854) := '61746128662C73292C752E736574446174612822746578742F68746D6C222C6528632E7370616E292E68746D6C2829292C752E736574446174612822746578742F706C61696E222C632E7469746C65297D63617463682865297B6C2E7761726E2822436F';
wwv_flow_imp.g_varchar2_table(855) := '756C64206E6F7420736574206461746120284945206F6E6C7920616363657074732027746578742729202D20222B65297D72657475726E20642E73657454657874547970654A736F6E3F752E73657444617461282274657874222C73293A752E73657444';
wwv_flow_imp.g_varchar2_table(856) := '617461282274657874222C632E7469746C65292C5F28692C70292C21313D3D3D642E64726167537461727428632C70293F287728292C2131293A284E28692C70292C6E3D6E756C6C2C702E75736544656661756C74496D616765262628743D6528632E73';
wwv_flow_imp.g_varchar2_table(857) := '70616E292E66696E6428222E66616E6379747265652D7469746C6522292C672626672E6C656E6774683E312626286E3D6528223C7370616E20636C6173733D2766616E6379747265652D6368696C64636F756E746572272F3E22292E7465787428222B22';
wwv_flow_imp.g_varchar2_table(858) := '2B28672E6C656E6774682D3129292E617070656E64546F287429292C752E73657444726167496D6167652626752E73657444726167496D61676528745B305D2C2D31302C2D313029292C2130293B636173652264726167223A5F28692C70292C642E6472';
wwv_flow_imp.g_varchar2_table(859) := '61674472616728632C70292C4E28692C70292C792E746F67676C65436C61737328612C702E69734D6F7665293B627265616B3B636173652264726167656E64223A5F28692C70292C7728292C702E697343616E63656C6C65643D21432C642E6472616745';
wwv_flow_imp.g_varchar2_table(860) := '6E6428632C702C2143297D7D66756E6374696F6E20412874297B766172206E2C692C6F2C612C6C3D746869732C643D6C2E6F7074696F6E732E646E64352C793D6E756C6C2C6D3D722E6765744E6F64652874292C783D742E646174615472616E73666572';
wwv_flow_imp.g_varchar2_table(861) := '7C7C742E6F726967696E616C4576656E742E646174615472616E736665722C623D7B747265653A6C2C6E6F64653A6D2C6F7074696F6E733A6C2E6F7074696F6E732C6F726967696E616C4576656E743A742E6F726967696E616C4576656E742C77696467';
wwv_flow_imp.g_varchar2_table(862) := '65743A6C2E7769646765742C6869744D6F64653A762C646174615472616E736665723A782C6F746865724E6F64653A687C7C6E756C6C2C6F746865724E6F64654C6973743A677C7C6E756C6C2C6F746865724E6F6465446174613A6E756C6C2C75736544';
wwv_flow_imp.g_varchar2_table(863) := '656661756C74496D6167653A21302C64726F704566666563743A766F696420302C64726F704566666563745375676765737465643A766F696420302C656666656374416C6C6F7765643A766F696420302C66696C65733A6E756C6C2C697343616E63656C';
wwv_flow_imp.g_varchar2_table(864) := '6C65643A766F696420302C69734D6F76653A766F696420307D3B73776974636828742E74797065297B636173652264726167656E746572223A6966286B3D6E756C6C2C216D297B6C2E6465627567282249676E6F7265206E6F6E2D6E6F646520222B742E';
wwv_flow_imp.g_varchar2_table(865) := '747970652B223A20222B742E7461726765742E7461674E616D652B222E222B742E7461726765742E636C6173734E616D65292C763D21313B627265616B7D69662865286D2E7370616E292E616464436C6173732863292E72656D6F7665436C6173732873';
wwv_flow_imp.g_varchar2_table(866) := '2B2220222B75292C6F3D652E696E417272617928662C782E7479706573293E3D302C642E70726576656E744E6F6E4E6F6465732626216F297B6D2E6465627567282252656A6563742064726F7070696E672061206E6F6E2D6E6F64652E22292C763D2131';
wwv_flow_imp.g_varchar2_table(867) := '3B627265616B7D696628642E70726576656E74466F726569676E4E6F64657326262821687C7C682E74726565213D3D6D2E7472656529297B6D2E6465627567282252656A6563742064726F7070696E67206120666F726569676E206E6F64652E22292C76';
wwv_flow_imp.g_varchar2_table(868) := '3D21313B627265616B7D696628642E70726576656E7453616D65506172656E742626622E6F746865724E6F64652626622E6F746865724E6F64652E747265653D3D3D6D2E7472656526266D2E706172656E743D3D3D622E6F746865724E6F64652E706172';
wwv_flow_imp.g_varchar2_table(869) := '656E74297B6D2E6465627567282252656A6563742064726F7070696E67206173207369626C696E67202873616D6520706172656E74292E22292C763D21313B627265616B7D696628642E70726576656E74526563757273696F6E2626622E6F746865724E';
wwv_flow_imp.g_varchar2_table(870) := '6F64652626622E6F746865724E6F64652E747265653D3D3D6D2E7472656526266D2E697344657363656E64616E744F6628622E6F746865724E6F646529297B6D2E6465627567282252656A6563742064726F7070696E672062656C6F77206F776E20616E';
wwv_flow_imp.g_varchar2_table(871) := '636573746F722E22292C763D21313B627265616B7D696628642E70726576656E744C617A79506172656E74732626216D2E69734C6F616465642829297B6D2E7761726E282244726F70206F76657220756E6C6F6164656420746172676574206E6F646520';
wwv_flow_imp.g_varchar2_table(872) := '70726576656E7465642E22292C763D21313B627265616B7D702E73686F7728292C5F28742C62292C613D66756E6374696F6E2874297B766172206E3B72657475726E2121742626286E3D652E6973506C61696E4F626A6563742874293F7B6F7665723A21';
wwv_flow_imp.g_varchar2_table(873) := '21742E6F7665722C6265666F72653A2121742E6265666F72652C61667465723A2121742E61667465727D3A41727261792E697341727261792874293F7B6F7665723A652E696E417272617928226F766572222C74293E3D302C6265666F72653A652E696E';
wwv_flow_imp.g_varchar2_table(874) := '417272617928226265666F7265222C74293E3D302C61667465723A652E696E417272617928226166746572222C74293E3D307D3A7B6F7665723A21303D3D3D747C7C226F766572223D3D3D742C6265666F72653A21303D3D3D747C7C226265666F726522';
wwv_flow_imp.g_varchar2_table(875) := '3D3D3D742C61667465723A21303D3D3D747C7C226166746572223D3D3D747D2C30213D3D4F626A6563742E6B657973286E292E6C656E67746826266E297D28642E64726167456E746572286D2C6229292C763D612C4E28742C622C793D61262628612E6F';
wwv_flow_imp.g_varchar2_table(876) := '7665727C7C612E6265666F72657C7C612E616674657229293B627265616B3B6361736522647261676F766572223A696628216D297B6C2E6465627567282249676E6F7265206E6F6E2D6E6F646520222B742E747970652B223A20222B742E746172676574';
wwv_flow_imp.g_varchar2_table(877) := '2E7461674E616D652B222E222B742E7461726765742E636C6173734E616D65293B627265616B7D5F28742C62292C793D212128433D4528742C6229292C28226F766572223D3D3D437C7C21313D3D3D43292626216D2E657870616E64656426262131213D';
wwv_flow_imp.g_varchar2_table(878) := '3D6D2E6861734368696C6472656E28293F6B3F2128642E6175746F457870616E644D532626446174652E6E6F7728292D6B3E642E6175746F457870616E644D53297C7C6D2E69734C6F6164696E6728297C7C642E64726167457870616E64262621313D3D';
wwv_flow_imp.g_varchar2_table(879) := '3D642E64726167457870616E64286D2C62297C7C6D2E736574457870616E64656428293A6B3D446174652E6E6F7728293A6B3D6E756C6C3B627265616B3B6361736522647261676C65617665223A696628216D297B6C2E6465627567282249676E6F7265';
wwv_flow_imp.g_varchar2_table(880) := '206E6F6E2D6E6F646520222B742E747970652B223A20222B742E7461726765742E7461674E616D652B222E222B742E7461726765742E636C6173734E616D65293B627265616B7D6966282165286D2E7370616E292E686173436C617373286329297B6D2E';
wwv_flow_imp.g_varchar2_table(881) := '6465627567282249676E6F726520647261676C6561766520286D756C7469292E22293B627265616B7D65286D2E7370616E292E72656D6F7665436C61737328632B2220222B732B2220222B75292C6D2E7363686564756C65416374696F6E282263616E63';
wwv_flow_imp.g_varchar2_table(882) := '656C22292C642E647261674C65617665286D2C62292C702E6869646528293B627265616B3B636173652264726F70223A696628652E696E417272617928662C782E7479706573293E3D30262628693D782E676574446174612866292C6C2E696E666F2874';
wwv_flow_imp.g_varchar2_table(883) := '2E747970652B223A206765744461746128276170706C69636174696F6E2F782D66616E6379747265652D6E6F646527293A2027222B692B22272229292C697C7C28693D782E6765744461746128227465787422292C6C2E696E666F28742E747970652B22';
wwv_flow_imp.g_varchar2_table(884) := '3A206765744461746128277465787427293A2027222B692B22272229292C69297472797B766F69642030213D3D286E3D4A534F4E2E7061727365286929292E7469746C65262628622E6F746865724E6F6465446174613D6E297D63617463682865297B7D';
wwv_flow_imp.g_varchar2_table(885) := '6C2E646562756728742E747970652B223A206E6F6465446174613A2027222B692B22272C206F746865724E6F6465446174613A20222C622E6F746865724E6F646544617461292C65286D2E7370616E292E72656D6F7665436C61737328632B2220222B73';
wwv_flow_imp.g_varchar2_table(886) := '2B2220222B75292C622E6869744D6F64653D432C5F28742C62292C622E697343616E63656C6C65643D21433B76617220533D682626682E7370616E2C443D682626682E747265653B642E6472616744726F70286D2C62292C742E70726576656E74446566';
wwv_flow_imp.g_varchar2_table(887) := '61756C7428292C53262621646F63756D656E742E626F64792E636F6E7461696E73285329262628443D3D3D6C3F286C2E6465627567282244726F702068616E646C65722072656D6F76656420736F7572636520656C656D656E743A2067656E6572617469';
wwv_flow_imp.g_varchar2_table(888) := '6E672064726167456E642E22292C642E64726167456E6428682C6229293A6C2E7761726E282244726F702068616E646C65722072656D6F76656420736F7572636520656C656D656E743A2064726167656E64206576656E74206D6179206265206C6F7374';
wwv_flow_imp.g_varchar2_table(889) := '2E2229292C7728297D696628792972657475726E20742E70726576656E7444656661756C7428292C21317D72657475726E20652E75692E66616E6379747265652E676574447261674E6F64654C6973743D66756E6374696F6E28297B72657475726E2067';
wwv_flow_imp.g_varchar2_table(890) := '7C7C5B5D7D2C652E75692E66616E6379747265652E676574447261674E6F64653D66756E6374696F6E28297B72657475726E20687D2C652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A22646E6435222C';
wwv_flow_imp.g_varchar2_table(891) := '76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B6175746F457870616E644D533A313530302C64726F704D61726B6572496E736572744F6666736574583A2D31362C64726F704D61726B65724F6666736574583A2D32342C64726F704D61';
wwv_flow_imp.g_varchar2_table(892) := '726B6572506172656E743A22626F6479222C6D756C7469536F757263653A21312C656666656374416C6C6F7765643A22616C6C222C64726F7045666665637444656661756C743A226D6F7665222C70726576656E74466F726569676E4E6F6465733A2131';
wwv_flow_imp.g_varchar2_table(893) := '2C70726576656E744C617A79506172656E74733A21302C70726576656E744E6F6E4E6F6465733A21312C70726576656E74526563757273696F6E3A21302C70726576656E7453616D65506172656E743A21312C70726576656E74566F69644D6F7665733A';
wwv_flow_imp.g_varchar2_table(894) := '21302C7363726F6C6C3A21302C7363726F6C6C53656E73697469766974793A32302C7363726F6C6C53706565643A352C73657454657874547970654A736F6E3A21312C736F75726365436F7079486F6F6B3A6E756C6C2C6472616753746172743A6E756C';
wwv_flow_imp.g_varchar2_table(895) := '6C2C64726167447261673A652E6E6F6F702C64726167456E643A652E6E6F6F702C64726167456E7465723A6E756C6C2C647261674F7665723A652E6E6F6F702C64726167457870616E643A652E6E6F6F702C6472616744726F703A652E6E6F6F702C6472';
wwv_flow_imp.g_varchar2_table(896) := '61674C656176653A652E6E6F6F707D2C74726565496E69743A66756E6374696F6E2874297B766172206E2C693D742E747265652C6F3D742E6F7074696F6E732C613D6F2E676C7970687C7C6E756C6C2C733D6F2E646E64353B652E696E41727261792822';
wwv_flow_imp.g_varchar2_table(897) := '646E64222C6F2E657874656E73696F6E73293E3D302626652E6572726F722822457874656E73696F6E732027646E642720616E642027646E64352720617265206D757475616C6C79206578636C75736976652E22292C732E6472616753746F702626652E';
wwv_flow_imp.g_varchar2_table(898) := '6572726F7228226472616753746F70206973206E6F742075736564206279206578742D646E64352E205573652064726167456E6420696E73746561642E22292C6E756C6C213D732E70726576656E745265637572736976654D6F7665732626652E657272';
wwv_flow_imp.g_varchar2_table(899) := '6F72282270726576656E745265637572736976654D6F766573207761732072656E616D656420746F2070726576656E74526563757273696F6E2E22292C732E6472616753746172742626722E6F766572726964654D6574686F6428742E6F7074696F6E73';
wwv_flow_imp.g_varchar2_table(900) := '2C226372656174654E6F6465222C66756E6374696F6E28652C74297B746869732E5F73757065722E6170706C7928746869732C617267756D656E7473292C742E6E6F64652E7370616E3F742E6E6F64652E7370616E2E647261676761626C653D21303A74';
wwv_flow_imp.g_varchar2_table(901) := '2E6E6F64652E7761726E282243616E6E6F74206164642060647261676761626C65603A206E6F207370616E2074616722297D292C746869732E5F73757065724170706C7928617267756D656E7473292C746869732E24636F6E7461696E65722E61646443';
wwv_flow_imp.g_varchar2_table(902) := '6C617373282266616E6379747265652D6578742D646E643522292C6E3D6528223C7370616E3E22292E617070656E64546F28746869732E24636F6E7461696E6572292C746869732E247363726F6C6C506172656E743D6E2E7363726F6C6C506172656E74';
wwv_flow_imp.g_varchar2_table(903) := '28292C6E2E72656D6F766528292C28703D6528222366616E6379747265652D64726F702D6D61726B65722229292E6C656E6774687C7C28703D6528223C6469762069643D2766616E6379747265652D64726F702D6D61726B6572273E3C2F6469763E2229';
wwv_flow_imp.g_varchar2_table(904) := '2E6869646528292E637373287B227A2D696E646578223A3165332C22706F696E7465722D6576656E7473223A226E6F6E65227D292E70726570656E64546F28732E64726F704D61726B6572506172656E74292C612626722E7365745370616E49636F6E28';
wwv_flow_imp.g_varchar2_table(905) := '705B305D2C612E6D61702E5F616464436C6173732C612E6D61702E64726F704D61726B657229292C702E746F67676C65436C617373282266616E6379747265652D72746C222C21216F2E72746C292C732E6472616753746172742626692E24636F6E7461';
wwv_flow_imp.g_varchar2_table(906) := '696E65722E6F6E282264726167737461727420647261672064726167656E64222C442E62696E64286929292C732E64726167456E7465722626692E24636F6E7461696E65722E6F6E282264726167656E74657220647261676F76657220647261676C6561';
wwv_flow_imp.g_varchar2_table(907) := '76652064726F70222C412E62696E64286929297D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E656469742E6A730A202A0A202A204D616B65206E6F6465207469746C65732065646974';
wwv_flow_imp.g_varchar2_table(908) := '61626C652E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972';
wwv_flow_imp.g_varchar2_table(909) := '696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A';
wwv_flow_imp.g_varchar2_table(910) := '2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A';
wwv_flow_imp.g_varchar2_table(911) := '2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A6563';
wwv_flow_imp.g_varchar2_table(912) := '74223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929';
wwv_flow_imp.g_varchar2_table(913) := '293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D2F4D61632F2E74657374286E6176696761746F722E706C6174666F726D292C6E3D652E75692E66616E6379747265652E6573636170654874';
wwv_flow_imp.g_varchar2_table(914) := '6D6C2C723D652E75692E66616E6379747265652E7472696D2C693D652E75692E66616E6379747265652E756E65736361706548746D6C3B72657475726E20652E75692E66616E6379747265652E5F46616E6379747265654E6F6465436C6173732E70726F';
wwv_flow_imp.g_varchar2_table(915) := '746F747970652E6564697453746172743D66756E6374696F6E28297B76617220742C6E3D746869732C723D746869732E747265652C6F3D722E6578742E656469742C613D722E6F7074696F6E732E656469742C733D6528222E66616E6379747265652D74';
wwv_flow_imp.g_varchar2_table(916) := '69746C65222C6E2E7370616E292C6C3D7B6E6F64653A6E2C747265653A722C6F7074696F6E733A722E6F7074696F6E732C69734E65773A65286E5B722E737461747573436C61737350726F704E616D655D292E686173436C617373282266616E63797472';
wwv_flow_imp.g_varchar2_table(917) := '65652D656469742D6E657722292C6F72675469746C653A6E2E7469746C652C696E7075743A6E756C6C2C64697274793A21317D3B69662821313D3D3D612E6265666F7265456469742E63616C6C286E2C7B747970653A226265666F726545646974227D2C';
wwv_flow_imp.g_varchar2_table(918) := '6C292972657475726E21313B652E75692E66616E6379747265652E61737365727428216F2E63757272656E744E6F64652C22726563757273697665206564697422292C6F2E63757272656E744E6F64653D746869732C6F2E6576656E74446174613D6C2C';
wwv_flow_imp.g_varchar2_table(919) := '722E7769646765742E5F756E62696E6428292C6F2E6C617374447261676761626C654174747256616C75653D6E2E7370616E2E647261676761626C652C6F2E6C617374447261676761626C654174747256616C75652626286E2E7370616E2E6472616767';
wwv_flow_imp.g_varchar2_table(920) := '61626C653D2131292C6528646F63756D656E74292E6F6E28226D6F757365646F776E2E66616E6379747265652D65646974222C66756E6374696F6E2874297B6528742E746172676574292E686173436C617373282266616E6379747265652D656469742D';
wwv_flow_imp.g_varchar2_table(921) := '696E70757422297C7C6E2E65646974456E642821302C74297D292C743D6528223C696E707574202F3E222C7B636C6173733A2266616E6379747265652D656469742D696E707574222C747970653A2274657874222C76616C75653A722E6F7074696F6E73';
wwv_flow_imp.g_varchar2_table(922) := '2E6573636170655469746C65733F6C2E6F72675469746C653A69286C2E6F72675469746C65297D292C6F2E6576656E74446174612E696E7075743D742C6E756C6C213D612E61646A75737457696474684F66732626742E776964746828732E7769647468';
wwv_flow_imp.g_varchar2_table(923) := '28292B612E61646A75737457696474684F6673292C6E756C6C213D612E696E7075744373732626742E63737328612E696E707574437373292C732E68746D6C2874292C742E747269676765722822666F63757322292E6368616E67652866756E6374696F';
wwv_flow_imp.g_varchar2_table(924) := '6E2865297B742E616464436C617373282266616E6379747265652D656469742D646972747922297D292E6F6E28226B6579646F776E222C66756E6374696F6E2874297B73776974636828742E7768696368297B6361736520652E75692E6B6579436F6465';
wwv_flow_imp.g_varchar2_table(925) := '2E4553434150453A6E2E65646974456E642821312C74293B627265616B3B6361736520652E75692E6B6579436F64652E454E5445523A72657475726E206E2E65646974456E642821302C74292C21317D742E73746F7050726F7061676174696F6E28297D';
wwv_flow_imp.g_varchar2_table(926) := '292E626C75722866756E6374696F6E2865297B72657475726E206E2E65646974456E642821302C65297D292C612E656469742E63616C6C286E2C7B747970653A2265646974227D2C6C297D2C652E75692E66616E6379747265652E5F46616E6379747265';
wwv_flow_imp.g_varchar2_table(927) := '654E6F6465436C6173732E70726F746F747970652E65646974456E643D66756E6374696F6E28742C69297B766172206F2C613D746869732C733D746869732E747265652C6C3D732E6578742E656469742C643D6C2E6576656E74446174612C633D732E6F';
wwv_flow_imp.g_varchar2_table(928) := '7074696F6E732E656469742C753D6528222E66616E6379747265652D7469746C65222C612E7370616E292E66696E642822696E7075742E66616E6379747265652D656469742D696E70757422293B72657475726E20632E7472696D2626752E76616C2872';
wwv_flow_imp.g_varchar2_table(929) := '28752E76616C282929292C6F3D752E76616C28292C642E64697274793D6F213D3D612E7469746C652C642E6F726967696E616C4576656E743D692C21313D3D3D743F642E736176653D21313A642E69734E65773F642E736176653D2222213D3D6F3A642E';
wwv_flow_imp.g_varchar2_table(930) := '736176653D642E646972747926262222213D3D6F2C2131213D3D632E6265666F7265436C6F73652E63616C6C28612C7B747970653A226265666F7265436C6F7365227D2C64292626282821642E736176657C7C2131213D3D632E736176652E63616C6C28';
wwv_flow_imp.g_varchar2_table(931) := '612C7B747970653A2273617665227D2C642929262628752E72656D6F7665436C617373282266616E6379747265652D656469742D646972747922292E6F666628292C6528646F63756D656E74292E6F666628222E66616E6379747265652D656469742229';
wwv_flow_imp.g_varchar2_table(932) := '2C642E736176653F28612E7365745469746C6528732E6F7074696F6E732E6573636170655469746C65733F6F3A6E286F29292C612E736574466F6375732829293A642E69734E65773F28612E72656D6F766528292C613D642E6E6F64653D6E756C6C2C6C';
wwv_flow_imp.g_varchar2_table(933) := '2E72656C617465644E6F64652E736574466F6375732829293A28612E72656E6465725469746C6528292C612E736574466F6375732829292C6C2E6576656E74446174613D6E756C6C2C6C2E63757272656E744E6F64653D6E756C6C2C6C2E72656C617465';
wwv_flow_imp.g_varchar2_table(934) := '644E6F64653D6E756C6C2C732E7769646765742E5F62696E6428292C6126266C2E6C617374447261676761626C654174747256616C7565262628612E7370616E2E647261676761626C653D2130292C732E24636F6E7461696E65722E6765742830292E66';
wwv_flow_imp.g_varchar2_table(935) := '6F637573287B70726576656E745363726F6C6C3A21307D292C642E696E7075743D6E756C6C2C632E636C6F73652E63616C6C28612C7B747970653A22636C6F7365227D2C64292C213029297D2C652E75692E66616E6379747265652E5F46616E63797472';
wwv_flow_imp.g_varchar2_table(936) := '65654E6F6465436C6173732E70726F746F747970652E656469744372656174654E6F64653D66756E6374696F6E28742C6E297B76617220722C693D746869732E747265652C6F3D746869733B743D747C7C226368696C64222C6E756C6C3D3D6E3F6E3D7B';
wwv_flow_imp.g_varchar2_table(937) := '7469746C653A22227D3A22737472696E67223D3D747970656F66206E3F6E3D7B7469746C653A6E7D3A652E75692E66616E6379747265652E61737365727428652E6973506C61696E4F626A656374286E29292C226368696C6422213D3D747C7C74686973';
wwv_flow_imp.g_varchar2_table(938) := '2E6973457870616E64656428297C7C21313D3D3D746869732E6861734368696C6472656E28293F2828723D746869732E6164644E6F6465286E2C7429292E6D617463683D21302C6528725B692E737461747573436C61737350726F704E616D655D292E72';
wwv_flow_imp.g_varchar2_table(939) := '656D6F7665436C617373282266616E6379747265652D6869646522292E616464436C617373282266616E6379747265652D6D6174636822292C722E6D616B6556697369626C6528292E646F6E652866756E6374696F6E28297B6528725B692E7374617475';
wwv_flow_imp.g_varchar2_table(940) := '73436C61737350726F704E616D655D292E616464436C617373282266616E6379747265652D656469742D6E657722292C6F2E747265652E6578742E656469742E72656C617465644E6F64653D6F2C722E65646974537461727428297D29293A746869732E';
wwv_flow_imp.g_varchar2_table(941) := '736574457870616E64656428292E646F6E652866756E6374696F6E28297B6F2E656469744372656174654E6F646528742C6E297D297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E69734564';
wwv_flow_imp.g_varchar2_table(942) := '6974696E673D66756E6374696F6E28297B72657475726E20746869732E6578742E656469743F746869732E6578742E656469742E63757272656E744E6F64653A6E756C6C7D2C652E75692E66616E6379747265652E5F46616E6379747265654E6F646543';
wwv_flow_imp.g_varchar2_table(943) := '6C6173732E70726F746F747970652E697345646974696E673D66756E6374696F6E28297B72657475726E2121746869732E747265652E6578742E656469742626746869732E747265652E6578742E656469742E63757272656E744E6F64653D3D3D746869';
wwv_flow_imp.g_varchar2_table(944) := '737D2C652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A2265646974222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B61646A75737457696474684F66733A342C616C6C6F77456D70';
wwv_flow_imp.g_varchar2_table(945) := '74793A21312C696E7075744373733A7B6D696E57696474683A2233656D227D2C7472696767657253746172743A5B226632222C226D61632B656E746572222C2273686966742B636C69636B225D2C7472696D3A21302C6265666F7265436C6F73653A652E';
wwv_flow_imp.g_varchar2_table(946) := '6E6F6F702C6265666F7265456469743A652E6E6F6F702C636C6F73653A652E6E6F6F702C656469743A652E6E6F6F702C736176653A652E6E6F6F707D2C63757272656E744E6F64653A6E756C6C2C74726565496E69743A66756E6374696F6E2865297B76';
wwv_flow_imp.g_varchar2_table(947) := '617220743D652E747265653B746869732E5F73757065724170706C7928617267756D656E7473292C746869732E24636F6E7461696E65722E616464436C617373282266616E6379747265652D6578742D6564697422292E6F6E282266616E637974726565';
wwv_flow_imp.g_varchar2_table(948) := '6265666F726575706461746576696577706F7274222C66756E6374696F6E28652C6E297B76617220723D742E697345646974696E6728293B72262628722E696E666F282243616E63656C20656469742064756520746F207363726F6C6C206576656E742E';
wwv_flow_imp.g_varchar2_table(949) := '22292C722E65646974456E642821312C6529297D297D2C6E6F6465436C69636B3A66756E6374696F6E2874297B766172206E3D652E75692E66616E6379747265652E6576656E74546F537472696E6728742E6F726967696E616C4576656E74292C723D74';
wwv_flow_imp.g_varchar2_table(950) := '2E6F7074696F6E732E656469742E7472696767657253746172743B72657475726E2273686966742B636C69636B223D3D3D6E2626652E696E4172726179282273686966742B636C69636B222C72293E3D302626742E6F726967696E616C4576656E742E73';
wwv_flow_imp.g_varchar2_table(951) := '686966744B65797C7C22636C69636B223D3D3D6E2626652E696E41727261792822636C69636B416374697665222C72293E3D302626742E6E6F64652E69734163746976652829262621742E6E6F64652E697345646974696E67282926266528742E6F7269';
wwv_flow_imp.g_varchar2_table(952) := '67696E616C4576656E742E746172676574292E686173436C617373282266616E6379747265652D7469746C6522293F28742E6E6F64652E65646974537461727428292C2131293A746869732E5F73757065724170706C7928617267756D656E7473297D2C';
wwv_flow_imp.g_varchar2_table(953) := '6E6F646544626C636C69636B3A66756E6374696F6E2874297B72657475726E20652E696E4172726179282264626C636C69636B222C742E6F7074696F6E732E656469742E747269676765725374617274293E3D303F28742E6E6F64652E65646974537461';
wwv_flow_imp.g_varchar2_table(954) := '727428292C2131293A746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F64654B6579646F776E3A66756E6374696F6E286E297B737769746368286E2E6F726967696E616C4576656E742E7768696368297B6361736520313133';
wwv_flow_imp.g_varchar2_table(955) := '3A696628652E696E417272617928226632222C6E2E6F7074696F6E732E656469742E747269676765725374617274293E3D302972657475726E206E2E6E6F64652E65646974537461727428292C21313B627265616B3B6361736520652E75692E6B657943';
wwv_flow_imp.g_varchar2_table(956) := '6F64652E454E5445523A696628652E696E417272617928226D61632B656E746572222C6E2E6F7074696F6E732E656469742E747269676765725374617274293E3D302626742972657475726E206E2E6E6F64652E65646974537461727428292C21317D72';
wwv_flow_imp.g_varchar2_table(957) := '657475726E20746869732E5F73757065724170706C7928617267756D656E7473297D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E66696C7465722E6A730A202A0A202A2052656D6F76';
wwv_flow_imp.g_varchar2_table(958) := '65206F7220686967686C696768742074726565206E6F6465732C206261736564206F6E20612066696C7465722E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F';
wwv_flow_imp.g_varchar2_table(959) := '6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A20';
wwv_flow_imp.g_varchar2_table(960) := '52656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E';
wwv_flow_imp.g_varchar2_table(961) := '20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B';
wwv_flow_imp.g_varchar2_table(962) := '226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472';
wwv_flow_imp.g_varchar2_table(963) := '656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D225F5F6E6F745F666F756E645F5F222C';
wwv_flow_imp.g_varchar2_table(964) := '6E3D652E75692E66616E6379747265652E65736361706548746D6C3B66756E6374696F6E20722865297B72657475726E28652B2222292E7265706C616365282F285B2E3F2A2B5E245B5C5D5C5C28297B7D7C2D5D292F672C225C5C243122297D66756E63';
wwv_flow_imp.g_varchar2_table(965) := '74696F6E206928652C742C6E297B666F722876617220723D5B5D2C693D313B693C742E6C656E6774683B692B2B297B766172206F3D745B695D2E6C656E6774682B28313D3D3D693F303A31292B28725B722E6C656E6774682D315D7C7C30293B722E7075';
wwv_flow_imp.g_varchar2_table(966) := '7368286F297D76617220613D652E73706C6974282222293B72657475726E206E3F722E666F72456163682866756E6374696F6E2865297B615B655D3D22EFBFB7222B615B655D2B22EFBFB8227D293A722E666F72456163682866756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(967) := '7B615B655D3D223C6D61726B3E222B615B655D2B223C2F6D61726B3E227D292C612E6A6F696E282222297D72657475726E20652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E5F6170706C7946696C';
wwv_flow_imp.g_varchar2_table(968) := '746572496D706C3D66756E6374696F6E286F2C612C73297B766172206C2C642C632C752C662C702C682C672C793D302C763D746869732E6F7074696F6E732C6D3D762E6573636170655469746C65732C783D762E6175746F436F6C6C617073652C623D65';
wwv_flow_imp.g_varchar2_table(969) := '2E657874656E64287B7D2C762E66696C7465722C73292C433D2268696465223D3D3D622E6D6F64652C6B3D2121622E6C65617665734F6E6C79262621613B69662822737472696E67223D3D747970656F66206F297B69662822223D3D3D6F297265747572';
wwv_flow_imp.g_varchar2_table(970) := '6E20746869732E7761726E282246616E6379747265652070617373696E6720616E20656D70747920737472696E6720617320612066696C7465722069732068616E646C656420617320636C65617246696C74657228292E22292C766F696420746869732E';
wwv_flow_imp.g_varchar2_table(971) := '636C65617246696C74657228293B6C3D622E66757A7A793F6F2E73706C6974282222292E6D61702872292E7265647563652866756E6374696F6E28652C74297B72657475726E20652B22285B5E222B742B225D2A29222B747D2C2222293A72286F292C63';
wwv_flow_imp.g_varchar2_table(972) := '3D6E657720526567457870286C2C226922292C753D6E6577205265674578702872286F292C22676922292C6D262628663D6E65772052656745787028722822EFBFB722292C226722292C703D6E65772052656745787028722822EFBFB822292C22672229';
wwv_flow_imp.g_varchar2_table(973) := '292C6F3D66756E6374696F6E2874297B69662821742E7469746C652972657475726E21313B76617220722C6F3D6D3F742E7469746C653A28723D742E7469746C65292E696E6465784F6628223E22293E3D303F6528223C6469762F3E22292E68746D6C28';
wwv_flow_imp.g_varchar2_table(974) := '72292E7465787428293A722C613D6F2E6D617463682863293B72657475726E20612626622E686967686C696768742626286D3F28683D622E66757A7A793F69286F2C612C6D293A6F2E7265706C61636528752C66756E6374696F6E2865297B7265747572';
wwv_flow_imp.g_varchar2_table(975) := '6E22EFBFB7222B652B22EFBFB8227D292C742E7469746C6557697468486967686C696768743D6E2868292E7265706C61636528662C223C6D61726B3E22292E7265706C61636528702C223C2F6D61726B3E2229293A622E66757A7A793F742E7469746C65';
wwv_flow_imp.g_varchar2_table(976) := '57697468486967686C696768743D69286F2C61293A742E7469746C6557697468486967686C696768743D6F2E7265706C61636528752C66756E6374696F6E2865297B72657475726E223C6D61726B3E222B652B223C2F6D61726B3E227D29292C2121617D';
wwv_flow_imp.g_varchar2_table(977) := '7D72657475726E20746869732E656E61626C6546696C7465723D21302C746869732E6C61737446696C746572417267733D617267756D656E74732C673D746869732E656E61626C65557064617465282131292C746869732E246469762E616464436C6173';
wwv_flow_imp.g_varchar2_table(978) := '73282266616E6379747265652D6578742D66696C74657222292C433F746869732E246469762E616464436C617373282266616E6379747265652D6578742D66696C7465722D6869646522293A746869732E246469762E616464436C617373282266616E63';
wwv_flow_imp.g_varchar2_table(979) := '79747265652D6578742D66696C7465722D64696D6D22292C746869732E246469762E746F67676C65436C617373282266616E6379747265652D6578742D66696C7465722D686964652D657870616E64657273222C2121622E68696465457870616E646572';
wwv_flow_imp.g_varchar2_table(980) := '73292C746869732E726F6F744E6F64652E7375624D61746368436F756E743D302C746869732E76697369742866756E6374696F6E2865297B64656C65746520652E6D617463682C64656C65746520652E7469746C6557697468486967686C696768742C65';
wwv_flow_imp.g_varchar2_table(981) := '2E7375624D61746368436F756E743D307D292C28643D746869732E676574526F6F744E6F646528292E5F66696E644469726563744368696C64287429292626642E72656D6F766528292C762E6175746F436F6C6C617073653D21312C746869732E766973';
wwv_flow_imp.g_varchar2_table(982) := '69742866756E6374696F6E2865297B696628216B7C7C6E756C6C3D3D652E6368696C6472656E297B76617220743D6F2865292C6E3D21313B69662822736B6970223D3D3D742972657475726E20652E76697369742866756E6374696F6E2865297B652E6D';
wwv_flow_imp.g_varchar2_table(983) := '617463683D21317D2C2130292C22736B6970223B747C7C21612626226272616E636822213D3D747C7C21652E706172656E742E6D617463687C7C28743D21302C6E3D2130292C74262628792B2B2C652E6D617463683D21302C652E766973697450617265';
wwv_flow_imp.g_varchar2_table(984) := '6E74732866756E6374696F6E2874297B74213D3D65262628742E7375624D61746368436F756E742B3D31292C21622E6175746F457870616E647C7C6E7C7C742E657870616E6465647C7C28742E736574457870616E6465642821302C7B6E6F416E696D61';
wwv_flow_imp.g_varchar2_table(985) := '74696F6E3A21302C6E6F4576656E74733A21302C7363726F6C6C496E746F566965773A21317D292C742E5F66696C7465724175746F457870616E6465643D2130297D2C213029297D7D292C762E6175746F436F6C6C617073653D782C303D3D3D79262662';
wwv_flow_imp.g_varchar2_table(986) := '2E6E6F646174612626432626282266756E6374696F6E223D3D747970656F6628643D622E6E6F6461746129262628643D642829292C21303D3D3D643F643D7B7D3A22737472696E67223D3D747970656F662064262628643D7B7469746C653A647D292C64';
wwv_flow_imp.g_varchar2_table(987) := '3D652E657874656E64287B7374617475734E6F6465547970653A226E6F64617461222C6B65793A742C7469746C653A746869732E6F7074696F6E732E737472696E67732E6E6F446174617D2C64292C746869732E676574526F6F744E6F646528292E6164';
wwv_flow_imp.g_varchar2_table(988) := '644E6F64652864292E6D617463683D2130292C746869732E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C746869732C226170706C7946696C74657222292C746869732E656E61626C655570646174652867292C797D';
wwv_flow_imp.g_varchar2_table(989) := '2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E66696C7465724E6F6465733D66756E6374696F6E28652C74297B72657475726E22626F6F6C65616E223D3D747970656F662074262628743D7B6C';
wwv_flow_imp.g_varchar2_table(990) := '65617665734F6E6C793A747D2C746869732E7761726E282246616E6379747265652E66696C7465724E6F6465732829206C65617665734F6E6C79206F7074696F6E20697320646570726563617465642073696E636520322E392E30202F20323031352D30';
wwv_flow_imp.g_varchar2_table(991) := '342D31392E20557365206F7074732E6C65617665734F6E6C7920696E73746561642E2229292C746869732E5F6170706C7946696C746572496D706C28652C21312C74297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E';
wwv_flow_imp.g_varchar2_table(992) := '70726F746F747970652E66696C7465724272616E636865733D66756E6374696F6E28652C74297B72657475726E20746869732E5F6170706C7946696C746572496D706C28652C21302C74297D2C652E75692E66616E6379747265652E5F46616E63797472';
wwv_flow_imp.g_varchar2_table(993) := '6565436C6173732E70726F746F747970652E75706461746546696C7465723D66756E6374696F6E28297B746869732E656E61626C6546696C7465722626746869732E6C61737446696C746572417267732626746869732E6F7074696F6E732E66696C7465';
wwv_flow_imp.g_varchar2_table(994) := '722E6175746F4170706C793F746869732E5F6170706C7946696C746572496D706C2E6170706C7928746869732C746869732E6C61737446696C74657241726773293A746869732E7761726E282275706461746546696C74657228293A206E6F2066696C74';
wwv_flow_imp.g_varchar2_table(995) := '6572206163746976652E22297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E636C65617246696C7465723D66756E6374696F6E28297B766172206E2C723D746869732E676574526F6F744E6F';
wwv_flow_imp.g_varchar2_table(996) := '646528292E5F66696E644469726563744368696C642874292C693D746869732E6F7074696F6E732E6573636170655469746C65732C6F3D746869732E6F7074696F6E732E656E68616E63655469746C652C613D746869732E656E61626C65557064617465';
wwv_flow_imp.g_varchar2_table(997) := '282131293B722626722E72656D6F766528292C64656C65746520746869732E726F6F744E6F64652E6D617463682C64656C65746520746869732E726F6F744E6F64652E7375624D61746368436F756E742C746869732E76697369742866756E6374696F6E';
wwv_flow_imp.g_varchar2_table(998) := '2874297B742E6D617463682626742E7370616E2626286E3D6528742E7370616E292E66696E6428223E7370616E2E66616E6379747265652D7469746C6522292C693F6E2E7465787428742E7469746C65293A6E2E68746D6C28742E7469746C65292C6F26';
wwv_flow_imp.g_varchar2_table(999) := '266F287B747970653A22656E68616E63655469746C65227D2C7B6E6F64653A742C247469746C653A6E7D29292C64656C65746520742E6D617463682C64656C65746520742E7375624D61746368436F756E742C64656C65746520742E7469746C65576974';
wwv_flow_imp.g_varchar2_table(1000) := '68486967686C696768742C742E247375624D617463684261646765262628742E247375624D6174636842616467652E72656D6F766528292C64656C65746520742E247375624D617463684261646765292C742E5F66696C7465724175746F457870616E64';
wwv_flow_imp.g_varchar2_table(1001) := '65642626742E657870616E6465642626742E736574457870616E6465642821312C7B6E6F416E696D6174696F6E3A21302C6E6F4576656E74733A21302C7363726F6C6C496E746F566965773A21317D292C64656C65746520742E5F66696C746572417574';
wwv_flow_imp.g_varchar2_table(1002) := '6F457870616E6465647D292C746869732E656E61626C6546696C7465723D21312C746869732E6C61737446696C746572417267733D6E756C6C2C746869732E246469762E72656D6F7665436C617373282266616E6379747265652D6578742D66696C7465';
wwv_flow_imp.g_varchar2_table(1003) := '722066616E6379747265652D6578742D66696C7465722D64696D6D2066616E6379747265652D6578742D66696C7465722D6869646522292C746869732E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C746869732C22';
wwv_flow_imp.g_varchar2_table(1004) := '636C65617246696C74657222292C746869732E656E61626C655570646174652861297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E697346696C7465724163746976653D66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(1005) := '28297B72657475726E2121746869732E656E61626C6546696C7465727D2C652E75692E66616E6379747265652E5F46616E6379747265654E6F6465436C6173732E70726F746F747970652E69734D6174636865643D66756E6374696F6E28297B72657475';
wwv_flow_imp.g_varchar2_table(1006) := '726E2128746869732E747265652E656E61626C6546696C746572262621746869732E6D61746368297D2C652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A2266696C746572222C76657273696F6E3A2232';
wwv_flow_imp.g_varchar2_table(1007) := '2E33382E34222C6F7074696F6E733A7B6175746F4170706C793A21302C6175746F457870616E643A21312C636F756E7465723A21302C66757A7A793A21312C68696465457870616E646564436F756E7465723A21302C68696465457870616E646572733A';
wwv_flow_imp.g_varchar2_table(1008) := '21312C686967686C696768743A21302C6C65617665734F6E6C793A21312C6E6F646174613A21302C6D6F64653A2264696D6D227D2C6E6F64654C6F61644368696C6472656E3A66756E6374696F6E28652C74297B766172206E3D652E747265653B726574';
wwv_flow_imp.g_varchar2_table(1009) := '75726E20746869732E5F73757065724170706C7928617267756D656E7473292E646F6E652866756E6374696F6E28297B6E2E656E61626C6546696C74657226266E2E6C61737446696C746572417267732626652E6F7074696F6E732E66696C7465722E61';
wwv_flow_imp.g_varchar2_table(1010) := '75746F4170706C7926266E2E5F6170706C7946696C746572496D706C2E6170706C79286E2C6E2E6C61737446696C74657241726773297D297D2C6E6F6465536574457870616E6465643A66756E6374696F6E28652C742C6E297B76617220723D652E6E6F';
wwv_flow_imp.g_varchar2_table(1011) := '64653B72657475726E2064656C65746520722E5F66696C7465724175746F457870616E6465642C21742626652E6F7074696F6E732E66696C7465722E68696465457870616E646564436F756E7465722626722E247375624D617463684261646765262672';
wwv_flow_imp.g_varchar2_table(1012) := '2E247375624D6174636842616467652E73686F7728292C746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F646552656E6465725374617475733A66756E6374696F6E2874297B766172206E2C723D742E6E6F64652C693D742E';
wwv_flow_imp.g_varchar2_table(1013) := '747265652C6F3D742E6F7074696F6E732E66696C7465722C613D6528722E7370616E292E66696E6428227370616E2E66616E6379747265652D7469746C6522292C733D6528725B692E737461747573436C61737350726F704E616D655D292C6C3D742E6F';
wwv_flow_imp.g_varchar2_table(1014) := '7074696F6E732E656E68616E63655469746C652C643D742E6F7074696F6E732E6573636170655469746C65733B72657475726E206E3D746869732E5F73757065722874292C732E6C656E6774682626692E656E61626C6546696C7465723F28732E746F67';
wwv_flow_imp.g_varchar2_table(1015) := '676C65436C617373282266616E6379747265652D6D61746368222C2121722E6D61746368292E746F67676C65436C617373282266616E6379747265652D7375626D61746368222C2121722E7375624D61746368436F756E74292E746F67676C65436C6173';
wwv_flow_imp.g_varchar2_table(1016) := '73282266616E6379747265652D68696465222C2128722E6D617463687C7C722E7375624D61746368436F756E7429292C216F2E636F756E7465727C7C21722E7375624D61746368436F756E747C7C722E6973457870616E646564282926266F2E68696465';
wwv_flow_imp.g_varchar2_table(1017) := '457870616E646564436F756E7465723F722E247375624D6174636842616467652626722E247375624D6174636842616467652E6869646528293A28722E247375624D6174636842616467657C7C28722E247375624D6174636842616467653D6528223C73';
wwv_flow_imp.g_varchar2_table(1018) := '70616E20636C6173733D2766616E6379747265652D6368696C64636F756E746572272F3E22292C6528227370616E2E66616E6379747265652D69636F6E2C207370616E2E66616E6379747265652D637573746F6D2D69636F6E222C722E7370616E292E61';
wwv_flow_imp.g_varchar2_table(1019) := '7070656E6428722E247375624D61746368426164676529292C722E247375624D6174636842616467652E73686F7728292E7465787428722E7375624D61746368436F756E7429292C21722E7370616E7C7C722E697345646974696E672626722E69734564';
wwv_flow_imp.g_varchar2_table(1020) := '6974696E672E63616C6C2872297C7C28722E7469746C6557697468486967686C696768743F612E68746D6C28722E7469746C6557697468486967686C69676874293A643F612E7465787428722E7469746C65293A612E68746D6C28722E7469746C65292C';
wwv_flow_imp.g_varchar2_table(1021) := '6C26266C287B747970653A22656E68616E63655469746C65227D2C7B6E6F64653A722C247469746C653A617D29292C6E293A6E7D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E676C79';
wwv_flow_imp.g_varchar2_table(1022) := '70682E6A730A202A0A202A2055736520676C7970682D666F6E74732C206C696761747572652D666F6E74732C206F72205356472069636F6E7320696E7374656164206F662069636F6E20737072697465732E0A202A2028457874656E73696F6E206D6F64';
wwv_flow_imp.g_varchar2_table(1023) := '756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D6172';
wwv_flow_imp.g_varchar2_table(1024) := '74696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E63';
wwv_flow_imp.g_varchar2_table(1025) := '79747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E';
wwv_flow_imp.g_varchar2_table(1026) := '223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F6475';
wwv_flow_imp.g_varchar2_table(1027) := '6C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(1028) := '297B2275736520737472696374223B76617220743D652E75692E66616E6379747265652C6E3D7B617765736F6D65333A7B5F616464436C6173733A22222C636865636B626F783A2269636F6E2D636865636B2D656D707479222C636865636B626F785365';
wwv_flow_imp.g_varchar2_table(1029) := '6C65637465643A2269636F6E2D636865636B222C636865636B626F78556E6B6E6F776E3A2269636F6E2D636865636B2069636F6E2D6D75746564222C6472616748656C7065723A2269636F6E2D63617265742D7269676874222C64726F704D61726B6572';
wwv_flow_imp.g_varchar2_table(1030) := '3A2269636F6E2D63617265742D7269676874222C6572726F723A2269636F6E2D6578636C616D6174696F6E2D7369676E222C657870616E646572436C6F7365643A2269636F6E2D63617265742D7269676874222C657870616E6465724C617A793A226963';
wwv_flow_imp.g_varchar2_table(1031) := '6F6E2D616E676C652D7269676874222C657870616E6465724F70656E3A2269636F6E2D63617265742D646F776E222C6C6F6164696E673A2269636F6E2D726566726573682069636F6E2D7370696E222C6E6F646174613A2269636F6E2D6D6568222C6E6F';
wwv_flow_imp.g_varchar2_table(1032) := '457870616E6465723A22222C726164696F3A2269636F6E2D636972636C652D626C616E6B222C726164696F53656C65637465643A2269636F6E2D636972636C65222C646F633A2269636F6E2D66696C652D616C74222C646F634F70656E3A2269636F6E2D';
wwv_flow_imp.g_varchar2_table(1033) := '66696C652D616C74222C666F6C6465723A2269636F6E2D666F6C6465722D636C6F73652D616C74222C666F6C6465724F70656E3A2269636F6E2D666F6C6465722D6F70656E2D616C74227D2C617765736F6D65343A7B5F616464436C6173733A22666122';
wwv_flow_imp.g_varchar2_table(1034) := '2C636865636B626F783A2266612D7371756172652D6F222C636865636B626F7853656C65637465643A2266612D636865636B2D7371756172652D6F222C636865636B626F78556E6B6E6F776E3A2266612D7371756172652066616E6379747265652D6865';
wwv_flow_imp.g_varchar2_table(1035) := '6C7065722D696E64657465726D696E6174652D6362222C6472616748656C7065723A2266612D6172726F772D7269676874222C64726F704D61726B65723A2266612D6C6F6E672D6172726F772D7269676874222C6572726F723A2266612D7761726E696E';
wwv_flow_imp.g_varchar2_table(1036) := '67222C657870616E646572436C6F7365643A2266612D63617265742D7269676874222C657870616E6465724C617A793A2266612D616E676C652D7269676874222C657870616E6465724F70656E3A2266612D63617265742D646F776E222C6C6F6164696E';
wwv_flow_imp.g_varchar2_table(1037) := '673A7B68746D6C3A223C7370616E20636C6173733D2766612066612D7370696E6E65722066612D70756C736527202F3E227D2C6E6F646174613A2266612D6D65682D6F222C6E6F457870616E6465723A22222C726164696F3A2266612D636972636C652D';
wwv_flow_imp.g_varchar2_table(1038) := '7468696E222C726164696F53656C65637465643A2266612D636972636C65222C646F633A2266612D66696C652D6F222C646F634F70656E3A2266612D66696C652D6F222C666F6C6465723A2266612D666F6C6465722D6F222C666F6C6465724F70656E3A';
wwv_flow_imp.g_varchar2_table(1039) := '2266612D666F6C6465722D6F70656E2D6F227D2C617765736F6D65353A7B5F616464436C6173733A22222C636865636B626F783A226661722066612D737175617265222C636865636B626F7853656C65637465643A226661722066612D636865636B2D73';
wwv_flow_imp.g_varchar2_table(1040) := '7175617265222C636865636B626F78556E6B6E6F776E3A226661732066612D7371756172652066616E6379747265652D68656C7065722D696E64657465726D696E6174652D6362222C726164696F3A226661722066612D636972636C65222C726164696F';
wwv_flow_imp.g_varchar2_table(1041) := '53656C65637465643A226661732066612D636972636C65222C726164696F556E6B6E6F776E3A226661722066612D646F742D636972636C65222C6472616748656C7065723A226661732066612D6172726F772D7269676874222C64726F704D61726B6572';
wwv_flow_imp.g_varchar2_table(1042) := '3A226661732066612D6C6F6E672D6172726F772D616C742D7269676874222C6572726F723A226661732066612D6578636C616D6174696F6E2D747269616E676C65222C657870616E646572436C6F7365643A226661732066612D63617265742D72696768';
wwv_flow_imp.g_varchar2_table(1043) := '74222C657870616E6465724C617A793A226661732066612D616E676C652D7269676874222C657870616E6465724F70656E3A226661732066612D63617265742D646F776E222C6C6F6164696E673A226661732066612D7370696E6E65722066612D70756C';
wwv_flow_imp.g_varchar2_table(1044) := '7365222C6E6F646174613A226661722066612D6D6568222C6E6F457870616E6465723A22222C646F633A226661722066612D66696C65222C646F634F70656E3A226661722066612D66696C65222C666F6C6465723A226661722066612D666F6C64657222';
wwv_flow_imp.g_varchar2_table(1045) := '2C666F6C6465724F70656E3A226661722066612D666F6C6465722D6F70656E227D2C626F6F747374726170333A7B5F616464436C6173733A22676C79706869636F6E222C636865636B626F783A22676C79706869636F6E2D756E636865636B6564222C63';
wwv_flow_imp.g_varchar2_table(1046) := '6865636B626F7853656C65637465643A22676C79706869636F6E2D636865636B222C636865636B626F78556E6B6E6F776E3A22676C79706869636F6E2D657870616E642066616E6379747265652D68656C7065722D696E64657465726D696E6174652D63';
wwv_flow_imp.g_varchar2_table(1047) := '62222C6472616748656C7065723A22676C79706869636F6E2D706C6179222C64726F704D61726B65723A22676C79706869636F6E2D6172726F772D7269676874222C6572726F723A22676C79706869636F6E2D7761726E696E672D7369676E222C657870';
wwv_flow_imp.g_varchar2_table(1048) := '616E646572436C6F7365643A22676C79706869636F6E2D6D656E752D7269676874222C657870616E6465724C617A793A22676C79706869636F6E2D6D656E752D7269676874222C657870616E6465724F70656E3A22676C79706869636F6E2D6D656E752D';
wwv_flow_imp.g_varchar2_table(1049) := '646F776E222C6C6F6164696E673A22676C79706869636F6E2D726566726573682066616E6379747265652D68656C7065722D7370696E222C6E6F646174613A22676C79706869636F6E2D696E666F2D7369676E222C6E6F457870616E6465723A22222C72';
wwv_flow_imp.g_varchar2_table(1050) := '6164696F3A22676C79706869636F6E2D72656D6F76652D636972636C65222C726164696F53656C65637465643A22676C79706869636F6E2D6F6B2D636972636C65222C646F633A22676C79706869636F6E2D66696C65222C646F634F70656E3A22676C79';
wwv_flow_imp.g_varchar2_table(1051) := '706869636F6E2D66696C65222C666F6C6465723A22676C79706869636F6E2D666F6C6465722D636C6F7365222C666F6C6465724F70656E3A22676C79706869636F6E2D666F6C6465722D6F70656E227D2C6D6174657269616C3A7B5F616464436C617373';
wwv_flow_imp.g_varchar2_table(1052) := '3A226D6174657269616C2D69636F6E73222C636865636B626F783A7B746578743A22636865636B5F626F785F6F75746C696E655F626C616E6B227D2C636865636B626F7853656C65637465643A7B746578743A22636865636B5F626F78227D2C63686563';
wwv_flow_imp.g_varchar2_table(1053) := '6B626F78556E6B6E6F776E3A7B746578743A22696E64657465726D696E6174655F636865636B5F626F78227D2C6472616748656C7065723A7B746578743A22706C61795F6172726F77227D2C64726F704D61726B65723A7B746578743A226172726F772D';
wwv_flow_imp.g_varchar2_table(1054) := '666F7277617264227D2C6572726F723A7B746578743A227761726E696E67227D2C657870616E646572436C6F7365643A7B746578743A2263686576726F6E5F7269676874227D2C657870616E6465724C617A793A7B746578743A226C6173745F70616765';
wwv_flow_imp.g_varchar2_table(1055) := '227D2C657870616E6465724F70656E3A7B746578743A22657870616E645F6D6F7265227D2C6C6F6164696E673A7B746578743A226175746F72656E6577222C616464436C6173733A2266616E6379747265652D68656C7065722D7370696E227D2C6E6F64';
wwv_flow_imp.g_varchar2_table(1056) := '6174613A7B746578743A22696E666F227D2C6E6F457870616E6465723A7B746578743A22227D2C726164696F3A7B746578743A22726164696F5F627574746F6E5F756E636865636B6564227D2C726164696F53656C65637465643A7B746578743A227261';
wwv_flow_imp.g_varchar2_table(1057) := '64696F5F627574746F6E5F636865636B6564227D2C646F633A7B746578743A22696E736572745F64726976655F66696C65227D2C646F634F70656E3A7B746578743A22696E736572745F64726976655F66696C65227D2C666F6C6465723A7B746578743A';
wwv_flow_imp.g_varchar2_table(1058) := '22666F6C646572227D2C666F6C6465724F70656E3A7B746578743A22666F6C6465725F6F70656E227D7D7D3B66756E6374696F6E207228742C6E2C722C692C6F297B76617220613D692E6D61702C733D615B6F5D2C6C3D65286E292C643D6C2E66696E64';
wwv_flow_imp.g_varchar2_table(1059) := '28222E66616E6379747265652D6368696C64636F756E74657222292C633D722B2220222B28612E5F616464436C6173737C7C2222293B2266756E6374696F6E223D3D747970656F662073262628733D732E63616C6C28746869732C742C6E2C6F29292C22';
wwv_flow_imp.g_varchar2_table(1060) := '737472696E67223D3D747970656F6620733F286E2E696E6E657248544D4C3D22222C6C2E617474722822636C617373222C632B2220222B73292E617070656E64286429293A73262628732E746578743F6E2E74657874436F6E74656E743D22222B732E74';
wwv_flow_imp.g_varchar2_table(1061) := '6578743A732E68746D6C3F6E2E696E6E657248544D4C3D732E68746D6C3A6E2E696E6E657248544D4C3D22222C6C2E617474722822636C617373222C632B2220222B28732E616464436C6173737C7C222229292E617070656E64286429297D7265747572';
wwv_flow_imp.g_varchar2_table(1062) := '6E20652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A22676C797068222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B7072657365743A6E756C6C2C6D61703A7B7D7D2C7472656549';
wwv_flow_imp.g_varchar2_table(1063) := '6E69743A66756E6374696F6E2872297B76617220693D722E747265652C6F3D722E6F7074696F6E732E676C7970683B6F2E7072657365743F28742E6173736572742821216E5B6F2E7072657365745D2C22496E76616C69642076616C756520666F722060';
wwv_flow_imp.g_varchar2_table(1064) := '6F7074696F6E732E676C7970682E707265736574603A20222B6F2E707265736574292C6F2E6D61703D652E657874656E64287B7D2C6E5B6F2E7072657365745D2C6F2E6D617029293A692E7761726E28226578742D676C7970683A206D697373696E6720';
wwv_flow_imp.g_varchar2_table(1065) := '6070726573657460206F7074696F6E2E22292C746869732E5F73757065724170706C7928617267756D656E7473292C692E24636F6E7461696E65722E616464436C617373282266616E6379747265652D6578742D676C79706822297D2C6E6F646552656E';
wwv_flow_imp.g_varchar2_table(1066) := '6465725374617475733A66756E6374696F6E286E297B76617220692C6F2C612C732C6C3D6E2E6E6F64652C643D65286C2E7370616E292C633D6E2E6F7074696F6E732E676C7970683B72657475726E20613D746869732E5F7375706572286E292C6C2E69';
wwv_flow_imp.g_varchar2_table(1067) := '73526F6F744E6F646528297C7C2828733D642E6368696C6472656E28222E66616E6379747265652D657870616E64657222292E676574283029292626286F3D6C2E657870616E64656426266C2E6861734368696C6472656E28293F22657870616E646572';
wwv_flow_imp.g_varchar2_table(1068) := '4F70656E223A6C2E6973556E646566696E656428293F22657870616E6465724C617A79223A6C2E6861734368696C6472656E28293F22657870616E646572436C6F736564223A226E6F457870616E646572222C72286C2C732C2266616E6379747265652D';
wwv_flow_imp.g_varchar2_table(1069) := '657870616E646572222C632C6F29292C28733D6C2E74723F6528227464222C6C2E7472292E66696E6428222E66616E6379747265652D636865636B626F7822292E6765742830293A642E6368696C6472656E28222E66616E6379747265652D636865636B';
wwv_flow_imp.g_varchar2_table(1070) := '626F7822292E67657428302929262628693D742E6576616C4F7074696F6E2822636865636B626F78222C6C2C6C2C632C2131292C6C2E706172656E7426266C2E706172656E742E726164696F67726F75707C7C22726164696F223D3D3D693F72286C2C73';
wwv_flow_imp.g_varchar2_table(1071) := '2C2266616E6379747265652D636865636B626F782066616E6379747265652D726164696F222C632C6F3D6C2E73656C65637465643F22726164696F53656C6563746564223A22726164696F22293A72286C2C732C2266616E6379747265652D636865636B';
wwv_flow_imp.g_varchar2_table(1072) := '626F78222C632C6F3D6C2E73656C65637465643F22636865636B626F7853656C6563746564223A6C2E7061727473656C3F22636865636B626F78556E6B6E6F776E223A22636865636B626F782229292C28733D642E6368696C6472656E28222E66616E63';
wwv_flow_imp.g_varchar2_table(1073) := '79747265652D69636F6E22292E676574283029292626286F3D6C2E7374617475734E6F6465547970653F6C2E7374617475734E6F6465547970653A6C2E666F6C6465723F6C2E657870616E64656426266C2E6861734368696C6472656E28293F22666F6C';
wwv_flow_imp.g_varchar2_table(1074) := '6465724F70656E223A22666F6C646572223A6C2E657870616E6465643F22646F634F70656E223A22646F63222C72286C2C732C2266616E6379747265652D69636F6E222C632C6F2929292C617D2C6E6F64655365745374617475733A66756E6374696F6E';
wwv_flow_imp.g_varchar2_table(1075) := '28742C6E2C692C6F297B76617220612C732C6C3D742E6F7074696F6E732E676C7970682C643D742E6E6F64653B72657475726E20613D746869732E5F73757065724170706C7928617267756D656E7473292C226572726F7222213D3D6E2626226C6F6164';
wwv_flow_imp.g_varchar2_table(1076) := '696E6722213D3D6E2626226E6F6461746122213D3D6E7C7C28642E706172656E743F28733D6528222E66616E6379747265652D657870616E646572222C642E7370616E292E6765742830292926267228642C732C2266616E6379747265652D657870616E';
wwv_flow_imp.g_varchar2_table(1077) := '646572222C6C2C6E293A28733D6528222E66616E6379747265652D7374617475736E6F64652D222B6E2C645B746869732E6E6F6465436F6E7461696E6572417474724E616D655D292E66696E6428222E66616E6379747265652D69636F6E22292E676574';
wwv_flow_imp.g_varchar2_table(1078) := '2830292926267228642C732C2266616E6379747265652D69636F6E222C6C2C6E29292C617D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E677269646E61762E6A730A202A0A202A2053';
wwv_flow_imp.g_varchar2_table(1079) := '7570706F7274206B6579626F617264206E617669676174696F6E20666F72207472656573207769746820656D62656464656420696E70757420636F6E74726F6C732E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66';
wwv_flow_imp.g_varchar2_table(1080) := '616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E647420286874747073';
wwv_flow_imp.g_varchar2_table(1081) := '3A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E';
wwv_flow_imp.g_varchar2_table(1082) := '7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E65';
wwv_flow_imp.g_varchar2_table(1083) := '2626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565222C222E2F6A71756572792E66616E6379747265652E7461626C65225D2C65293A226F626A656374223D3D747970656F66206D';
wwv_flow_imp.g_varchar2_table(1084) := '6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E6379747265652E7461626C6522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A51';
wwv_flow_imp.g_varchar2_table(1085) := '75657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D652E75692E6B6579436F64652C6E3D7B746578743A5B742E55502C742E444F574E5D2C636865636B626F783A5B742E55502C742E444F574E2C742E4C4546';
wwv_flow_imp.g_varchar2_table(1086) := '542C742E52494748545D2C6C696E6B3A5B742E55502C742E444F574E2C742E4C4546542C742E52494748545D2C726164696F627574746F6E3A5B742E55502C742E444F574E2C742E4C4546542C742E52494748545D2C2273656C6563742D6F6E65223A5B';
wwv_flow_imp.g_varchar2_table(1087) := '742E4C4546542C742E52494748545D2C2273656C6563742D6D756C7469706C65223A5B742E4C4546542C742E52494748545D7D3B66756E6374696F6E207228742C6E297B76617220722C693D6E756C6C2C6F3D303B72657475726E20742E6368696C6472';
wwv_flow_imp.g_varchar2_table(1088) := '656E28292E656163682866756E6374696F6E28297B6966286F3E3D6E2972657475726E20693D652874686973292C21313B723D652874686973292E70726F702822636F6C7370616E22292C6F2B3D727C7C317D292C697D66756E6374696F6E2069286E2C';
wwv_flow_imp.g_varchar2_table(1089) := '69297B766172206F2C612C733D6E2E636C6F736573742822746422292C6C3D6E756C6C3B7377697463682869297B6361736520742E4C4546543A6C3D732E7072657628293B627265616B3B6361736520742E52494748543A6C3D732E6E65787428293B62';
wwv_flow_imp.g_varchar2_table(1090) := '7265616B3B6361736520742E55503A6361736520742E444F574E3A666F7228613D66756E6374696F6E28742C6E297B76617220722C693D6E2E6765742830292C6F3D303B72657475726E20742E6368696C6472656E28292E656163682866756E6374696F';
wwv_flow_imp.g_varchar2_table(1091) := '6E28297B696628746869733D3D3D692972657475726E21313B723D652874686973292E70726F702822636F6C7370616E22292C6F2B3D727C7C317D292C6F7D286F3D732E706172656E7428292C73293B286F3D693D3D3D742E55503F6F2E707265762829';
wwv_flow_imp.g_varchar2_table(1092) := '3A6F2E6E6578742829292E6C656E6774682626286F2E697328223A68696464656E22297C7C21286C3D72286F2C6129297C7C216C2E66696E6428223A696E7075742C6122292E6C656E677468293B293B7D72657475726E206C7D72657475726E20652E75';
wwv_flow_imp.g_varchar2_table(1093) := '692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A22677269646E6176222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B6175746F666F637573496E7075743A21312C68616E646C6543757273';
wwv_flow_imp.g_varchar2_table(1094) := '6F724B6579733A21307D2C74726565496E69743A66756E6374696F6E2874297B746869732E5F72657175697265457874656E73696F6E28227461626C65222C21302C2130292C746869732E5F73757065724170706C7928617267756D656E7473292C7468';
wwv_flow_imp.g_varchar2_table(1095) := '69732E24636F6E7461696E65722E616464436C617373282266616E6379747265652D6578742D677269646E617622292C746869732E24636F6E7461696E65722E6F6E2822666F637573696E222C66756E6374696F6E286E297B76617220722C693D652E75';
wwv_flow_imp.g_varchar2_table(1096) := '692E66616E6379747265652E6765744E6F6465286E2E746172676574293B69262621692E69734163746976652829262628723D742E747265652E5F6D616B65486F6F6B436F6E7465787428692C6E292C742E747265652E5F63616C6C486F6F6B28226E6F';
wwv_flow_imp.g_varchar2_table(1097) := '6465536574416374697665222C722C213029297D297D2C6E6F64655365744163746976653A66756E6374696F6E28742C6E2C72297B76617220693D742E6F7074696F6E732E677269646E61762C6F3D742E6E6F64652C613D742E6F726967696E616C4576';
wwv_flow_imp.g_varchar2_table(1098) := '656E747C7C7B7D2C733D6528612E746172676574292E697328223A696E70757422293B6E3D2131213D3D6E2C746869732E5F73757065724170706C7928617267756D656E7473292C6E262628742E6F7074696F6E732E7469746C65735461626261626C65';
wwv_flow_imp.g_varchar2_table(1099) := '3F28737C7C2865286F2E7370616E292E66696E6428227370616E2E66616E6379747265652D7469746C6522292E747269676765722822666F63757322292C6F2E736574466F6375732829292C742E747265652E24636F6E7461696E65722E617474722822';
wwv_flow_imp.g_varchar2_table(1100) := '746162696E646578222C222D312229293A692E6175746F666F637573496E70757426262173262665286F2E74727C7C6F2E7370616E292E66696E6428223A696E7075743A656E61626C656422292E666972737428292E747269676765722822666F637573';
wwv_flow_imp.g_varchar2_table(1101) := '2229297D2C6E6F64654B6579646F776E3A66756E6374696F6E2874297B76617220722C6F2C612C733D742E6F7074696F6E732E677269646E61762C6C3D742E6F726967696E616C4576656E742C643D65286C2E746172676574293B72657475726E20642E';
wwv_flow_imp.g_varchar2_table(1102) := '697328223A696E7075743A656E61626C656422293F723D642E70726F7028227479706522293A642E69732822612229262628723D226C696E6B22292C722626732E68616E646C65437572736F724B6579733F2128286F3D6E5B725D292626652E696E4172';
wwv_flow_imp.g_varchar2_table(1103) := '726179286C2E77686963682C6F293E3D30262628613D6928642C6C2E776869636829292626612E6C656E677468297C7C28612E66696E6428223A696E7075743A656E61626C65642C6122292E747269676765722822666F63757322292C2131293A746869';
wwv_flow_imp.g_varchar2_table(1104) := '732E5F73757065724170706C7928617267756D656E7473297D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E6D756C74692E6A730A202A0A202A20416C6C6F77206D756C7469706C6520';
wwv_flow_imp.g_varchar2_table(1105) := '73656C656374696F6E206F66206E6F64657320206279206D6F757365206F72206B6579626F6172642E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F67697468';
wwv_flow_imp.g_varchar2_table(1106) := '75622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C65';
wwv_flow_imp.g_varchar2_table(1107) := '6173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33';
wwv_flow_imp.g_varchar2_table(1108) := '382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175';
wwv_flow_imp.g_varchar2_table(1109) := '657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E6379747265652229';
wwv_flow_imp.g_varchar2_table(1110) := '2C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B72657475726E20652E75692E66616E6379747265652E72656769';
wwv_flow_imp.g_varchar2_table(1111) := '73746572457874656E73696F6E287B6E616D653A226D756C7469222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B616C6C6F774E6F53656C6563743A21312C6D6F64653A2273616D65506172656E74227D2C74726565496E69743A66';
wwv_flow_imp.g_varchar2_table(1112) := '756E6374696F6E2874297B746869732E5F73757065724170706C7928617267756D656E7473292C746869732E24636F6E7461696E65722E616464436C617373282266616E6379747265652D6578742D6D756C746922292C313D3D3D742E6F7074696F6E73';
wwv_flow_imp.g_varchar2_table(1113) := '2E73656C6563744D6F64652626652E6572726F72282246616E637974726565206578742D6D756C74693A2073656C6563744D6F64653A2031202873696E676C6529206973206E6F7420636F6D70617469626C652E22297D2C6E6F6465436C69636B3A6675';
wwv_flow_imp.g_varchar2_table(1114) := '6E6374696F6E2874297B766172206E3D742E747265652C723D742E6E6F64652C693D6E2E6765744163746976654E6F646528297C7C6E2E67657446697273744368696C6428292C6F3D22636865636B626F78223D3D3D742E746172676574547970652C61';
wwv_flow_imp.g_varchar2_table(1115) := '3D22657870616E646572223D3D3D742E746172676574547970653B73776974636828652E75692E66616E6379747265652E6576656E74546F537472696E6728742E6F726967696E616C4576656E7429297B6361736522636C69636B223A69662861296272';
wwv_flow_imp.g_varchar2_table(1116) := '65616B3B6F7C7C286E2E73656C656374416C6C282131292C722E73657453656C65637465642829293B627265616B3B636173652273686966742B636C69636B223A6E2E7669736974526F77732866756E6374696F6E2865297B696628652E73657453656C';
wwv_flow_imp.g_varchar2_table(1117) := '656374656428292C653D3D3D722972657475726E21317D2C7B73746172743A692C726576657273653A692E697342656C6F774F662872297D293B627265616B3B63617365226374726C2B636C69636B223A63617365226D6574612B636C69636B223A7265';
wwv_flow_imp.g_varchar2_table(1118) := '7475726E20766F696420722E746F67676C6553656C656374656428297D72657475726E20746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F64654B6579646F776E3A66756E6374696F6E2874297B766172206E3D742E747265';
wwv_flow_imp.g_varchar2_table(1119) := '652C723D742E6E6F64652C693D742E6F726967696E616C4576656E743B73776974636828652E75692E66616E6379747265652E6576656E74546F537472696E67286929297B63617365227570223A6361736522646F776E223A6E2E73656C656374416C6C';
wwv_flow_imp.g_varchar2_table(1120) := '282131292C722E6E6176696761746528692E77686963682C2130292C6E2E6765744163746976654E6F646528292E73657453656C656374656428293B627265616B3B636173652273686966742B7570223A636173652273686966742B646F776E223A722E';
wwv_flow_imp.g_varchar2_table(1121) := '6E6176696761746528692E77686963682C2130292C6E2E6765744163746976654E6F646528292E73657453656C656374656428297D72657475726E20746869732E5F73757065724170706C7928617267756D656E7473297D7D292C652E75692E66616E63';
wwv_flow_imp.g_varchar2_table(1122) := '79747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E706572736973742E6A730A202A0A202A205065727369737420747265652073746174757320696E20636F6F6B69657352656D6F7665206F7220686967686C6967687420';
wwv_flow_imp.g_varchar2_table(1123) := '74726565206E6F6465732C206261736564206F6E20612066696C7465722E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231';
wwv_flow_imp.g_varchar2_table(1124) := '302F66616E6379747265652F290A202A0A202A2040646570656E64733A206A732D636F6F6B6965206F72206A71756572792D636F6F6B69650A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474';
wwv_flow_imp.g_varchar2_table(1125) := '202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B';
wwv_flow_imp.g_varchar2_table(1126) := '692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F66';
wwv_flow_imp.g_varchar2_table(1127) := '20646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274';
wwv_flow_imp.g_varchar2_table(1128) := '733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B22757365207374';
wwv_flow_imp.g_varchar2_table(1129) := '72696374223B76617220743D6E756C6C2C6E3D6E756C6C2C723D6E756C6C2C693D652E75692E66616E6379747265652E6173736572742C6F3D22616374697665222C613D22657870616E646564222C733D22666F637573222C6C3D2273656C6563746564';
wwv_flow_imp.g_varchar2_table(1130) := '223B7472797B692877696E646F772E6C6F63616C53746F72616765262677696E646F772E6C6F63616C53746F726167652E6765744974656D292C6E3D7B6765743A66756E6374696F6E2865297B72657475726E2077696E646F772E6C6F63616C53746F72';
wwv_flow_imp.g_varchar2_table(1131) := '6167652E6765744974656D2865297D2C7365743A66756E6374696F6E28652C74297B77696E646F772E6C6F63616C53746F726167652E7365744974656D28652C74297D2C72656D6F76653A66756E6374696F6E2865297B77696E646F772E6C6F63616C53';
wwv_flow_imp.g_varchar2_table(1132) := '746F726167652E72656D6F76654974656D2865297D7D7D63617463682874297B652E75692E66616E6379747265652E7761726E2822436F756C64206E6F74206163636573732077696E646F772E6C6F63616C53746F72616765222C74297D7472797B6928';
wwv_flow_imp.g_varchar2_table(1133) := '77696E646F772E73657373696F6E53746F72616765262677696E646F772E73657373696F6E53746F726167652E6765744974656D292C723D7B6765743A66756E6374696F6E2865297B72657475726E2077696E646F772E73657373696F6E53746F726167';
wwv_flow_imp.g_varchar2_table(1134) := '652E6765744974656D2865297D2C7365743A66756E6374696F6E28652C74297B77696E646F772E73657373696F6E53746F726167652E7365744974656D28652C74297D2C72656D6F76653A66756E6374696F6E2865297B77696E646F772E73657373696F';
wwv_flow_imp.g_varchar2_table(1135) := '6E53746F726167652E72656D6F76654974656D2865297D7D7D63617463682874297B652E75692E66616E6379747265652E7761726E2822436F756C64206E6F74206163636573732077696E646F772E73657373696F6E53746F72616765222C74297D6675';
wwv_flow_imp.g_varchar2_table(1136) := '6E6374696F6E206428742C6E2C722C692C6F297B76617220732C6C2C632C752C663D21312C703D742E6F7074696F6E732E706572736973742E657870616E644F7074732C683D5B5D2C673D5B5D3B666F7228723D727C7C5B5D2C6F3D6F7C7C652E446566';
wwv_flow_imp.g_varchar2_table(1137) := '657272656428292C733D302C633D722E6C656E6774683B733C633B732B2B296966286C3D725B735D2C753D742E6765744E6F646542794B6579286C2929696628692626752E6973556E646566696E6564282929663D21302C742E646562756728225F6C6F';
wwv_flow_imp.g_varchar2_table(1138) := '61644C617A794E6F6465733A20222B752B22206973206C617A793A206C6F6164696E672E2E2E22292C22657870616E64223D3D3D693F682E7075736828752E736574457870616E6465642821302C7029293A682E7075736828752E6C6F61642829293B65';
wwv_flow_imp.g_varchar2_table(1139) := '6C73657B742E646562756728225F6C6F61644C617A794E6F6465733A20222B752B2220616C7265616479206C6F616465642E22293B7472797B752E736574457870616E6465642821302C70297D63617463682865297B742E7761726E28226578742D7065';
wwv_flow_imp.g_varchar2_table(1140) := '72736973743A20736574457870616E646564206661696C656420666F7220222B752C65297D7D656C736520672E70757368286C292C742E646562756728225F6C6F61644C617A794E6F6465733A20222B752B2220776173206E6F742079657420666F756E';
wwv_flow_imp.g_varchar2_table(1141) := '642E22293B72657475726E20652E7768656E2E6170706C7928652C68292E616C776179732866756E6374696F6E28297B696628662626672E6C656E6774683E30296428742C6E2C672C692C6F293B656C73657B696628672E6C656E67746829666F722874';
wwv_flow_imp.g_varchar2_table(1142) := '2E7761726E28225F6C6F61644C617A794E6F6465733A20636F756C64206E6F74206C6F61642074686F7365206B6579733A20222C67292C733D302C633D672E6C656E6774683B733C633B732B2B296C3D725B735D2C6E2E5F617070656E644B657928612C';
wwv_flow_imp.g_varchar2_table(1143) := '725B735D2C2131293B6F2E7265736F6C766528297D7D292C6F7D72657475726E2266756E6374696F6E223D3D747970656F6620436F6F6B6965733F743D7B6765743A436F6F6B6965732E6765742C7365743A66756E6374696F6E28652C74297B436F6F6B';
wwv_flow_imp.g_varchar2_table(1144) := '6965732E73657428652C742C746869732E6F7074696F6E732E706572736973742E636F6F6B6965297D2C72656D6F76653A436F6F6B6965732E72656D6F76657D3A6526262266756E6374696F6E223D3D747970656F6620652E636F6F6B6965262628743D';
wwv_flow_imp.g_varchar2_table(1145) := '7B6765743A652E636F6F6B69652C7365743A66756E6374696F6E28742C6E297B652E636F6F6B696528742C6E2C746869732E6F7074696F6E732E706572736973742E636F6F6B6965297D2C72656D6F76653A652E72656D6F7665436F6F6B69657D292C65';
wwv_flow_imp.g_varchar2_table(1146) := '2E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E636C65617250657273697374446174613D66756E6374696F6E2865297B76617220743D746869732E6578742E706572736973742C6E3D742E636F6F6B';
wwv_flow_imp.g_varchar2_table(1147) := '69655072656669783B28653D657C7C2261637469766520657870616E64656420666F6375732073656C656374656422292E696E6465784F66286F293E3D302626742E5F64617461286E2B6F2C6E756C6C292C652E696E6465784F662861293E3D30262674';
wwv_flow_imp.g_varchar2_table(1148) := '2E5F64617461286E2B612C6E756C6C292C652E696E6465784F662873293E3D302626742E5F64617461286E2B732C6E756C6C292C652E696E6465784F66286C293E3D302626742E5F64617461286E2B6C2C6E756C6C297D2C652E75692E66616E63797472';
wwv_flow_imp.g_varchar2_table(1149) := '65652E5F46616E637974726565436C6173732E70726F746F747970652E636C656172436F6F6B6965733D66756E6374696F6E2865297B72657475726E20746869732E7761726E282227747265652E636C656172436F6F6B69657328292720697320646570';
wwv_flow_imp.g_varchar2_table(1150) := '726563617465642073696E63652076322E32372E303A207573652027636C656172506572736973744461746128292720696E73746561642E22292C746869732E636C65617250657273697374446174612865297D2C652E75692E66616E6379747265652E';
wwv_flow_imp.g_varchar2_table(1151) := '5F46616E637974726565436C6173732E70726F746F747970652E67657450657273697374446174613D66756E6374696F6E28297B76617220653D746869732E6578742E706572736973742C743D652E636F6F6B69655072656669782C6E3D652E636F6F6B';
wwv_flow_imp.g_varchar2_table(1152) := '696544656C696D697465722C723D7B7D3B72657475726E20725B6F5D3D652E5F6461746128742B6F292C725B615D3D28652E5F6461746128742B61297C7C2222292E73706C6974286E292C725B6C5D3D28652E5F6461746128742B6C297C7C2222292E73';
wwv_flow_imp.g_varchar2_table(1153) := '706C6974286E292C725B735D3D652E5F6461746128742B73292C727D2C652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A2270657273697374222C76657273696F6E3A22322E33382E34222C6F7074696F';
wwv_flow_imp.g_varchar2_table(1154) := '6E733A7B636F6F6B696544656C696D697465723A227E222C636F6F6B69655072656669783A766F696420302C636F6F6B69653A7B7261773A21312C657870697265733A22222C706174683A22222C646F6D61696E3A22222C7365637572653A21317D2C65';
wwv_flow_imp.g_varchar2_table(1155) := '7870616E644C617A793A21312C657870616E644F7074733A766F696420302C6669726541637469766174653A21302C6F76657272696465536F757263653A21302C73746F72653A226175746F222C74797065733A2261637469766520657870616E646564';
wwv_flow_imp.g_varchar2_table(1156) := '20666F6375732073656C6563746564227D2C5F646174613A66756E6374696F6E28652C74297B766172206E3D746869732E5F6C6F63616C2E73746F72653B696628766F696420303D3D3D742972657475726E206E2E6765742E63616C6C28746869732C65';
wwv_flow_imp.g_varchar2_table(1157) := '293B6E756C6C3D3D3D743F6E2E72656D6F76652E63616C6C28746869732C65293A6E2E7365742E63616C6C28746869732C652C74297D2C5F617070656E644B65793A66756E6374696F6E28742C6E2C72297B6E3D22222B6E3B76617220693D746869732E';
wwv_flow_imp.g_varchar2_table(1158) := '5F6C6F63616C2C6F3D746869732E6F7074696F6E732E706572736973742E636F6F6B696544656C696D697465722C613D692E636F6F6B69655072656669782B742C733D692E5F646174612861292C6C3D733F732E73706C6974286F293A5B5D2C643D652E';
wwv_flow_imp.g_varchar2_table(1159) := '696E4172726179286E2C6C293B643E3D3026266C2E73706C69636528642C31292C7226266C2E70757368286E292C692E5F6461746128612C6C2E6A6F696E286F29297D2C74726565496E69743A66756E6374696F6E2863297B76617220753D632E747265';
wwv_flow_imp.g_varchar2_table(1160) := '652C663D632E6F7074696F6E732C703D746869732E5F6C6F63616C2C683D746869732E6F7074696F6E732E706572736973743B72657475726E20702E636F6F6B69655072656669783D682E636F6F6B69655072656669787C7C2266616E6379747265652D';
wwv_flow_imp.g_varchar2_table(1161) := '222B752E5F69642B222D222C702E73746F72654163746976653D682E74797065732E696E6465784F66286F293E3D302C702E73746F7265457870616E6465643D682E74797065732E696E6465784F662861293E3D302C702E73746F726553656C65637465';
wwv_flow_imp.g_varchar2_table(1162) := '643D682E74797065732E696E6465784F66286C293E3D302C702E73746F7265466F6375733D682E74797065732E696E6465784F662873293E3D302C702E73746F72653D6E756C6C2C226175746F223D3D3D682E73746F7265262628682E73746F72653D6E';
wwv_flow_imp.g_varchar2_table(1163) := '3F226C6F63616C223A22636F6F6B696522292C652E6973506C61696E4F626A65637428682E73746F7265293F702E73746F72653D682E73746F72653A22636F6F6B6965223D3D3D682E73746F72653F702E73746F72653D743A28226C6F63616C223D3D3D';
wwv_flow_imp.g_varchar2_table(1164) := '682E73746F72657C7C2273657373696F6E223D3D3D682E73746F726529262628702E73746F72653D226C6F63616C223D3D3D682E73746F72653F6E3A72292C6928702E73746F72652C224E65656420612076616C69642073746F72652E22292C752E2464';
wwv_flow_imp.g_varchar2_table(1165) := '69762E6F6E282266616E637974726565696E6974222C66756E6374696F6E2874297B6966282131213D3D752E5F74726967676572547265654576656E7428226265666F7265526573746F7265222C6E756C6C2C7B7D29297B766172206E2C722C692C632C';
wwv_flow_imp.g_varchar2_table(1166) := '673D702E5F6461746128702E636F6F6B69655072656669782B73292C793D21313D3D3D682E6669726541637469766174653B6E3D702E5F6461746128702E636F6F6B69655072656669782B61292C693D6E26266E2E73706C697428682E636F6F6B696544';
wwv_flow_imp.g_varchar2_table(1167) := '656C696D69746572292C28702E73746F7265457870616E6465643F6428752C702C692C2121682E657870616E644C617A79262622657870616E64222C6E756C6C293A286E657720652E4465666572726564292E7265736F6C76652829292E646F6E652866';
wwv_flow_imp.g_varchar2_table(1168) := '756E6374696F6E28297B696628702E73746F726553656C6563746564297B6966286E3D702E5F6461746128702E636F6F6B69655072656669782B6C2929666F7228693D6E2E73706C697428682E636F6F6B696544656C696D69746572292C723D303B723C';
wwv_flow_imp.g_varchar2_table(1169) := '692E6C656E6774683B722B2B2928633D752E6765744E6F646542794B657928695B725D29293F28766F696420303D3D3D632E73656C65637465647C7C682E6F76657272696465536F75726365262621313D3D3D632E73656C656374656429262628632E73';
wwv_flow_imp.g_varchar2_table(1170) := '656C65637465643D21302C632E72656E6465725374617475732829293A702E5F617070656E644B6579286C2C695B725D2C2131293B333D3D3D752E6F7074696F6E732E73656C6563744D6F64652626752E76697369742866756E6374696F6E2865297B69';
wwv_flow_imp.g_varchar2_table(1171) := '6628652E73656C65637465642972657475726E20652E66697853656C656374696F6E334166746572436C69636B28292C22736B6970227D297D702E73746F726541637469766526262821286E3D702E5F6461746128702E636F6F6B69655072656669782B';
wwv_flow_imp.g_varchar2_table(1172) := '6F29297C7C21662E706572736973742E6F76657272696465536F757263652626752E6163746976654E6F64657C7C28633D752E6765744E6F646542794B6579286E2929262628632E64656275672822706572736973743A2073657420616374697665222C';
wwv_flow_imp.g_varchar2_table(1173) := '6E292C632E7365744163746976652821302C7B6E6F466F6375733A21302C6E6F4576656E74733A797D2929292C702E73746F7265466F637573262667262628633D752E6765744E6F646542794B657928672929262628752E6F7074696F6E732E7469746C';
wwv_flow_imp.g_varchar2_table(1174) := '65735461626261626C653F6528632E7370616E292E66696E6428222E66616E6379747265652D7469746C6522292E747269676765722822666F63757322293A6528752E24636F6E7461696E6572292E747269676765722822666F6375732229292C752E5F';
wwv_flow_imp.g_varchar2_table(1175) := '74726967676572547265654576656E742822726573746F7265222C6E756C6C2C7B7D297D297D7D292C746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F64655365744163746976653A66756E6374696F6E28652C742C6E297B';
wwv_flow_imp.g_varchar2_table(1176) := '76617220722C693D746869732E5F6C6F63616C3B72657475726E20743D2131213D3D742C723D746869732E5F73757065724170706C7928617267756D656E7473292C692E73746F72654163746976652626692E5F6461746128692E636F6F6B6965507265';
wwv_flow_imp.g_varchar2_table(1177) := '6669782B6F2C746869732E6163746976654E6F64653F746869732E6163746976654E6F64652E6B65793A6E756C6C292C727D2C6E6F6465536574457870616E6465643A66756E6374696F6E28652C742C6E297B76617220722C693D652E6E6F64652C6F3D';
wwv_flow_imp.g_varchar2_table(1178) := '746869732E5F6C6F63616C3B72657475726E20743D2131213D3D742C723D746869732E5F73757065724170706C7928617267756D656E7473292C6F2E73746F7265457870616E64656426266F2E5F617070656E644B657928612C692E6B65792C74292C72';
wwv_flow_imp.g_varchar2_table(1179) := '7D2C6E6F6465536574466F6375733A66756E6374696F6E28652C74297B766172206E2C723D746869732E5F6C6F63616C3B72657475726E20743D2131213D3D742C6E3D746869732E5F73757065724170706C7928617267756D656E7473292C722E73746F';
wwv_flow_imp.g_varchar2_table(1180) := '7265466F6375732626722E5F6461746128722E636F6F6B69655072656669782B732C746869732E666F6375734E6F64653F746869732E666F6375734E6F64652E6B65793A6E756C6C292C6E7D2C6E6F646553657453656C65637465643A66756E6374696F';
wwv_flow_imp.g_varchar2_table(1181) := '6E28742C6E2C72297B76617220692C6F2C613D742E747265652C733D742E6E6F64652C643D746869732E5F6C6F63616C3B72657475726E206E3D2131213D3D6E2C693D746869732E5F73757065724170706C7928617267756D656E7473292C642E73746F';
wwv_flow_imp.g_varchar2_table(1182) := '726553656C6563746564262628333D3D3D612E6F7074696F6E732E73656C6563744D6F64653F286F3D286F3D652E6D617028612E67657453656C65637465644E6F646573282130292C66756E6374696F6E2865297B72657475726E20652E6B65797D2929';
wwv_flow_imp.g_varchar2_table(1183) := '2E6A6F696E28742E6F7074696F6E732E706572736973742E636F6F6B696544656C696D69746572292C642E5F6461746128642E636F6F6B69655072656669782B6C2C6F29293A642E5F617070656E644B6579286C2C732E6B65792C732E73656C65637465';
wwv_flow_imp.g_varchar2_table(1184) := '6429292C697D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E7461626C652E6A730A202A0A202A2052656E6465722074726565206173207461626C652028616B61202774726565206772';
wwv_flow_imp.g_varchar2_table(1185) := '6964272C20277461626C65207472656527292E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E637974726565';
wwv_flow_imp.g_varchar2_table(1186) := '2F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963';
wwv_flow_imp.g_varchar2_table(1187) := '656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32';
wwv_flow_imp.g_varchar2_table(1188) := '375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E63797472';
wwv_flow_imp.g_varchar2_table(1189) := '6565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D652872657175';
wwv_flow_imp.g_varchar2_table(1190) := '69726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D652E75692E66616E6379747265652E6173736572743B66756E6374696F6E206E28652C74297B652E7669';
wwv_flow_imp.g_varchar2_table(1191) := '7369742866756E6374696F6E2865297B766172206E3D652E74723B6966286E2626286E2E7374796C652E646973706C61793D652E686964657C7C21743F226E6F6E65223A2222292C21652E657870616E6465642972657475726E22736B6970227D297D72';
wwv_flow_imp.g_varchar2_table(1192) := '657475726E20652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A227461626C65222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B636865636B626F78436F6C756D6E4964783A6E756C';
wwv_flow_imp.g_varchar2_table(1193) := '6C2C696E64656E746174696F6E3A31362C6D65726765537461747573436F6C756D6E733A21302C6E6F6465436F6C756D6E4964783A307D2C74726565496E69743A66756E6374696F6E286E297B76617220722C692C6F2C612C733D6E2E747265652C6C3D';
wwv_flow_imp.g_varchar2_table(1194) := '6E2E6F7074696F6E732C643D6C2E7461626C652C633D732E7769646765742E656C656D656E743B6966286E756C6C213D642E637573746F6D5374617475732626286E756C6C3D3D6C2E72656E646572537461747573436F6C756D6E733F28732E7761726E';
wwv_flow_imp.g_varchar2_table(1195) := '28225468652027637573746F6D53746174757327206F7074696F6E20697320646570726563617465642073696E63652076322E31352E302E20557365202772656E646572537461747573436F6C756D6E732720696E73746561642E22292C6C2E72656E64';
wwv_flow_imp.g_varchar2_table(1196) := '6572537461747573436F6C756D6E733D642E637573746F6D537461747573293A652E6572726F7228225468652027637573746F6D53746174757327206F7074696F6E20697320646570726563617465642073696E63652076322E31352E302E2055736520';
wwv_flow_imp.g_varchar2_table(1197) := '2772656E646572537461747573436F6C756D6E7327206F6E6C7920696E73746561642E2229292C6C2E72656E646572537461747573436F6C756D6E73262621303D3D3D6C2E72656E646572537461747573436F6C756D6E732626286C2E72656E64657253';
wwv_flow_imp.g_varchar2_table(1198) := '7461747573436F6C756D6E733D6C2E72656E646572436F6C756D6E73292C632E616464436C617373282266616E6379747265652D636F6E7461696E65722066616E6379747265652D6578742D7461626C6522292C28613D632E66696E6428223E74626F64';
wwv_flow_imp.g_varchar2_table(1199) := '792229292E6C656E6774687C7C28632E66696E6428223E747222292E6C656E6774682626652E6572726F7228224578706563746564207461626C65203E2074626F6479203E2074722E20496620796F7520736565207468697320706C65617365206F7065';
wwv_flow_imp.g_varchar2_table(1200) := '6E20616E2069737375652E22292C613D6528223C74626F64793E22292E617070656E64546F286329292C732E74626F64793D615B305D2C732E636F6C756D6E436F756E743D6528227468656164203E7472222C63292E6C61737428292E66696E6428223E';
wwv_flow_imp.g_varchar2_table(1201) := '7468222C63292E6C656E6774682C286F3D612E6368696C6472656E2822747222292E66697273742829292E6C656E67746829693D6F2E6368696C6472656E2822746422292E6C656E6774682C732E636F6C756D6E436F756E74262669213D3D732E636F6C';
wwv_flow_imp.g_varchar2_table(1202) := '756D6E436F756E74262628732E7761726E2822436F6C756D6E20636F756E74206D69736D61746368206265747765656E2074686561642028222B732E636F6C756D6E436F756E742B222920616E642074626F64792028222B692B22293A207573696E6720';
wwv_flow_imp.g_varchar2_table(1203) := '74626F64792E22292C732E636F6C756D6E436F756E743D69292C6F3D6F2E636C6F6E6528293B656C736520666F72287428732E636F6C756D6E436F756E743E3D312C224E65656420656974686572203C74686561643E206F72203C74626F64793E207769';
wwv_flow_imp.g_varchar2_table(1204) := '7468203C74643E20656C656D656E747320746F2064657465726D696E6520636F6C756D6E20636F756E742E22292C6F3D6528223C7472202F3E22292C723D303B723C732E636F6C756D6E436F756E743B722B2B296F2E617070656E6428223C7464202F3E';
wwv_flow_imp.g_varchar2_table(1205) := '22293B6F2E66696E6428223E746422292E657128642E6E6F6465436F6C756D6E496478292E68746D6C28223C7370616E20636C6173733D2766616E6379747265652D6E6F646527202F3E22292C6C2E617269612626286F2E617474722822726F6C65222C';
wwv_flow_imp.g_varchar2_table(1206) := '22726F7722292C6F2E66696E642822746422292E617474722822726F6C65222C226772696463656C6C2229292C732E726F77467261676D656E743D646F63756D656E742E637265617465446F63756D656E74467261676D656E7428292C732E726F774672';
wwv_flow_imp.g_varchar2_table(1207) := '61676D656E742E617070656E644368696C64286F2E676574283029292C612E656D70747928292C732E737461747573436C61737350726F704E616D653D227472222C732E6172696150726F704E616D653D227472222C746869732E6E6F6465436F6E7461';
wwv_flow_imp.g_varchar2_table(1208) := '696E6572417474724E616D653D227472222C732E24636F6E7461696E65723D632C746869732E5F73757065724170706C7928617267756D656E7473292C6528732E726F6F744E6F64652E756C292E72656D6F766528292C732E726F6F744E6F64652E756C';
wwv_flow_imp.g_varchar2_table(1209) := '3D6E756C6C2C746869732E24636F6E7461696E65722E617474722822746162696E646578222C6C2E746162696E646578292C6C2E617269612626732E24636F6E7461696E65722E617474722822726F6C65222C22747265656772696422292E6174747228';
wwv_flow_imp.g_varchar2_table(1210) := '22617269612D726561646F6E6C79222C2130297D2C6E6F646552656D6F76654368696C644D61726B75703A66756E6374696F6E2874297B742E6E6F64652E76697369742866756E6374696F6E2874297B742E74722626286528742E7472292E72656D6F76';
wwv_flow_imp.g_varchar2_table(1211) := '6528292C742E74723D6E756C6C297D297D2C6E6F646552656D6F76654D61726B75703A66756E6374696F6E2874297B766172206E3D742E6E6F64653B6E2E747226262865286E2E7472292E72656D6F766528292C6E2E74723D6E756C6C292C746869732E';
wwv_flow_imp.g_varchar2_table(1212) := '6E6F646552656D6F76654368696C644D61726B75702874297D2C6E6F646552656E6465723A66756E6374696F6E28722C692C6F2C612C73297B766172206C2C642C632C752C662C702C682C672C793D722E747265652C763D722E6E6F64652C6D3D722E6F';
wwv_flow_imp.g_varchar2_table(1213) := '7074696F6E732C783D21762E706172656E743B6966282131213D3D792E5F656E61626C65557064617465297B696628737C7C28722E686173436F6C6C6170736564506172656E74733D762E706172656E74262621762E706172656E742E657870616E6465';
wwv_flow_imp.g_varchar2_table(1214) := '64292C217829696628762E74722626692626746869732E6E6F646552656D6F76654D61726B75702872292C762E747229693F746869732E6E6F646552656E6465725469746C652872293A746869732E6E6F646552656E6465725374617475732872293B65';
wwv_flow_imp.g_varchar2_table(1215) := '6C73657B696628722E686173436F6C6C6170736564506172656E74732626216F2972657475726E3B663D792E726F77467261676D656E742E66697273744368696C642E636C6F6E654E6F6465282130292C703D66756E6374696F6E286E297B7661722072';
wwv_flow_imp.g_varchar2_table(1216) := '2C692C6F3D6E2E706172656E742C613D6F3F6F2E6368696C6472656E3A6E756C6C3B696628612626612E6C656E6774683E312626615B305D213D3D6E29666F7228693D615B652E696E4172726179286E2C61292D315D2C7428692E74722C22707265762E';
wwv_flow_imp.g_varchar2_table(1217) := '7472206D697373696E673A20222B69293B692E6368696C6472656E2626692E6368696C6472656E2E6C656E677468262628723D692E6368696C6472656E5B692E6368696C6472656E2E6C656E6774682D315D292E74723B29693D723B656C736520693D6F';
wwv_flow_imp.g_varchar2_table(1218) := '3B72657475726E20697D2876292C742870292C2821303D3D3D612626737C7C6F2626722E686173436F6C6C6170736564506172656E747329262628662E7374796C652E646973706C61793D226E6F6E6522292C702E74723F28623D702E74722C433D662C';
wwv_flow_imp.g_varchar2_table(1219) := '622E706172656E744E6F64652E696E736572744265666F726528432C622E6E6578745369626C696E6729293A28742821702E706172656E742C22707265762E20726F77206D757374206861766520612074722C206F722062652073797374656D20726F6F';
wwv_flow_imp.g_varchar2_table(1220) := '743A20222B70292C66756E6374696F6E28652C74297B652E696E736572744265666F726528742C652E66697273744368696C64297D28792E74626F64792C6629292C762E74723D662C762E6B657926266D2E67656E6572617465496473262628762E7472';
wwv_flow_imp.g_varchar2_table(1221) := '2E69643D6D2E69645072656669782B762E6B6579292C762E74722E66746E6F64653D762C762E7370616E3D6528227370616E2E66616E6379747265652D6E6F6465222C762E7472292E6765742830292C746869732E6E6F646552656E6465725469746C65';
wwv_flow_imp.g_varchar2_table(1222) := '2872292C6D2E6372656174654E6F646526266D2E6372656174654E6F64652E63616C6C28792C7B747970653A226372656174654E6F6465227D2C72297D76617220622C433B6966286D2E72656E6465724E6F646526266D2E72656E6465724E6F64652E63';
wwv_flow_imp.g_varchar2_table(1223) := '616C6C28792C7B747970653A2272656E6465724E6F6465227D2C72292C286C3D762E6368696C6472656E29262628787C7C6F7C7C762E657870616E6465642929666F7228633D302C753D6C2E6C656E6774683B633C753B632B2B2928673D652E65787465';
wwv_flow_imp.g_varchar2_table(1224) := '6E64287B7D2C722C7B6E6F64653A6C5B635D7D29292E686173436F6C6C6170736564506172656E74733D672E686173436F6C6C6170736564506172656E74737C7C21762E657870616E6465642C746869732E6E6F646552656E64657228672C692C6F2C61';
wwv_flow_imp.g_varchar2_table(1225) := '2C2130293B6C26262173262628683D762E74727C7C6E756C6C2C643D792E74626F64792E66697273744368696C642C762E76697369742866756E6374696F6E2865297B696628652E7472297B696628652E706172656E742E657870616E6465647C7C226E';
wwv_flow_imp.g_varchar2_table(1226) := '6F6E65223D3D3D652E74722E7374796C652E646973706C61797C7C28652E74722E7374796C652E646973706C61793D226E6F6E65222C6E28652C213129292C652E74722E70726576696F75735369626C696E67213D3D68297B762E646562756728225F66';
wwv_flow_imp.g_varchar2_table(1227) := '69784F726465723A206D69736D61746368206174206E6F64653A20222B65293B76617220743D683F682E6E6578745369626C696E673A643B792E74626F64792E696E736572744265666F726528652E74722C74297D683D652E74727D7D29297D7D2C6E6F';
wwv_flow_imp.g_varchar2_table(1228) := '646552656E6465725469746C653A66756E6374696F6E28742C6E297B76617220722C692C6F3D742E747265652C613D742E6E6F64652C733D742E6F7074696F6E732C6C3D612E69735374617475734E6F646528293B72657475726E20693D746869732E5F';
wwv_flow_imp.g_varchar2_table(1229) := '737570657228742C6E292C612E6973526F6F744E6F646528297C7C28732E636865636B626F782626216C26266E756C6C213D732E7461626C652E636865636B626F78436F6C756D6E496478262628723D6528227370616E2E66616E6379747265652D6368';
wwv_flow_imp.g_varchar2_table(1230) := '65636B626F78222C612E7370616E292C6528612E7472292E66696E642822746422292E6571282B732E7461626C652E636865636B626F78436F6C756D6E496478292E68746D6C287229292C746869732E6E6F646552656E6465725374617475732874292C';
wwv_flow_imp.g_varchar2_table(1231) := '6C3F732E72656E646572537461747573436F6C756D6E733F732E72656E646572537461747573436F6C756D6E732E63616C6C286F2C7B747970653A2272656E646572537461747573436F6C756D6E73227D2C74293A732E7461626C652E6D657267655374';
wwv_flow_imp.g_varchar2_table(1232) := '61747573436F6C756D6E732626612E6973546F704C6576656C282926266528612E7472292E66696E6428223E746422292E65712830292E70726F702822636F6C7370616E222C6F2E636F6C756D6E436F756E74292E7465787428612E7469746C65292E61';
wwv_flow_imp.g_varchar2_table(1233) := '6464436C617373282266616E6379747265652D7374617475732D6D657267656422292E6E657874416C6C28292E72656D6F766528293A732E72656E646572436F6C756D6E732626732E72656E646572436F6C756D6E732E63616C6C286F2C7B747970653A';
wwv_flow_imp.g_varchar2_table(1234) := '2272656E646572436F6C756D6E73227D2C7429292C697D2C6E6F646552656E6465725374617475733A66756E6374696F6E2874297B766172206E2C723D742E6E6F64652C693D742E6F7074696F6E733B746869732E5F73757065722874292C6528722E74';
wwv_flow_imp.g_varchar2_table(1235) := '72292E72656D6F7665436C617373282266616E6379747265652D6E6F646522292C6E3D28722E6765744C6576656C28292D31292A692E7461626C652E696E64656E746174696F6E2C692E72746C3F6528722E7370616E292E637373287B70616464696E67';
wwv_flow_imp.g_varchar2_table(1236) := '52696768743A6E2B227078227D293A6528722E7370616E292E637373287B70616464696E674C6566743A6E2B227078227D297D2C6E6F6465536574457870616E6465643A66756E6374696F6E28742C722C69297B696628723D2131213D3D722C742E6E6F';
wwv_flow_imp.g_varchar2_table(1237) := '64652E657870616E6465642626727C7C21742E6E6F64652E657870616E646564262621722972657475726E20746869732E5F73757065724170706C7928617267756D656E7473293B766172206F3D6E657720652E44656665727265642C613D652E657874';
wwv_flow_imp.g_varchar2_table(1238) := '656E64287B7D2C692C7B6E6F4576656E74733A21302C6E6F416E696D6174696F6E3A21307D293B66756E6374696F6E207328652C61297B653F286E28742E6E6F64652C72292C722626742E6F7074696F6E732E6175746F5363726F6C6C262621692E6E6F';
wwv_flow_imp.g_varchar2_table(1239) := '416E696D6174696F6E2626742E6E6F64652E6861734368696C6472656E28293F742E6E6F64652E6765744C6173744368696C6428292E7363726F6C6C496E746F566965772821302C7B746F704E6F64653A742E6E6F64657D292E616C776179732866756E';
wwv_flow_imp.g_varchar2_table(1240) := '6374696F6E28297B692E6E6F4576656E74737C7C742E747265652E5F747269676765724E6F64654576656E7428723F22657870616E64223A22636F6C6C61707365222C74292C6F2E7265736F6C76655769746828742E6E6F6465297D293A28692E6E6F45';
wwv_flow_imp.g_varchar2_table(1241) := '76656E74737C7C742E747265652E5F747269676765724E6F64654576656E7428723F22657870616E64223A22636F6C6C61707365222C74292C6F2E7265736F6C76655769746828742E6E6F64652929293A28692E6E6F4576656E74737C7C742E74726565';
wwv_flow_imp.g_varchar2_table(1242) := '2E5F747269676765724E6F64654576656E7428723F22657870616E64223A22636F6C6C61707365222C74292C6F2E72656A6563745769746828742E6E6F646529297D72657475726E20693D697C7C7B7D2C746869732E5F737570657228742C722C61292E';
wwv_flow_imp.g_varchar2_table(1243) := '646F6E652866756E6374696F6E28297B73282130297D292E6661696C2866756E6374696F6E28297B73282131297D292C6F2E70726F6D69736528297D2C6E6F64655365745374617475733A66756E6374696F6E28742C6E2C722C69297B696628226F6B22';
wwv_flow_imp.g_varchar2_table(1244) := '3D3D3D6E297B766172206F3D742E6E6F64652C613D6F2E6368696C6472656E3F6F2E6368696C6472656E5B305D3A6E756C6C3B612626612E69735374617475734E6F6465282926266528612E7472292E72656D6F766528297D72657475726E2074686973';
wwv_flow_imp.g_varchar2_table(1245) := '2E5F73757065724170706C7928617267756D656E7473297D2C74726565436C6561723A66756E6374696F6E2865297B72657475726E20746869732E6E6F646552656D6F76654368696C644D61726B757028746869732E5F6D616B65486F6F6B436F6E7465';
wwv_flow_imp.g_varchar2_table(1246) := '787428746869732E726F6F744E6F646529292C746869732E5F73757065724170706C7928617267756D656E7473297D2C7472656544657374726F793A66756E6374696F6E2865297B72657475726E20746869732E24636F6E7461696E65722E66696E6428';
wwv_flow_imp.g_varchar2_table(1247) := '2274626F647922292E656D70747928292C746869732E24736F757263652626746869732E24736F757263652E72656D6F7665436C617373282266616E6379747265652D68656C7065722D68696464656E22292C746869732E5F73757065724170706C7928';
wwv_flow_imp.g_varchar2_table(1248) := '617267756D656E7473297D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E7468656D65726F6C6C65722E6A730A202A0A202A20456E61626C65206A5175657279205549205468656D6552';
wwv_flow_imp.g_varchar2_table(1249) := '6F6C6C6572207374796C65732E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A';
wwv_flow_imp.g_varchar2_table(1250) := '202A204073656520687474703A2F2F6A717565727975692E636F6D2F7468656D65726F6C6C65722F0A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64';
wwv_flow_imp.g_varchar2_table(1251) := '742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A';
wwv_flow_imp.g_varchar2_table(1252) := '0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E';
wwv_flow_imp.g_varchar2_table(1253) := '616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71';
wwv_flow_imp.g_varchar2_table(1254) := '756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B72657475726E20652E75';
wwv_flow_imp.g_varchar2_table(1255) := '692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A227468656D65726F6C6C6572222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B616374697665436C6173733A2275692D73746174652D6163';
wwv_flow_imp.g_varchar2_table(1256) := '74697665222C616464436C6173733A2275692D636F726E65722D616C6C222C666F637573436C6173733A2275692D73746174652D666F637573222C686F766572436C6173733A2275692D73746174652D686F766572222C73656C6563746564436C617373';
wwv_flow_imp.g_varchar2_table(1257) := '3A2275692D73746174652D686967686C69676874227D2C74726565496E69743A66756E6374696F6E2874297B766172206E3D742E7769646765742E656C656D656E742C723D742E6F7074696F6E732E7468656D65726F6C6C65723B746869732E5F737570';
wwv_flow_imp.g_varchar2_table(1258) := '65724170706C7928617267756D656E7473292C225441424C45223D3D3D6E5B305D2E6E6F64654E616D653F286E2E616464436C617373282275692D7769646765742075692D636F726E65722D616C6C22292C6E2E66696E6428223E746865616420747222';
wwv_flow_imp.g_varchar2_table(1259) := '292E616464436C617373282275692D7769646765742D68656164657222292C6E2E66696E6428223E74626F647922292E616464436C617373282275692D7769646765742D636F6E656E742229293A6E2E616464436C617373282275692D77696467657420';
wwv_flow_imp.g_varchar2_table(1260) := '75692D7769646765742D636F6E74656E742075692D636F726E65722D616C6C22292C6E2E6F6E28226D6F757365656E746572206D6F7573656C65617665222C222E66616E6379747265652D6E6F6465222C66756E6374696F6E2874297B766172206E3D65';
wwv_flow_imp.g_varchar2_table(1261) := '2E75692E66616E6379747265652E6765744E6F646528742E746172676574292C693D226D6F757365656E746572223D3D3D742E747970653B65286E2E74723F6E2E74723A6E2E7370616E292E746F67676C65436C61737328722E686F766572436C617373';
wwv_flow_imp.g_varchar2_table(1262) := '2B2220222B722E616464436C6173732C69297D297D2C7472656544657374726F793A66756E6374696F6E2865297B746869732E5F73757065724170706C7928617267756D656E7473292C652E7769646765742E656C656D656E742E72656D6F7665436C61';
wwv_flow_imp.g_varchar2_table(1263) := '7373282275692D7769646765742075692D7769646765742D636F6E74656E742075692D636F726E65722D616C6C22297D2C6E6F646552656E6465725374617475733A66756E6374696F6E2874297B766172206E3D7B7D2C723D742E6E6F64652C693D6528';
wwv_flow_imp.g_varchar2_table(1264) := '722E74723F722E74723A722E7370616E292C6F3D742E6F7074696F6E732E7468656D65726F6C6C65723B746869732E5F73757065722874292C6E5B6F2E616374697665436C6173735D3D21312C6E5B6F2E666F637573436C6173735D3D21312C6E5B6F2E';
wwv_flow_imp.g_varchar2_table(1265) := '73656C6563746564436C6173735D3D21312C722E697341637469766528292626286E5B6F2E616374697665436C6173735D3D2130292C722E686173466F63757328292626286E5B6F2E666F637573436C6173735D3D2130292C722E697353656C65637465';
wwv_flow_imp.g_varchar2_table(1266) := '642829262621722E697341637469766528292626286E5B6F2E73656C6563746564436C6173735D3D2130292C692E746F67676C65436C617373286F2E616374697665436C6173732C6E5B6F2E616374697665436C6173735D292C692E746F67676C65436C';
wwv_flow_imp.g_varchar2_table(1267) := '617373286F2E666F637573436C6173732C6E5B6F2E666F637573436C6173735D292C692E746F67676C65436C617373286F2E73656C6563746564436C6173732C6E5B6F2E73656C6563746564436C6173735D292C692E616464436C617373286F2E616464';
wwv_flow_imp.g_varchar2_table(1268) := '436C617373297D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E776964652E6A730A202A20537570706F727420666F72203130302520776964652073656C656374696F6E20626172732E';
wwv_flow_imp.g_varchar2_table(1269) := '0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F7079726967687420';
wwv_flow_imp.g_varchar2_table(1270) := '28632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F676974';
wwv_flow_imp.g_varchar2_table(1271) := '6875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E';
wwv_flow_imp.g_varchar2_table(1272) := '6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D74';
wwv_flow_imp.g_varchar2_table(1273) := '7970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A';
wwv_flow_imp.g_varchar2_table(1274) := '5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D2F5E285B2B2D5D3F283F3A5C642B7C5C642A5C2E5C642B2929285B612D7A5D2A7C2529242F3B66756E6374696F6E206E28742C6E297B76617220723D65';
wwv_flow_imp.g_varchar2_table(1275) := '282223222B28743D2266616E6379747265652D7374796C652D222B7429293B696628216E2972657475726E20722E72656D6F766528292C6E756C6C3B722E6C656E6774687C7C28723D6528223C7374796C65202F3E22292E6174747228226964222C7429';
wwv_flow_imp.g_varchar2_table(1276) := '2E616464436C617373282266616E6379747265652D7374796C6522292E70726F70282274797065222C22746578742F63737322292E617070656E64546F2822686561642229293B7472797B722E68746D6C286E297D63617463682865297B725B305D2E73';
wwv_flow_imp.g_varchar2_table(1277) := '74796C6553686565742E637373546578743D6E7D72657475726E20727D66756E6374696F6E207228652C742C6E2C722C692C6F297B76617220612C733D2223222B652B22207370616E2E66616E6379747265652D6C6576656C2D222C6C3D5B5D3B666F72';
wwv_flow_imp.g_varchar2_table(1278) := '28613D303B613C743B612B2B296C2E7075736828732B28612B31292B22207370616E2E66616E6379747265652D7469746C65207B2070616464696E672D6C6566743A20222B28612A6E2B72292B6F2B223B207D22293B72657475726E206C2E7075736828';
wwv_flow_imp.g_varchar2_table(1279) := '2223222B652B22206469762E75692D656666656374732D7772617070657220756C206C69207370616E2E66616E6379747265652D7469746C652C2023222B652B22206C692E66616E6379747265652D616E696D6174696E67207370616E2E66616E637974';
wwv_flow_imp.g_varchar2_table(1280) := '7265652D7469746C65207B2070616464696E672D6C6566743A20222B692B6F2B223B20706F736974696F6E3A207374617469633B2077696474683A206175746F3B207D22292C6C2E6A6F696E28225C6E22297D72657475726E20652E75692E66616E6379';
wwv_flow_imp.g_varchar2_table(1281) := '747265652E7265676973746572457874656E73696F6E287B6E616D653A2277696465222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B69636F6E57696474683A6E756C6C2C69636F6E53706163696E673A6E756C6C2C6C6162656C53';
wwv_flow_imp.g_varchar2_table(1282) := '706163696E673A6E756C6C2C6C6576656C4F66733A6E756C6C7D2C747265654372656174653A66756E6374696F6E2869297B746869732E5F73757065724170706C7928617267756D656E7473292C746869732E24636F6E7461696E65722E616464436C61';
wwv_flow_imp.g_varchar2_table(1283) := '7373282266616E6379747265652D6578742D7769646522293B766172206F2C612C732C6C2C642C633D692E6F7074696F6E732E776964652C753D6528223C6C692069643D2766616E63797472656554656D70273E3C7370616E20636C6173733D2766616E';
wwv_flow_imp.g_varchar2_table(1284) := '6379747265652D6E6F6465273E3C7370616E20636C6173733D2766616E6379747265652D69636F6E27202F3E3C7370616E20636C6173733D2766616E6379747265652D7469746C6527202F3E3C2F7370616E3E3C756C202F3E22292E617070656E64546F';
wwv_flow_imp.g_varchar2_table(1285) := '28692E747265652E24636F6E7461696E6572292C663D752E66696E6428222E66616E6379747265652D69636F6E22292C703D752E66696E642822756C22292C683D632E69636F6E53706163696E677C7C662E63737328226D617267696E2D6C6566742229';
wwv_flow_imp.g_varchar2_table(1286) := '2C673D632E69636F6E57696474687C7C662E6373732822776964746822292C793D632E6C6162656C53706163696E677C7C22337078222C763D632E6C6576656C4F66737C7C702E637373282270616464696E672D6C65667422293B752E72656D6F766528';
wwv_flow_imp.g_varchar2_table(1287) := '292C613D682E6D617463682874295B325D2C683D7061727365466C6F617428682C3130292C733D792E6D617463682874295B325D2C793D7061727365466C6F617428792C3130292C6C3D672E6D617463682874295B325D2C673D7061727365466C6F6174';
wwv_flow_imp.g_varchar2_table(1288) := '28672C3130292C643D762E6D617463682874295B325D2C613D3D3D6C2626643D3D3D6C2626733D3D3D6C7C7C652E6572726F72282269636F6E57696474682C2069636F6E53706163696E672C20616E64206C6576656C4F6673206D757374206861766520';
wwv_flow_imp.g_varchar2_table(1289) := '7468652073616D6520637373206D65617375726520756E697422292C746869732E5F6C6F63616C2E6D656173757265556E69743D6C2C746869732E5F6C6F63616C2E6C6576656C4F66733D7061727365466C6F61742876292C746869732E5F6C6F63616C';
wwv_flow_imp.g_varchar2_table(1290) := '2E6C696E654F66733D28312B28692E6F7074696F6E732E636865636B626F783F313A30292B2821313D3D3D692E6F7074696F6E732E69636F6E3F303A3129292A28672B68292B682C746869732E5F6C6F63616C2E6C6162656C4F66733D792C746869732E';
wwv_flow_imp.g_varchar2_table(1291) := '5F6C6F63616C2E6D617844657074683D31302C6E286F3D746869732E24636F6E7461696E65722E756E69717565496428292E617474722822696422292C72286F2C746869732E5F6C6F63616C2E6D617844657074682C746869732E5F6C6F63616C2E6C65';
wwv_flow_imp.g_varchar2_table(1292) := '76656C4F66732C746869732E5F6C6F63616C2E6C696E654F66732C746869732E5F6C6F63616C2E6C6162656C4F66732C746869732E5F6C6F63616C2E6D656173757265556E697429297D2C7472656544657374726F793A66756E6374696F6E2865297B72';
wwv_flow_imp.g_varchar2_table(1293) := '657475726E206E28746869732E24636F6E7461696E65722E617474722822696422292C6E756C6C292C746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F646552656E6465725374617475733A66756E6374696F6E2874297B76';
wwv_flow_imp.g_varchar2_table(1294) := '617220692C6F2C613D742E6E6F64652C733D612E6765744C6576656C28293B72657475726E206F3D746869732E5F73757065722874292C733E746869732E5F6C6F63616C2E6D61784465707468262628693D746869732E24636F6E7461696E65722E6174';
wwv_flow_imp.g_varchar2_table(1295) := '74722822696422292C746869732E5F6C6F63616C2E6D617844657074682A3D322C612E64656275672822446566696E6520676C6F62616C206578742D776964652063737320757020746F206C6576656C20222B746869732E5F6C6F63616C2E6D61784465';
wwv_flow_imp.g_varchar2_table(1296) := '707468292C6E28692C7228692C746869732E5F6C6F63616C2E6D617844657074682C746869732E5F6C6F63616C2E6C6576656C4F66732C746869732E5F6C6F63616C2E6C696E654F66732C746869732E5F6C6F63616C2E6C6162656C53706163696E672C';
wwv_flow_imp.g_varchar2_table(1297) := '746869732E5F6C6F63616C2E6D656173757265556E69742929292C6528612E7370616E292E616464436C617373282266616E6379747265652D6C6576656C2D222B73292C6F7D7D292C652E75692E66616E6379747265657D292C0A2F2A210A202A206A71';
wwv_flow_imp.g_varchar2_table(1298) := '756572792E66616E6379747265652E66696C7465722E6A730A202A0A202A2052656D6F7665206F7220686967686C696768742074726565206E6F6465732C206261736564206F6E20612066696C7465722E0A202A2028457874656E73696F6E206D6F6475';
wwv_flow_imp.g_varchar2_table(1299) := '6C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274';
wwv_flow_imp.g_varchar2_table(1300) := '696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C6963656E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379';
wwv_flow_imp.g_varchar2_table(1301) := '747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D32375432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E22';
wwv_flow_imp.g_varchar2_table(1302) := '3D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E637974726565225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C';
wwv_flow_imp.g_varchar2_table(1303) := '652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E286529';
wwv_flow_imp.g_varchar2_table(1304) := '7B2275736520737472696374223B76617220743D225F5F6E6F745F666F756E645F5F222C6E3D652E75692E66616E6379747265652E65736361706548746D6C3B66756E6374696F6E20722865297B72657475726E28652B2222292E7265706C616365282F';
wwv_flow_imp.g_varchar2_table(1305) := '285B2E3F2A2B5E245B5C5D5C5C28297B7D7C2D5D292F672C225C5C243122297D66756E6374696F6E206928652C742C6E297B666F722876617220723D5B5D2C693D313B693C742E6C656E6774683B692B2B297B766172206F3D745B695D2E6C656E677468';
wwv_flow_imp.g_varchar2_table(1306) := '2B28313D3D3D693F303A31292B28725B722E6C656E6774682D315D7C7C30293B722E70757368286F297D76617220613D652E73706C6974282222293B72657475726E206E3F722E666F72456163682866756E6374696F6E2865297B615B655D3D22EFBFB7';
wwv_flow_imp.g_varchar2_table(1307) := '222B615B655D2B22EFBFB8227D293A722E666F72456163682866756E6374696F6E2865297B615B655D3D223C6D61726B3E222B615B655D2B223C2F6D61726B3E227D292C612E6A6F696E282222297D72657475726E20652E75692E66616E637974726565';
wwv_flow_imp.g_varchar2_table(1308) := '2E5F46616E637974726565436C6173732E70726F746F747970652E5F6170706C7946696C746572496D706C3D66756E6374696F6E286F2C612C73297B766172206C2C642C632C752C662C702C682C672C793D302C763D746869732E6F7074696F6E732C6D';
wwv_flow_imp.g_varchar2_table(1309) := '3D762E6573636170655469746C65732C783D762E6175746F436F6C6C617073652C623D652E657874656E64287B7D2C762E66696C7465722C73292C433D2268696465223D3D3D622E6D6F64652C6B3D2121622E6C65617665734F6E6C79262621613B6966';
wwv_flow_imp.g_varchar2_table(1310) := '2822737472696E67223D3D747970656F66206F297B69662822223D3D3D6F2972657475726E20746869732E7761726E282246616E6379747265652070617373696E6720616E20656D70747920737472696E6720617320612066696C746572206973206861';
wwv_flow_imp.g_varchar2_table(1311) := '6E646C656420617320636C65617246696C74657228292E22292C766F696420746869732E636C65617246696C74657228293B6C3D622E66757A7A793F6F2E73706C6974282222292E6D61702872292E7265647563652866756E6374696F6E28652C74297B';
wwv_flow_imp.g_varchar2_table(1312) := '72657475726E20652B22285B5E222B742B225D2A29222B747D2C2222293A72286F292C633D6E657720526567457870286C2C226922292C753D6E6577205265674578702872286F292C22676922292C6D262628663D6E65772052656745787028722822EF';
wwv_flow_imp.g_varchar2_table(1313) := 'BFB722292C226722292C703D6E65772052656745787028722822EFBFB822292C22672229292C6F3D66756E6374696F6E2874297B69662821742E7469746C652972657475726E21313B76617220722C6F3D6D3F742E7469746C653A28723D742E7469746C';
wwv_flow_imp.g_varchar2_table(1314) := '65292E696E6465784F6628223E22293E3D303F6528223C6469762F3E22292E68746D6C2872292E7465787428293A722C613D6F2E6D617463682863293B72657475726E20612626622E686967686C696768742626286D3F28683D622E66757A7A793F6928';
wwv_flow_imp.g_varchar2_table(1315) := '6F2C612C6D293A6F2E7265706C61636528752C66756E6374696F6E2865297B72657475726E22EFBFB7222B652B22EFBFB8227D292C742E7469746C6557697468486967686C696768743D6E2868292E7265706C61636528662C223C6D61726B3E22292E72';
wwv_flow_imp.g_varchar2_table(1316) := '65706C61636528702C223C2F6D61726B3E2229293A622E66757A7A793F742E7469746C6557697468486967686C696768743D69286F2C61293A742E7469746C6557697468486967686C696768743D6F2E7265706C61636528752C66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(1317) := '297B72657475726E223C6D61726B3E222B652B223C2F6D61726B3E227D29292C2121617D7D72657475726E20746869732E656E61626C6546696C7465723D21302C746869732E6C61737446696C746572417267733D617267756D656E74732C673D746869';
wwv_flow_imp.g_varchar2_table(1318) := '732E656E61626C65557064617465282131292C746869732E246469762E616464436C617373282266616E6379747265652D6578742D66696C74657222292C433F746869732E246469762E616464436C617373282266616E6379747265652D6578742D6669';
wwv_flow_imp.g_varchar2_table(1319) := '6C7465722D6869646522293A746869732E246469762E616464436C617373282266616E6379747265652D6578742D66696C7465722D64696D6D22292C746869732E246469762E746F67676C65436C617373282266616E6379747265652D6578742D66696C';
wwv_flow_imp.g_varchar2_table(1320) := '7465722D686964652D657870616E64657273222C2121622E68696465457870616E64657273292C746869732E726F6F744E6F64652E7375624D61746368436F756E743D302C746869732E76697369742866756E6374696F6E2865297B64656C6574652065';
wwv_flow_imp.g_varchar2_table(1321) := '2E6D617463682C64656C65746520652E7469746C6557697468486967686C696768742C652E7375624D61746368436F756E743D307D292C28643D746869732E676574526F6F744E6F646528292E5F66696E644469726563744368696C6428742929262664';
wwv_flow_imp.g_varchar2_table(1322) := '2E72656D6F766528292C762E6175746F436F6C6C617073653D21312C746869732E76697369742866756E6374696F6E2865297B696628216B7C7C6E756C6C3D3D652E6368696C6472656E297B76617220743D6F2865292C6E3D21313B69662822736B6970';
wwv_flow_imp.g_varchar2_table(1323) := '223D3D3D742972657475726E20652E76697369742866756E6374696F6E2865297B652E6D617463683D21317D2C2130292C22736B6970223B747C7C21612626226272616E636822213D3D747C7C21652E706172656E742E6D617463687C7C28743D21302C';
wwv_flow_imp.g_varchar2_table(1324) := '6E3D2130292C74262628792B2B2C652E6D617463683D21302C652E7669736974506172656E74732866756E6374696F6E2874297B74213D3D65262628742E7375624D61746368436F756E742B3D31292C21622E6175746F457870616E647C7C6E7C7C742E';
wwv_flow_imp.g_varchar2_table(1325) := '657870616E6465647C7C28742E736574457870616E6465642821302C7B6E6F416E696D6174696F6E3A21302C6E6F4576656E74733A21302C7363726F6C6C496E746F566965773A21317D292C742E5F66696C7465724175746F457870616E6465643D2130';
wwv_flow_imp.g_varchar2_table(1326) := '297D2C213029297D7D292C762E6175746F436F6C6C617073653D782C303D3D3D792626622E6E6F646174612626432626282266756E6374696F6E223D3D747970656F6628643D622E6E6F6461746129262628643D642829292C21303D3D3D643F643D7B7D';
wwv_flow_imp.g_varchar2_table(1327) := '3A22737472696E67223D3D747970656F662064262628643D7B7469746C653A647D292C643D652E657874656E64287B7374617475734E6F6465547970653A226E6F64617461222C6B65793A742C7469746C653A746869732E6F7074696F6E732E73747269';
wwv_flow_imp.g_varchar2_table(1328) := '6E67732E6E6F446174617D2C64292C746869732E676574526F6F744E6F646528292E6164644E6F64652864292E6D617463683D2130292C746869732E5F63616C6C486F6F6B2822747265655374727563747572654368616E676564222C746869732C2261';
wwv_flow_imp.g_varchar2_table(1329) := '70706C7946696C74657222292C746869732E656E61626C655570646174652867292C797D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E66696C7465724E6F6465733D66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(1330) := '2C74297B72657475726E22626F6F6C65616E223D3D747970656F662074262628743D7B6C65617665734F6E6C793A747D2C746869732E7761726E282246616E6379747265652E66696C7465724E6F6465732829206C65617665734F6E6C79206F7074696F';
wwv_flow_imp.g_varchar2_table(1331) := '6E20697320646570726563617465642073696E636520322E392E30202F20323031352D30342D31392E20557365206F7074732E6C65617665734F6E6C7920696E73746561642E2229292C746869732E5F6170706C7946696C746572496D706C28652C2131';
wwv_flow_imp.g_varchar2_table(1332) := '2C74297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E66696C7465724272616E636865733D66756E6374696F6E28652C74297B72657475726E20746869732E5F6170706C7946696C74657249';
wwv_flow_imp.g_varchar2_table(1333) := '6D706C28652C21302C74297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E75706461746546696C7465723D66756E6374696F6E28297B746869732E656E61626C6546696C7465722626746869';
wwv_flow_imp.g_varchar2_table(1334) := '732E6C61737446696C746572417267732626746869732E6F7074696F6E732E66696C7465722E6175746F4170706C793F746869732E5F6170706C7946696C746572496D706C2E6170706C7928746869732C746869732E6C61737446696C74657241726773';
wwv_flow_imp.g_varchar2_table(1335) := '293A746869732E7761726E282275706461746546696C74657228293A206E6F2066696C746572206163746976652E22297D2C652E75692E66616E6379747265652E5F46616E637974726565436C6173732E70726F746F747970652E636C65617246696C74';
wwv_flow_imp.g_varchar2_table(1336) := '65723D66756E6374696F6E28297B766172206E2C723D746869732E676574526F6F744E6F646528292E5F66696E644469726563744368696C642874292C693D746869732E6F7074696F6E732E6573636170655469746C65732C6F3D746869732E6F707469';
wwv_flow_imp.g_varchar2_table(1337) := '6F6E732E656E68616E63655469746C652C613D746869732E656E61626C65557064617465282131293B722626722E72656D6F766528292C64656C65746520746869732E726F6F744E6F64652E6D617463682C64656C65746520746869732E726F6F744E6F';
wwv_flow_imp.g_varchar2_table(1338) := '64652E7375624D61746368436F756E742C746869732E76697369742866756E6374696F6E2874297B742E6D617463682626742E7370616E2626286E3D6528742E7370616E292E66696E6428223E7370616E2E66616E6379747265652D7469746C6522292C';
wwv_flow_imp.g_varchar2_table(1339) := '693F6E2E7465787428742E7469746C65293A6E2E68746D6C28742E7469746C65292C6F26266F287B747970653A22656E68616E63655469746C65227D2C7B6E6F64653A742C247469746C653A6E7D29292C64656C65746520742E6D617463682C64656C65';
wwv_flow_imp.g_varchar2_table(1340) := '746520742E7375624D61746368436F756E742C64656C65746520742E7469746C6557697468486967686C696768742C742E247375624D617463684261646765262628742E247375624D6174636842616467652E72656D6F766528292C64656C6574652074';
wwv_flow_imp.g_varchar2_table(1341) := '2E247375624D617463684261646765292C742E5F66696C7465724175746F457870616E6465642626742E657870616E6465642626742E736574457870616E6465642821312C7B6E6F416E696D6174696F6E3A21302C6E6F4576656E74733A21302C736372';
wwv_flow_imp.g_varchar2_table(1342) := '6F6C6C496E746F566965773A21317D292C64656C65746520742E5F66696C7465724175746F457870616E6465647D292C746869732E656E61626C6546696C7465723D21312C746869732E6C61737446696C746572417267733D6E756C6C2C746869732E24';
wwv_flow_imp.g_varchar2_table(1343) := '6469762E72656D6F7665436C617373282266616E6379747265652D6578742D66696C7465722066616E6379747265652D6578742D66696C7465722D64696D6D2066616E6379747265652D6578742D66696C7465722D6869646522292C746869732E5F6361';
wwv_flow_imp.g_varchar2_table(1344) := '6C6C486F6F6B2822747265655374727563747572654368616E676564222C746869732C22636C65617246696C74657222292C746869732E656E61626C655570646174652861297D2C652E75692E66616E6379747265652E5F46616E637974726565436C61';
wwv_flow_imp.g_varchar2_table(1345) := '73732E70726F746F747970652E697346696C7465724163746976653D66756E6374696F6E28297B72657475726E2121746869732E656E61626C6546696C7465727D2C652E75692E66616E6379747265652E5F46616E6379747265654E6F6465436C617373';
wwv_flow_imp.g_varchar2_table(1346) := '2E70726F746F747970652E69734D6174636865643D66756E6374696F6E28297B72657475726E2128746869732E747265652E656E61626C6546696C746572262621746869732E6D61746368297D2C652E75692E66616E6379747265652E72656769737465';
wwv_flow_imp.g_varchar2_table(1347) := '72457874656E73696F6E287B6E616D653A2266696C746572222C76657273696F6E3A22322E33382E34222C6F7074696F6E733A7B6175746F4170706C793A21302C6175746F457870616E643A21312C636F756E7465723A21302C66757A7A793A21312C68';
wwv_flow_imp.g_varchar2_table(1348) := '696465457870616E646564436F756E7465723A21302C68696465457870616E646572733A21312C686967686C696768743A21302C6C65617665734F6E6C793A21312C6E6F646174613A21302C6D6F64653A2264696D6D227D2C6E6F64654C6F6164436869';
wwv_flow_imp.g_varchar2_table(1349) := '6C6472656E3A66756E6374696F6E28652C74297B766172206E3D652E747265653B72657475726E20746869732E5F73757065724170706C7928617267756D656E7473292E646F6E652866756E6374696F6E28297B6E2E656E61626C6546696C7465722626';
wwv_flow_imp.g_varchar2_table(1350) := '6E2E6C61737446696C746572417267732626652E6F7074696F6E732E66696C7465722E6175746F4170706C7926266E2E5F6170706C7946696C746572496D706C2E6170706C79286E2C6E2E6C61737446696C74657241726773297D297D2C6E6F64655365';
wwv_flow_imp.g_varchar2_table(1351) := '74457870616E6465643A66756E6374696F6E28652C742C6E297B76617220723D652E6E6F64653B72657475726E2064656C65746520722E5F66696C7465724175746F457870616E6465642C21742626652E6F7074696F6E732E66696C7465722E68696465';
wwv_flow_imp.g_varchar2_table(1352) := '457870616E646564436F756E7465722626722E247375624D6174636842616467652626722E247375624D6174636842616467652E73686F7728292C746869732E5F73757065724170706C7928617267756D656E7473297D2C6E6F646552656E6465725374';
wwv_flow_imp.g_varchar2_table(1353) := '617475733A66756E6374696F6E2874297B766172206E2C723D742E6E6F64652C693D742E747265652C6F3D742E6F7074696F6E732E66696C7465722C613D6528722E7370616E292E66696E6428227370616E2E66616E6379747265652D7469746C652229';
wwv_flow_imp.g_varchar2_table(1354) := '2C733D6528725B692E737461747573436C61737350726F704E616D655D292C6C3D742E6F7074696F6E732E656E68616E63655469746C652C643D742E6F7074696F6E732E6573636170655469746C65733B72657475726E206E3D746869732E5F73757065';
wwv_flow_imp.g_varchar2_table(1355) := '722874292C732E6C656E6774682626692E656E61626C6546696C7465723F28732E746F67676C65436C617373282266616E6379747265652D6D61746368222C2121722E6D61746368292E746F67676C65436C617373282266616E6379747265652D737562';
wwv_flow_imp.g_varchar2_table(1356) := '6D61746368222C2121722E7375624D61746368436F756E74292E746F67676C65436C617373282266616E6379747265652D68696465222C2128722E6D617463687C7C722E7375624D61746368436F756E7429292C216F2E636F756E7465727C7C21722E73';
wwv_flow_imp.g_varchar2_table(1357) := '75624D61746368436F756E747C7C722E6973457870616E646564282926266F2E68696465457870616E646564436F756E7465723F722E247375624D6174636842616467652626722E247375624D6174636842616467652E6869646528293A28722E247375';
wwv_flow_imp.g_varchar2_table(1358) := '624D6174636842616467657C7C28722E247375624D6174636842616467653D6528223C7370616E20636C6173733D2766616E6379747265652D6368696C64636F756E746572272F3E22292C6528227370616E2E66616E6379747265652D69636F6E2C2073';
wwv_flow_imp.g_varchar2_table(1359) := '70616E2E66616E6379747265652D637573746F6D2D69636F6E222C722E7370616E292E617070656E6428722E247375624D61746368426164676529292C722E247375624D6174636842616467652E73686F7728292E7465787428722E7375624D61746368';
wwv_flow_imp.g_varchar2_table(1360) := '436F756E7429292C21722E7370616E7C7C722E697345646974696E672626722E697345646974696E672E63616C6C2872297C7C28722E7469746C6557697468486967686C696768743F612E68746D6C28722E7469746C6557697468486967686C69676874';
wwv_flow_imp.g_varchar2_table(1361) := '293A643F612E7465787428722E7469746C65293A612E68746D6C28722E7469746C65292C6C26266C287B747970653A22656E68616E63655469746C65227D2C7B6E6F64653A722C247469746C653A617D29292C6E293A6E7D7D292C652E75692E66616E63';
wwv_flow_imp.g_varchar2_table(1362) := '79747265657D292C0A2F2A210A202A206A71756572792E66616E6379747265652E676C7970682E6A730A202A0A202A2055736520676C7970682D666F6E74732C206C696761747572652D666F6E74732C206F72205356472069636F6E7320696E73746561';
wwv_flow_imp.g_varchar2_table(1363) := '64206F662069636F6E20737072697465732E0A202A2028457874656E73696F6E206D6F64756C6520666F72206A71756572792E66616E6379747265652E6A733A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F';
wwv_flow_imp.g_varchar2_table(1364) := '290A202A0A202A20436F707972696768742028632920323030382D323032332C204D617274696E2057656E6474202868747470733A2F2F777757656E64742E6465290A202A0A202A2052656C656173656420756E64657220746865204D4954206C696365';
wwv_flow_imp.g_varchar2_table(1365) := '6E73650A202A2068747470733A2F2F6769746875622E636F6D2F6D617231302F66616E6379747265652F77696B692F4C6963656E7365496E666F0A202A0A202A204076657273696F6E20322E33382E340A202A20406461746520323032342D31322D3237';
wwv_flow_imp.g_varchar2_table(1366) := '5432333A32353A30325A0A202A2F0A66756E6374696F6E2865297B2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226A7175657279222C222E2F6A71756572792E66616E6379747265';
wwv_flow_imp.g_varchar2_table(1367) := '65225D2C65293A226F626A656374223D3D747970656F66206D6F64756C6526266D6F64756C652E6578706F7274733F287265717569726528222E2F6A71756572792E66616E63797472656522292C6D6F64756C652E6578706F7274733D65287265717569';
wwv_flow_imp.g_varchar2_table(1368) := '726528226A7175657279222929293A65286A5175657279297D2866756E6374696F6E2865297B2275736520737472696374223B76617220743D652E75692E66616E6379747265652C6E3D7B617765736F6D65333A7B5F616464436C6173733A22222C6368';
wwv_flow_imp.g_varchar2_table(1369) := '65636B626F783A2269636F6E2D636865636B2D656D707479222C636865636B626F7853656C65637465643A2269636F6E2D636865636B222C636865636B626F78556E6B6E6F776E3A2269636F6E2D636865636B2069636F6E2D6D75746564222C64726167';
wwv_flow_imp.g_varchar2_table(1370) := '48656C7065723A2269636F6E2D63617265742D7269676874222C64726F704D61726B65723A2269636F6E2D63617265742D7269676874222C6572726F723A2269636F6E2D6578636C616D6174696F6E2D7369676E222C657870616E646572436C6F736564';
wwv_flow_imp.g_varchar2_table(1371) := '3A2269636F6E2D63617265742D7269676874222C657870616E6465724C617A793A2269636F6E2D616E676C652D7269676874222C657870616E6465724F70656E3A2269636F6E2D63617265742D646F776E222C6C6F6164696E673A2269636F6E2D726566';
wwv_flow_imp.g_varchar2_table(1372) := '726573682069636F6E2D7370696E222C6E6F646174613A2269636F6E2D6D6568222C6E6F457870616E6465723A22222C726164696F3A2269636F6E2D636972636C652D626C616E6B222C726164696F53656C65637465643A2269636F6E2D636972636C65';
wwv_flow_imp.g_varchar2_table(1373) := '222C646F633A2269636F6E2D66696C652D616C74222C646F634F70656E3A2269636F6E2D66696C652D616C74222C666F6C6465723A2269636F6E2D666F6C6465722D636C6F73652D616C74222C666F6C6465724F70656E3A2269636F6E2D666F6C646572';
wwv_flow_imp.g_varchar2_table(1374) := '2D6F70656E2D616C74227D2C617765736F6D65343A7B5F616464436C6173733A226661222C636865636B626F783A2266612D7371756172652D6F222C636865636B626F7853656C65637465643A2266612D636865636B2D7371756172652D6F222C636865';
wwv_flow_imp.g_varchar2_table(1375) := '636B626F78556E6B6E6F776E3A2266612D7371756172652066616E6379747265652D68656C7065722D696E64657465726D696E6174652D6362222C6472616748656C7065723A2266612D6172726F772D7269676874222C64726F704D61726B65723A2266';
wwv_flow_imp.g_varchar2_table(1376) := '612D6C6F6E672D6172726F772D7269676874222C6572726F723A2266612D7761726E696E67222C657870616E646572436C6F7365643A2266612D63617265742D7269676874222C657870616E6465724C617A793A2266612D616E676C652D726967687422';
wwv_flow_imp.g_varchar2_table(1377) := '2C657870616E6465724F70656E3A2266612D63617265742D646F776E222C6C6F6164696E673A7B68746D6C3A223C7370616E20636C6173733D2766612066612D7370696E6E65722066612D70756C736527202F3E227D2C6E6F646174613A2266612D6D65';
wwv_flow_imp.g_varchar2_table(1378) := '682D6F222C6E6F457870616E6465723A22222C726164696F3A2266612D636972636C652D7468696E222C726164696F53656C65637465643A2266612D636972636C65222C646F633A2266612D66696C652D6F222C646F634F70656E3A2266612D66696C65';
wwv_flow_imp.g_varchar2_table(1379) := '2D6F222C666F6C6465723A2266612D666F6C6465722D6F222C666F6C6465724F70656E3A2266612D666F6C6465722D6F70656E2D6F227D2C617765736F6D65353A7B5F616464436C6173733A22222C636865636B626F783A226661722066612D73717561';
wwv_flow_imp.g_varchar2_table(1380) := '7265222C636865636B626F7853656C65637465643A226661722066612D636865636B2D737175617265222C636865636B626F78556E6B6E6F776E3A226661732066612D7371756172652066616E6379747265652D68656C7065722D696E64657465726D69';
wwv_flow_imp.g_varchar2_table(1381) := '6E6174652D6362222C726164696F3A226661722066612D636972636C65222C726164696F53656C65637465643A226661732066612D636972636C65222C726164696F556E6B6E6F776E3A226661722066612D646F742D636972636C65222C647261674865';
wwv_flow_imp.g_varchar2_table(1382) := '6C7065723A226661732066612D6172726F772D7269676874222C64726F704D61726B65723A226661732066612D6C6F6E672D6172726F772D616C742D7269676874222C6572726F723A226661732066612D6578636C616D6174696F6E2D747269616E676C';
wwv_flow_imp.g_varchar2_table(1383) := '65222C657870616E646572436C6F7365643A226661732066612D63617265742D7269676874222C657870616E6465724C617A793A226661732066612D616E676C652D7269676874222C657870616E6465724F70656E3A226661732066612D63617265742D';
wwv_flow_imp.g_varchar2_table(1384) := '646F776E222C6C6F6164696E673A226661732066612D7370696E6E65722066612D70756C7365222C6E6F646174613A226661722066612D6D6568222C6E6F457870616E6465723A22222C646F633A226661722066612D66696C65222C646F634F70656E3A';
wwv_flow_imp.g_varchar2_table(1385) := '226661722066612D66696C65222C666F6C6465723A226661722066612D666F6C646572222C666F6C6465724F70656E3A226661722066612D666F6C6465722D6F70656E227D2C626F6F747374726170333A7B5F616464436C6173733A22676C7970686963';
wwv_flow_imp.g_varchar2_table(1386) := '6F6E222C636865636B626F783A22676C79706869636F6E2D756E636865636B6564222C636865636B626F7853656C65637465643A22676C79706869636F6E2D636865636B222C636865636B626F78556E6B6E6F776E3A22676C79706869636F6E2D657870';
wwv_flow_imp.g_varchar2_table(1387) := '616E642066616E6379747265652D68656C7065722D696E64657465726D696E6174652D6362222C6472616748656C7065723A22676C79706869636F6E2D706C6179222C64726F704D61726B65723A22676C79706869636F6E2D6172726F772D7269676874';
wwv_flow_imp.g_varchar2_table(1388) := '222C6572726F723A22676C79706869636F6E2D7761726E696E672D7369676E222C657870616E646572436C6F7365643A22676C79706869636F6E2D6D656E752D7269676874222C657870616E6465724C617A793A22676C79706869636F6E2D6D656E752D';
wwv_flow_imp.g_varchar2_table(1389) := '7269676874222C657870616E6465724F70656E3A22676C79706869636F6E2D6D656E752D646F776E222C6C6F6164696E673A22676C79706869636F6E2D726566726573682066616E6379747265652D68656C7065722D7370696E222C6E6F646174613A22';
wwv_flow_imp.g_varchar2_table(1390) := '676C79706869636F6E2D696E666F2D7369676E222C6E6F457870616E6465723A22222C726164696F3A22676C79706869636F6E2D72656D6F76652D636972636C65222C726164696F53656C65637465643A22676C79706869636F6E2D6F6B2D636972636C';
wwv_flow_imp.g_varchar2_table(1391) := '65222C646F633A22676C79706869636F6E2D66696C65222C646F634F70656E3A22676C79706869636F6E2D66696C65222C666F6C6465723A22676C79706869636F6E2D666F6C6465722D636C6F7365222C666F6C6465724F70656E3A22676C7970686963';
wwv_flow_imp.g_varchar2_table(1392) := '6F6E2D666F6C6465722D6F70656E227D2C6D6174657269616C3A7B5F616464436C6173733A226D6174657269616C2D69636F6E73222C636865636B626F783A7B746578743A22636865636B5F626F785F6F75746C696E655F626C616E6B227D2C63686563';
wwv_flow_imp.g_varchar2_table(1393) := '6B626F7853656C65637465643A7B746578743A22636865636B5F626F78227D2C636865636B626F78556E6B6E6F776E3A7B746578743A22696E64657465726D696E6174655F636865636B5F626F78227D2C6472616748656C7065723A7B746578743A2270';
wwv_flow_imp.g_varchar2_table(1394) := '6C61795F6172726F77227D2C64726F704D61726B65723A7B746578743A226172726F772D666F7277617264227D2C6572726F723A7B746578743A227761726E696E67227D2C657870616E646572436C6F7365643A7B746578743A2263686576726F6E5F72';
wwv_flow_imp.g_varchar2_table(1395) := '69676874227D2C657870616E6465724C617A793A7B746578743A226C6173745F70616765227D2C657870616E6465724F70656E3A7B746578743A22657870616E645F6D6F7265227D2C6C6F6164696E673A7B746578743A226175746F72656E6577222C61';
wwv_flow_imp.g_varchar2_table(1396) := '6464436C6173733A2266616E6379747265652D68656C7065722D7370696E227D2C6E6F646174613A7B746578743A22696E666F227D2C6E6F457870616E6465723A7B746578743A22227D2C726164696F3A7B746578743A22726164696F5F627574746F6E';
wwv_flow_imp.g_varchar2_table(1397) := '5F756E636865636B6564227D2C726164696F53656C65637465643A7B746578743A22726164696F5F627574746F6E5F636865636B6564227D2C646F633A7B746578743A22696E736572745F64726976655F66696C65227D2C646F634F70656E3A7B746578';
wwv_flow_imp.g_varchar2_table(1398) := '743A22696E736572745F64726976655F66696C65227D2C666F6C6465723A7B746578743A22666F6C646572227D2C666F6C6465724F70656E3A7B746578743A22666F6C6465725F6F70656E227D7D7D3B66756E6374696F6E207228742C6E2C722C692C6F';
wwv_flow_imp.g_varchar2_table(1399) := '297B6966286E297B76617220613D692E6D61702C733D615B6F5D2C6C3D65286E292C643D6C2E66696E6428222E66616E6379747265652D6368696C64636F756E74657222292C633D722B2220222B28612E5F616464436C6173737C7C2222293B2266756E';
wwv_flow_imp.g_varchar2_table(1400) := '6374696F6E223D3D747970656F662073262628733D732E63616C6C28746869732C742C6E2C6F29292C22737472696E67223D3D747970656F6620733F286E2E696E6E657248544D4C3D22222C6C2E617474722822636C617373222C632B2220222B73292E';
wwv_flow_imp.g_varchar2_table(1401) := '617070656E64286429293A73262628732E746578743F6E2E74657874436F6E74656E743D22222B732E746578743A732E68746D6C3F6E2E696E6E657248544D4C3D732E68746D6C3A6E2E696E6E657248544D4C3D22222C6C2E617474722822636C617373';
wwv_flow_imp.g_varchar2_table(1402) := '222C632B2220222B28732E616464436C6173737C7C222229292E617070656E64286429297D7D72657475726E20652E75692E66616E6379747265652E7265676973746572457874656E73696F6E287B6E616D653A22676C797068222C76657273696F6E3A';
wwv_flow_imp.g_varchar2_table(1403) := '22322E33382E34222C6F7074696F6E733A7B7072657365743A6E756C6C2C6D61703A7B7D7D2C74726565496E69743A66756E6374696F6E2872297B76617220693D722E747265652C6F3D722E6F7074696F6E732E676C7970683B6F2E7072657365743F28';
wwv_flow_imp.g_varchar2_table(1404) := '742E6173736572742821216E5B6F2E7072657365745D2C22496E76616C69642076616C756520666F7220606F7074696F6E732E676C7970682E707265736574603A20222B6F2E707265736574292C6F2E6D61703D652E657874656E64287B7D2C6E5B6F2E';
wwv_flow_imp.g_varchar2_table(1405) := '7072657365745D2C6F2E6D617029293A692E7761726E28226578742D676C7970683A206D697373696E67206070726573657460206F7074696F6E2E22292C746869732E5F73757065724170706C7928617267756D656E7473292C692E24636F6E7461696E';
wwv_flow_imp.g_varchar2_table(1406) := '65722E616464436C617373282266616E6379747265652D6578742D676C79706822297D2C6E6F646552656E6465725374617475733A66756E6374696F6E286E297B76617220692C6F2C612C732C6C3D6E2E6E6F64652C643D65286C2E7370616E292C633D';
wwv_flow_imp.g_varchar2_table(1407) := '6E2E6F7074696F6E732E676C7970683B72657475726E20613D746869732E5F7375706572286E292C6C2E6973526F6F744E6F646528297C7C2828733D642E6368696C6472656E28222E66616E6379747265652D657870616E64657222292E676574283029';
wwv_flow_imp.g_varchar2_table(1408) := '292626286F3D6C2E657870616E64656426266C2E6861734368696C6472656E28293F22657870616E6465724F70656E223A6C2E6973556E646566696E656428293F22657870616E6465724C617A79223A6C2E6861734368696C6472656E28293F22657870';
wwv_flow_imp.g_varchar2_table(1409) := '616E646572436C6F736564223A226E6F457870616E646572222C72286C2C732C2266616E6379747265652D657870616E646572222C632C6F29292C28733D6C2E74723F6528227464222C6C2E7472292E66696E6428222E66616E6379747265652D636865';
wwv_flow_imp.g_varchar2_table(1410) := '636B626F7822292E6765742830293A642E6368696C6472656E28222E66616E6379747265652D636865636B626F7822292E67657428302929262628693D742E6576616C4F7074696F6E2822636865636B626F78222C6C2C6C2C632C2131292C6C2E706172';
wwv_flow_imp.g_varchar2_table(1411) := '656E7426266C2E706172656E742E726164696F67726F75707C7C22726164696F223D3D3D693F72286C2C732C2266616E6379747265652D636865636B626F782066616E6379747265652D726164696F222C632C6F3D6C2E73656C65637465643F22726164';
wwv_flow_imp.g_varchar2_table(1412) := '696F53656C6563746564223A22726164696F22293A72286C2C732C2266616E6379747265652D636865636B626F78222C632C6F3D6C2E73656C65637465643F22636865636B626F7853656C6563746564223A6C2E7061727473656C3F22636865636B626F';
wwv_flow_imp.g_varchar2_table(1413) := '78556E6B6E6F776E223A22636865636B626F782229292C28733D642E6368696C6472656E28222E66616E6379747265652D69636F6E22292E676574283029292626286F3D6C2E7374617475734E6F6465547970653F6C2E7374617475734E6F6465547970';
wwv_flow_imp.g_varchar2_table(1414) := '653A6C2E666F6C6465723F6C2E657870616E64656426266C2E6861734368696C6472656E28293F22666F6C6465724F70656E223A22666F6C646572223A6C2E657870616E6465643F22646F634F70656E223A22646F63222C72286C2C732C2266616E6379';
wwv_flow_imp.g_varchar2_table(1415) := '747265652D69636F6E222C632C6F2929292C617D2C6E6F64655365745374617475733A66756E6374696F6E28742C6E2C692C6F297B76617220612C732C6C3D742E6F7074696F6E732E676C7970682C643D742E6E6F64653B72657475726E20613D746869';
wwv_flow_imp.g_varchar2_table(1416) := '732E5F73757065724170706C7928617267756D656E7473292C226572726F7222213D3D6E2626226C6F6164696E6722213D3D6E2626226E6F6461746122213D3D6E7C7C28642E706172656E743F28733D6528222E66616E6379747265652D657870616E64';
wwv_flow_imp.g_varchar2_table(1417) := '6572222C642E7370616E292E6765742830292926267228642C732C2266616E6379747265652D657870616E646572222C6C2C6E293A28733D6528222E66616E6379747265652D7374617475736E6F64652D222B6E2C645B746869732E6E6F6465436F6E74';
wwv_flow_imp.g_varchar2_table(1418) := '61696E6572417474724E616D655D292E66696E6428222E66616E6379747265652D69636F6E22292E6765742830292926267228642C732C2266616E6379747265652D69636F6E222C6C2C6E29292C617D7D292C652E75692E66616E6379747265657D293B';
wwv_flow_imp.g_varchar2_table(1419) := '766172204C5A537472696E673D7B77726974654269743A66756E6374696F6E28652C74297B742E76616C3D742E76616C3C3C317C652C31353D3D742E706F736974696F6E3F28742E706F736974696F6E3D302C742E737472696E672B3D537472696E672E';
wwv_flow_imp.g_varchar2_table(1420) := '66726F6D43686172436F646528742E76616C292C742E76616C3D30293A742E706F736974696F6E2B2B7D2C7772697465426974733A66756E6374696F6E28652C742C6E297B22737472696E67223D3D747970656F662074262628743D742E63686172436F';
wwv_flow_imp.g_varchar2_table(1421) := '64654174283029293B666F722876617220723D303B723C653B722B2B29746869732E7772697465426974283126742C6E292C743E3E3D317D2C70726F64756365573A66756E6374696F6E2865297B4F626A6563742E70726F746F747970652E6861734F77';
wwv_flow_imp.g_varchar2_table(1422) := '6E50726F70657274792E63616C6C28652E64696374696F6E617279546F4372656174652C652E77293F28652E772E63686172436F646541742830293C3235363F28746869732E77726974654269747328652E6E756D426974732C302C652E64617461292C';
wwv_flow_imp.g_varchar2_table(1423) := '746869732E77726974654269747328382C652E772C652E6461746129293A28746869732E77726974654269747328652E6E756D426974732C312C652E64617461292C746869732E7772697465426974732831362C652E772C652E6461746129292C746869';
wwv_flow_imp.g_varchar2_table(1424) := '732E64656372656D656E74456E6C61726765496E2865292C64656C65746520652E64696374696F6E617279546F4372656174655B652E775D293A746869732E77726974654269747328652E6E756D426974732C652E64696374696F6E6172795B652E775D';
wwv_flow_imp.g_varchar2_table(1425) := '2C652E64617461292C746869732E64656372656D656E74456E6C61726765496E2865297D2C64656372656D656E74456E6C61726765496E3A66756E6374696F6E2865297B652E656E6C61726765496E2D2D2C303D3D652E656E6C61726765496E26262865';
wwv_flow_imp.g_varchar2_table(1426) := '2E656E6C61726765496E3D4D6174682E706F7728322C652E6E756D42697473292C652E6E756D426974732B2B297D2C636F6D70726573733A66756E6374696F6E2865297B76617220742C6E3D7B64696374696F6E6172793A7B7D2C64696374696F6E6172';
wwv_flow_imp.g_varchar2_table(1427) := '79546F4372656174653A7B7D2C633A22222C77633A22222C773A22222C656E6C61726765496E3A322C6469637453697A653A332C6E756D426974733A322C726573756C743A22222C646174613A7B737472696E673A22222C76616C3A302C706F73697469';
wwv_flow_imp.g_varchar2_table(1428) := '6F6E3A307D7D3B666F7228743D303B743C652E6C656E6774683B742B3D31296E2E633D652E6368617241742874292C4F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C286E2E64696374696F6E6172792C6E2E63';
wwv_flow_imp.g_varchar2_table(1429) := '297C7C286E2E64696374696F6E6172795B6E2E635D3D6E2E6469637453697A652B2B2C6E2E64696374696F6E617279546F4372656174655B6E2E635D3D2130292C6E2E77633D6E2E772B6E2E632C4F626A6563742E70726F746F747970652E6861734F77';
wwv_flow_imp.g_varchar2_table(1430) := '6E50726F70657274792E63616C6C286E2E64696374696F6E6172792C6E2E7763293F6E2E773D6E2E77633A28746869732E70726F6475636557286E292C6E2E64696374696F6E6172795B6E2E77635D3D6E2E6469637453697A652B2B2C6E2E773D537472';
wwv_flow_imp.g_varchar2_table(1431) := '696E67286E2E6329293B666F72282222213D3D6E2E772626746869732E70726F6475636557286E292C746869732E777269746542697473286E2E6E756D426974732C322C6E2E64617461293B6E2E646174612E76616C3E303B29746869732E7772697465';
wwv_flow_imp.g_varchar2_table(1432) := '42697428302C6E2E64617461293B72657475726E206E2E646174612E737472696E677D2C726561644269743A66756E6374696F6E2865297B76617220743D652E76616C26652E706F736974696F6E3B72657475726E20652E706F736974696F6E3E3E3D31';
wwv_flow_imp.g_varchar2_table(1433) := '2C303D3D652E706F736974696F6E262628652E706F736974696F6E3D33323736382C652E76616C3D652E737472696E672E63686172436F6465417428652E696E6465782B2B29292C743E303F313A307D2C72656164426974733A66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(1434) := '2C74297B666F7228766172206E3D302C723D4D6174682E706F7728322C65292C693D313B69213D723B296E7C3D746869732E726561644269742874292A692C693C3C3D313B72657475726E206E7D2C6465636F6D70726573733A66756E6374696F6E2865';
wwv_flow_imp.g_varchar2_table(1435) := '297B76617220742C6E2C722C693D7B7D2C6F3D342C613D342C733D332C6C3D22222C643D22222C633D302C753D7B737472696E673A652C76616C3A652E63686172436F646541742830292C706F736974696F6E3A33323736382C696E6465783A317D3B66';
wwv_flow_imp.g_varchar2_table(1436) := '6F7228743D303B743C333B742B3D3129695B745D3D743B73776974636828746869732E726561644269747328322C7529297B6361736520303A723D537472696E672E66726F6D43686172436F646528746869732E726561644269747328382C7529293B62';
wwv_flow_imp.g_varchar2_table(1437) := '7265616B3B6361736520313A723D537472696E672E66726F6D43686172436F646528746869732E72656164426974732831362C7529293B627265616B3B6361736520323A72657475726E22227D666F7228695B335D3D722C6E3D643D723B3B297B737769';
wwv_flow_imp.g_varchar2_table(1438) := '74636828723D746869732E726561644269747328732C7529297B6361736520303A696628632B2B3E3165342972657475726E224572726F72223B723D537472696E672E66726F6D43686172436F646528746869732E726561644269747328382C7529292C';
wwv_flow_imp.g_varchar2_table(1439) := '695B612B2B5D3D722C723D612D312C6F2D2D3B627265616B3B6361736520313A723D537472696E672E66726F6D43686172436F646528746869732E72656164426974732831362C7529292C695B612B2B5D3D722C723D612D312C6F2D2D3B627265616B3B';
wwv_flow_imp.g_varchar2_table(1440) := '6361736520323A72657475726E20647D696628303D3D6F2626286F3D4D6174682E706F7728322C73292C732B2B292C695B725D296C3D695B725D3B656C73657B69662872213D3D612972657475726E206E756C6C3B6C3D6E2B6E2E636861724174283029';
wwv_flow_imp.g_varchar2_table(1441) := '7D642B3D6C2C695B612B2B5D3D6E2B6C2E6368617241742830292C6E3D6C2C303D3D2D2D6F2626286F3D4D6174682E706F7728322C73292C732B2B297D72657475726E20647D7D3B6C65742066616E6379547265653D66756E6374696F6E28652C74297B';
wwv_flow_imp.g_varchar2_table(1442) := '2275736520737472696374223B636F6E7374206E3D7B6665617475726544657461696C733A7B6E616D653A22415045582D46616E63792D547265652D53656C656374222C696E666F3A7B73637269707456657273696F6E3A2232352E30332E3137222C75';
wwv_flow_imp.g_varchar2_table(1443) := '74696C56657273696F6E3A2232352E30332E3137222C75726C3A2268747470733A2F2F6769746875622E636F6D2F526F6E6E795765697373222C6C6963656E73653A224D4954227D7D2C6973446566696E6564416E644E6F744E756C6C3A66756E637469';
wwv_flow_imp.g_varchar2_table(1444) := '6F6E2865297B72657475726E206E756C6C213D6526262222213D3D657D2C636F6E766572744A534F4E324C6F776572436173653A66756E6374696F6E2874297B7472797B6C657420653D7B7D3B666F72286C6574207220696E207429225B6F626A656374';
wwv_flow_imp.g_varchar2_table(1445) := '204F626A6563745D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E6170706C7928745B725D293F655B722E746F4C6F7765724361736528295D3D6E2E636F6E766572744A534F4E324C6F7765724361736528745B725D293A22';
wwv_flow_imp.g_varchar2_table(1446) := '5B6F626A6563742041727261795D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E6170706C7928745B725D293F28655B722E746F4C6F7765724361736528295D3D5B5D2C655B722E746F4C6F7765724361736528295D2E7075';
wwv_flow_imp.g_varchar2_table(1447) := '7368286E2E636F6E766572744A534F4E324C6F7765724361736528745B725D5B305D2929293A655B722E746F4C6F7765724361736528295D3D745B725D3B72657475726E20657D63617463682874297B72657475726E20766F696420652E64656275672E';
wwv_flow_imp.g_varchar2_table(1448) := '6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C6520746F206C6F776572206A736F6E222C6572723A747D297D7D2C6A736F6E53617665457874656E643A66756E6374696F6E286E2C72297B6C65742069';
wwv_flow_imp.g_varchar2_table(1449) := '3D7B7D2C6F3D7B7D3B69662822737472696E67223D3D747970656F662072297472797B6F3D4A534F4E2E70617273652872297D63617463682874297B652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A22457272';
wwv_flow_imp.g_varchar2_table(1450) := '6F72207768696C652074727920746F20706172736520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C6572';
wwv_flow_imp.g_varchar2_table(1451) := '723A742C746172676574436F6E6669673A727D297D656C7365206F3D742E657874656E642821302C7B7D2C72293B7472797B693D742E657874656E642821302C7B7D2C6E2C6F297D63617463682872297B693D742E657874656E642821302C7B7D2C6E29';
wwv_flow_imp.g_varchar2_table(1452) := '2C652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F206D657267652032204A534F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474';
wwv_flow_imp.g_varchar2_table(1453) := '726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C6572723A722C66696E616C436F6E6669673A69';
wwv_flow_imp.g_varchar2_table(1454) := '7D297D72657475726E20697D2C7072696E74444F4D4D6573736167653A7B73686F773A66756E6374696F6E28652C6E2C722C69297B636F6E7374206F3D7428223C6469763E22293B696628742865292E68656967687428293E3D313530297B636F6E7374';
wwv_flow_imp.g_varchar2_table(1455) := '20653D7428223C6469763E3C2F6469763E22292C613D7428223C7370616E3E3C2F7370616E3E22292E616464436C6173732822666122292E616464436C61737328727C7C2266612D696E666F2D636972636C652D6F22292E616464436C61737328226661';
wwv_flow_imp.g_varchar2_table(1456) := '2D327822292E6373732822686569676874222C223332707822292E63737328227769647468222C223332707822292E63737328226D617267696E2D626F74746F6D222C223136707822292E6373732822636F6C6F72222C697C7C22234430443044302229';
wwv_flow_imp.g_varchar2_table(1457) := '3B652E617070656E642861293B636F6E737420733D7428223C7370616E3E3C2F7370616E3E22292E74657874286E292E6373732822646973706C6179222C22626C6F636B22292E6373732822636F6C6F72222C222337303730373022292E637373282274';
wwv_flow_imp.g_varchar2_table(1458) := '6578742D6F766572666C6F77222C22656C6C697073697322292E63737328226F766572666C6F77222C2268696464656E22292E637373282277686974652D7370616365222C226E6F7772617022292E6373732822666F6E742D73697A65222C2231327078';
wwv_flow_imp.g_varchar2_table(1459) := '22293B6F2E63737328226D617267696E222C223132707822292E6373732822746578742D616C69676E222C2263656E74657222292E637373282270616464696E67222C2231307078203022292E616464436C6173732822646F6D696E666F6D6573736167';
wwv_flow_imp.g_varchar2_table(1460) := '6564697622292E617070656E642865292E617070656E642873297D656C73657B636F6E737420653D7428223C7370616E3E3C2F7370616E3E22292E616464436C6173732822666122292E616464436C61737328727C7C2266612D696E666F2D636972636C';
wwv_flow_imp.g_varchar2_table(1461) := '652D6F22292E6373732822666F6E742D73697A65222C223232707822292E63737328226C696E652D686569676874222C223236707822292E63737328226D617267696E2D7269676874222C2235707822292E6373732822636F6C6F72222C697C7C222344';
wwv_flow_imp.g_varchar2_table(1462) := '304430443022292C613D7428223C7370616E3E3C2F7370616E3E22292E74657874286E292E6373732822636F6C6F72222C222337303730373022292E6373732822746578742D6F766572666C6F77222C22656C6C697073697322292E63737328226F7665';
wwv_flow_imp.g_varchar2_table(1463) := '72666C6F77222C2268696464656E22292E637373282277686974652D7370616365222C226E6F7772617022292E6373732822666F6E742D73697A65222C223132707822292E63737328226C696E652D686569676874222C223230707822293B6F2E637373';
wwv_flow_imp.g_varchar2_table(1464) := '28226D617267696E222C223130707822292E6373732822746578742D616C69676E222C2263656E74657222292E616464436C6173732822646F6D696E666F6D65737361676564697622292E617070656E642865292E617070656E642861297D742865292E';
wwv_flow_imp.g_varchar2_table(1465) := '617070656E64286F297D2C686964653A66756E6374696F6E2865297B742865292E6368696C6472656E28222E646F6D696E666F6D65737361676564697622292E72656D6F766528297D7D2C6E6F446174614D6573736167653A7B73686F773A66756E6374';
wwv_flow_imp.g_varchar2_table(1466) := '696F6E28652C74297B6E2E7072696E74444F4D4D6573736167652E73686F7728652C742C2266612D73656172636822297D2C686964653A66756E6374696F6E2865297B6E2E7072696E74444F4D4D6573736167652E686964652865297D7D2C6572726F72';
wwv_flow_imp.g_varchar2_table(1467) := '4D6573736167653A7B73686F773A66756E6374696F6E28652C74297B6E2E7072696E74444F4D4D6573736167652E73686F7728652C742C2266612D6578636C616D6174696F6E2D747269616E676C65222C222346464342334422297D2C686964653A6675';
wwv_flow_imp.g_varchar2_table(1468) := '6E6374696F6E2865297B6E2E7072696E74444F4D4D6573736167652E686964652865297D7D2C6C696E6B3A66756E6374696F6E28742C6E3D225F706172656E7422297B5B225F706172656E74222C225F73656C66225D2E696E636C75646573286E293F65';
wwv_flow_imp.g_varchar2_table(1469) := '2E6E617669676174696F6E2E72656469726563742874293A6E756C6C213D7426262222213D3D74262677696E646F772E6F70656E28742C6E297D2C6C6F616465723A7B73746172743A66756E6374696F6E286E2C72297B72262674286E292E6373732822';
wwv_flow_imp.g_varchar2_table(1470) := '6D696E2D686569676874222C22313030707822292C652E7574696C2E73686F775370696E6E65722874286E29297D2C73746F703A66756E6374696F6E28652C6E297B6E2626742865292E63737328226D696E2D686569676874222C2222292C7428652B22';
wwv_flow_imp.g_varchar2_table(1471) := '203E202E752D50726F63657373696E6722292E72656D6F766528292C7428652B22203E202E63742D6C6F6164657222292E72656D6F766528297D7D2C636F70794A534F4E4F626A6563743A66756E6374696F6E2874297B7472797B6C657420652C6E3D7B';
wwv_flow_imp.g_varchar2_table(1472) := '7D3B666F72286520696E207429745B655D2626286E5B655D3D745B655D293B72657475726E206E7D63617463682874297B652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C65207472';
wwv_flow_imp.g_varchar2_table(1473) := '7920746F20636F7079206F626A656374222C6572723A747D297D7D2C6465626F756E63653A66756E6374696F6E28652C743D3530297B6C6574206E3B72657475726E282E2E2E72293D3E7B636C65617254696D656F7574286E292C6E3D73657454696D65';
wwv_flow_imp.g_varchar2_table(1474) := '6F75742866756E6374696F6E28297B652E6170706C7928746869732C72297D2C74297D7D2C6C6F63616C53746F726167653A7B636865636B3A66756E6374696F6E28297B72657475726E22756E646566696E656422213D747970656F662053746F726167';
wwv_flow_imp.g_varchar2_table(1475) := '657C7C28652E64656275672E696E666F287B6D6F64756C653A227574696C2E6A73222C6D73673A22596F75722062726F7773657220646F6573206E6F7420737570706F7274206C6F63616C2073746F72616765227D292C2131297D2C7365743A66756E63';
wwv_flow_imp.g_varchar2_table(1476) := '74696F6E28742C722C69297B7472797B6E2E6C6F63616C53746F726167652E636865636B262628227065726D616E656E74223D3D3D693F6C6F63616C53746F726167652E7365744974656D28742C72293A73657373696F6E53746F726167652E73657449';
wwv_flow_imp.g_varchar2_table(1477) := '74656D28742C7229297D63617463682874297B652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F2073617665206974656D20746F206C6F63616C2053746F726167';
wwv_flow_imp.g_varchar2_table(1478) := '652E20436F6E6669726D207468617420796F75206E6F7420657863656564207468652073746F72616765206C696D6974206F6620354D422E222C6572723A747D297D7D2C6765743A66756E6374696F6E28742C72297B7472797B6966286E2E6C6F63616C';
wwv_flow_imp.g_varchar2_table(1479) := '53746F726167652E636865636B2972657475726E227065726D616E656E74223D3D3D723F6C6F63616C53746F726167652E6765744974656D2874293A73657373696F6E53746F726167652E6765744974656D2874297D63617463682874297B652E646562';
wwv_flow_imp.g_varchar2_table(1480) := '75672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F2072656164206974656D2066726F6D206C6F63616C2053746F72616765222C6572723A747D297D7D2C72656D6F76653A6675';
wwv_flow_imp.g_varchar2_table(1481) := '6E6374696F6E28742C72297B7472797B6E2E6C6F63616C53746F726167652E636865636B262628227065726D616E656E74223D3D3D723F6C6F63616C53746F726167652E72656D6F76654974656D2874293A73657373696F6E53746F726167652E72656D';
wwv_flow_imp.g_varchar2_table(1482) := '6F76654974656D287429297D63617463682874297B652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C65207472792072656D6F7665206974656D2066726F6D206C6F63616C2053746F';
wwv_flow_imp.g_varchar2_table(1483) := '72616765222C6572723A747D297D7D7D7D3B72657475726E7B696E6974547265653A66756E6374696F6E28722C692C6F2C612C732C6C2C642C632C752C662C702C68297B652E64656275672E696E666F287B6663743A6E2E666561747572654465746169';
wwv_flow_imp.g_varchar2_table(1484) := '6C732E6E616D652B22202D20696E697454726565222C617267756D656E74733A7B726567696F6E49443A722C616A617849443A692C6E6F446174614D6573736167653A6F2C6572724D6573736167653A612C7564436F6E6669674A534F4E3A732C697465';
wwv_flow_imp.g_varchar2_table(1485) := '6D73325375626D69743A6C2C65736361706548544D4C3A642C7365617263684974656D4E616D653A632C6163746976654E6F64654974656D4E616D653A752C704C6F63616C53746F726167653A662C704C6F63616C53746F7261676556657273696F6E3A';
wwv_flow_imp.g_varchar2_table(1486) := '702C70457870616E6465644E6F6465734974656D3A687D2C6665617475726544657461696C733A6E2E6665617475726544657461696C737D293B6C657420673D7B7D3B66756E6374696F6E207928297B72657475726E207428672E726567696F6E494429';
wwv_flow_imp.g_varchar2_table(1487) := '2E66616E63797472656528226765745472656522297D66756E6374696F6E207628722C69297B692626742844292E747269676765722822617065786265666F72657265667265736822292C6E2E6C6F616465722E737461727428672E726567696F6E4944';
wwv_flow_imp.g_varchar2_table(1488) := '2C2130293B7472797B696628672E6C6F63616C53746F726167652E656E61626C6564297B636F6E7374206F3D6E2E6C6F63616C53746F726167652E67657428672E6C6F63616C53746F726167652E6B657946696E616C2C672E6C6F63616C53746F726167';
wwv_flow_imp.g_varchar2_table(1489) := '652E74797065293B6966286F297B636F6E737420613D4C5A537472696E672E6465636F6D7072657373286F292C733D4A534F4E2E70617273652861293B72657475726E20652E64656275672E696E666F287B6663743A6E2E666561747572654465746169';
wwv_flow_imp.g_varchar2_table(1490) := '6C732E6E616D652B22202D2067657444617461222C6D73673A225265616420737472696E672066726F6D206C6F63616C2073746F72616765222C6C6F63616C53746F726167654B65793A672E6C6F63616C53746F726167652E6B657946696E616C2C6C6F';
wwv_flow_imp.g_varchar2_table(1491) := '63616C53746F726167655374723A612C6C6F63616C53746F72616765436F6D707265737365645374723A6F2C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C722873292C766F696428692626742844292E74726967';
wwv_flow_imp.g_varchar2_table(1492) := '676572282261706578616674657272656672657368222C7329297D7D652E7365727665722E706C7567696E28672E616A617849442C7B706167654974656D733A672E6974656D73325375626D69747D2C7B737563636573733A66756E6374696F6E286F29';
wwv_flow_imp.g_varchar2_table(1493) := '7B69662872286F292C672E6C6F63616C53746F726167652E656E61626C6564297472797B636F6E737420743D4A534F4E2E737472696E67696679286F2C6E756C6C2C30292C723D4C5A537472696E672E636F6D70726573732874293B6E2E6C6F63616C53';
wwv_flow_imp.g_varchar2_table(1494) := '746F726167652E73657428672E6C6F63616C53746F726167652E6B657946696E616C2C722C672E6C6F63616C53746F726167652E74797065292C652E64656275672E696E666F287B6663743A6E2E6665617475726544657461696C732E6E616D652B2220';
wwv_flow_imp.g_varchar2_table(1495) := '2D2067657444617461222C6D73673A22577269746520737472696E6720746F206C6F63616C2073746F72616765222C6C6F63616C53746F726167654B65793A672E6C6F63616C53746F726167652E6B657946696E616C2C6C6F63616C53746F7261676553';
wwv_flow_imp.g_varchar2_table(1496) := '74723A742C6C6F63616C53746F72616765436F6D707265737365645374723A722C6665617475726544657461696C733A6E2E6665617475726544657461696C737D297D63617463682874297B652E64656275672E6572726F72287B6663743A6E2E666561';
wwv_flow_imp.g_varchar2_table(1497) := '7475726544657461696C732E6E616D652B22202D2067657444617461222C6D73673A224572726F72207768696C652074727920746F2073746F7265206C6F63616C2063616368652E205468697320636F756C642062652062656361757365206C6F63616C';
wwv_flow_imp.g_varchar2_table(1498) := '2063616368652069732064697361626C656420696E20796F75722062726F77736572206F72206D6178696D756D2073746F72616765206F6620354D422069732065786365656465642E222C6572723A742C6665617475726544657461696C733A6E2E6665';
wwv_flow_imp.g_varchar2_table(1499) := '617475726544657461696C737D297D692626742844292E74726967676572282261706578616674657272656672657368222C6F297D2C6572726F723A66756E6374696F6E2872297B6E2E6C6F616465722E73746F7028672E726567696F6E49442C213029';
wwv_flow_imp.g_varchar2_table(1500) := '2C7428672E726567696F6E4944292E656D70747928292C6E2E6572726F724D6573736167652E73686F7728672E726567696F6E49442C672E6572724D657373616765292C652E64656275672E6572726F72287B6663743A6E2E6665617475726544657461';
null;
end;
/
begin
wwv_flow_imp.g_varchar2_table(1501) := '696C732E6E616D652B22202D2067657444617461222C6D73673A224572726F72207768696C652074727920746F20676574206E65772064617461222C6572723A722C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C';
wwv_flow_imp.g_varchar2_table(1502) := '692626742844292E7472696767657228226170657861667465727265667265736822297D2C64617461547970653A226A736F6E227D297D63617463682872297B652E64656275672E6572726F72287B6663743A6E2E6665617475726544657461696C732E';
wwv_flow_imp.g_varchar2_table(1503) := '6E616D652B22202D2067657444617461222C6D73673A224572726F72207768696C652074727920746F20676574206E65772064617461222C6572723A722C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C69262674';
wwv_flow_imp.g_varchar2_table(1504) := '2844292E7472696767657228226170657861667465727265667265736822297D7D66756E6374696F6E206D28652C74297B72657475726E20652D747D66756E6374696F6E20782872297B7472797B6C657420692C6F3D6E2E636F6E766572744A534F4E32';
wwv_flow_imp.g_varchar2_table(1505) := '4C6F7765724361736528722E726F77292C613D21313B6E2E6973446566696E6564416E644E6F744E756C6C287529262628693D652E6974656D2875292E67657456616C75652829292C742E65616368286F2C66756E6374696F6E28652C74297B672E7479';
wwv_flow_imp.g_varchar2_table(1506) := '706553657474696E67732626672E7479706553657474696E67732E666F72456163682866756E6374696F6E2865297B652E69643D3D3D742E74797065262628742E69636F6E262630213D3D742E69636F6E2E6C656E6774687C7C28742E69636F6E3D2266';
wwv_flow_imp.g_varchar2_table(1507) := '6120222B652E69636F6E29297D292C313D3D3D742E756E73656C65637461626C65262628742E756E73656C65637461626C655374617475733D313D3D3D742E73656C6563746564292C2161262669262622222B742E69643D3D22222B69262628742E6163';
wwv_flow_imp.g_varchar2_table(1508) := '746976653D312C613D2130297D293B6C657420733D5B5D3B666F72286C6574206520696E206F296F5B655D2626732E70757368286F5B655D293B72657475726E206F3D66756E6374696F6E2865297B6C657420742C6E2C722C692C6F2C612C732C6C2C64';
wwv_flow_imp.g_varchar2_table(1509) := '2C632C752C662C702C682C673B666F7228693D652E69647C7C226964222C613D652E706172656E745F69647C7C22706172656E745F6964222C6C3D5B5D2C733D7B7D2C743D7B7D2C6F3D5B5D2C683D652E712C723D633D302C663D682E6C656E6774683B';
wwv_flow_imp.g_varchar2_table(1510) := '633C663B723D632B3D31296E3D685B725D2C735B6E5B695D5D3D722C6E756C6C3D3D745B6E5B615D5D262628745B6E5B615D5D3D5B5D292C745B6E5B615D5D2E7075736828652E715B725D5B695D293B666F7228673D652E712C753D302C703D672E6C65';
wwv_flow_imp.g_varchar2_table(1511) := '6E6774683B753C703B752B3D31296E3D675B755D2C6E756C6C3D3D735B6E5B615D5D26266C2E70757368286E5B695D293B666F72283B6C2E6C656E6774683B29643D6C2E73706C69636528302C31292C6F2E7075736828652E715B735B645D5D292C6E75';
wwv_flow_imp.g_varchar2_table(1512) := '6C6C213D745B645D2626286C3D745B645D2E636F6E636174286C29293B72657475726E206F7D287B713A737D292C6F3D66756E6374696F6E2865297B6C657420742C6E2C722C692C6F2C612C732C6C2C643B666F7228723D652E69647C7C226964222C6F';
wwv_flow_imp.g_varchar2_table(1513) := '3D652E706172656E745F69647C7C22706172656E745F6964222C743D652E6368696C6472656E7C7C226368696C6472656E222C613D7B7D2C693D5B5D2C643D652E712C733D302C6C3D642E6C656E6774683B733C6C3B732B3D31296E3D645B735D2C6E5B';
wwv_flow_imp.g_varchar2_table(1514) := '745D3D5B5D2C615B6E5B725D5D3D6E2C6E756C6C213D615B6E5B6F5D5D3F615B6E5B6F5D5D5B745D2E70757368286E293A692E70757368286E293B72657475726E20697D287B713A6F7D292C21612626672E7365744163746976654E6F646526266F2E6C';
wwv_flow_imp.g_varchar2_table(1515) := '656E6774683E302626286F5B305D2E6163746976653D312C613D2130292C722E726F772626722E726F772E6C656E6774683E303F6E2E6E6F446174614D6573736167652E6869646528672E726567696F6E4944293A286E2E6E6F446174614D6573736167';
wwv_flow_imp.g_varchar2_table(1516) := '652E6869646528672E726567696F6E4944292C6E2E6E6F446174614D6573736167652E73686F7728672E726567696F6E49442C672E6E6F446174614D65737361676529292C6F7D63617463682872297B6E2E6C6F616465722E73746F7028672E72656769';
wwv_flow_imp.g_varchar2_table(1517) := '6F6E49442C2130292C7428672E726567696F6E4944292E656D70747928292C6E2E6572726F724D6573736167652E73686F7728672E726567696F6E49442C672E6572724D657373616765292C652E64656275672E6572726F72287B6663743A6E2E666561';
wwv_flow_imp.g_varchar2_table(1518) := '7475726544657461696C732E6E616D652B22202D207072657061726544617461222C6D73673A224572726F72207768696C652074727920746F2070726570617265206461746120666F722074726565222C6572723A722C6665617475726544657461696C';
wwv_flow_imp.g_varchar2_table(1519) := '733A6E2E6665617475726544657461696C737D297D7D66756E6374696F6E20622874297B636F6E737420723D782874293B6966287928292E72656C6F61642872292C6B28672E6175746F457870616E64324C6576656C292C6E2E6973446566696E656441';
wwv_flow_imp.g_varchar2_table(1520) := '6E644E6F744E756C6C286329297B636F6E737420743D652E6974656D2863292E67657456616C756528293B6E2E6973446566696E6564416E644E6F744E756C6C2874292626742E6C656E6774683E3026265328297D4E28292C4528292C6E2E6C6F616465';
wwv_flow_imp.g_varchar2_table(1521) := '722E73746F7028672E726567696F6E49442C2130297D66756E6374696F6E204328297B6966286E2E6973446566696E6564416E644E6F744E756C6C28672E657870616E6465644E6F6465734974656D29297B6C657420743D7928292E676574526F6F744E';
wwv_flow_imp.g_varchar2_table(1522) := '6F646528292C6E3D5B5D3B742E76697369742866756E6374696F6E2865297B652E657870616E64656426266E2E7075736828652E646174612E6964297D293B636F6E737420723D6E2E736F7274286D292E6A6F696E28223A22293B652E6974656D28672E';
wwv_flow_imp.g_varchar2_table(1523) := '657870616E6465644E6F6465734974656D292626652E6974656D28672E657870616E6465644E6F6465734974656D292E67657456616C75652829213D3D722626652E6974656D28672E657870616E6465644E6F6465734974656D292E73657456616C7565';
wwv_flow_imp.g_varchar2_table(1524) := '2872297D7D66756E6374696F6E206B2865297B653E3026267428672E726567696F6E4944292E66616E6379747265652822676574526F6F744E6F646522292E76697369742866756E6374696F6E2874297B742E6765744C6576656C28293C653F742E7365';
wwv_flow_imp.g_varchar2_table(1525) := '74457870616E646564282130293A742E736574457870616E646564282131297D297D66756E6374696F6E2077286E297B696628216E2972657475726E3B636F6E737420723D652E6C616E672E6765744D6573736167652822545245452E455850414E445F';
wwv_flow_imp.g_varchar2_table(1526) := '414C4C5F42454C4F5722292C693D652E6C616E672E6765744D6573736167652822545245452E434F4C4C415053455F414C4C5F42454C4F5722292C6F3D607370616E2E66616E6379747265652D657870616E6465722E66612E247B672E69636F6E457870';
wwv_flow_imp.g_varchar2_table(1527) := '616E646572436C6F7365647D602C613D607370616E2E66616E6379747265652D657870616E6465722E66612E247B672E69636F6E457870616E6465724F70656E7D602C733D74286E292E66696E64286F292C6C3D74286E292E66696E642861293B732E6C';
wwv_flow_imp.g_varchar2_table(1528) := '656E6774683E302626732E617474722822617269612D6C6162656C222C72292C6C2E6C656E6774683E3026266C2E617474722822617269612D6C6162656C222C69297D66756E6374696F6E205328297B6C657420743B636F6E737420723D7928292C693D';
wwv_flow_imp.g_varchar2_table(1529) := '652E6974656D2863292E67657456616C756528293B743D722E66696C7465724272616E636865732E63616C6C28722C69292C6E2E6E6F446174614D6573736167652E6869646528672E726567696F6E4944292C303D3D3D7426266E2E6E6F446174614D65';
wwv_flow_imp.g_varchar2_table(1530) := '73736167652E73686F7728672E726567696F6E49442C672E6E6F446174614D657373616765297D66756E6374696F6E205F28297B696628672E7479706553657474696E6773297B6C657420723D5B5D3B672E7479706553657474696E67732E666F724561';
wwv_flow_imp.g_varchar2_table(1531) := '63682866756E6374696F6E2865297B722E70757368286E2E636F70794A534F4E4F626A656374286529297D293B636F6E737420693D7928292E67657453656C65637465644E6F64657328293B742E6561636828692C66756E6374696F6E28742C69297B72';
wwv_flow_imp.g_varchar2_table(1532) := '2E666F72456163682866756E6374696F6E28742C6F297B742E69643F692E747970653F692E747970653D3D3D742E6964262628766F696420303D3D3D725B6F5D2E64617461262628725B6F5D2E646174613D5B5D292C2D313D3D3D725B6F5D2E64617461';
wwv_flow_imp.g_varchar2_table(1533) := '2E696E6465784F6628692E646174612E76616C756529262628692E646174612E76616C7565262633213D3D672E73656C6563744D6F64657C7C21313D3D3D692E706172656E742E73656C65637465647C7C6E756C6C3D3D3D692E706172656E742E6C697C';
wwv_flow_imp.g_varchar2_table(1534) := '7C21303D3D3D672E666F72636553656C656374696F6E536574292626725B6F5D2E646174612E7075736828692E646174612E76616C756529293A652E64656275672E6572726F72287B6663743A6E2E6665617475726544657461696C732E6E616D652B22';
wwv_flow_imp.g_varchar2_table(1535) := '202D207365744974656D73222C6D73673A227479706520696E206E6F742073657420696E2064617461222C6665617475726544657461696C733A6E2E6665617475726544657461696C737D293A652E64656275672E6572726F72287B6663743A6E2E6665';
wwv_flow_imp.g_varchar2_table(1536) := '617475726544657461696C732E6E616D652B22202D207365744974656D73222C6D73673A226964206973206E6F7420646566696E656420696E20636F6E666967206A736F6E20696E2074797065732E20506C6561736520636865636B2068656C7020666F';
wwv_flow_imp.g_varchar2_table(1537) := '7220636F6E666967206A736F6E2E222C6665617475726544657461696C733A6E2E6665617475726544657461696C737D297D297D292C722E666F72456163682866756E6374696F6E2874297B696628742E73746F72654974656D29696628742E64617461';
wwv_flow_imp.g_varchar2_table(1538) := '2626742E646174612E6C656E6774683E30297B636F6E7374206E3D742E646174612E736F7274286D292E6A6F696E28223A22293B652E6974656D28742E73746F72654974656D292E67657456616C75652829213D3D6E2626652E6974656D28742E73746F';
wwv_flow_imp.g_varchar2_table(1539) := '72654974656D292E73657456616C7565286E297D656C736522222B652E6974656D28742E73746F72654974656D292E67657456616C75652829213D22222626652E6974656D28742E73746F72654974656D292E73657456616C7565282222293B656C7365';
wwv_flow_imp.g_varchar2_table(1540) := '20652E64656275672E6572726F72287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D207365744974656D73222C6D73673A2273746F72654974656D206973206E6F7420646566696E656420696E20636F6E666967206A736F6E';
wwv_flow_imp.g_varchar2_table(1541) := '20696E2074797065732E20506C6561736520636865636B2068656C7020666F7220636F6E666967206A736F6E2E222C6665617475726544657461696C733A6E2E6665617475726544657461696C737D297D297D656C736520652E64656275672E6572726F';
wwv_flow_imp.g_varchar2_table(1542) := '72287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D207365744974656D73222C6D73673A225479706573206973206E6F7420646566696E656420696E20636F6E666967206A736F6E2062757420796F75206861766520736574';
wwv_flow_imp.g_varchar2_table(1543) := '207365744974656D734F6E496E69743A2074727565206F722074727920746F2073656C6563742061206E6F64652E20506C6561736520636865636B2068656C7020666F7220636F6E666967206A736F6E2E222C6665617475726544657461696C733A6E2E';
wwv_flow_imp.g_varchar2_table(1544) := '6665617475726544657461696C737D297D66756E6374696F6E204E2865297B696628672E6D61726B4E6F646573576974684368696C6472656E297B6526267428672E726567696F6E4944292E66696E6428222E66616E6379747265652D637573746F6D2D';
wwv_flow_imp.g_varchar2_table(1545) := '69636F6E22292E72656D6F7665436C61737328672E6D61726B65724D6F646966696572293B636F6E737420723D7928292C693D722E67657453656C65637465644E6F64657328293B742E6561636828692C66756E6374696F6E28652C6E297B742E656163';
wwv_flow_imp.g_varchar2_table(1546) := '68286E2E676574506172656E744C697374282130292C66756E6374696F6E28652C6E297B74286E2E7370616E292E66696E6428222E66616E6379747265652D637573746F6D2D69636F6E22292E616464436C61737328672E6D61726B65724D6F64696669';
wwv_flow_imp.g_varchar2_table(1547) := '6572297D297D293B636F6E7374206F3D722E6765744163746976654E6F646528293B6E2E6973446566696E6564416E644E6F744E756C6C286F292626742E65616368286F2E676574506172656E744C697374282130292C66756E6374696F6E28652C6E29';
wwv_flow_imp.g_varchar2_table(1548) := '7B74286E2E7370616E292E66696E6428222E66616E6379747265652D637573746F6D2D69636F6E22292E616464436C61737328672E6D61726B65724D6F646966696572297D297D7D66756E6374696F6E20452865297B696628672E6F70656E506172656E';
wwv_flow_imp.g_varchar2_table(1549) := '744F6653656C65637465647C7C65297B636F6E737420653D7928292E67657453656C65637465644E6F64657328293B742E6561636828652C66756E6374696F6E28652C6E297B742E65616368286E2E676574506172656E744C697374282130292C66756E';
wwv_flow_imp.g_varchar2_table(1550) := '6374696F6E28652C74297B742E736574457870616E646564282130297D297D297D7D673D6E2E6A736F6E53617665457874656E64287B616E696D6174696F6E4475726174696F6E3A3230302C6175746F457870616E64324C6576656C3A302C636865636B';
wwv_flow_imp.g_varchar2_table(1551) := '626F783A2266612D7371756172652D6F222C636865636B626F7853656C65637465643A2266612D636865636B2D737175617265222C636865636B626F78556E6B6E6F776E3A2266612D737175617265222C656E61626C65436865636B426F783A21302C65';
wwv_flow_imp.g_varchar2_table(1552) := '6E61626C654B6579426F6172643A21302C656E61626C65517569636B7365617263683A21302C666F72636553656C656374696F6E5365743A21302C666F726365526566726573684576656E744F6E53746172743A21312C69636F6E457870616E6465724F';
wwv_flow_imp.g_varchar2_table(1553) := '70656E3A2266612D63617265742D646F776E222C69636F6E457870616E646572436C6F7365643A2266612D63617265742D7269676874222C6D61726B4E6F646573576974684368696C6472656E3A21312C6D61726B65724D6F6469666965723A2266616D';
wwv_flow_imp.g_varchar2_table(1554) := '2D706C75732066616D2D69732D696E666F222C6F70656E506172656E744F664163746976654E6F64653A21302C6F70656E506172656E744F6653656C65637465643A21302C726566726573683A302C7365617263683A7B6175746F457870616E643A2130';
wwv_flow_imp.g_varchar2_table(1555) := '2C6C65617665734F6E6C793A21312C686967686C696768743A21302C636F756E7465723A21302C68696465556E6D6174636865643A21302C6465626F756E63653A7B656E61626C65643A21302C74696D653A3430307D7D2C73656C6563744D6F64653A32';
wwv_flow_imp.g_varchar2_table(1556) := '2C73656C6563744F6E6C794F6E6550657247726F75703A21312C7365744163746976654E6F64653A21302C7365744974656D734F6E496E69743A21317D2C73292C672E726567696F6E49443D722C672E616A617849443D692C672E6E6F446174614D6573';
wwv_flow_imp.g_varchar2_table(1557) := '736167653D6F2C672E6572724D6573736167653D612C672E6974656D73325375626D69743D6C2C672E657870616E6465644E6F6465734974656D3D682C672E6C6F63616C53746F726167653D7B7D2C672E6C6F63616C53746F726167652E656E61626C65';
wwv_flow_imp.g_varchar2_table(1558) := '643D2259223D3D3D662C672E6C6F63616C53746F726167652E656E61626C6564262628672E73657373696F6E3D652E6974656D282270496E7374616E636522292E67657456616C756528292C672E76657273696F6E3D702C672E6C6F63616C53746F7261';
wwv_flow_imp.g_varchar2_table(1559) := '67652E6B65793D722C672E6C6F63616C53746F726167652E747970653D2273657373696F6E222C672E6C6F63616C53746F726167652E6B657946696E616C3D4A534F4E2E737472696E67696679287B6B65793A672E6C6F63616C53746F726167652E6B65';
wwv_flow_imp.g_varchar2_table(1560) := '792C706C7567696E3A6E2E6665617475726544657461696C732E6E616D652C73657373696F6E3A672E73657373696F6E2C76657273696F6E3A672E76657273696F6E7D2C6E756C6C2C30292C6E2E6C6F63616C53746F726167652E636865636B2626742E';
wwv_flow_imp.g_varchar2_table(1561) := '656163682873657373696F6E53746F726167652C66756E6374696F6E2874297B696628227B223D3D3D742E737562737472696E6728302C3129297472797B6C657420653D4A534F4E2E70617273652874293B652E706C7567696E213D3D6E2E6665617475';
wwv_flow_imp.g_varchar2_table(1562) := '726544657461696C732E6E616D657C7C652E6B6579213D3D672E6C6F63616C53746F726167652E6B65797C7C652E73657373696F6E3D3D3D672E73657373696F6E2626652E76657273696F6E3D3D3D672E76657273696F6E7C7C6E2E6C6F63616C53746F';
wwv_flow_imp.g_varchar2_table(1563) := '726167652E72656D6F76652874297D63617463682874297B652E64656275672E6572726F72287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D20696E697454726565222C6D73673A224572726F72207768696C652074727920';
wwv_flow_imp.g_varchar2_table(1564) := '746F207061727365206C6F63616C2073746F72616765206B6579206A736F6E222C6572723A742C6665617475726544657461696C733A6E2E6665617475726544657461696C737D297D7D29292C2169734E614E28672E616E696D6174696F6E4475726174';
wwv_flow_imp.g_varchar2_table(1565) := '696F6E292626672E616E696D6174696F6E4475726174696F6E3E3D303F672E616E696D6174696F6E4475726174696F6E3D7B6566666563743A22736C696465546F67676C65222C6475726174696F6E3A672E616E696D6174696F6E4475726174696F6E7D';
wwv_flow_imp.g_varchar2_table(1566) := '3A672E616E696D6174696F6E4475726174696F6E3D21312C2131213D3D64262628672E65736361706548544D4C3D2130293B636F6E737420443D2223222B722E737562737472696E672834293B762866756E6374696F6E2872297B636F6E737420693D78';
wwv_flow_imp.g_varchar2_table(1567) := '2872293B6966287428672E726567696F6E4944292E66616E637974726565287B657874656E73696F6E733A5B22676C797068222C2266696C746572225D2C636C6F6E65733A7B686967686C69676874436C6F6E65733A21307D2C6E6F646174613A21312C';
wwv_flow_imp.g_varchar2_table(1568) := '617269613A21302C61637469766556697369626C653A672E6F70656E506172656E744F664163746976654E6F64652C6573636170655469746C65733A672E65736361706548544D4C2C666F6375734F6E53656C6563743A21302C7469746C657354616262';
wwv_flow_imp.g_varchar2_table(1569) := '61626C653A21312C636865636B626F783A672E656E61626C65436865636B426F782C746F67676C654566666563743A672E616E696D6174696F6E4475726174696F6E2C73656C6563744D6F64653A672E73656C6563744D6F64652C73656C6563744F6E6C';
wwv_flow_imp.g_varchar2_table(1570) := '794F6E6550657247726F75703A672E73656C6563744F6E6C794F6E6550657247726F75702C64656275674C6576656C3A302C6B6579626F6172643A672E656E61626C654B6579426F6172642C717569636B7365617263683A672E656E61626C6551756963';
wwv_flow_imp.g_varchar2_table(1571) := '6B7365617263682C676C7970683A7B7072657365743A22617765736F6D6534222C6D61703A7B5F616464436C6173733A226661222C636865636B626F783A672E636865636B626F782C636865636B626F7853656C65637465643A672E636865636B626F78';
wwv_flow_imp.g_varchar2_table(1572) := '53656C65637465642C636865636B626F78556E6B6E6F776E3A672E636865636B626F78556E6B6E6F776E2C6472616748656C7065723A2266612D6172726F772D7269676874222C64726F704D61726B65723A2266612D6C6F6E672D6172726F772D726967';
wwv_flow_imp.g_varchar2_table(1573) := '6874222C6572726F723A2266612D7761726E696E67222C657870616E646572436C6F7365643A672E69636F6E457870616E646572436C6F7365642C657870616E6465724C617A793A2266612D616E676C652D7269676874222C657870616E6465724F7065';
wwv_flow_imp.g_varchar2_table(1574) := '6E3A672E69636F6E457870616E6465724F70656E2C6C6F6164696E673A2266612D7370696E6E65722066612D70756C7365222C6E6F646174613A2266612D6D65682D6F222C6E6F457870616E6465723A22222C726164696F3A2266612D636972636C652D';
wwv_flow_imp.g_varchar2_table(1575) := '7468696E222C726164696F53656C65637465643A2266612D636972636C65222C646F633A2266612D66696C652D6F222C646F634F70656E3A2266612D66696C652D6F222C666F6C6465723A2266612D666F6C6465722D6F222C666F6C6465724F70656E3A';
wwv_flow_imp.g_varchar2_table(1576) := '2266612D666F6C6465722D6F70656E2D6F227D7D2C66696C7465723A7B6175746F4170706C793A21302C6175746F457870616E643A672E7365617263682E6175746F457870616E642C636F756E7465723A672E7365617263682E636F756E7465722C6675';
wwv_flow_imp.g_varchar2_table(1577) := '7A7A793A21312C68696465457870616E646564436F756E7465723A21302C68696465457870616E646572733A21312C686967686C696768743A672E7365617263682E686967686C696768742C6C65617665734F6E6C793A672E7365617263682E6C656176';
wwv_flow_imp.g_varchar2_table(1578) := '65734F6E6C792C6E6F646174613A21312C6D6F64653A672E7365617263682E68696465556E6D6174636865643F2268696465223A2264696D6D227D2C736F757263653A692C696E69743A66756E6374696F6E28297B6966284E28292C4528292C672E7365';
wwv_flow_imp.g_varchar2_table(1579) := '744974656D734F6E496E69742626284328292C5F2829292C7728672E726567696F6E4944292C672E7365744163746976654E6F6465297B636F6E737420653D7928293B69662821652E6765744163746976654E6F64652829297B636F6E737420743D652E';
wwv_flow_imp.g_varchar2_table(1580) := '67657446697273744368696C6428293B742626742E736574416374697665282130297D7D7D2C636F6C6C617073653A66756E6374696F6E28652C6E297B77286E2E6E6F64652E6C69292C4328292C742844292E747269676765722822636F6C6C61707365';
wwv_flow_imp.g_varchar2_table(1581) := '64222C6E2E6E6F6465297D2C657870616E643A66756E6374696F6E28652C6E297B77286E2E6E6F64652E6C69292C4E28292C4328292C742844292E747269676765722822657870616E646564222C6E2E6E6F6465297D2C73656C6563743A66756E637469';
wwv_flow_imp.g_varchar2_table(1582) := '6F6E28652C6E297B71756575654D6963726F7461736B2866756E6374696F6E28297B6C657420653D6E2E6E6F64652C723D652E706172656E743B323D3D3D672E73656C6563744D6F6465262621303D3D3D672E73656C6563744F6E6C794F6E6550657247';
wwv_flow_imp.g_varchar2_table(1583) := '726F7570262672262621722E6973526F6F7428292626722E6368696C6472656E2E666F724561636828743D3E7B74213D3D652626742E697353656C656374656428292626742E73657453656C65637465642821312C7B6E6F4576656E74733A21307D297D';
wwv_flow_imp.g_varchar2_table(1584) := '292C4E282130292C22222B652E6578747261436C6173736573213D22222626287428652E6C69292E66696E6428222E66616E6379747265652D6E6F646522292E686173436C617373282266616E6379747265652D73656C656374656422293F7428222E22';
wwv_flow_imp.g_varchar2_table(1585) := '2B652E6578747261436C6173736573292E616464436C617373282266616E6379747265652D73656C656374656422293A7428222E222B652E6578747261436C6173736573292E72656D6F7665436C617373282266616E6379747265652D73656C65637465';
wwv_flow_imp.g_varchar2_table(1586) := '642229292C5F28297D297D2C636C69636B3A66756E6374696F6E28652C74297B69662828227469746C65223D3D3D742E746172676574547970657C7C2269636F6E223D3D3D742E74617267657454797065292626742E6E6F64652626742E6E6F64652E64';
wwv_flow_imp.g_varchar2_table(1587) := '617461297B636F6E737420653D742E6E6F64652E646174613B6E2E6973446566696E6564416E644E6F744E756C6C28652E6C696E6B293F6E2E6C696E6B28652E6C696E6B293A313D3D3D742E6E6F64652E636865636B626F782626742E6E6F64652E746F';
wwv_flow_imp.g_varchar2_table(1588) := '67676C6553656C656374656428297D7D2C6265666F726541637469766174653A66756E6374696F6E28297B72657475726E2121672E7365744163746976654E6F64657D2C61637469766174653A66756E6374696F6E28742C72297B696628722E6E6F6465';
wwv_flow_imp.g_varchar2_table(1589) := '2626722E6E6F64652E64617461297B636F6E737420743D722E6E6F64652E646174613B6E2E6973446566696E6564416E644E6F744E756C6C28742E76616C7565292626652E6974656D2875292E73657456616C756528742E76616C7565297D4E28213029';
wwv_flow_imp.g_varchar2_table(1590) := '7D7D292C6E2E6973446566696E6564416E644E6F744E756C6C286329297B672E7365617263682E6465626F756E63652E656E61626C65643F74282223222B63292E6B65797570286E2E6465626F756E63652866756E6374696F6E28297B5328297D2C672E';
wwv_flow_imp.g_varchar2_table(1591) := '7365617263682E6465626F756E63652E74696D6529293A74282223222B63292E6B657975702866756E6374696F6E28297B5328297D292C74282223222B63292E6F6E28226368616E6765222C66756E6374696F6E28297B5328297D293B636F6E73742072';
wwv_flow_imp.g_varchar2_table(1592) := '3D652E6974656D2863292E67657456616C756528293B6E2E6973446566696E6564416E644E6F744E756C6C2872292626722E6C656E6774683E3026265328297D6B28672E6175746F457870616E64324C6576656C292C6E2E6C6F616465722E73746F7028';
wwv_flow_imp.g_varchar2_table(1593) := '672E726567696F6E49442C2130292C742844292E6F6E2822657870616E64416C6C222C66756E6374696F6E28297B652E64656275672E696E666F287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D206472617754726565222C';
wwv_flow_imp.g_varchar2_table(1594) := '6D73673A22657870616E64416C6C206669726564222C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C7928292E657870616E64416C6C28297D292C742844292E6F6E2822636F6C6C61707365416C6C222C66756E63';
wwv_flow_imp.g_varchar2_table(1595) := '74696F6E28297B652E64656275672E696E666F287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D206472617754726565222C6D73673A22636F6C6C61707365416C6C206669726564222C6665617475726544657461696C733A';
wwv_flow_imp.g_varchar2_table(1596) := '6E2E6665617475726544657461696C737D292C7928292E657870616E64416C6C282131297D292C742844292E6F6E282273656C656374416C6C222C66756E6374696F6E28297B652E64656275672E696E666F287B6663743A6E2E66656174757265446574';
wwv_flow_imp.g_varchar2_table(1597) := '61696C732E6E616D652B22202D206472617754726565222C6D73673A2273656C656374416C6C206669726564222C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C7928292E73656C656374416C6C282130297D292C';
wwv_flow_imp.g_varchar2_table(1598) := '742844292E6F6E2822756E73656C656374416C6C222C66756E6374696F6E28297B652E64656275672E696E666F287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D206472617754726565222C6D73673A22756E73656C656374';
wwv_flow_imp.g_varchar2_table(1599) := '416C6C206669726564222C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C7928292E73656C656374416C6C282131297D292C742844292E6F6E2822657870616E6453656C6563746564222C66756E6374696F6E2829';
wwv_flow_imp.g_varchar2_table(1600) := '7B652E64656275672E696E666F287B6663743A6E2E6665617475726544657461696C732E6E616D652B22202D206472617754726565222C6D73673A22657870616E6453656C6563746564206669726564222C6665617475726544657461696C733A6E2E66';
wwv_flow_imp.g_varchar2_table(1601) := '65617475726544657461696C737D292C45282130297D292C742844292E6F6E2822657870616E64546F4C6576656C222C66756E6374696F6E28742C72297B652E64656275672E696E666F287B6663743A6E2E6665617475726544657461696C732E6E616D';
wwv_flow_imp.g_varchar2_table(1602) := '652B22202D206472617754726565222C6D73673A22657870616E64546F4C6576656C206669726564222C693A742C643A722C6665617475726544657461696C733A6E2E6665617475726544657461696C737D292C6E2E6973446566696E6564416E644E6F';
wwv_flow_imp.g_varchar2_table(1603) := '744E756C6C2872293F6B2872293A6B28672E6175746F457870616E64324C6576656C297D297D2C672E666F726365526566726573684576656E744F6E5374617274292C742844292E62696E6428226170657872656672657368222C66756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(1604) := '297B303D3D3D7428672E726567696F6E4944292E6368696C6472656E28227370616E22292E6C656E677468262628672E6C6F63616C53746F726167652E656E61626C656426266E2E6C6F63616C53746F726167652E72656D6F766528672E6C6F63616C53';
wwv_flow_imp.g_varchar2_table(1605) := '746F726167652E6B657946696E616C2C672E6C6F63616C53746F726167652E74797065292C7628622C213029297D292C672E726566726573683E302626736574496E74657276616C2866756E6374696F6E28297B303D3D3D7428672E726567696F6E4944';
wwv_flow_imp.g_varchar2_table(1606) := '292E6368696C6472656E28227370616E22292E6C656E677468262628672E6C6F63616C53746F726167652E656E61626C656426266E2E6C6F63616C53746F726167652E72656D6F766528672E6C6F63616C53746F726167652E6B657946696E616C2C672E';
wwv_flow_imp.g_varchar2_table(1607) := '6C6F63616C53746F726167652E74797065292C7628622C213029297D2C3165332A672E72656672657368297D7D7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(156403374909651069706)
,p_plugin_id=>wwv_flow_imp.id(142832840034600703466)
,p_file_name=>'fancytree.pkgd.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
