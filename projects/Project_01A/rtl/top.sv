//TOP Module
//Connects all the four operation modules
//priority encoder and output multiplexer
//
`timescale 1ns/1ps
module top (
        input logic [3:0] A, B,
        input logic [3:0] REQUEST,
        output logic [3:0] ALU_OUT);

//Internal operation results
logic [3:0] ADD_RESULT;
logic [3:0] SUB_RESULT;
logic [3:0] AND_RESULT;
logic [3:0] OR_RESULT;

//Encoder outputs
logic [1:0] SEL;
logic VALID;

//ADD Module
add U1
    (
        .A(A),
        .B(B),
        .Y(ADD_RESULT)
    );

//SUB Module
sub U2
    (
        .A(A),
        .B(B),
        .Y(SUB_RESULT)
    );

//AND Module
and_op U3
    (
        .A(A),
        .B(B),
        .Y(AND_RESULT)
    );

//OR Module
or_op U4
    (
        .A(A),
        .B(B),
        .Y(OR_RESULT)
    );

//Priority Encoder
p_enc U5
    (
        .REQUEST(REQUEST),
        .SEL(SEL),
        .VALID(VALID)
    );

//OUTPUT Multiplexer
mux_4to1 U6
    (
        .ADD_RESULT(ADD_RESULT),
        .SUB_RESULT(SUB_RESULT),
        .AND_RESULT(AND_RESULT),
        .OR_RESULT(OR_RESULT),
        .SEL(SEL),
        .VALID(VALID),
        .Y(ALU_OUT)
    );
    
    
endmodule
