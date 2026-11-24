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
    .SYS_CLOCK(SYS_CLOCK),
    .Ain(Ain),
    .Bin(Bin),
    .ALU_CONTROL(ALU_CONTROL),
    .Y(Y)
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
// Expected ALU Function
/////////////////////////////////////////////////

function automatic logic [3:0] expected_ALU
(
    input logic [3:0] A,
    input logic [3:0] B,
    input logic [3:0] CONTROL
);

begin

case (CONTROL)

4'd0 : expected_ALU = A + B;
4'd1 : expected_ALU = A - B;
4'd2 : expected_ALU = A & B;
4'd3 : expected_ALU = A | B;

4'd4 : expected_ALU = ~(A & B);
4'd5 : expected_ALU = ~(A | B);
4'd6 : expected_ALU = A ^ B;
4'd7 : expected_ALU = ~(A ^ B);

4'd8 : expected_ALU = A + 1;
4'd9 : expected_ALU = A - 1;
4'd10: expected_ALU = B + 1;
4'd11: expected_ALU = B - 1;

4'd12: expected_ALU = A << 1;
4'd13: expected_ALU = A >> 1;
4'd14: expected_ALU = ~A;
4'd15: expected_ALU = ~B;

default:
expected_ALU = 'x;

endcase

end

endfunction

/////////////////////////////////////////////////
// Generator Task
/////////////////////////////////////////////////

task automatic gen_data
(
    int unsigned A_low, A_high,
    int unsigned B_low, B_high,
    int unsigned CTRL_low, CTRL_high
);

logic [3:0] randA;
logic [3:0] randB;
logic [3:0] randCTRL;

@(negedge SYS_CLOCK);

randA    = $urandom_range(A_low,A_high);
randB    = $urandom_range(B_low,B_high);
randCTRL = $urandom_range(CTRL_low,CTRL_high);

$display(" %0t: Generator Task...\n",$time);

Ain         = randA;
Bin         = randB;
ALU_CONTROL = randCTRL;

endtask

/////////////////////////////////////////////////
// Monitor Task
/////////////////////////////////////////////////

int EdgeNo = 0;

task automatic monitor();

    @(posedge SYS_CLOCK);

    EdgeNo = EdgeNo + 1;

    $display(" %0t: Monitor Task...\n",$time);

    $strobe("MONITOR: Time=%4t,\t+ve EdgeNo=%3d,\tAin=%2d,\tBin=%2d,\tCTRL=%2d,\tY=%2d",
            $time,EdgeNo,Ain,Bin,ALU_CONTROL,Y);

endtask

/////////////////////////////////////////////////
// Checker Task
/////////////////////////////////////////////////

int error = 0;

task automatic check();

logic [3:0] A_old;
logic [3:0] B_old;
logic [3:0] CTRL_old;
logic [3:0] Y_expected;

A_old    = Ain;
B_old    = Bin;
CTRL_old = ALU_CONTROL;

@(posedge SYS_CLOCK);
@(posedge SYS_CLOCK);
#1ps;

Y_expected = expected_ALU(A_old,B_old,CTRL_old);

$display(" %0t: Checker Task...\n",$time);

assert (Y == Y_expected)

$display("CHECKER:=============== OUTPUT IS OK ================\n");

else
begin

error = error + 1;

$display("///////////////////////////////////////////////////////////");

$error("CHECKER: ERROR AT TIME = %4t,\tErrorNo = %3d\n",$time,error);

$display("CHECKER: Time=%4t,\tA=%2d,\tB=%2d,\tCTRL=%2d,\tExpected=%2d,\tActual=%2d",
          $time,A_old,B_old,CTRL_old,Y_expected,Y);

$display("///////////////////////////////////////////////////////////");

end

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

$strobe("MONITOR: Time=%4t,\t+ve EdgeNo=%3d,\tAin=%2d,\tBin=%2d,\tCTRL=%2d,\tY=%2d",
         $time,EdgeNo,Ain,Bin,ALU_CONTROL,Y);

repeat (20)
begin

    gen_data(0,15,0,15,0,15);

    fork
        monitor();
        check();
    join

end

#1;

if(error==0)
$display("\nTEST PASSED: No errors detected.\n");

else
$display("\nTEST FAILED: %0d errors detected.\n",error);

$finish;

end

endmodule
