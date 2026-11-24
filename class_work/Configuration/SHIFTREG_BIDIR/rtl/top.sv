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

module SHIFTREG_4BIT
(input logic SYS_CLOCK,
input logic SRST, LOAD, LEFT, RIGHT,
input logic [3:0] DATA,
output logic [3:0] SHIFT_OUT);

always_ff @ (posedge SYS_CLOCK)
begin

	if (SRST)
        SHIFT_OUT <= '0; 
        else if (LOAD)
        SHIFT_OUT <= DATA;
        else if (LEFT && !RIGHT)
        SHIFT_OUT <= SHIFT_OUT << 1;
        else if (!LEFT && RIGHT)
        SHIFT_OUT <= SHIFT_OUT >> 1;

end


endmodule: SHIFTREG_4BIT
