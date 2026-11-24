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
"This project uses work from S. M. Rizvi, "1bit Adder", ASIC Design, American International University-Bangladesh, Dhaka, Bangladesh, 2026."
*/
/////////////////////////////////////////////////////////////////////////////////////////

module ADDER_1BIT
(input logic A, B, CARRYIN,
output logic SUM, CARRYOUT);

always_comb
begin
{CARRYOUT, SUM} = A + B + CARRYIN;
end

endmodule
