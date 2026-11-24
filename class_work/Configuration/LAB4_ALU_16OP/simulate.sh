source /home/eee/cshrc
xmvlog -sv rtl/top.sv
xmvlog -sv tb/TB_top.sv
xrun -sv -access +rwc +gui rtl/top.sv tb/TB_top_adv.sv 
#xmvlog -sv -f rtl_list.f 
