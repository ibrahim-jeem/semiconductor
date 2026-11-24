module TB_test;
logic SYS_CLOCK, SRST;
logic [3:0] Ain, Bin;
logic [7:0] Y;

timeunit 1ns;
timeprecision 1ps;

// For observing DUT internal registered inputs
logic [3:0] A, B;

assign A = DUT.A;
assign B = DUT.B;

MAC_16BIT DUT (.SYS_CLOCK(SYS_CLOCK), .SRST(SRST), .Ain(Ain), .Bin(Bin), .Y(Y));

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

time SRST_offset = 2ns;
time SRST_width = 5ns;

initial
begin

SRST = 0;
#SRST_offset SRST = 1;   //#2ns
#SRST_width SRST = 0;    //#5ns

end


/////////////////////////////////////////////////
////Generator Task
////////////////////////////////////////////////// 


task automatic gen_data(int unsigned A_low, A_high, B_low, B_high); 
                         
    logic [3:0] randA, randB;

    @(negedge SYS_CLOCK);
    randA = $urandom_range(A_low, A_high);
    randB = $urandom_range(B_low, B_high);

    //$display(" %0t: Generator Task...\n", $time);
    
    Ain = randA;
    Bin = randB;
    $display("%0t: GENERATOR: Ain=%0d, Bin=%0d\n", $time, Ain, Bin); 
          
endtask : gen_data


/////////////////////////////////////////////////
//Monitor Task
////////////////////////////////////////////////
int EdgeNo = 0;
task automatic monitor(); 
        logic [3:0]  A_sampled, B_sampled;
        logic [7:0] Y_sampled;
 
        // Save old values before active clock edge
        A_sampled = A;
        B_sampled = B;
        Y_sampled = Y;
        
        @(posedge SYS_CLOCK);
	#1ps;

        //Count Active Clock-Edges
        EdgeNo = EdgeNo + 1;
        //$display(" %0t: Monitor Task...\n", $time); 
        $display("MONITOR: Time = %4t,\t+ve EdgeNo= %4d,\tSRST = %0d,\tA_sampled = %6d,\tB_sampled = %6d,\tY_sampled = %10d,\tY = %10d\n",$time, EdgeNo, SRST, A_sampled, B_sampled, Y_sampled, Y);
endtask : monitor


    //////////////////////////////////////////////////
    // Checker Task
    //////////////////////////////////////////////////

    int error = 0;

    task automatic check();

        logic [3:0]  A_old, B_old;
        logic [7:0] Y_old;
        logic [7:0] expected_Y;

        // Save old values before active clock edge
        A_old = A;
        B_old = B;
        Y_old = Y;

        @(posedge SYS_CLOCK);
        #1ps;

        if (SRST)
            expected_Y = 0;
        else
            expected_Y = Y_old + (A_old * B_old);

        if (Y == expected_Y) begin
            $display("CHECKER: OK     Time=%4t, Expected=%0d, Actual=%0d\n",
                     $time, expected_Y, Y);
        end
        else begin
            error = error + 1;
            $display("///////////////////////////////////////////////////////////");
            $error("CHECKER ERROR: Time=%4t, ErrorNo=%0d", $time, error);
            $display("Expected Y=%0d, Actual Y=%0d", expected_Y, Y);
            $display("Old A=%0d, Old B=%0d, Old Y=%0d", A_old, B_old, Y_old);
            $display("Current Ain=%0d, Bin=%0d, A=%0d, B=%0d, Y=%0d",
                     Ain, Bin, A, B, Y);
            $display("///////////////////////////////////////////////////////////");
        end

    endtask : check

    //////////////////////////////////////////////////
    // Main Initial Block
    //////////////////////////////////////////////////

    initial begin

        $timeformat(-9, 0, " ns", 4);

        Ain = 0;
        Bin = 0;

        // Wait until reset has completed
        #20ns;

        repeat (25) begin
            fork
                gen_data(1, 15, 1, 15);
                monitor();
                check();
            join
        end

        #1ns;

        if (error == 0)
            $display("\nTEST PASSED: No errors detected.\n");
        else
            $display("\nTEST FAILED: %0d errors detected.\n", error);

        $finish;

    end

endmodule
