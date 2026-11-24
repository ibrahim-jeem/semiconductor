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
logic [3:0] D;
logic [3:0] Q;

timeunit 1ns;
timeprecision 1ps;

DREG DUV (.SYS_CLOCK(SYS_CLOCK), .D(D), .Q(Q));

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

/*
event clock_event;
initial
begin
	forever
	begin
	@(posedge SYS_CLOCK);
	->>clock_event;
	end
end
*/

/////////////////////////////////////////////////
////Generator Task
////////////////////////////////////////////////// 

task automatic gen_data(int unsigned D_low, D_high); 
                         
    logic [3:0] randD;

    @(negedge SYS_CLOCK);
    randD = $urandom_range(D_low, D_high);
    
    $display(" %0t: Generator Task...\n", $time);
    D = randD;
    @(negedge SYS_CLOCK);
   
endtask : gen_data


/////////////////////////////////////////////////
//Monitor Task
////////////////////////////////////////////////
int EdgeNo = 0;
task automatic monitor(); 
        
        @(posedge SYS_CLOCK);
        //@(clock_event);
        EdgeNo = EdgeNo + 1;
        $display(" %0t: Monitor Task...\n", $time); 
        $strobe("MONITOR: Time = %4t,\t+ve EdgeNo = %4d,\tD = %4d,\tQ = %4d",$time, EdgeNo, D, Q);
endtask : monitor


/////////////////////////////////////////////////
//Checker Task
////////////////////////////////////////////////

int error = 0;
task automatic report_error(string msg);
    error = error + 1;

    $display("///////////////////////////////////////////////////////////");
    $error("CHECKER: ERROR (%s) AT TIME = %4t,\tErrorNo = %3d\n", msg, $time, error);

    $display("CHECKER: Time = %4t,\t+ve EdgeNo = %4d,\tD = %4d,\tQ = %4d",$time, EdgeNo, D, Q);
    $display("///////////////////////////////////////////////////////////");
endtask

task automatic check(); 
                
                @(posedge SYS_CLOCK);
		#1ps;
                //@(clock_event);
                //#1ps;
                $display(" %0t: Checker Task...\n", $time);                
		
		        assert (Q == D )		        
                        $display("CHECKER:===============  OUTPUT IS OK  ================\n");
                        else
                        report_error("LOAD condition failed");

endtask : check

/////////////////////////////////////////////////
//Main initial block
////////////////////////////////////////////////
	initial
	begin
	
	$timeformat (-9, 0, " ns", 4); 	
        D = 0; 	
        $strobe("MONITOR: Time = %4t,\t+ve EdgeNo = %4d,\tD = %4d,\tQ = %4d",$time, EdgeNo, D, Q);

                fork
		
		repeat (16)
            	begin
		//fork                	
            	gen_data (0,15);					
		//monitor();
		//check();
            	//join
            	end
                
		repeat(32)
                begin
		fork
		monitor();
		check();
                join
                end

		join
	
	#1;
	if (error == 0)
		begin
	 	$display("\n//////////////////////////////////////////////////////////////\n");
	    	$display("===============TEST PASSED: No errors detected.===============\n");
		$display("//////////////////////////////////////////////////////////////\n");
		end
	else
		begin
		$display("\n//////////////////////////////////////////////////////////////\n");
	    	$display("===============TEST FAILED: %0d errors detected.===============\n", error);
		$display("//////////////////////////////////////////////////////////////\n");
		end

	$finish;
	end

endmodule
