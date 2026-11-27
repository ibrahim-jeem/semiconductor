//Subtraction Module
//Performs  4-bit substractions

`timescale 1ns/1ps
module sub (
        input logic [3:0] A, B,
        output logic [3:0] Y);

    assign Y = A - B;

endmodule

