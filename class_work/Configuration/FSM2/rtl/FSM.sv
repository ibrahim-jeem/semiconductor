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

module FSM
(
	input  logic       SYS_CLOCK, 
	input  logic	   FSM_ARESET, 
        output logic [1:0] SEL1, SEL2,
        output logic ALU_CONTROL,
        output logic LDR1, LDR2, LDF	
);

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
	n 
	//Assign default values to outputs, so you do not have to specify in every case/branch.
	
	case (P_STATE)
	S0:	begin
                SEL1 = 1; //Pass A
                SEL2 = 0; //Pass B
                ALU_CONTROL = 0; //Add
                LDR1 = 1;
		end	
	S1:	begin
                SEL1 = 2; //Pass C
                SEL2 = 1; //Pass D
                ALU_CONTROL = 1; //Sub
                LDR2 = 1;
		end
	S2:	begin
                SEL1 = 0; //Pass R1
                SEL2 = 2; //Pass R2
                ALU_CONTROL = 0; //Add
                LDR1 = 1;
		end	
	S3:	LDF = 1;
	
	default: ; 
	endcase	  
	
	end : OL	
end : NSOL

always_ff @ (posedge SYS_CLOCK, posedge FSM_ARESET)
begin :PSR
	if (FSM_ARESET)
		P_STATE <= S0;
	else
		P_STATE <= N_STATE;	

end : PSR
	
endmodule : FSM



