# Create clock: 100 MHz
create_clock -name SYS_CLOCK -period 10.00 [get_ports SYS_CLOCK]

# All synchronous inputs except clock
set data_inputs [remove_from_collection [all_inputs] [get_ports SYS_CLOCK]]

# Simple teaching constraints
set_input_delay 0.0 -clock SYS_CLOCK $data_inputs
set_output_delay 0.0 -clock SYS_CLOCK [all_outputs]
