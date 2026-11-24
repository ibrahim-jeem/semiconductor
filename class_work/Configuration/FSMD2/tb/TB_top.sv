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
logic [1:0] A, B, C, D;
logic [3:0] F;

//logic [1:0] P_STATE;
typedef enum logic [1:0] {S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11} state_t;

state_t P_STATE;

logic [3:0] R1, R2;

int edge_no = 0;

// Expected result of the PREVIOUS completed transaction


FSMD DUV (.*);


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

//assign P_STATE = TB_top.DUV.F1.P_STATE;
assign P_STATE = state_t'(TB_top.DUV.P_STATE);
assign R1 = TB_top.DUV.R1;
assign R2 = TB_top.DUV.R2;

always @(posedge SYS_CLOCK) begin
    #1ps;
    edge_no++;
    $display("%0t: Monitor Task...\n", $time);
    $display("MONITOR: Time = %0t,\t+ve EdgeNo= %4d,\tP_STATE = %2b,\tA = %2d,\tB = %2d,\tC = %2d,\tD = %2d,\tR1 = %2d,\tR2 = %2d,\tF = %2d",
             $time, edge_no, P_STATE, A, B, C, D, R1, R2, F);
end


/////////////////////////////////////////////////
// Generator
/////////////////////////////////////////////////

task automatic gen_data(int unsigned A_low, A_high, B_low, B_high, C_low, C_high, D_low, D_high); 
                         
    logic [1:0] randA, randB, randC, randD;

    	@(negedge SYS_CLOCK);
    	randA = $urandom_range(A_low, A_high);
	randB = $urandom_range(B_low, B_high);
	randC = $urandom_range(C_low, C_high);
	randD = $urandom_range(D_low, D_high);
    	{A, B, C, D} = {randA, randB, randC, randD};
    	$display(" %0t: Generator (Data) Task...\n", $time);

	repeat (2)
	begin
	@(negedge SYS_CLOCK);
	end
    
endtask : gen_data

task automatic gen_reset(); 
	repeat (12)
	begin
	@(negedge SYS_CLOCK);
	end	

	@(negedge SYS_CLOCK);
	FSM_ARESET = 1;
	@(posedge SYS_CLOCK);
	FSM_ARESET = 0;

endtask


/////////////////////////////////////////////////
// Main Stimulus
/////////////////////////////////////////////////

initial 
begin
    $timeformat(-9, 0, " ns", 4);

	FSM_ARESET = 0; {A, B, C, D} = '0; 
	
	fork
	
	repeat (4)
	begin
	gen_data(1,3, 1,3, 1,3, 1,3);	
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
