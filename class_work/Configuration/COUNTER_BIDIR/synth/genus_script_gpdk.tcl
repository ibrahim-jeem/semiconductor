set_db init_lib_search_path lib_gpdk045/lib
set_db init_hdl_search_path ../rtl/
read_libs lib_gpdk045/lib/slow_lib/slow_vdd1v0_basicCells.lib

read_hdl -sv top.sv
elaborate
read_sdc ../constraints/top.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
syn_generic
syn_map
syn_opt
#reports
report_timing > reports/report_timing.rpt
report_power > reports/report_power.rpt
report_area > reports/report_area.rpt
report_qor > reports/report_qor.rpt
report_gates -power > reports/report_gates.rpt
#Outputs
write_hdl > outputs/test_netlist.v
write_sdc > outputs/test_sdc.sdc
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge -setuphold split > outputs/delays.sdf
gui_show
