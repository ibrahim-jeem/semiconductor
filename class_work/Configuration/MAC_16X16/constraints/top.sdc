# Create clock: 100 MHz
create_clock -name SYS_CLOCK -period 2.500 [get_ports SYS_CLOCK]

# Data inputs only: exclude clock and reset
set data_inputs [remove_from_collection [all_inputs] [get_ports {SYS_CLOCK SRST}]]

# Simple teaching constraints
set_input_delay 0.0 -clock SYS_CLOCK $data_inputs
set_output_delay 0.0 -clock SYS_CLOCK [all_outputs]
