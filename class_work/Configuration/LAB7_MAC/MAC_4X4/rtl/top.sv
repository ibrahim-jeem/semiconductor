`timescale 1ns/1ps
module MAC_4X4
(input logic SYS_CLOCK,
input logic SRST,
input logic [3:0] Ain, Bin,
output logic [7:0] Y);

//Internal signals
logic [3:0] A, B;

//Input Registers
always_ff@(posedge SYS_CLOCK)
begin
        A <= Ain;

end

always_ff@(posedge SYS_CLOCK)
begin
        B <= Bin;

end

//Multiply Accumulator (MAC)
always_ff@(posedge SYS_CLOCK)
begin

        if (SRST)
        Y <= 0;
        else
        Y <= Y + (A * B);

end


endmodule
