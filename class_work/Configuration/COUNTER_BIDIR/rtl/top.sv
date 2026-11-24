/////////////////////////////////////////////////////////////////////////////////////////
/*
The following SystemVerilog RTL/testbench was developed by Dr. Shahriyar Masud Rizvi. 

    © 2026 Shahriyar Masud Rizvi

Attribution Requirement:
If you use the following SystemVerilog sources, in whole or in part,
you MUST include visible credit to the original authors in:
  - Documentation or README of your project, OR
  - About/Info section of your tool, OR
  - Academic citation/reference if used in research

Citation Example:
"This project uses work from S. M. Rizvi, RTL Design, Verification, Synthesis & PnR for Digital VLSI Design, American International University-Bangladesh, Dhaka, Bangladesh, 2026."
*/
/////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module COUNTER_4BIT
(input logic SYS_CLOCK,
input logic SRST, LOAD, UP, DOWN,
input logic [3:0] DATA,
output logic [3:0] COUNT);

always_ff @ (posedge SYS_CLOCK)
begin

	if (SRST)
        COUNT <= '0; 
        else if (LOAD)
        COUNT <= DATA;
        else if (UP && !DOWN)
        COUNT <= COUNT + 1;
        else if (!UP && DOWN)
        COUNT <= COUNT - 1;

end


endmodule: COUNTER_4BIT
