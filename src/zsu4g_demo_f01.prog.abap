*&---------------------------------------------------------------------*
*& Include          ZSU4G_DEMO_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form pbo_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM pbo_2000 .
  zcl_su4g=>pbo(
    EXPORTING
      iv_callback = 'ON_SEARCH'
      iv_view = 'SFLIGHT'
  ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_2000 .
  CHECK: go_grid_container IS INITIAL.

  CREATE OBJECT go_grid_container
    EXPORTING
*     parent         = parent                  " Parent container
      container_name = 'GRID_CONTAINER'          " Name of the Screen CustCtrl Name to Link Container To
*     style          = style                   " Windows Style Attributes Applied to this Container
*     lifetime       = lifetime_default        " Lifetime
*     repid          = repid                   " Screen to Which this Container is Linked
*     dynnr          = dynnr                   " Report To Which this Container is Linked
*     no_autodef_progid_dynnr     = no_autodef_progid_dynnr " Don't Autodefined Progid and Dynnr?
*    EXCEPTIONS
*     cntl_error     = 1                       " CNTL_ERROR
*     cntl_system_error           = 2                       " CNTL_SYSTEM_ERROR
*     create_error   = 3                       " CREATE_ERROR
*     lifetime_error = 4                       " LIFETIME_ERROR
*     lifetime_dynpro_dynpro_link = 5                       " LIFETIME_DYNPRO_DYNPRO_LINK
*     others         = 6
    .

  CREATE OBJECT go_grid
    EXPORTING
*     i_shellstyle            = 0                       " Control Style
*     i_lifetime              = i_lifetime              " Lifetime
      i_parent = go_grid_container                " Parent Container
*     i_appl_events           = space                   " Register Events as Application Events
*     i_parentdbg             = i_parentdbg             " Internal, Do not Use
*     i_applogparent          = i_applogparent          " Container for Application Log
*     i_graphicsparent        = i_graphicsparent        " Container for Graphics
*     i_name   = i_name                  " Name
*     i_fcat_complete         = space                   " Boolean Variable (X=True, Space=False)
*     o_previous_sral_handler = o_previous_sral_handler
*    EXCEPTIONS
*     error_cntl_create       = 1                       " Error when creating the control
*     error_cntl_init         = 2                       " Error While Initializing Control
*     error_cntl_link         = 3                       " Error While Linking Control
*     error_dp_create         = 4                       " Error While Creating DataProvider Control
*     others   = 5
    .

  go_grid->set_table_for_first_display(
    EXPORTING
*      i_buffer_active               = i_buffer_active      " Buffering Active
*      i_bypassing_buffer            = i_bypassing_buffer   " Switch Off Buffer
*      i_consistency_check           = i_consistency_check  " Starting Consistency Check for Interface Error Recognition
      i_structure_name              = 'SFLIGHT'     " Internal Output Table Structure Name
*      is_variant                    = is_variant           " Layout
*      i_save                        = i_save               " Save Layout
*      i_default                     = 'X'                  " Default Display Variant
*      is_layout                     = is_layout            " Layout
*      is_print                      = is_print             " Print Control
*      it_special_groups             = it_special_groups    " Field Groups
*      it_toolbar_excluding          = it_toolbar_excluding " Excluded Toolbar Standard Functions
*      it_hyperlink                  = it_hyperlink         " Hyperlinks
*      it_alv_graphics               = it_alv_graphics      " Table of Structure DTC_S_TC
*      it_except_qinfo               = it_except_qinfo      " Table for Exception Quickinfo
*      ir_salv_adapter               = ir_salv_adapter      " Interface ALV Adapter
    CHANGING
      it_outtab                     = gt_outtab            " Output Table
*      it_fieldcatalog               = it_fieldcatalog      " Field Catalog
*      it_sort                       = it_sort              " Sort Criteria
*      it_filter                     = it_filter            " Filter Criteria
*    EXCEPTIONS
*      invalid_parameter_combination = 1                    " Wrong Parameter
*      program_error                 = 2                    " Program Errors
*      too_many_lines                = 3                    " Too many Rows in Ready for Input Grid
*      others                        = 4
  ).
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.
FORM on_search.
  DATA: lt_data             TYPE TABLE OF sflight,
        lt_range_carrid     TYPE RANGE OF sflight-carrid,
        lt_range_connid     TYPE RANGE OF sflight-connid,
        lt_range_fldate     TYPE RANGE OF sflight-fldate,
        lt_range_price      TYPE RANGE OF sflight-price,
        lt_range_currency   TYPE RANGE OF sflight-currency,
        lt_range_planetype  TYPE RANGE OF sflight-planetype,
        lt_range_seatsmax   TYPE RANGE OF sflight-seatsmax,
        lt_range_seatsocc   TYPE RANGE OF sflight-seatsocc,
        lt_range_paymentsum TYPE RANGE OF sflight-paymentsum,
        lt_range_seatsmax_b TYPE RANGE OF sflight-seatsmax_b,
        lt_range_seatsocc_b TYPE RANGE OF sflight-seatsocc_b,
        lt_range_seatsmax_f TYPE RANGE OF sflight-seatsmax_f,
        lt_range_seatsocc_f TYPE RANGE OF sflight-seatsocc_f,
        lv_count            TYPE i,
        lv_max_exceed       TYPE flag,
        lv_error_msg        TYPE string.

  MESSAGE 'search' TYPE 'S'.

  DATA(ls_search_param) = zcl_su4g=>get_search_param( ).
  LOOP AT ls_search_param-t_name_range INTO DATA(ls_name_range).
    CASE ls_name_range-name.
      WHEN 'CARRID'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_carrid.
      WHEN 'CONNID'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_connid.
      WHEN 'FLDATE'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_fldate.
      WHEN 'PRICE'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_price.
      WHEN 'CURRENCY'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_currency.
      WHEN 'PLANETYPE'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_planetype.
      WHEN 'SEATSMAX'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_seatsmax.
      WHEN 'SEATSOCC'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_seatsocc.
      WHEN 'PAYMENTSUM'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_paymentsum.
      WHEN 'SEATSMAX_B'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_seatsmax_b.
      WHEN 'SEATSOCC_B'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_seatsocc_b.
      WHEN 'SEATSMAX_F'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_seatsmax_f.
      WHEN 'SEATSOCC_F'.
        MOVE-CORRESPONDING ls_name_range-range TO lt_range_seatsocc_f.
    ENDCASE.
  ENDLOOP.

  SELECT *
    FROM sflight
    WHERE carrid     IN @lt_range_carrid
      AND connid     IN @lt_range_connid
      AND fldate     IN @lt_range_fldate
      AND price      IN @lt_range_price
      AND currency   IN @lt_range_currency
      AND planetype  IN @lt_range_planetype
      AND seatsmax   IN @lt_range_seatsmax
      AND seatsocc   IN @lt_range_seatsocc
      AND paymentsum IN @lt_range_paymentsum
      AND seatsmax_b IN @lt_range_seatsmax_b
      AND seatsocc_b IN @lt_range_seatsocc_b
      AND seatsmax_f IN @lt_range_seatsmax_f
      AND seatsocc_f IN @lt_range_seatsocc_f
    INTO TABLE @lt_data
    UP TO @ls_search_param-v_max_count ROWS.

  MOVE-CORRESPONDING lt_data TO gt_outtab.

  go_grid->refresh_table_display( ).

ENDFORM.
