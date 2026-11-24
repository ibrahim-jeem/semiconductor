`include "environment.sv"
//timeunit 1ns;
//timeprecision 1ps;

program test (intf i_ntff);
  environment env;
  
  /*
      transaction trans;
      covergroup cg; 
  		coverpoint trans.A;
   		coverpoint trans.B; 
	endgroup
  
  
  	cg cg_h;
    */
  
  initial 
    begin
      env = new(i_ntff);
      //cg_h = new();
      //env.gen.repeat_count = 4;
      //env.drv.repeat_count = 4;
      //env.mon.repeat_count = 4;
      //env.scb.repeat_count = 4;
      env.repeat_count = 20;
      env.run();
      //cg_h.sample();
      
    end
  
endprogram
