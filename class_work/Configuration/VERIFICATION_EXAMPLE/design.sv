// Code your design here
//timeunit 1ns;
//timeprecision 1ps;
`timescale 1ns/1ps
module ADDER_4BIT
  (input logic [3:0] A, B,
   output logic [3:0] SUM,
   output logic CARRYOUT);
  
  always_comb
   begin
     {CARRYOUT, SUM} = A + B;  
   end
      
endmodule
