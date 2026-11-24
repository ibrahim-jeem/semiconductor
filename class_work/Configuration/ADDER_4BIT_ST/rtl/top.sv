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
"This project uses work from S. M. Rizvi, "4bit Adder", RTL Design, Verification, Synthesis & PnR for Digital VLSI Design, American International University-Bangladesh, Dhaka, Bangladesh, 2026."
*/
/////////////////////////////////////////////////////////////////////////////////////////

module ADDER_4BIT_ST
(input logic [3:0] A, B,
output logic [3:0] SUM,
output logic CARRYOUT);

logic [4:0] C;

FULLADDER F0 (.CIN(C[0]), .X(A[0]), .Y(B[0]), .S(SUM[0]), .COUT(C[1]) );
FULLADDER F1 (.CIN(C[1]), .X(A[1]), .Y(B[1]), .S(SUM[1]), .COUT(C[2]) );
FULLADDER F2 (.CIN(C[2]), .X(A[2]), .Y(B[2]), .S(SUM[2]), .COUT(C[3]) );
FULLADDER F3 (.CIN(C[3]), .X(A[3]), .Y(B[3]), .S(SUM[3]), .COUT(C[4]) );

assign C[0] = 0;
assign CARRYOUT = C[4];




























endmodule

  
  

  
