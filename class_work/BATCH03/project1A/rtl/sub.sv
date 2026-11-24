`timescale 1ns/1ps
module SUB (
    input logic [3:0] A, B,
    output logic [3:0] Y);

    assign Y = A - B;

endmodule

