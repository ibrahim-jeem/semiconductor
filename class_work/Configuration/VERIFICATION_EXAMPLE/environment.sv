`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
//`include "interface.sv"
//timeunit 1ns;
//timeprecision 1ps;

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  mailbox m1;
  mailbox m2;
  
  virtual intf vif;
  
  int  repeat_count;
  
  function new (virtual intf vif);
    this.vif= vif;
    m1 = new();
    m2 = new();
    gen = new(m1);
    drv = new(vif, m1);
    mon = new(vif, m2);
    scb = new(m2);    
    

  endfunction
  
     /*
     transaction trans;
      covergroup cg; 
  		coverpoint trans.A;
   		coverpoint trans.B; 
	endgroup
  	*/
  
  	//cg cg_h;
  	
  
  
  task test();
    
    fork
      //cg cg_h;
      //cg_h = new();
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join
    
  endtask
  
  int no_transactions = 1;
  
     /*
     transaction trans;
      covergroup cg; 
  		coverpoint trans.A;
   		coverpoint trans.B; 
	endgroup
  	*/
  
  	//cg cg_h;
  
  task run;
     repeat (repeat_count)
     begin
       //cg cg_h;
       //cg_h = new();
    	test();
       //cg_h.sample();
       $display("Completed test case %0d",no_transactions);
       no_transactions++; 
     end
    $display("End of test");
    //cg_h.sample();
    $finish;
  endtask
  
endclass
