//`include "transaction.sv"

class monitor;
  virtual intf vif;
  mailbox mon2scb;
 
  int  repeat_count;
 
  function new (virtual intf vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  
  task main ();
    repeat (1)
      //#3;
      #1;
      //#0;
     begin
       transaction trans;
       trans = new();        
       trans.A = vif.A;
       trans.B = vif.B;
       trans.SUM = vif.SUM;
       trans.CARRYOUT = vif.CARRYOUT;
		mon2scb.put(trans);
       trans.display("Monitor");
             
     end
  
  endtask
    
endclass