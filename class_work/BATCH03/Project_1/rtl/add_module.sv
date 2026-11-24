module add_module (
    input logic [3:0] A, B,
    output logic [4:0] ADD_RESULT
);
    assign ADD_RESULT = {1'b0, A} + {1'b0, B}

endmodule

