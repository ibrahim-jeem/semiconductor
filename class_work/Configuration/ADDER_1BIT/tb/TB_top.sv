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

module TB_top;

logic A, B, CARRYIN;
logic SUM, CARRYOUT;

ADDER_1BIT DUT (
    .A(A),
    .B(B),
    .CARRYIN(CARRYIN),
    .SUM(SUM),
    .CARRYOUT(CARRYOUT)
);

/////////////////////////////////////////////////
// Generator Task
/////////////////////////////////////////////////

time DATA_PER = 100ns;

task automatic gen
(
    input logic       cin,
    input logic [1:0] ab
);

    $display("Time=%4t  CIN=%1b  A=%1b  B=%1b",
             $time, cin, ab[1], ab[0]);

    CARRYIN = cin;
    A       = ab[1];
    B       = ab[0];

    #DATA_PER;

endtask : gen

/////////////////////////////////////////////////
// Main Initial Block
/////////////////////////////////////////////////

initial
begin : stimulus

    logic cin;

    // Initialize DUT inputs
    A       = 1'b0;
    B       = 1'b0;
    CARRYIN = 1'b0;

    cin = 1'b0;

    repeat (2)
    begin

        for (int ab = 0; ab < 4; ab++)
        begin
            gen(cin, ab[1:0]);
        end

        cin = ~cin;      // Toggle carry-in after 4 cases

    end

    $finish;

end

endmodule

