CLASS zcl_su4g DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_fpm_guibb .
    INTERFACES if_fpm_guibb_search .
    INTERFACES if_fpm_guibb_search_ext .
    INTERFACES if_wd_component_assistance .
    INTERFACES if_fpm_guibb_dynamic_config .
    INTERFACES if_fpm_ovp_conf_exit .

    TYPES:
      BEGIN OF ts_init_param,
        v_callback       TYPE string,
        v_view           TYPE string,
        v_size           TYPE i,
        v_hide_max_count TYPE flag,
      END OF ts_init_param .
    TYPES:
      BEGIN OF ts_search_param,
        v_max_count           TYPE i,
        t_fpm_search_criteria TYPE fpmgb_t_search_criteria,
        t_name_range          TYPE sabp_t_name_range_pairs,
      END OF ts_search_param .

    CLASS-METHODS pbo
      IMPORTING
        !iv_callback       TYPE clike
        !iv_view           TYPE clike
        !iv_size           TYPE i OPTIONAL
        !iv_hide_max_count TYPE flag OPTIONAL .
    CLASS-METHODS get_search_param
      RETURNING
        VALUE(rs_search_param) TYPE ts_search_param .
    METHODS wddomodifyview
      IMPORTING
        !first_time TYPE flag
        !view       TYPE REF TO if_wd_view .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA ms_search_param TYPE ts_search_param .
    DATA mo_gui_full_screen TYPE REF TO cl_gui_docking_container .
    DATA mo_gui_html_viewer TYPE REF TO cl_gui_html_viewer .
    DATA mo_rtti TYPE REF TO cl_abap_structdescr .
    CLASS-DATA go_wd_view TYPE REF TO if_wd_view .
    CLASS-DATA go_instance TYPE REF TO zcl_su4g .
    CLASS-DATA gs_init_param TYPE ts_init_param .
    CONSTANTS gc_size_min TYPE i VALUE 100 ##NO_TEXT.
    CONSTANTS gc_size_max TYPE i VALUE 300 ##NO_TEXT.

    METHODS on_sapevent
      FOR EVENT sapevent OF cl_gui_html_viewer
      IMPORTING
        !action
        !frame
        !getdata
        !postdata
        !query_table .
    METHODS init .
    METHODS gui_size_min .
    METHODS gui_size_max .
    METHODS set_js
      IMPORTING
        !iv_js TYPE string .
ENDCLASS.



CLASS ZCL_SU4G IMPLEMENTATION.


  METHOD get_search_param.
*@gui
    rs_search_param = go_instance->ms_search_param.
  ENDMETHOD.


  METHOD gui_size_max.
*@gui
    mo_gui_full_screen->set_extension( gs_init_param-v_size ).
  ENDMETHOD.


  METHOD gui_size_min.
*@gui
    mo_gui_full_screen->set_extension( gc_size_min ).
  ENDMETHOD.


  METHOD if_fpm_guibb_dynamic_config~has_dynamic_configuration.
*@search uibb
    rv_has_dynamic_configuration = abap_true.
  ENDMETHOD.


  METHOD if_fpm_guibb_search_ext~after_failed_event.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search_ext~before_dispatch_event.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search_ext~get_own_persistence_util.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search_ext~needs_confirmation.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search~check_config.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search~flush.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search~get_data.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb_search~get_default_config.
*@search uibb
    io_layout_config->set_settings(
      EXPORTING
        iv_number_of_query_lines     = 99     " Number of Visible Query Rows in GUIBB Search
*        iv_result_number_of_vis_rows = iv_result_number_of_vis_rows " GUIBB SEARCH: Number of Rows in Result List
*        iv_enable_saved_searches     = iv_enable_saved_searches     " GUIBB Search: Enable Saved Searches
*        iv_enable_exclude_criteria   = iv_enable_exclude_criteria   " Enable Exclude Criteria Area in Search Component
*        iv_show_button_search        = iv_show_button_search        " Show "Search" Button
*        iv_show_button_clear         = iv_show_button_clear         " Show "Clear Entries" Button
*        iv_show_button_reset         = iv_show_button_reset         " Show "Reset to Default" Button in GUIBB Search
*        iv_show_max_num_result_field = iv_show_max_num_result_field " Visibility of 'Maximum Number of Results' Field
*        iv_max_number_of_results     = iv_max_number_of_results     " Maximum Number of Rows in Result List in Search GUIBB
*        iv_group_same_criteria       = iv_group_same_criteria       " Group Same Search Criteria
*        iv_allow_personalization     = iv_allow_personalization     " FPM Search: Allow Personalization
*        iv_aria_landmark             = iv_aria_landmark             " Aria Landmark
*        iv_location_saved_searches   = iv_location_saved_searches
*        iv_check_mandatory           = iv_check_mandatory           " Check Mandatory Fields on Screen
*        iv_allow_easy_search         = iv_allow_easy_search         " GUIBB Search: Enable Easy Search
*        iv_execute_search_on_enter   = iv_execute_search_on_enter   " Execute a Search after Pressing ENTER In the Search GUIBB
*        iv_search_as_select_option   = iv_search_as_select_option   " Search: Display Search Criteria as Select Option
    ).


    LOOP AT mo_rtti->components INTO DATA(ls_comp).
      io_layout_config->add_attribute(
        EXPORTING
          iv_name             = ls_comp-name             " Component name
*    iv_index            = iv_index            " WDA Configuration: Index Attribute
*    iv_text             = iv_text             " Web Dynpro: Configuration: Translatable Text
*    iv_default_operator = iv_default_operator " GUIBB SEARCH: Search Operator
*    iv_group_id_attr    = iv_group_id_attr    " ID of Search Group
*    iv_input_prompt     = iv_input_prompt     " FPM: Input Prompt of a UI Element
*    iv_enable_tokens    = iv_enable_tokens    " Use Tokens as Input in a Search Attribute
*    iv_shlp_textfield   = iv_shlp_textfield   " DDIC Search Help: Text Field
*    iv_token_format     = iv_token_format     " Format for Text of a Token
*    iv_id               = iv_id               " FPM: Element ID
*    iv_elem_ddic_shlp   = iv_elem_ddic_shlp   " Name of a Search Help
*  RECEIVING
*    rv_element_id       = rv_element_id       " FPM: Element ID
      ).

    ENDLOOP.
  ENDMETHOD.


  METHOD if_fpm_guibb_search~get_definition.
*@search uibb
    DATA: ls_field_description_attr	TYPE fpmgb_s_searchfield_descr.

    CHECK: mo_rtti IS NOT INITIAL.
    eo_field_catalog_attr = mo_rtti.

    LOOP AT mo_rtti->components INTO DATA(ls_comp).
      CLEAR: ls_field_description_attr.
      ls_field_description_attr-name = ls_comp-name.
      ls_field_description_attr-value_suggest = abap_true.
      APPEND ls_field_description_attr TO et_field_description_attr.
    ENDLOOP.

    es_options-app_key_for_saving_searches = gs_init_param-v_view.
    es_options-hide_max_num_result_field = gs_init_param-v_hide_max_count.
    es_options-allow_exclude_criterias = abap_true.
  ENDMETHOD.


  METHOD if_fpm_guibb_search~process_event.
*@search uibb
    DATA: lt_fpm_search_criteria TYPE fpmgb_t_search_criteria,
          ls_fpm_search_criteria TYPE fpmgb_s_search_criteria,
          ls_search_param        TYPE ts_search_param,
          ls_name_range          TYPE sabp_s_name_range_pair,
          lr_range               TYPE REF TO data,
          lv_json                TYPE string,
          lv_index               TYPE i.
    FIELD-SYMBOLS: <lt_range> TYPE ANY TABLE.

    CASE io_event->mv_event_id.
      WHEN if_fpm_guibb_search=>fpm_execute_search.
        " FPM:SEARCH -> SAPEVENT:ZSEARCH
        ls_search_param-v_max_count = iv_max_num_results.
        ls_search_param-t_fpm_search_criteria = it_fpm_search_criteria.

        lt_fpm_search_criteria = it_fpm_search_criteria.
        SORT lt_fpm_search_criteria BY search_attribute.
        DELETE ADJACENT DUPLICATES FROM lt_fpm_search_criteria COMPARING search_attribute.
        LOOP AT lt_fpm_search_criteria INTO ls_fpm_search_criteria.
          lv_index = sy-tabix.

          io_search_conversion->fpm_attribute_into_abap_range(
            EXPORTING
              iv_search_attribute = ls_fpm_search_criteria-search_attribute
            IMPORTING
              et_range_tab_ref    = lr_range
          ).

          CLEAR: ls_name_range.
          ls_name_range-name = ls_fpm_search_criteria-search_attribute.
          ASSIGN lr_range->* TO <lt_range>.
          MOVE-CORRESPONDING <lt_range> TO ls_name_range-range.
          APPEND ls_name_range TO ls_search_param-t_name_range.
        ENDLOOP.

        /ui2/cl_json=>serialize(
          EXPORTING
            data             = ls_search_param
          RECEIVING
            r_json           = lv_json
        ).
        cl_http_utility=>escape_html(
          EXPORTING
            unescaped   = lv_json
          RECEIVING
            escaped     = lv_json
        ).
        set_js(
          iv_js = `document.getElementById('zsearch_return').value = '` && lv_json && `';`
               && `document.getElementById('zsearch').submit();`
        ).
      WHEN 'EXPANDALL'.
        " FPM:EXPANDALL -> SAPEVENT:ZZ1
        set_js( `document.getElementById('zz1').submit();` ).
      WHEN 'COLLAPSEALL'.
        " FPM:COLLAPSEALL -> SAPEVENT:ZZ2
        set_js( `document.getElementById('zz2').submit();` ).
    ENDCASE.
  ENDMETHOD.


  METHOD if_fpm_guibb~get_parameter_list.
*@search uibb
  ENDMETHOD.


  METHOD if_fpm_guibb~initialize.
*@search uibb

    io_app_parameter->get_value(
      EXPORTING
        iv_key   = 'IV_VIEW'
      IMPORTING
        ev_value = gs_init_param-v_view
    ).
    IF gs_init_param-v_view IS INITIAL.
      gs_init_param-v_view = 'MASSDUMMY'.
    ENDIF.

    io_app_parameter->get_value(
      EXPORTING
        iv_key   = 'IV_HIDE_MAX_COUNT'
      IMPORTING
        ev_value = gs_init_param-v_hide_max_count
    ).

    mo_rtti ?= cl_abap_structdescr=>describe_by_name( p_name = gs_init_param-v_view ).

  ENDMETHOD.


  METHOD if_fpm_ovp_conf_exit~override_event_ovp.
*@search uibb
    DATA: lo_event TYPE REF TO cl_fpm_event.

    lo_event = io_ovp->get_event( ).

    CASE lo_event->mv_event_id.
      WHEN if_fpm_constants=>gc_event-start.

        TRY.
            io_ovp->get_uibbs(
              IMPORTING
                et_uibb = DATA(lt_uibb)
            ).

            LOOP AT lt_uibb INTO DATA(ls_uibb).
              ls_uibb-instance_id = gs_init_param-v_view.
              io_ovp->change_uibb( ls_uibb ).
            ENDLOOP.
          CATCH cx_fpm_floorplan.

        ENDTRY.

    ENDCASE.
  ENDMETHOD.


  METHOD if_wd_component_assistance~get_text.
*@wd
  ENDMETHOD.


  METHOD init.
*@gui
    DATA: lo_parent     TYPE REF TO cl_gui_container,
          lt_event      TYPE cntl_simple_events,
          ls_event      TYPE cntl_simple_event,
          lt_parameter  TYPE tihttpnvp,
          lv_url_string TYPE string,
          lv_url        TYPE bxurlg-gen_url.

    " full screen
    CREATE OBJECT mo_gui_full_screen
      EXPORTING
        side      = cl_gui_docking_container=>dock_at_top
        extension = gs_init_param-v_size.
    lo_parent = mo_gui_full_screen.

    " html viewer
    CREATE OBJECT mo_gui_html_viewer
      EXPORTING
        parent               = lo_parent
        query_table_disabled = abap_true.
    ls_event-eventid = cl_gui_html_viewer=>m_id_sapevent.
    ls_event-appl_event = abap_true.
    APPEND ls_event TO lt_event.
    mo_gui_html_viewer->set_registered_events( lt_event ).
    SET HANDLER me->on_sapevent FOR mo_gui_html_viewer.

    " FPM URL
    lt_parameter = VALUE #(
      ( name = 'IV_VIEW' value = gs_init_param-v_view )
      ( name = 'IV_HIDE_MAX_COUNT' value = gs_init_param-v_hide_max_count )
    ).
    CALL FUNCTION 'WDY_CONSTRUCT_URL'
      EXPORTING
        internalmode        = abap_false
        application         = 'ZW_SU4G'
        parameters          = lt_parameter
      IMPORTING
        out_url             = lv_url_string
      EXCEPTIONS
        invalid_application = 1
        OTHERS              = 2.
    lv_url = lv_url_string.

    mo_gui_html_viewer->enable_sapsso( abap_true ).
    mo_gui_html_viewer->show_url( lv_url ).



  ENDMETHOD.


  METHOD on_sapevent.
*@gui
    DATA: lv_string       TYPE string,
          ls_search_param TYPE ts_search_param.

    CASE action.
      WHEN 'ZSEARCH'.
        " FPM:SEARCH -> SAPEVENT:ZSEARCH
        CONCATENATE LINES OF postdata INTO lv_string.
        lv_string = lv_string+7.

        /ui2/cl_json=>deserialize(
          EXPORTING
            json             = lv_string
          CHANGING
            data             = ls_search_param
        ).
        ms_search_param = ls_search_param.

        gui_size_min( ).

        PERFORM (gs_init_param-v_callback) IN PROGRAM (sy-cprog) IF FOUND.
      WHEN 'ZZ1'.
        " FPM:EXPANDALL -> SAPEVENT:ZZ1
        gui_size_max( ).
      WHEN 'ZZ2'.
        " FPM:COLLAPSEALL -> SAPEVENT:ZZ2
        gui_size_min( ).
    ENDCASE.


  ENDMETHOD.


  METHOD pbo.
*@gui
    IF go_instance IS INITIAL.
      gs_init_param-v_callback = iv_callback.
      IF gs_init_param-v_callback IS INITIAL.
        gs_init_param-v_callback = 'ON_SEARCH'.
      ENDIF.
      gs_init_param-v_view = iv_view.
      IF gs_init_param-v_view IS INITIAL.
        gs_init_param-v_view = 'MASSDUMMY'.
      ENDIF.
      gs_init_param-v_size = iv_size.
      IF gs_init_param-v_size IS INITIAL.
        gs_init_param-v_size = gc_size_max.
      ENDIF.
      gs_init_param-v_hide_max_count = iv_hide_max_count.

      CREATE OBJECT go_instance.
      go_instance->init( ).
    ENDIF.
  ENDMETHOD.


  METHOD set_js.
*@wd
    DATA: lo_html_fragment TYPE REF TO cl_wd_html_fragment.

    lo_html_fragment ?= go_wd_view->get_element( id = 'HTML_FRAGMENT' ).
    lo_html_fragment->set_html(
      value = `<img src="/sap/public/bc/ur/nw5/1x1.gif?` && sy-uzeit
           && `" style="display: none;" onload="` && iv_js
           && `" />`
    ).
  ENDMETHOD.


  METHOD wddomodifyview.
*@wd
    IF first_time EQ abap_true.
      go_wd_view = view.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
