`timescale 1ns/1ps

module ALU_16OP
(
    input  logic       SYS_CLOCK,
    input  logic [3:0] Ain,
    input  logic [3:0] Bin,
    input  logic [3:0] ALU_CONTROL,
    output logic [3:0] Y
);

// Internal Signals
logic [3:0] A, B;
logic [3:0] CONTROL;
logic [3:0] ALU_OUT;

/////////////////////////////////////////////////
// Input Registers
/////////////////////////////////////////////////

always_ff @(posedge SYS_CLOCK)
begin
    A <= Ain;
    B <= Bin;
    CONTROL <= ALU_CONTROL;
end

/////////////////////////////////////////////////
// ALU
/////////////////////////////////////////////////

always_comb
begin

    case (CONTROL)

        4'd0 : ALU_OUT = A + B;
        4'd1 : ALU_OUT = A - B;
        4'd2 : ALU_OUT = A & B;
        4'd3 : ALU_OUT = A | B;

        4'd4 : ALU_OUT = ;
        4'd5 : ALU_OUT = ;
        4'd6 : ALU_OUT = 
        4'd7 : ALU_OUT = ;

        4'd8 : ALU_OUT = ;
        4'd9 : ALU_OUT = ;
        4'd10: ALU_OUT = ;
        4'd11: ALU_OUT = ;

        4'd12: ALU_OUT = ;
        4'd13: ALU_OUT = ;
        4'd14: ALU_OUT = ;
        4'd15: ALU_OUT = ;

        default: ALU_OUT = 'x;

    endcase

end

/////////////////////////////////////////////////
// Output Register
/////////////////////////////////////////////////

always_ff @(posedge SYS_CLOCK)
begin
    Y <= ALU_OUT;
end

endmodule
