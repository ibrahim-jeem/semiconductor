//OR Module
//Performs bitwise or
//
`timescale 1ns/1ps
module or_op (
        input logic [3:0] A, B,
        output logic [3:0] Y);

    assign Y = A | B;

endmodule
