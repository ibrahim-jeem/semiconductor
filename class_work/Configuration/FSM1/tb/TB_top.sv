/////////////////////////////////////////////////////////////////////////////////////////
/*
The following SystemVerilog RTL/testbench was developed by Dr. Shahriyar Masud Rizvi. 

    © 2026 Shahriyar Masud Rizvi

Attribution Requirement:
If you use the following SystemVerilog sources, in whole or in part,
you MUST include visible credit to the original authors in:
  - Documentation or README of your project, OR
  - About/Info section of your tool, OR
  - Academic citation/reference if used in research

Citation Example:
"This project uses work from S. M. Rizvi, RTL Design, Verification, Synthesis & PnR for Digital VLSI Design, American International University-Bangladesh, Dhaka, Bangladesh, 2026."
*/
/////////////////////////////////////////////////////////////////////////////////////////

module TB_top;

timeunit 1ns;
timeprecision 1ps;

logic       SYS_CLOCK; 
logic	    FSM_ARESET; 
logic       GO;	
logic       STOP;

//logic [1:0] P_STATE;
typedef enum logic [1:0] {S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11} state_t;

state_t P_STATE;

logic       READY;
logic       RED;
logic       GREEN;
logic       YELLOW;

logic SCLR, INC, COUNT_LT_2; 
logic [1:0] COUNT;


//localparam logic [1:0] S0 = 2'b00;
//localparam logic [1:0] S1 = 2'b01;
//localparam logic [1:0] S2 = 2'b10;
//localparam logic [1:0] S3 = 2'b11;
//int error = 0;
int edge_no = 0;

// Expected result of the PREVIOUS completed transaction


top DUV (.*);


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
// Monitor
/////////////////////////////////////////////////

assign P_STATE = TB_top.DUV.F1.P_STATE;
assign SCLR = TB_top.DUV.SCLR;
assign INC = TB_top.DUV.INC;
assign COUNT_LT_2 = TB_top.DUV.COUNT_LT_2;	
assign COUNT = TB_top.DUV.D1.COUNT;

always @(posedge SYS_CLOCK) begin
    #1ps;
    edge_no++;
    $display("%0t: Monitor Task...\n", $time);
    $display("MONITOR: Time = %0t,\t+ve EdgeNo= %4d,\tP_STATE = %2b,\tGO = %0b,\tSTOP = %0b,\tREADY = %0b,\tRED = %0b,\tGREEN = %0b,\tYELLOW = %0b,\tSCLR = %0b,\tINC = %0b,\tCOUNT_LT_2 = %0b,\tCOUNT = %2d",
             $time, edge_no, P_STATE, GO, STOP, READY, RED, GREEN, YELLOW, SCLR, INC, COUNT_LT_2, COUNT);
end


/////////////////////////////////////////////////
// Generator
/////////////////////////////////////////////////

task automatic gen_GO(); 
	wait (READY);
	@(negedge SYS_CLOCK);
	@(negedge SYS_CLOCK);
	GO = 1;
	@(negedge SYS_CLOCK);
	GO  = 0;
endtask	

//logic GO1, GO2, GO3;
//
//task automatic gen_GO1(); 
//	wait (READY);
//	@(negedge SYS_CLOCK);
//	@(negedge SYS_CLOCK);
//	GO1 = 1;
//	@(negedge SYS_CLOCK);
//	GO1  = 0;
//endtask	  
//
//task automatic gen_GO2(); 
//	wait (RED);
//	@(negedge SYS_CLOCK);
//	@(negedge SYS_CLOCK);
//	GO2 = 1;
//	@(negedge SYS_CLOCK);
//	GO2  = 0;
//endtask	  
//
//task automatic gen_GO3(); 
//	wait (GREEN);
//	@(negedge SYS_CLOCK);
//	@(negedge SYS_CLOCK);
//	GO3 = 1;
//	@(negedge SYS_CLOCK);
//	GO3  = 0;
//endtask	 

//assign GO = GO1 | GO2 | GO3;

task automatic gen_STOP(); 
	wait (YELLOW);
	@(negedge SYS_CLOCK);
	STOP = ~STOP;
endtask	 

task automatic gen_reset(); 
	repeat (3)
	begin
	wait (READY);
	@(negedge SYS_CLOCK);
	@(negedge SYS_CLOCK); 
	@(negedge SYS_CLOCK);
	end
	
	wait (RED);
	@(negedge SYS_CLOCK);
	FSM_ARESET = 1;
	@(posedge SYS_CLOCK);
	FSM_ARESET = 0;

endtask



/////////////////////////////////////////////////
// Assertions
/////////////////////////////////////////////////

default clocking cb @(posedge SYS_CLOCK); endclocking

//------------------------------
// 1. Reset behavior
//------------------------------
// Async reset must take effect immediately
assert property (@(posedge FSM_ARESET)
                 1 |=> (P_STATE == S0))
    else $error("Async reset failed");

// While reset is high, state must stay S0
assert property (@(posedge SYS_CLOCK)
                 FSM_ARESET |-> (P_STATE == S0))
    else $error("State not held in S0 during reset");

//------------------------------
// 2. State validity
//------------------------------
/////////////////////////////////////////////////
// Enable assertion checking only after the
// first +ve edge of SYS_CLOCK has occurred
// and settled.
//
// This avoids checking P_STATE at startup,
// when it may still be X before the FSM has
// completed its first clocked update.
/////////////////////////////////////////////////

logic checks_enable;

initial begin
    checks_enable = 0;
    @(posedge SYS_CLOCK);   // wait for first +ve edge
    #1ps;                   // let the edge settle / NBA updates complete
    checks_enable = 1;      // start checking from later cycles
end

/////////////////////////////////////////////////
// State validity assertions
/////////////////////////////////////////////////

// Check that P_STATE is not X/Z.
// Disabled during async reset and before
// the first +ve clock edge has settled.
property p_no_x;
    disable iff (FSM_ARESET || !checks_enable)
    !$isunknown(P_STATE);
endproperty

// Check that P_STATE is one of the legal FSM states.
// Kept separate from p_no_x so unknown state and
// illegal known state can be distinguished clearly.
property p_legal_state;
    disable iff (FSM_ARESET || !checks_enable)
    (P_STATE inside {S0, S1, S2, S3});
endproperty

assert property (p_no_x)
    else $error("%0t: X/Z detected in P_STATE = %b", $time, P_STATE);

assert property (p_legal_state)
    else $error("%0t: Illegal state detected in P_STATE = %b", $time, P_STATE);

//------------------------------
// 3. State transition checks
//------------------------------
property p_s0_stay;
    disable iff (FSM_ARESET)
    (P_STATE == S0 && !GO) |=> (P_STATE == S0);
endproperty

assert property (p_s0_stay)
    else $error("ASSERTION FAILED: S0 with GO=0 should remain in S0.");

property p_s0_to_s1;
    disable iff (FSM_ARESET)
    (P_STATE == S0 && GO) |=> (P_STATE == S1);
endproperty

assert property (p_s0_to_s1)
    else $error("ASSERTION FAILED: S0 with GO=1 should go to S1.");

property p_s1_hold;
    disable iff (FSM_ARESET)
    (P_STATE == S1 && COUNT_LT_2) |=> (P_STATE == S1);
endproperty

assert property (p_s1_hold)
    else $error("ASSERTION FAILED: S1 with COUNT_LT_2=1 should remain in S1.");

property p_s1_to_s2;
    disable iff (FSM_ARESET)
    (P_STATE == S1 && !COUNT_LT_2) |=> (P_STATE == S2);
endproperty

assert property (p_s1_to_s2)
    else $error("ASSERTION FAILED: S1 with COUNT_LT_2=0 should go to S2.");

property p_s2_hold;
    disable iff (FSM_ARESET)
    (P_STATE == S2 && COUNT_LT_2) |=> (P_STATE == S2);
endproperty

assert property (p_s2_hold)
    else $error("ASSERTION FAILED: S2 with COUNT_LT_2=1 should remain in S2.");

property p_s2_to_s3;
    disable iff (FSM_ARESET)
    (P_STATE == S2 && !COUNT_LT_2) |=> (P_STATE == S3);
endproperty

assert property (p_s2_to_s3)
    else $error("ASSERTION FAILED: S2 with COUNT_LT_2=0 should go to S3.");

property p_s3_to_s1;
    disable iff (FSM_ARESET)
    (P_STATE == S3 && !STOP) |=> (P_STATE == S1);
endproperty

assert property (p_s3_to_s1)
    else $error("ASSERTION FAILED: S3 with STOP=0 should go to S1.");

property p_s3_to_s0;
    disable iff (FSM_ARESET)
    (P_STATE == S3 && STOP) |=> (P_STATE == S0);
endproperty

assert property (p_s3_to_s0)
    else $error("ASSERTION FAILED: S3 with STOP=1 should go to S0.");

//------------------------------
// 4. Output checks by state
//------------------------------
property p_s0_outputs;
    disable iff (FSM_ARESET)
    (P_STATE == S0) |-> (READY && SCLR && !RED && !GREEN && !YELLOW && !INC);
endproperty

assert property (p_s0_outputs)
    else $error("ASSERTION FAILED: Incorrect outputs in S0.");

property p_s1_outputs;
    disable iff (FSM_ARESET)
    (P_STATE == S1) |-> (RED && INC && !READY && !GREEN && !YELLOW);
endproperty

assert property (p_s1_outputs)
    else $error("ASSERTION FAILED: Incorrect outputs in S1.");

property p_s2_outputs;
    disable iff (FSM_ARESET)
    (P_STATE == S2) |-> (GREEN && INC && !READY && !RED && !YELLOW && !SCLR);
endproperty

assert property (p_s2_outputs)
    else $error("ASSERTION FAILED: Incorrect outputs in S2.");

property p_s3_outputs;
    disable iff (FSM_ARESET)
    (P_STATE == S3) |-> (YELLOW && SCLR && !READY && !RED && !GREEN && !INC);
endproperty

assert property (p_s3_outputs)
    else $error("ASSERTION FAILED: Incorrect outputs in S3.");

//------------------------------
// 5. Only one light active at a time
// READY is not included here because it is not a light
//------------------------------
property p_onehot_lights;
    $onehot0({RED, GREEN, YELLOW});
endproperty

assert property (p_onehot_lights)
    else $error("ASSERTION FAILED: More than one light is active at the same time.");

//------------------------------
// 6. READY should only be high in S0
//------------------------------
property p_ready_only_in_s0;
    READY |-> (P_STATE == S0);
endproperty

assert property (p_ready_only_in_s0)
    else $error("ASSERTION FAILED: READY high outside S0.");

//------------------------------
// 7. INC should only be high in S1 or S2
//------------------------------
property p_inc_only_in_s1_s2;
    INC |-> (P_STATE inside {S1, S2});
endproperty

assert property (p_inc_only_in_s1_s2)
    else $error("ASSERTION FAILED: INC high outside S1/S2.");

//------------------------------
// 8. SCLR should only be high in S0, S3,
// or at end of S1 when COUNT_LT_2 = 0
//------------------------------
property p_sclr_usage;
    SCLR |-> ((P_STATE == S0) ||
              (P_STATE == S3) ||
              (P_STATE == S1 && !COUNT_LT_2));
endproperty

assert property (p_sclr_usage)
    else $error("ASSERTION FAILED: SCLR asserted in unexpected condition.");

/////////////////////////////////////////////////
// Optional Coverage
/////////////////////////////////////////////////

cover property (@(posedge SYS_CLOCK)
    (P_STATE == S0)[*1:$] ##1
    (P_STATE == S1)[*3]   ##1
    (P_STATE == S2)[*3]   ##1
    (P_STATE == S3)       ##1
    ((P_STATE == S1) || (P_STATE == S0))
);


/////////////////////////////////////////////////
// Main Stimulus
/////////////////////////////////////////////////

initial 
begin
    $timeformat(-9, 0, " ns", 4);

    GO = 0;	
	//{GO1, GO2, GO3} = '0;
	STOP = 1; FSM_ARESET = 0; 
	
	fork
	
	repeat (4)
	begin
	gen_GO();	
	end	   

//	repeat (4)
//	begin
//	fork
//	gen_GO1();	
//	gen_GO2();	
//	gen_GO3();	
//	join
//	end
	
	repeat (4)
	begin
	gen_STOP();		
	end	 	   
	
	gen_reset();
	
	join	
//    if (error == 0)
//        $display("\nTEST PASSED: No errors detected.\n");
//    else
//        $display("\nTEST FAILED: %0d errors detected.\n", error);

    $finish;
end
endmodule
