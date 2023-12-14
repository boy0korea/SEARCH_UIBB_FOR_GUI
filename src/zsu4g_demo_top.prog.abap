*&---------------------------------------------------------------------*
*& Include ZSU4G_DEMO_TOP              - Report ZSU4G_DEMO
*&---------------------------------------------------------------------*
REPORT zsu4g_demo.

DATA: go_grid_container TYPE REF TO cl_gui_custom_container,
      go_grid           TYPE REF TO cl_gui_alv_grid,
      gt_outtab         TYPE TABLE OF sflight.
