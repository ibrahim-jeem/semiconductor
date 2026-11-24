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

module CLA_4BIT
(
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic       CIN,

    output logic [3:0] SUM,
    output logic       COUT
);

logic [3:0] G;
logic [3:0] P;
logic [4:0] C;

assign C[0] = CIN;

//////////////////////////////////////////////////
// Generate / Propagate
//////////////////////////////////////////////////

assign G = A & B;
assign P = A ^ B;

//////////////////////////////////////////////////
// Carry Lookahead Logic
//////////////////////////////////////////////////

assign C[1] = G[0] | (P[0] & C[0]);

assign C[2] =
G[1] |
(P[1] & G[0]) |
(P[1] & P[0] & C[0]);

assign C[3] =
G[2] |
(P[2] & G[1]) |
(P[2] & P[1] & G[0]) |
(P[2] & P[1] & P[0] & C[0]);

assign C[4] =
G[3] |
(P[3] & G[2]) |
(P[3] & P[2] & G[1]) |
(P[3] & P[2] & P[1] & G[0]) |
(P[3] & P[2] & P[1] & P[0] & C[0]);

//////////////////////////////////////////////////
// Sum
//////////////////////////////////////////////////

assign SUM = P ^ C[3:0];

assign COUT = C[4];

endmodule

  
  

  
