/////////////////////////////////////////////////////////////////////////////////////////
/*
The following SystemVerilog RTL/testbench was developed by Dr. Shahriyar Masud Rizvi. 

    © 2026 Shahriyar Masud Rizvi

Attribution Requirement:
If you use the following SystemVerilog sources, in whole or in part,
you MUST include visible credit to the original authors in:
  - Documentation or README of your project, OR
  - About/Info section of your tool, OR
  - Academic citation/reference if used in research

Citation Example:
"This project uses work from S. M. Rizvi, RTL Design, Verification, Synthesis & PnR for Digital VLSI Design, American International University-Bangladesh, Dhaka, Bangladesh, 2026."
*/
/////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module FSMD
(
    input  logic       SYS_CLOCK, 
    input  logic       FSM_ARESET, 
    input  logic [1:0] A, B, C, D,
    output logic [3:0] F
);


logic [3:0] next_R1, R1, next_R2, R2, next_F;

//Using enumertaed (symbolic) data types for P_STATE and N_STATE.
//This is industry-standard practice  

//Here, typedef is used as N_STATE is assigned unknown values by default (to catch simulation bugs).
//typedef won't be needed if N_STATE is not assigned non-binary values such as unknown states

typedef enum logic [1:0] {S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11} state_t;

state_t P_STATE, N_STATE;

always_comb
begin : NSOL  

	begin: NSL
	//assign N_STATE to unknown value to catch unspecified N_STATES in simulation.
	N_STATE = state_t'('x); 

	case (P_STATE)
	S0:	N_STATE = S1;
	S1:	N_STATE = S2;	
	S2:	N_STATE = S3;
	S3:	N_STATE = S0;	
	default: N_STATE = S0;
	//assign N_STATE to the initial state so that FSM can return to a safe state if it enters an illegal or unknown state.
	//This is needed for safe FSM coding style, which is industry-standard practice. 
	endcase	 
	
	end : NSL
	
	begin : OL	
 
	//Default value of next_R1, next_R2 and next_F are R1, R2 and F (so output is held) 	
	next_R1 = R1;
	next_R2 = R2;
	next_F = F;
	
	case (P_STATE)
	S0:	next_R1 = {2'b00,A} + {2'b00,B};	
	S1:	next_R2 = {2'b00,C} - {2'b00,D};
	S2:	next_R1 = R1 + R2;	
	S3:	next_F = R1;
	
	default: ; 
	endcase	  
	
	end : OL	
end : NSOL

always_ff @ (posedge SYS_CLOCK, posedge FSM_ARESET)
begin :PSR
	if (FSM_ARESET)
		P_STATE <= S0;
	else
		begin
		P_STATE <= N_STATE;
		R1 <= next_R1;
		R2 <= next_R2;
		F <= next_F;
                end	

end : PSR
	
endmodule : FSMD






