// Code your testbench here
// or browse Examples
//https://www.youtube.com/watch?v=nX9FQVVlKio&t=551s
//Verification of ALU with basic System Verilog TB 
//System Verilog Project

//Made no of test cases generic (env.repeat_count = 4;)
//
//timeunit 1ns;
//timeprecision 1ps;
`timescale 1ns/1ps
`include "interface.sv"
`include "test.sv"


module tb_top;
  
  intf i_ntff();
  test t1 (i_ntff);
  
  ADDER_4BIT A1 (.A(i_ntff.A), .B(i_ntff.B), .SUM(i_ntff.SUM), .CARRYOUT(i_ntff.CARRYOUT));
  
  initial
  begin
    $dumpfile ("dump.vcd");  
    $dumpvars;
  end

endmodule
