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

module Datapath
(
    input  logic SYS_CLOCK, 
    input  logic [1:0] A, B, C, D,
    input logic [1:0] SEL1, SEL2,
    input logic ALU_CONTROL,
    input logic LDR1, LDR2, LDF,
    output logic [3:0] F	
);


logic [3:0] R1, R2, R1_IN, R2_IN;
logic [3:0] MUX1_OUT, MUX2_OUT, AIN1, AIN2, ALU_OUT;

//ALU
always_comb
begin : ALU
	
	case (ALU_CONTROL)
	0: ALU_OUT = AIN1 + AIN2;
	1: ALU_OUT = AIN1 - AIN2;
	default: ALU_OUT = 0;
	endcase
	
end : ALU

assign R1_IN = ALU_OUT;
assign R2_IN = ALU_OUT;


//MUX1
always_comb
begin : MUX1 
	
	case (SEL1)
	0: MUX1_OUT = R1;
	1: MUX1_OUT = {2'b00,A};
	2: MUX1_OUT = {2'b00,C};
	default: MUX1_OUT = 0;
	endcase	
end : MUX1 

assign AIN1 = MUX1_OUT;

//MUX2
always_comb
begin : MUX2
	
	case (SEL2)
	0: MUX2_OUT = {2'b00,B};
	1: MUX2_OUT = {2'b00,D};
	2: MUX2_OUT = R2;
	default: MUX2_OUT = 0;
	endcase	
end : MUX2 

assign AIN2 = MUX2_OUT;


//Register R1
always_ff @ (posedge SYS_CLOCK)
begin : R1_Reg
	
	if (LDR1)
		R1 <= R1_IN;
end : R1_Reg

//Register R2
always_ff @ (posedge SYS_CLOCK)
begin : R2_Reg
	
	if (LDR2)
		R2 <= R2_IN;
end : R2_Reg

//Register F
always_ff @ (posedge SYS_CLOCK)
begin : F_Reg
	
	if (LDF)
		F <= R1;
end : F_Reg	

	
endmodule : Datapath



