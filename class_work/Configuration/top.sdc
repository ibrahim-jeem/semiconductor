#create_clock -name SYS_CLOCK -period 10 -waveform {0 5} [get_ports "SYS_CLOCK"]


#Works--set1
#set_input_delay -max 0.0 [get_ports *] -clock SYS_CLOCK
#remove_input_delay [get ports SYS_CLOCK SRST]
#set_output_delay -max 0.0 [get_ports *] -clock SYS_CLOCK
################

#Works
#set_input_delay 0.0 -clock SYS_CLOCK -max [all_inputs]
#set_output_delay 0.0 -clock SYS_CLOCK -max [all_outputs]
################

###############
# Don't time reset
#set_false_path -from [get_ports aresetn]
###############

set_max_delay 5.0 -from [all_inputs] -to [all_outputs]
