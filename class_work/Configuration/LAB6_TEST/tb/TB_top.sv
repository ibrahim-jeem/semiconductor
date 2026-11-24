module COUNTER_4BIT_DFT_WRAPPER_TB;

timeunit      1ns;
timeprecision 1ps;

/////////////////////////////////////////////////
// DUT Signals
/////////////////////////////////////////////////

logic       SYS_CLOCK;
logic       SRST;

// Functional inputs
logic       LOAD;
logic       UP;
logic       DOWN;
logic [3:0] DATA_IN;

// DFT inputs
logic       TEST_MODE;
logic       SCAN_ENABLE;
logic       SCAN_CAPTURE;
logic       SCAN_UPDATE;
logic       SCAN_IN;

// Outputs
logic [3:0] COUNT;
logic       SCAN_OUT;

/////////////////////////////////////////////////
// DUT Instantiation
/////////////////////////////////////////////////

COUNTER_4BIT_DFT_WRAPPER DUT
(
    .SYS_CLOCK   (SYS_CLOCK),
    .SRST        (SRST),

    .LOAD        (LOAD),
    .UP          (UP),
    .DOWN        (DOWN),
    .DATA_IN     (DATA_IN),

    .TEST_MODE   (TEST_MODE),
    .SCAN_ENABLE (SCAN_ENABLE),
    .SCAN_CAPTURE(SCAN_CAPTURE),
    .SCAN_UPDATE (SCAN_UPDATE),
    .SCAN_IN     (SCAN_IN),

    .COUNT        (COUNT),
    .SCAN_OUT     (SCAN_OUT)
);

/////////////////////////////////////////////////
// Clock Generator
/////////////////////////////////////////////////

time CLK_PERIOD = 10ns;

initial
begin
    SYS_CLOCK = 1'b0;

    forever
        #(CLK_PERIOD/2) SYS_CLOCK = ~SYS_CLOCK;
end

/////////////////////////////////////////////////
// Error Counter
/////////////////////////////////////////////////

int unsigned error_count = 0;

/////////////////////////////////////////////////
// Functional-Cycle Task
/////////////////////////////////////////////////

task automatic functional_cycle
(
    input logic       srst,
    input logic       load,
    input logic       up,
    input logic       down,
    input logic [3:0] data_in,
    input logic [3:0] expected_count,
    input string      test_name
);

    // Apply inputs away from the active clock edge.
    @(negedge SYS_CLOCK);

    TEST_MODE = 1'b0;

    SRST    = srst;
    LOAD    = load;
    UP      = up;
    DOWN    = down;
    DATA_IN = data_in;

    @(posedge SYS_CLOCK);
    #1ps;

    if (COUNT !== expected_count)
    begin
        $error(
            "%s FAILED: COUNT=%0h, expected=%0h",
            test_name,
            COUNT,
            expected_count
        );

        error_count++;
    end
    else
    begin
        $display(
            "%0t: %s PASSED: COUNT=%0h",
            $time,
            test_name,
            COUNT
        );
    end

endtask : functional_cycle

/////////////////////////////////////////////////
// Shift Data into Scan Register
//
// Wrapper shifting:
//
// SCAN_IN -> scan_reg[0] -> scan_reg[1]
//         -> scan_reg[2] -> scan_reg[3]
//
// Therefore, desired data is shifted MSB first.
/////////////////////////////////////////////////

task automatic scan_shift_in
(
    input logic [3:0] scan_data
);

    $display(
        "\n%0t: Shifting %b into the scan register",
        $time,
        scan_data
    );

    TEST_MODE    = 1'b1;
    SRST         = 1'b0;
    SCAN_CAPTURE = 1'b0;
    SCAN_UPDATE  = 1'b0;
    SCAN_ENABLE  = 1'b1;

    for (int i = 3; i >= 0; i--)
    begin
        @(negedge SYS_CLOCK);

        SCAN_IN = scan_data[i];

        @(posedge SYS_CLOCK);
        #1ps;

        $display(
            "%0t: Shifted SCAN_IN=%b",
            $time,
            scan_data[i]
        );
    end

    @(negedge SYS_CLOCK);

    SCAN_ENABLE = 1'b0;
    SCAN_IN     = 1'b0;

endtask : scan_shift_in

/////////////////////////////////////////////////
// Update Counter from Scan Register
/////////////////////////////////////////////////

task automatic scan_update_counter
(
    input logic [3:0] expected_count
);

    $display(
        "\n%0t: Updating counter from scan register",
        $time
    );

    @(negedge SYS_CLOCK);

    TEST_MODE    = 1'b1;
    SCAN_ENABLE  = 1'b0;
    SCAN_CAPTURE = 1'b0;
    SCAN_UPDATE  = 1'b1;

    @(posedge SYS_CLOCK);
    #1ps;

    if (COUNT !== expected_count)
    begin
        $error(
            "SCAN UPDATE FAILED: COUNT=%b, expected=%b",
            COUNT,
            expected_count
        );

        error_count++;
    end
    else
    begin
        $display(
            "%0t: SCAN UPDATE PASSED: COUNT=%b",
            $time,
            COUNT
        );
    end

    @(negedge SYS_CLOCK);

    SCAN_UPDATE = 1'b0;

endtask : scan_update_counter

/////////////////////////////////////////////////
// Capture Counter into Scan Register
/////////////////////////////////////////////////

task automatic scan_capture_count;

    $display(
        "\n%0t: Capturing COUNT=%b into scan register",
        $time,
        COUNT
    );

    @(negedge SYS_CLOCK);

    TEST_MODE    = 1'b1;
    SCAN_ENABLE  = 1'b0;
    SCAN_UPDATE  = 1'b0;
    SCAN_CAPTURE = 1'b1;

    @(posedge SYS_CLOCK);
    #1ps;

    @(negedge SYS_CLOCK);

    SCAN_CAPTURE = 1'b0;

endtask : scan_capture_count

/////////////////////////////////////////////////
// Shift Captured Data Out
/////////////////////////////////////////////////

task automatic scan_shift_out
(
    input logic [3:0] expected_data
);

    logic [3:0] shifted_data;

    shifted_data = '0;

    $display(
        "\n%0t: Shifting captured data out",
        $time
    );

    TEST_MODE    = 1'b1;
    SCAN_CAPTURE = 1'b0;
    SCAN_UPDATE  = 1'b0;
    SCAN_ENABLE  = 1'b1;
    SCAN_IN      = 1'b0;

    // SCAN_OUT initially presents scan_reg[3].
    // Therefore, captured data is observed MSB first.
    for (int i = 3; i >= 0; i--)
    begin
        shifted_data[i] = SCAN_OUT;

        $display(
            "%0t: SCAN_OUT=%b",
            $time,
            SCAN_OUT
        );

        @(posedge SYS_CLOCK);
        #1ps;
    end

    @(negedge SYS_CLOCK);

    SCAN_ENABLE = 1'b0;

    if (shifted_data !== expected_data)
    begin
        $error(
            "SCAN SHIFT-OUT FAILED: received=%b, expected=%b",
            shifted_data,
            expected_data
        );

        error_count++;
    end
    else
    begin
        $display(
            "%0t: SCAN SHIFT-OUT PASSED: received=%b",
            $time,
            shifted_data
        );
    end

endtask : scan_shift_out

/////////////////////////////////////////////////
// Main Test Sequence
/////////////////////////////////////////////////

initial
begin : stimulus

    logic [3:0] captured_value;

    //////////////////////////////////////////////////
    // Initialization
    //////////////////////////////////////////////////

    SRST    = 1'b0;
    LOAD    = 1'b0;
    UP      = 1'b0;
    DOWN    = 1'b0;
    DATA_IN = 4'b0000;

    TEST_MODE    = 1'b0;
    SCAN_ENABLE  = 1'b0;
    SCAN_CAPTURE = 1'b0;
    SCAN_UPDATE  = 1'b0;
    SCAN_IN      = 1'b0;

    //////////////////////////////////////////////////
    // Functional-Mode Tests
    //////////////////////////////////////////////////

    $display("\n========================================");
    $display(" Functional-Mode Verification");
    $display("========================================");

    // Synchronous reset
    functional_cycle(
        1'b1, 1'b0, 1'b0, 1'b0,
        4'b0000,
        4'b0000,
        "Synchronous reset"
    );

    // Hold after reset
    functional_cycle(
        1'b0, 1'b0, 1'b0, 1'b0,
        4'b0000,
        4'b0000,
        "Hold operation"
    );

    // Load 9
    functional_cycle(
        1'b0, 1'b1, 1'b0, 1'b0,
        4'b1001,
        4'b1001,
        "Load operation"
    );

    // Count up: 9 -> 10
    functional_cycle(
        1'b0, 1'b0, 1'b1, 1'b0,
        4'b0000,
        4'b1010,
        "Up-count operation"
    );

    // Count down: 10 -> 9
    functional_cycle(
        1'b0, 1'b0, 1'b0, 1'b1,
        4'b0000,
        4'b1001,
        "Down-count operation"
    );

    //////////////////////////////////////////////////
    // Priority Tests
    //////////////////////////////////////////////////

    // LOAD has priority over UP and DOWN.
    functional_cycle(
        1'b0, 1'b1, 1'b1, 1'b1,
        4'b0110,
        4'b0110,
        "Priority: LOAD > UP > DOWN"
    );

    // UP has priority over DOWN.
    functional_cycle(
        1'b0, 1'b0, 1'b1, 1'b1,
        4'b0000,
        4'b0111,
        "Priority: UP > DOWN"
    );

    // SRST has highest priority.
    functional_cycle(
        1'b1, 1'b1, 1'b1, 1'b1,
        4'b1111,
        4'b0000,
        "Priority: SRST highest"
    );

    //////////////////////////////////////////////////
    // Counter Overflow and Underflow
    //////////////////////////////////////////////////

    // Load maximum value
    functional_cycle(
        1'b0, 1'b1, 1'b0, 1'b0,
        4'b1111,
        4'b1111,
        "Load maximum value"
    );

    // 15 -> 0
    functional_cycle(
        1'b0, 1'b0, 1'b1, 1'b0,
        4'b0000,
        4'b0000,
        "Up-count overflow"
    );

    // 0 -> 15
    functional_cycle(
        1'b0, 1'b0, 1'b0, 1'b1,
        4'b0000,
        4'b1111,
        "Down-count underflow"
    );

    //////////////////////////////////////////////////
    // Scan Controllability Test
    //////////////////////////////////////////////////

    $display("\n========================================");
    $display(" Scan Controllability Verification");
    $display("========================================");

    // Shift 1011 into scan register.
    scan_shift_in(4'b1011);

    // Transfer scan register value to counter.
    scan_update_counter(4'b1011);

    //////////////////////////////////////////////////
    // Scan Observability Test
    //////////////////////////////////////////////////

    $display("\n========================================");
    $display(" Scan Observability Verification");
    $display("========================================");

    captured_value = COUNT;

    // Capture counter into scan register.
    scan_capture_count();

    // Shift captured data out serially.
    scan_shift_out(captured_value);

    //////////////////////////////////////////////////
    // Return to Functional Mode
    //
    // Important:
    // Do NOT separately switch TEST_MODE to 0 here.
    // functional_cycle() changes TEST_MODE and the
    // functional inputs together at the next negedge.
    //////////////////////////////////////////////////

    functional_cycle(
        1'b0, 1'b0, 1'b1, 1'b0,
        4'b0000,
        4'b1100,
        "Return to functional mode"
    );

    //////////////////////////////////////////////////
    // Final Test Summary
    //////////////////////////////////////////////////

    $display("\n========================================");

    if (error_count == 0)
        $display(" ALL TESTS PASSED");
    else
        $display(
            " TEST FAILED: %0d error(s)",
            error_count
        );

    $display("========================================\n");

    $finish;

end

endmodule
