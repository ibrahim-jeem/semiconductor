// 4-to-1 Multiplexer
// Selects one operation result using SEL
// IF VALID is zero, the output remais zero

`timescale 1ns/1ps
module mux_4to1 (
        input logic [3:0] ADD_RESULT, SUB_RESULT, AND_RESULT, OR_RESULT,
        input logic [1:0] SEL,
        input logic VALID,
        output logic [3:0] Y);
always_comb
begin
    Y = 4'b0000;

    if (VALID)
    begin
        case (SEL)
            2'd0: Y = ADD_RESULT;
            2'd1: Y = SUB_RESULT;
            2'd2: Y = AND_RESULT;
            2'd3: Y = OR_RESULT;

            default: Y = 4'b0000;
        endcase
    end
end

endmodule
