`timescale 1ns/1ps
module MAC_8BIT
(input logic SYS_CLOCK,
input logic SRST,
input logic [15:0] Ain, Bin,
output logic [31:0] Y);

//Internal signals
logic [7:0] A, B;

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
