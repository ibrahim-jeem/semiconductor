//`include "transaction.sv"


class driver;
  virtual intf vif;
  mailbox gen2drv;
  
  int  repeat_count;
  int no_transactions;
  
  function new (virtual intf vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
 //timeunit 1ns;
//timeprecision 1ps;
 
  task main ();
    repeat (1)
      
     begin
       transaction trans;
       gen2drv.get(trans); 
       vif.A <= trans.A;
       vif.B <= trans.B;
		#1;
       trans.display("Driver");
       trans.SUM <= vif.SUM;
       trans.CARRYOUT <= vif.CARRYOUT;
       no_transactions++;   
       $display("No of Transactions %0d",no_transactions);
     end
  
  endtask
    
endclass
