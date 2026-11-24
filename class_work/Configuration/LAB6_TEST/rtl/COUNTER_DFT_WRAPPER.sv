`timescale 1ns/1ps
module COUNTER_4BIT_DFT_WRAPPER
(
    input  logic       SYS_CLOCK,
    input  logic       SRST,

    // Functional inputs
    input  logic       LOAD,
    input  logic       UP,
    input  logic       DOWN,
    input  logic [3:0] DATA_IN,

    // DFT control inputs
    input  logic       TEST_MODE,
    input  logic       SCAN_ENABLE,
    input  logic       SCAN_CAPTURE,
    input  logic       SCAN_UPDATE,
    input  logic       SCAN_IN,

    // Functional output
    output logic [3:0] COUNT,

    // Serial scan output
    output logic       SCAN_OUT
);

/////////////////////////////////////////////////
// Internal Signals
/////////////////////////////////////////////////

logic [3:0] scan_reg;

logic       dut_load;
logic       dut_up;
logic       dut_down;
logic [3:0] dut_data_in;

/////////////////////////////////////////////////
// Functional/Test-Mode Input Selection
/////////////////////////////////////////////////

always_comb
begin
    // Normal functional operation
    dut_load    = LOAD;
    dut_up      = UP;
    dut_down    = DOWN;
    dut_data_in = DATA_IN;

    if (TEST_MODE)
    begin
        // Disable normal counter operations
        dut_up      = 1'b0;
        dut_down    = 1'b0;

        // During SCAN_UPDATE, load the scanned value
        // into the counter.
        dut_load    = SCAN_UPDATE;
        dut_data_in = scan_reg;
    end
end

/////////////////////////////////////////////////
// Counter Under Test
/////////////////////////////////////////////////

COUNTER_4BIT DUT
(
    .SYS_CLOCK (SYS_CLOCK),
    .SRST      (SRST),
    .LOAD      (dut_load),
    .UP        (dut_up),
    .DOWN      (dut_down),
    .DATA_IN   (dut_data_in),
    .COUNT     (COUNT)
);

/////////////////////////////////////////////////
// Scan Register
//
// Priority:
// SRST > SCAN_CAPTURE > SCAN_ENABLE
/////////////////////////////////////////////////

always_ff @(posedge SYS_CLOCK)
begin
    if (SRST)
        scan_reg <= 4'b0000;

    else if (TEST_MODE)
    begin
        if (SCAN_CAPTURE)
            scan_reg <= COUNT;

        else if (SCAN_ENABLE)
            scan_reg <= {scan_reg[2:0], SCAN_IN};
    end
end

/////////////////////////////////////////////////
// Serial Scan Output
/////////////////////////////////////////////////

assign SCAN_OUT = scan_reg[3];

endmodule
