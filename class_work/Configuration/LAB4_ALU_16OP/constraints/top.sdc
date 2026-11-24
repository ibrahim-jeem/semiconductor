# Create clock: 100 MHz
create_clock -name SYS_CLOCK -period 10.000 [get_ports SYS_CLOCK]

# Define data inputs: Ain, Bin, ALU_CONTROL
set data_inputs [remove_from_collection [all_inputs] [get_ports SYS_CLOCK]]

# Ideal/simple constraint for teaching
set_input_delay 0.0 -clock SYS_CLOCK $data_inputs
set_output_delay 0.0 -clock SYS_CLOCK [all_outputs]
