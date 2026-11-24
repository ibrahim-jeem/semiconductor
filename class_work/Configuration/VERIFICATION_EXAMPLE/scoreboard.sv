//`include "transaction.sv"

class scoreboard;
  transaction trans;
  mailbox mon2scb;
  
  int  repeat_count;
  
  function new (mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
//timeunit 1ns;
//timeprecision 1ps;  

  task main ();
    transaction trans;
    repeat (1)
     begin
       mon2scb.get(trans);
       

       if ((trans.A + trans.B) == {trans.CARRYOUT, trans.SUM})
         begin
          $display("********PASSS********");
           //$display ("A = %0d, B = %0d, SUM = %0d, CARRYOUT = %0d", trans.A, trans.B, trans.SUM, trans.CARRYOUT);
         end
       else
         $display("!!!!!!FAIL");
     
       //$display("////////////Transaction Done////////////");
       trans.display("Scoreboard");
     end
  
  endtask
    
endclass
