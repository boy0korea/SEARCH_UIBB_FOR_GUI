*&---------------------------------------------------------------------*
*& Include          ZSU4G_DEMO_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'
      OR 'BACK'
      OR 'CANC'.
      LEAVE TO SCREEN 0.
*    WHEN 'TEST'.
*      PERFORM on_test.
    WHEN OTHERS.
      CALL METHOD cl_gui_cfw=>dispatch.
  ENDCASE.
ENDMODULE.
