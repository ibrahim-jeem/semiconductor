module ALU_4OP
(input logic [3:0] A, B,
input logic [1:0] ALU_CONTROL,
output logic [3:0] Y);

always_comb
begin

case (ALU_CONTROL)
2'd0: Y = A + B;
2'd1: Y = A - B; 
2'd2: Y = A & B;
2'd3: Y = A | B;
default: Y = 'x;
endcase

end

endmodule
