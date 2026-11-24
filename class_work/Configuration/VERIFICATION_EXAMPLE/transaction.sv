class transaction;
  randc bit [3:0] A, B;
  bit [3:0] SUM;
  bit CARRYOUT;
  
  constraint C_A {A>0; B>0;};
  
  /*
  covergroup cg; 
  	coverpoint A;
   coverpoint B; 
	endgroup
  
 cg cg_h; 
 */
  
    function void display  (string name); 
      $display ("=============================");
      $display ("%s", name);
      $display ("A = %0d, B = %0d, SUM = %0d, CARRYOUT = %0d", A, B, SUM, CARRYOUT);
      $display ("=============================");

    endfunction
  
  
endclass