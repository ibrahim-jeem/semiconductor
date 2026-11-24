module Test
    (input logic [3:0] A, B,
    output logic [3:0] SUM, 
    output logic CARRYOUT);

    always_comb
    begin
    {CARRYOUT, SUM} = A + B;

    end
endmodule
