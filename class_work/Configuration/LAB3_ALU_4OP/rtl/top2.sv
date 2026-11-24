//////////////////////////////
// RTL
//////////////////////////////

module ALU_4OP
(
    input  logic [3:0] A, B,
    input  logic [1:0] ALU_Control,
    output logic [3:0] Y
);

always_comb
begin
    case (ALU_Control)
        2'd0:    Y = A + B;
        2'd1:    Y = A - B;
        2'd2:    Y = A & B;
        2'd3:    Y = A | B;
        default: Y = 4'd0;
    endcase
end

endmodule
