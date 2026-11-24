module TB_test;

logic SYS_CLOCK;
logic [3:0] Ain, Bin;
logic [3:0] ALU_CONTROL;
logic [3:0] Y;

timeunit 1ns;
timeprecision 1ps;

/////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////

ALU_16OP DUT
(
    .SYS_CLOCK   (SYS_CLOCK),
    .Ain         (Ain),
    .Bin         (Bin),
    .ALU_CONTROL (ALU_CONTROL),
    .Y           (Y)
);

/////////////////////////////////////////////////
// Clock Generator
/////////////////////////////////////////////////

time CLK_PERIOD = 10ns;

initial
begin

    SYS_CLOCK = 0;

    forever
    begin
        #(CLK_PERIOD/2);
        SYS_CLOCK = ~SYS_CLOCK;
    end

end

/////////////////////////////////////////////////
// Generator Task
/////////////////////////////////////////////////

task automatic gen_data
(
    int unsigned A_low,    A_high,
    int unsigned B_low,    B_high,
    int unsigned CTRL_low, CTRL_high
);

logic [3:0] randA;
logic [3:0] randB;
logic [3:0] randCTRL;

@(negedge SYS_CLOCK);

randA    = $urandom_range(A_low,    A_high);
randB    = $urandom_range(B_low,    B_high);
randCTRL = $urandom_range(CTRL_low, CTRL_high);

Ain         = randA;
Bin         = randB;
ALU_CONTROL = randCTRL;

$display("Time=%4t  Ain=%2d  Bin=%2d  CTRL=%2d",
         $time, Ain, Bin, ALU_CONTROL);

endtask

/////////////////////////////////////////////////
// Main Test
/////////////////////////////////////////////////

initial
begin

    $timeformat(-9,0," ns",4);

    Ain = 0;
    Bin = 0;
    ALU_CONTROL = 0;

    // Wait one clock before starting
    @(posedge SYS_CLOCK);

    repeat (20)
    begin

        gen_data(0,15,0,15,0,15);

    end

    // Allow pipeline to flush
    repeat (3)
        @(posedge SYS_CLOCK);

    $display("\nSimulation Finished.\n");

    $finish;

end

endmodule
