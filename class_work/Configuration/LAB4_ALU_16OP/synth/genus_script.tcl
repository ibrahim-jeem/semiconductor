###############################################################################
# Cadence Genus Synthesis Script
###############################################################################

#------------------------------------------------------------
# User Settings
#------------------------------------------------------------

set LIB_PATH lib/slow_lib/slow_vdd1v0_basicCells.lib
set RTL_PATH ../rtl
set SDC_FILE ../constraints/top.sdc

set _REPORTS_PATH reports
set _OUTPUTS_PATH outputs

#------------------------------------------------------------
# Search paths
#------------------------------------------------------------

set_db init_lib_search_path lib/
set_db init_hdl_search_path $RTL_PATH

#------------------------------------------------------------
# Create output directories
#------------------------------------------------------------

file mkdir $_REPORTS_PATH
file mkdir $_OUTPUTS_PATH
file mkdir $_REPORTS_PATH/Gen
file mkdir $_REPORTS_PATH/Map
file mkdir $_REPORTS_PATH/Opt

#------------------------------------------------------------
# Read technology library
#------------------------------------------------------------

read_libs $LIB_PATH

#------------------------------------------------------------
# Read RTL
#------------------------------------------------------------

set RTL_FILES [concat \
    [glob -nocomplain $RTL_PATH/*.sv] \
    [glob -nocomplain $RTL_PATH/*.v]]

if {[llength $RTL_FILES] == 0} {
    error "No RTL files found in $RTL_PATH"
}

puts "Reading RTL files:"
foreach f $RTL_FILES {
    puts "  $f"
}

read_hdl -sv $RTL_FILES

#------------------------------------------------------------
# Elaborate
#------------------------------------------------------------

elaborate


#------------------------------------------------------------
# Determine top-level module
#------------------------------------------------------------

set TOP_NAME [get_db current_design .name]

puts ""
puts "======================================================"
puts "Top-level module : $TOP_NAME"
puts "======================================================"
puts ""

#------------------------------------------------------------
# Read timing constraints
#------------------------------------------------------------

read_sdc $SDC_FILE

# Exclude clock port from input-to-register timing reports
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports SYS_CLOCK]]

#------------------------------------------------------------
# Pre-synthesis checks
#------------------------------------------------------------

check_design  > $_REPORTS_PATH/check_design_pre.rpt
check_timing  > $_REPORTS_PATH/check_timing_pre.rpt
report_clocks > $_REPORTS_PATH/report_clocks_pre.rpt

#------------------------------------------------------------
# Synthesis effort
#------------------------------------------------------------

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

###############################################################################
# Generic Synthesis
###############################################################################

puts "========== Generic Synthesis =========="

syn_generic

report_area         > $_REPORTS_PATH/Gen/report_area.rpt
report_power        > $_REPORTS_PATH/Gen/report_power.rpt
report_qor          > $_REPORTS_PATH/Gen/report_qor.rpt
report_gates        > $_REPORTS_PATH/Gen/report_gates.rpt
report_gates -power > $_REPORTS_PATH/Gen/report_gates_power.rpt
report_timing       > $_REPORTS_PATH/Gen/report_timing.rpt

write_snapshot \
    -outdir $_REPORTS_PATH \
    -tag generic

###############################################################################
# Technology Mapping
###############################################################################

puts "========== Technology Mapping =========="

syn_map

report_area         > $_REPORTS_PATH/Map/report_area.rpt
report_power        > $_REPORTS_PATH/Map/report_power.rpt
report_qor          > $_REPORTS_PATH/Map/report_qor.rpt
report_gates        > $_REPORTS_PATH/Map/report_gates.rpt
report_gates -power > $_REPORTS_PATH/Map/report_gates_power.rpt
report_timing       > $_REPORTS_PATH/Map/report_timing.rpt

write_snapshot \
    -outdir $_REPORTS_PATH \
    -tag map

###############################################################################
# Optimization
###############################################################################

puts "========== Optimization =========="

syn_opt

report_area         > $_REPORTS_PATH/Opt/report_area.rpt
report_power        > $_REPORTS_PATH/Opt/report_power.rpt
report_qor          > $_REPORTS_PATH/Opt/report_qor.rpt
report_gates        > $_REPORTS_PATH/Opt/report_gates.rpt
report_gates -power > $_REPORTS_PATH/Opt/report_gates_power.rpt
report_timing       > $_REPORTS_PATH/Opt/report_timing.rpt

write_snapshot \
    -outdir $_REPORTS_PATH \
    -tag final

###############################################################################
# Final Checks
###############################################################################

check_design  > $_REPORTS_PATH/check_design_final.rpt
check_timing  > $_REPORTS_PATH/check_timing_final.rpt
report_clocks > $_REPORTS_PATH/report_clocks_final.rpt

###############################################################################
# Final Timing Reports
###############################################################################

report_timing \
    > $_REPORTS_PATH/report_timing.rpt

report_timing \
    -max_paths 20 \
    > $_REPORTS_PATH/report_timing_20paths.rpt

report_timing \
    -from [all_registers] \
    -to [all_registers] \
    -max_paths 20 \
    > $_REPORTS_PATH/report_timing_reg2reg.rpt

report_timing \
    -from $DATA_INPUTS \
    -to [all_registers] \
    -max_paths 20 \
    > $_REPORTS_PATH/report_timing_in2reg.rpt

report_timing \
    -from [all_registers] \
    -to [all_outputs] \
    -max_paths 20 \
    > $_REPORTS_PATH/report_timing_reg2out.rpt

###############################################################################
# Final Reports
###############################################################################

report_area         > $_REPORTS_PATH/report_area.rpt
report_power        > $_REPORTS_PATH/report_power.rpt
report_qor          > $_REPORTS_PATH/report_qor.rpt
report_gates        > $_REPORTS_PATH/report_gates.rpt
report_gates -power > $_REPORTS_PATH/report_gates_power.rpt

###############################################################################
# Debug Reports
###############################################################################

report_design_rules > $_REPORTS_PATH/report_design_rules.rpt
report_messages     > $_REPORTS_PATH/report_messages.rpt

###############################################################################
# Write Outputs
###############################################################################

write_hdl > $_OUTPUTS_PATH/test_netlist.v

write_sdc > $_OUTPUTS_PATH/test_sdc.sdc

write_sdf \
    -timescale ns \
    -nonegchecks \
    -recrem split \
    -edges check_edge \
    -setuphold split \
    > $_OUTPUTS_PATH/delays.sdf

###############################################################################
# Remove duplicate snapshot files
###############################################################################

foreach f [list \
    generic_area.rpt \
    generic_gates.rpt \
    generic_qor.rpt \
    generic_time.rpt \
    generic_${TOP_NAME}.db \
    map_area.rpt \
    map_gates.rpt \
    map_qor.rpt \
    map_time.rpt \
    map_${TOP_NAME}.db \
    final_area.rpt \
    final_gates.rpt \
    final_qor.rpt \
    final_time.rpt \
] {
    if {[file exists "$_REPORTS_PATH/$f"]} {
        file delete -force "$_REPORTS_PATH/$f"
    }
}

###############################################################################
# Launch GUI
###############################################################################

gui_show
