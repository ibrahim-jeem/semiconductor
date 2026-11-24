`timescale 1ns/1ps
module MUX (
    input logic [3:0] ADD, SUB, AND, OR,
    input logic [3:0] SEL
    output logic [3:0] Y);

assign Y = ({4{SEL[3]}} & ADD) |
           ({4{SEL[2]}} & SUB) |
           ({4{SEL[1]}} & AND) | 
           ({4{SEL[0]}} & OR);

endmodule
