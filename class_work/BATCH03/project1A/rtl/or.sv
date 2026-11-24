`timescale 1ns/1ps
module OR (
    input module [3:0} A, B,
    output module [3:0] Y);

        assign Y = A | B;

endmodule
