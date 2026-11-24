`timescale 1ns/1ps
module COUNTER_4BIT
(
    input  logic       SYS_CLOCK,
    input  logic       SRST,
    input  logic       LOAD,
    input  logic       UP,
    input  logic       DOWN,
    input  logic [3:0] DATA_IN,

    output logic [3:0] COUNT
);

/////////////////////////////////////////////////
// Sequential Counter Logic
//
// Control priority:
// SRST > LOAD > UP > DOWN
/////////////////////////////////////////////////

always_ff @(posedge SYS_CLOCK)
begin
    if (SRST)
        COUNT <= 4'b0000;

    else if (LOAD)
        COUNT <= DATA_IN;

    else if (UP)
        COUNT <= COUNT + 4'b0001;

    else if (DOWN)
        COUNT <= COUNT - 4'b0001;

    else
        COUNT <= COUNT;
end

endmodule
