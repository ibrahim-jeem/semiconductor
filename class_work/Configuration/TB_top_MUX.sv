//-----------------------------------------------------------------------------
//
// Title       : MUX2BIT_4X1_tb
// Design      : test1
// Author      : USER
// Company     : AIUB
//
//-----------------------------------------------------------------------------
//
// File        : MUX2BIT_4X1_TB.v
// Generated   : Fri Mar  6 20:33:30 2026
// From        : c:\My_Designs\TB_test\test1\src\TestBench\MUX2BIT_4X1_TB_settings.txt
// By          : tb_verilog.pl ver. ver 1.2s
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------

module TB_top;


logic [1:0] A, B, C, D;
logic [1:0] SEL;
logic [1:0] Y;



MUX2BIT_4X1 DUT (.SEL(SEL), .A(A), .B(B), .C(C), .D(D), .Y(Y) );


/////////////////////////////////////////////////
////Generator Task
////////////////////////////////////////////////// 
time DATA_PER = 100ns;

task automatic gen_data(int unsigned A_low, A_high, B_low, B_high, C_low, C_high, D_low, D_high); 
                         
$display(" %0t: Generator (Data) Task...\n", $time);

		#DATA_PER;
		A = $urandom_range(A_low, A_high);
		B = $urandom_range(B_low, B_high);
		C = $urandom_range(C_low, C_high);	
		D = $urandom_range(D_low, D_high);
		
//$display(" %0t: Exiting Generator Task...\n", $time);
endtask : gen_data

/////////////////////////////////////////////////
//Monitor Task
////////////////////////////////////////////////

task automatic monitor(); 
$display(" %0t: Monitor Task...\n", $time);
        @ (SEL, A, B, C, D);
        
        $strobe("Time = %4t,\tSEL = %1d,\tA = %2d,\tB = %2d,\tC = %2d,\tD = %2d, \tY = %2d,\n",$time, SEL, A, B, C, D, Y);
//$display(" %0t: Exiting Monitor Task...\n", $time);
endtask : monitor


/////////////////////////////////////////////////
//Checker Task
////////////////////////////////////////////////

int error = 0;
task automatic check(); 
//$display(" %0t: Checker Task...\n", $time);
        @(SEL, A, B, C, D);
		#0;
                $display(" %0t: Checker Task...\n", $time);                
		
		assert ((SEL ==0 && Y == A) || (SEL ==1 && Y == B) || (SEL ==2 && Y == C) || (SEL ==3 && Y == D))
                begin
                $display("////////////////////////  OUTPUT IS OK  ///////////////////\n");
                //error = error;
                end
                else
                begin
                error = error + 1;
                $display("///////////////////////////////////////////////////////////");
                $warning("ERROR AT TIME = %4t,\tErrorNo = %3d\n",$time, error);
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
        A = 0; B = 0; C = 0; D = 0; SEL = '0;
		
    	for (int i = 0; i < 4; i++) 
		begin
        	SEL = i; 
			$display("\n===== Testing SEL = %0d =====\n", SEL);

			repeat (4)
            begin
			fork	
            gen_data (0,3,0,3,0,3,0,3);					
			monitor();
			check();
            join

            end
		
		end
		
	
	#1;
	$finish;
	end


endmodule
