`timescale 1ns/1ps
module ADD (
        input  logic [3:0] A, B,
        output logic [4:0] Y,
);

        assign Y = A + B;

endmodule

