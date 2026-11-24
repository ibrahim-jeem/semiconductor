//`include "transaction.sv"

class generator;
  transaction trans;
  mailbox gen2drv;
  
  int  repeat_count;
 
  
      covergroup cg; 
        option.per_instance = 1;
  		coverpoint trans.A;
   		coverpoint trans.B; 
	endgroup
  
  
  function new (mailbox gen2drv);
    this.gen2drv = gen2drv;
    //cg cg_h = new();
    cg = new();
   endfunction
  
    

    
    /*
  
 	cg cg_h;
    */
  
  /*
  function new ();
    cg cg_h = new();
  */
  
//timeunit 1ns;
//timeprecision 1ps;

  task main ();
    repeat (1)
     begin
       trans = new ();
       //cg_h = new ();
       trans.randomize();
       trans.display("Generator");
       gen2drv.put(trans); 
       cg.sample();
     end
  
  endtask
    
endclass
