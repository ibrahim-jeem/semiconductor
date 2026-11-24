source /home/eee/cshrc
xmvlog -sv rtl/CLA_4BIT.sv 
xmvlog -sv tb/TB_top.sv
xrun -sv -access +rwc +gui rtl/CLA_4BIT.sv tb/TB_top.sv



