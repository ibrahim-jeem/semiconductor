#############################################
# Clock Definition
#############################################
# 100 MHz clock (10 ns period)
create_clock -name SYS_CLOCK -period 10.000 [get_ports SYS_CLOCK]

#############################################
# Input Constraints
#############################################
# Collect all inputs except clock and async reset
set data_inputs [remove_from_collection [all_inputs] [get_ports {SYS_CLOCK FSM_ARESET}]]

# Assume zero input delay (ideal source)
set_input_delay 0.0 -clock SYS_CLOCK $data_inputs

#############################################
# Output Constraints
#############################################
# Assume zero output delay (ideal load)
set_output_delay 0.0 -clock SYS_CLOCK [all_outputs]

#############################################
# Asynchronous Reset Handling
#############################################
# Ignore timing from async reset to registers
set_false_path -from [get_ports FSM_ARESET] -to [all_registers]

