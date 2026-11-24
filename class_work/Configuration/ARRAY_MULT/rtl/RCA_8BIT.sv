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

module RIPPLE_CARRY_ADDER
(input logic [7:0] A, B,
output logic [7:0] SUM,
output logic CARRYOUT);

logic [8:0] C;

FULLADDER F0 (.CIN(C[0]), .X(A[0]), .Y(B[0]), .S(SUM[0]), .COUT(C[1]) );
FULLADDER F1 (.CIN(C[1]), .X(A[1]), .Y(B[1]), .S(SUM[1]), .COUT(C[2]) );
FULLADDER F2 (.CIN(C[2]), .X(A[2]), .Y(B[2]), .S(SUM[2]), .COUT(C[3]) );
FULLADDER F3 (.CIN(C[3]), .X(A[3]), .Y(B[3]), .S(SUM[3]), .COUT(C[4]) );
FULLADDER F4 (.CIN(C[4]), .X(A[4]), .Y(B[4]), .S(SUM[3]), .COUT(C[5]) );
FULLADDER F5 (.CIN(C[5]), .X(A[5]), .Y(B[5]), .S(SUM[3]), .COUT(C[6]) );
FULLADDER F6 (.CIN(C[6]), .X(A[6]), .Y(B[6]), .S(SUM[3]), .COUT(C[7]) );
FULLADDER F7 (.CIN(C[7]), .X(A[7]), .Y(B[7]), .S(SUM[3]), .COUT(C[8]) );

assign C[0] = 0;
assign CARRYOUT = C[8];

endmodule

  
  

  
