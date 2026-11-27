// ADD Module
// Performs 4-bit addition.
// output is 4-bit

`timescale 1ns/1ps
module add (
        input  logic [3:0] A, B,
        output logic [3:0] Y);

    assign Y = A + B;

endmodule

