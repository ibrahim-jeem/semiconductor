source /home/eee/cshrc
xmvlog -sv rtl/COUNTER_4BIT.sv rtl/COUNTER_DFT_WRAPPER.sv
xmvlog -sv tb/TB_top.sv
#xmvlog -sv -f rtl_list.f
#xmvlog -sv `ls rtl/*.sv | grep -v top.sv` rtl/top.sv
#xmvlog -sv rtl/*.sv
#xmvlog -sv top/*.sv
xrun -sv -access +rwc +gui rtl/COUNTER_DFT_WRAPPER.sv tb/TB_top.sv
