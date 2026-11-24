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
	input  logic       SYS_CLOCK, 
    input  logic       SCLR,
    input  logic       INC,
	output logic	   COUNT_LT_2	
);


logic [1:0] COUNT;

//Counter
always_ff @ (posedge SYS_CLOCK)
begin : Counter
	
	if (SCLR)
		COUNT <= 0;
	else if (INC)  		
		COUNT <= COUNT + 1;	

end : Counter	

//Comparator
always_comb
begin : Comparator 
	
	if (COUNT < 2)
		COUNT_LT_2 = 1;
	else
		COUNT_LT_2 = 0;	
	
end : Comparator
	
endmodule : Datapath



