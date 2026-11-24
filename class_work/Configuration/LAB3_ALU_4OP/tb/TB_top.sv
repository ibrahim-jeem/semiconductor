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

    #DATA_PER;

    A           = $urandom_range(0,15);
    B           = $urandom_range(0,15);
    ALU_Control = $urandom_range(0,3);

    $display("Time=%4t\tCTRL=%0d\tA=%2d\tB=%2d\tY=%2d",
              $time, ALU_Control, A, B, Y);

endtask : gen_data


/////////////////////////////////////////////////
// Main Initial Block
/////////////////////////////////////////////////

initial
begin

    A           = 0;
    B           = 0;
    ALU_Control = 0;

    repeat (50)
        gen_data();

    $finish;

end

endmodule
