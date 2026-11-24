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
"This project uses work from S. M. Rizvi, "4bit Adder", RTL Design, Verification, Synthesis & PnR for Digital VLSI Design, American International University-Bangladesh, Dhaka, Bangladesh, 2026."
*/
/////////////////////////////////////////////////////////////////////////////////////////

module TB_top;


logic [3:0] A, B;
logic [3:0] SUM;
logic CARRYOUT;

ADDER_4BIT DUT (.A(A), .B(B), .SUM(SUM), .CARRYOUT(CARRYOUT));


/////////////////////////////////////////////////
////Generator Task
////////////////////////////////////////////////// 
time DATA_PER = 100ns;

task automatic gen(int unsigned A_low, A_high, B_low, B_high); 
                         
		#DATA_PER;	   
		$display(" %0t: Generator Task...\n", $time);
		A = $urandom_range(A_low, A_high);
		B = $urandom_range(B_low, B_high);	
		
//$display(" %0t: Exiting Generator Task...\n", $time);
endtask : gen


/////////////////////////////////////////////////
//Monitor Task
////////////////////////////////////////////////

task automatic monitor(); 

        @ (A, B);
        $display(" %0t: Monitor Task...\n", $time);
        $strobe("MONITOR: Time = %4t,\tA = %2d,\tB = %2d,\tSUM =%2d \tCARRYOUT =%1d\n",$time, A, B, SUM, CARRYOUT);	 
		
//$display(" %0t: Exiting Monitor Task...\n", $time);
endtask : monitor


/////////////////////////////////////////////////
//Checker Task
////////////////////////////////////////////////

int error = 0;
task automatic check(); 

        @(A, B);
		#0;
                $display(" %0t: Checker Task...\n", $time);
                assert ({CARRYOUT, SUM} == (A + B))
                begin
                $display("////////////////////////  CHECKER: OUTPUT IS OK  ///////////////////\n");
                error = error;
                end
                else
                begin
                error = error + 1;
                $display("///////////////////////////////////////////////////////////");
                $error("CHECKER: ERROR AT TIME = %4t,\tErrorNo = %3d\n",$time, error);
                $display("///////////////////////////////////////////////////////////");
                end
//$display(" %0t: Exiting Checker Task...\n", $time);
endtask : check


/////////////////////////////////////////////////
//Main initial block
////////////////////////////////////////////////
	initial
	begin
	
	$timeformat (-9, 0, " ns", 4); 
        A = 0; B = 0;


		
		repeat (10)		
		begin 			
			fork	
            gen (1,15,1,15);
			monitor();
			check();
            join 
		end

	#1;
	$finish;
	end


endmodule
