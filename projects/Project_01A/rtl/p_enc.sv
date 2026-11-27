// Priority Encoder
// Decodes the 4-bit request
// Highest priority: ADD, followed by SUB, AND and OR
// SEL selects the correspnding MUX input
// VALID indicates whether a valid request was received.
//
`timescale 1ns/1ps
module p_enc (
        input logic [3:0] REQUEST,
        output logic [1:0] SEL,
        output logic VALID);

always_comb
begin
    SEL = 2'b00;
    VALID = 1'b0;

//Highest priority: ADD
    if (REQUEST[3] == 1'b1)
    begin
        SEL = 2'b00;
        VALID = 1'b1;
    end
//Second priority: SUB
    else if (REQUEST[2] == 1'b1)
    begin
        SEL = 2'b01;
        VALID = 1'b1;
    end

//Thrid priority: AND
    else if (REQUEST[1] == 1'b1)
    begin
        SEL = 2'b10;
        VALID = 1'b1;
    end

//Lowest priority: OR
    else if (REQUEST == 4'b0001)
    begin
        SEL = 2'b11;
        VALID = 1'b1;
    end
end

endmodule
