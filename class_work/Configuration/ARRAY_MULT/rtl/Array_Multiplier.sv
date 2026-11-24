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

module ARRAY_MULTIPLIER_4X4
(
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [7:0] PRODUCT
);

logic [7:0] PP0;
logic [7:0] PP1;
logic [7:0] PP2;
logic [7:0] PP3;

logic [7:0] SUM1;
logic [7:0] SUM2;

logic COUT1;
logic COUT2;
logic COUT3;

/////////////////////////////////////////////////
// Partial-product generation
/////////////////////////////////////////////////

assign PP0 = {4'b0000, (A & {4{B[0]}})};
assign PP1 = {3'b000,  (A & {4{B[1]}}), 1'b0};
assign PP2 = {2'b00,   (A & {4{B[2]}}), 2'b00};
assign PP3 = {1'b0,    (A & {4{B[3]}}), 3'b000};

/////////////////////////////////////////////////
// Partial-product accumulation
/////////////////////////////////////////////////

RCA_8BIT RCA_STAGE1
(
    .A    (PP0),
    .B    (PP1),
    .CIN  (1'b0),
    .SUM  (SUM1),
    .COUT (COUT1)
);

RCA_8BIT RCA_STAGE2
(
    .A    (SUM1),
    .B    (PP2),
    .CIN  (1'b0),
    .SUM  (SUM2),
    .COUT (COUT2)
);

RCA_8BIT RCA_STAGE3
(
    .A    (SUM2),
    .B    (PP3),
    .CIN  (1'b0),
    .SUM  (PRODUCT),
    .COUT (COUT3)
);

endmodule

  
  

  
