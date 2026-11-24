`timescale 1ns/1ps
module ALU (
    input logic [3:0] A, B,
    input logic [3:0] REQUEST,
    output logic [3:0] ALU);

    logic [3:0] ADD, SUB, AND, OR;
    logic [3:0] SEL;

    ADD U1 (A, B, ADD);
    SUB U2 (A, B, SUB);
    AND U3 (A, B, AND);
    OR U4 (A, B, OR);
    P_ENC U5 (REQUEST, SEL);
    MUX U6 (ADD, SUB, AND, OR, SEL, TOP);

endmodule
