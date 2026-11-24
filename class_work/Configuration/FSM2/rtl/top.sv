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

module top
(
    input  logic       SYS_CLOCK, 
    input  logic       FSM_ARESET, 
    input  logic [1:0] A, B, C, D,
    output logic [3:0] F
);


logic [1:0] SEL1, SEL2;
logic ALU_CONTROL;
logic LDR1, LDR2, LDF;

	FSM F1 (.*);
	Datapath D1 (.*);
	
endmodule : top



