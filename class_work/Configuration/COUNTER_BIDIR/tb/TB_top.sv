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

module TB_test;
logic SYS_CLOCK; 
logic SRST, LOAD, UP, DOWN;
logic [3:0] DATA;
logic [3:0] COUNT;

timeunit 1ns;
timeprecision 1ps;

COUNTER_4BIT DUT (.SYS_CLOCK(SYS_CLOCK), .SRST(SRST), .LOAD(LOAD), .UP(UP), .DOWN(DOWN), .DATA(DATA), .COUNT(COUNT));

/////////////////////////////////////////////////
//Generator
////////////////////////////////////////////////


///////////CLOCK GENERATOR////////////

time CLK_PERIOD = 10ns;

initial
begin

SYS_CLOCK = 0;

        forever
        begin
        #(CLK_PERIOD/2);
        SYS_CLOCK = ~ SYS_CLOCK;
        end
end


///////////RESET GENERATOR/////////////

logic [3:0] CONTROL;

/*
int i = 0;
task automatic gen_control();                    
    
    @(negedge SYS_CLOCK);
    if (i == 4)
        begin
        CONTROL = 4'b0011;
        $display(" %0t: Generator (Control) Task...\n", $time);
        i = 0;
        end 
    else
    	begin
    	CONTROL[i] = i; 
    	$display(" %0t: Generator (Control) Task...\n", $time);
    	i = i+ 1;
    end
    @(negedge SYS_CLOCK);
    @(negedge SYS_CLOCK);
    @(negedge SYS_CLOCK);       
       
endtask : gen_control
*/

task automatic gen_control();                         
    
    @(negedge SYS_CLOCK);
    CONTROL = CONTROL + 1; 
    $display(" %0t: Generator (Control) Task...\n", $time);
    @(negedge SYS_CLOCK);
    @(negedge SYS_CLOCK);
    @(negedge SYS_CLOCK);
       
endtask : gen_control

/////////////////////////////////////////////////
////Generator Task
////////////////////////////////////////////////// 

task automatic gen_data(int unsigned D_low, D_high); 
                         
    logic [3:0] randD;

    @(negedge SYS_CLOCK);
    randD = $urandom_range(D_low, D_high);
    DATA = randD;
    $display(" %0t: Generator (Data) Task...\n", $time);
    
endtask : gen_data

/////////////////////////////////////////////////
//Monitor Task
////////////////////////////////////////////////
int EdgeNo = 0;
task automatic monitor(); 
        
        @(posedge SYS_CLOCK);
        EdgeNo = EdgeNo + 1;
        $display(" %0t: Monitor Task...\n", $time); 
        $strobe("MONITOR: Time = %4t,\t+ve EdgeNo= %4d,\tSRST = %0d,\tLOAD = %0d,\tUP = %0d,\tDOWN = %0d,\tDATA = %2d,\tCOUNT = %2d",$time, EdgeNo, SRST, LOAD, UP, DOWN, DATA, COUNT);
endtask : monitor


/////////////////////////////////////////////////
//Checker Task
////////////////////////////////////////////////
int error = 0;
task automatic report_error(string msg);
    error = error + 1;

    $display("///////////////////////////////////////////////////////////");
    $error("CHECKER ERROR (%s) AT TIME = %4t,\tErrorNo = %3d\n", msg, $time, error);

    $display("CHECKER: Time = %4t,\t+ve EdgeNo= %4d,\tSRST = %0d,\tLOAD = %0d,\tUP = %0d,\tDOWN = %0d,\tDATA = %2d,\tCOUNT = %2d",
              $time, EdgeNo, SRST, LOAD, UP, DOWN, DATA, COUNT);

    $display("///////////////////////////////////////////////////////////");
endtask

logic [3:0] COUNT_old = 0;
task automatic check(); 
                COUNT_old = COUNT;
                
                @(posedge SYS_CLOCK);
		#1ps;
                $display(" %0t: Checker Task...\n", $time);                
		
		if (SRST) 
    			assert (COUNT == 0)
        		$display("CHECKER:===============  OUTPUT IS OK  ================\n");
    			else
        		report_error("SRST condition failed");
		        
		else if (LOAD) 
		        assert (COUNT == DATA) 
        		$display("CHECKER:===============  OUTPUT IS OK  ================\n");
    			else
        		report_error("LOAD condition failed");

		else if (UP && !DOWN) 
		        assert (COUNT == (COUNT_old + 4'd1) ) 
        		$display("CHECKER:===============  OUTPUT IS OK  ================\n");
    			else
        		report_error("UPCOUNT condition failed");

		else if (!UP && DOWN) 
		        assert (COUNT == (COUNT_old - 4'd1) ) 
        		$display("CHECKER:===============  OUTPUT IS OK  ================\n");
    			else
        		report_error("DOWNCOUNT condition failed");

                else
		        assert (COUNT == COUNT_old)
        		$display("CHECKER:===============  OUTPUT IS OK  ================\n");
    			else
        		report_error("Hold condition failed");

endtask : check

/////////////////////////////////////////////////
//Main initial block
////////////////////////////////////////////////
	initial
	begin
	
    	assign {SRST, DOWN, UP, LOAD} = CONTROL;
	$timeformat (-9, 0, " ns", 4); 	
        DATA = 1; CONTROL = 1; 
        $strobe("MONITOR: Time = %4t,\t+ve EdgeNo= %4d,\tSRST = %0d,\tLOAD = %0d,\tUP = %0d,\tDOWN = %0d,\tDATA = %2d,\tCOUNT = %2d",$time, EdgeNo, SRST, LOAD, UP, DOWN, DATA, COUNT);
		
		fork
                repeat (64)
            	begin
		fork       	
            	gen_data (0,3);					
		monitor();
		check();
            	join
            	end

                repeat (16)
                begin
                gen_control();
                end
                join
	
	#1;
	if (error == 0)
    	$display("\nTEST PASSED: No errors detected.\n");
	else
    	$display("\nTEST FAILED: %0d errors detected.\n", error);
	$finish;
	end

endmodule
