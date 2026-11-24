module FULLADDER
(input logic CIN, X, Y,
output logic S, COUT);

assign S = X ^ Y ^ CIN;
assign COUT = (X & Y) | ((X ^ Y) & CIN );

endmodule
