module TB_top;

logic [3:0] A, B;
logic [1:0] ALU_Control;
logic [3:0] Y;

ALU_4OP DUT
(
    .A(A),
    .B(B),
    .ALU_Control(ALU_Control),
    .Y(Y)
);

/////////////////////////////////////////////////
// Generator Task
/////////////////////////////////////////////////

time DATA_PER = 100ns;

task automatic gen_data();

    $display("%0t: Generator Task...", $time);

    #DATA_PER;

    A           = $urandom_range(0,15);
    B           = $urandom_range(0,15);
    ALU_Control = $urandom_range(0,3);

endtask : gen_data


/////////////////////////////////////////////////
// Monitor Task
/////////////////////////////////////////////////

task automatic monitor();

    @(A, B, ALU_Control);

    $strobe("Time=%4t\tCTRL=%0d\tA=%2d\tB=%2d\tY=%2d",
             $time, ALU_Control, A, B, Y);

endtask : monitor


/////////////////////////////////////////////////
// Checker Task
/////////////////////////////////////////////////

int error = 0;

task automatic check();

    logic [3:0] expected_Y;

    @(A, B, ALU_Control);
    #1;

    case(ALU_Control)
        2'd0: expected_Y = A + B;
        2'd1: expected_Y = A - B;
        2'd2: expected_Y = A & B;
        2'd3: expected_Y = A | B;
        default: expected_Y = 0;
    endcase

    assert (Y == expected_Y)
    begin
        $display("%0t: OUTPUT IS OK", $time);
    end
    else
    begin
        error++;

        $warning("ERROR %0d  Time=%0t CTRL=%0d A=%0d B=%0d Y=%0d Expected=%0d",
                  error, $time, ALU_Control, A, B, Y, expected_Y);
    end

endtask : check


/////////////////////////////////////////////////
// Main initial block
/////////////////////////////////////////////////

initial
begin

    A           = 0;
    B           = 0;
    ALU_Control = 0;

    fork

        begin
            repeat (50)
                gen_data();
        end

        begin
            repeat (50)
                monitor();
        end

        begin
            repeat (50)
                check();
        end

    join

    $display("\nTotal Errors = %0d\n", error);

    $finish;

end

endmodule
