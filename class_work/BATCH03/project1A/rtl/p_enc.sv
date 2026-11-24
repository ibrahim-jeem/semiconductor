`timescale 1ns/ps
module P_ENC (
    input logic [3:0] REQUEST,
    output logic [3:0] SEL);

    assign SEL[3] = REQUEST[3];

    assign SEL[2] = ~REQUEST[3] & REQUEST[2];

    assign SEL[1] = ~REQUEST[3] & ~REQUEST[2] & REQUEST[1];

    assign SEL[0] = ~REQUEST[3] & REQUEST[2] & REQUEST[1] & REQUEST[0];

endmodule

