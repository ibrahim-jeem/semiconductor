source /home/eee/cshrc
xmvlog -sv rtl/FULLADDER.sv rtl/RCA_4BIT.sv 
xmvlog -sv tb/TB_top.sv
xrun -sv -access +rwc +gui rtl/RCA_4BIT.sv tb/TB_top.sv



