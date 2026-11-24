source /home/eee/cshrc
xmvlog -sv -f rtl_list.f
xmvlog -sv tb/TB_top.sv
#xrun -sv -access +rwc +gui -f rtl_list.f tb/TB_top.sv
xrun -sv -access +rwc +gui rtl/top.sv tb/TB_top.sv

#xmvlog -sv rtl/FULLADDER.sv rtl/top.sv 
#xmvlog -sv tb/TB_top.sv
#xrun -sv -access +rwc +gui rtl/FULLADDER.sv rtl/top.sv tb/TB_top.sv
