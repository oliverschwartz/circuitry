//==============================================================================
// Control Unit for PUnC LC3 Processor
//==============================================================================

`include "Defines.v"

module PUnCControl(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset

	// Inputs from datapath
	input [15:0] ir,
	input p,
	input n,
	input z,

	// Memory controls
	output reg mem_w_en,
	output reg [1:0] mem_w_addr_sel,
	output reg mem_w_data_sel,
	output reg [1:0] mem_r_addr_sel,

	// Register file controls
	output reg rf_w_en,
	output reg rf_r0_addr_sel,
	output reg rf_r1_addr_sel,
	output reg [1:0] rf_w_data_sel,
	output reg rf_w_addr_sel,

	// Instruction register controls
	output reg ir_ld,

	// Program counter controls
	output reg pc_ld,
	output reg pc_clr,
	output reg pc_inc,
	output reg [1:0] pc_ld_data_sel,

	// ALU controls
	output reg [2:0] alu_sel,
  
	// Condition code controls
	output reg cond_ld,
	output reg cond_ld_data_sel,

	// LDI controls
	output reg ldi_reg_ld
);

	// FSM States
   	localparam STATE_INIT      = 3'b000;
   	localparam STATE_FETCH     = 3'b001;
   	localparam STATE_DECODE    = 3'b010;
 	localparam STATE_EXECUTE   = 3'b011;
   	localparam STATE_EXECUTE_I = 3'b100;
   	localparam STATE_HALT      = 3'b101;

	// State, Next State
	reg [2:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Set default values for outputs here (prevents implicit latching)
		mem_w_en = 1'd0;
		mem_w_addr_sel = 2'd0;
		mem_r_addr_sel = 1'd0;
		rf_w_en = 1'd0;
		rf_r0_addr_sel = 2'd0;
		rf_r1_addr_sel = 2'd0;
		rf_w_data_sel = 2'd0;
		rf_r0_addr_sel = 1'd0;
		rf_r1_addr_sel = 1'd0;
		ir_ld = 1'd0;
		pc_ld = 1'd0;
		pc_clr = 1'd0;
		pc_inc = 1'd0;
		pc_ld_data_sel = 2'd0;
		alu_sel = 3'd0;
		cond_ld = 1'd0;
		cond_ld_data_sel = 1'd0;

		case (state)
			STATE_INIT: begin
				pc_clr = 1'd1;		
			end
			STATE_FETCH: begin
				ir_ld = 1'd1;
			end
			STATE_DECODE: begin
				pc_inc = 1'd1;
			end

			STATE_EXECUTE: begin
				case (ir[`OC])
					`OC_ADD: begin
						rf_w_addr_sel = `RF_W_ADDR_SEL_A;
						rf_w_data_sel = `RF_W_DATA_SEL_ALU;
						rf_w_en = 1'b1;
						rf_r0_addr_sel = `RF_R0_ADDR_SEL_A;
						rf_r1_addr_sel = `RF_R1_ADDR_SEL_A;
						if (ir[5] == 1'b0) begin
              				alu_sel = `ALU_FN_ADD;
						end
						else begin
							alu_sel = `ALU_FN_ADD_I;
						end
						// set condition codes
						cond_ld = 1'b1;
						cond_ld_data_sel = `COND_LD_DATA_SEL_ALU;
					end

					`OC_AND: begin
            			rf_w_addr_sel = `RF_W_ADDR_SEL_A;
						rf_w_data_sel = `RF_W_DATA_SEL_ALU;
            			rf_w_en = 1'b1;
            			rf_r0_addr_sel = `RF_R0_ADDR_SEL_A;
            			rf_r1_addr_sel = `RF_R1_ADDR_SEL_A;
						if (ir[5] == 1'b0) begin
              				alu_sel = `ALU_FN_AND;
						end
						else begin
              				alu_sel = `ALU_FN_AND_I;
						end
						// set condition codes
						cond_ld = 1'b1;
						cond_ld_data_sel = `COND_LD_DATA_SEL_ALU;
					end

					`OC_BR: begin
            			if ((n & ir[`BR_N]) | (z & ir[`BR_Z]) | (p & ir[`BR_P])) begin
              				pc_ld_data_sel = `PC_LD_DATA_SEL_A;
              				pc_ld = 1'b1;
            			end
					end

					`OC_JMP: begin // NOTE: THIS IS FOR JMP/RET
            			pc_ld = 1'b1;
						pc_ld_data_sel = `PC_LD_DATA_SEL_B;
              			rf_r0_addr_sel = `RF_R0_ADDR_SEL_A;
					end

					`OC_JSR: begin
						rf_w_data_sel = `RF_W_DATA_SEL_PC;
						rf_w_addr_sel = `RF_W_ADDR_SEL_B;
						rf_w_en = 1'b1;
						pc_ld = 1'b1;

						// JSR or JSRR
						if (ir[11] == 1'b1) begin // JSR
							pc_ld_data_sel = `PC_LD_DATA_SEL_C;              
						end            			
						else begin // JSRR
              				pc_ld_data_sel = `PC_LD_DATA_SEL_B;
              				rf_r0_addr_sel = `RF_R0_ADDR_SEL_A;
						end
					end

					`OC_LD: begin
						rf_w_en = 1'b1;
						rf_w_data_sel = `RF_W_DATA_SEL_MEM;
						rf_w_addr_sel = `RF_W_ADDR_SEL_A;
						mem_r_addr_sel = `MEM_R_ADDR_SEL_A;
						
						// set condition codes
						cond_ld = 1'b1;
						cond_ld_data_sel = `COND_LD_DATA_SEL_RF;
					end

					// requires two cycles
					`OC_LDI: begin
						ldi_reg_ld = 1'b1;
						mem_r_addr_sel = `MEM_R_ADDR_SEL_A;
					end

					`OC_LDR: begin
						rf_w_en = 1'b1;
						rf_w_data_sel = `RF_W_DATA_SEL_MEM;
						rf_w_addr_sel = `RF_W_ADDR_SEL_A;
						mem_r_addr_sel = `MEM_R_ADDR_SEL_B;
						rf_r0_addr_sel = `RF_R0_ADDR_SEL_A;
						
						// set condition codes
						cond_ld = 1'b1;
						cond_ld_data_sel = `COND_LD_DATA_SEL_RF;
					end

					`OC_LEA: begin
						rf_w_en = 1'b1;
						rf_w_data_sel = `RF_W_DATA_SEL_A;
						rf_w_addr_sel = `RF_W_ADDR_SEL_A;

						// set condition codes
						cond_ld = 1'b1;
						cond_ld_data_sel = `COND_LD_DATA_SEL_RF;
					end

					`OC_NOT: begin
						alu_sel = `ALU_FN_NOT;
						rf_w_addr_sel = `RF_W_ADDR_SEL_A;
						rf_w_data_sel = `RF_W_DATA_SEL_ALU;
						rf_w_en = 1'b1;
						rf_r0_addr_sel = `RF_R0_ADDR_SEL_A;

						// set condition codes
						cond_ld = 1'b1;
						cond_ld_data_sel = `COND_LD_DATA_SEL_ALU;
					end

					`OC_ST: begin
						mem_w_en = 1'b1;
						mem_w_data_sel = `MEM_W_DATA_SEL_RF;
						mem_w_addr_sel = `MEM_W_ADDR_SEL_A;
						rf_r0_addr_sel = `RF_R0_ADDR_SEL_B;
					end

					`OC_STI: begin // incomplete
						mem_w_en = 1'b1;
						mem_w_addr_sel = `MEM_W_ADDR_SEL_MEMDATA;
						rf_r0_addr_sel = `RF_R0_ADDR_SEL_B;
						mem_r_addr_sel = `MEM_R_ADDR_SEL_A;
					end

					`OC_STR: begin
						mem_w_en = 1'b1;
						mem_w_data_sel = `MEM_W_DATA_SEL_RF;
						mem_w_addr_sel = `MEM_W_ADDR_SEL_B;
						rf_r0_addr_sel = `RF_R0_ADDR_SEL_B;
						rf_r1_addr_sel = `RF_R1_ADDR_SEL_B;
					end

					`OC_HLT: begin
					// do nothing
					end
				endcase
			end

			STATE_EXECUTE_I: begin
				// in second phase of LDI
				rf_w_en = 1'b1;
				rf_w_data_sel = `RF_W_DATA_SEL_MEM;
				rf_w_addr_sel = `RF_W_ADDR_SEL_A;
				mem_r_addr_sel = `MEM_R_ADDR_SEL_LDI_REG;

				// set condition codes
				cond_ld = 1'b1;
				cond_ld_data_sel = `COND_LD_DATA_SEL_RF;
			end

			STATE_HALT: begin

			end
		endcase
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;

		case (state)
			STATE_INIT: begin
				next_state = STATE_FETCH;
			end
			STATE_FETCH: begin
				next_state = STATE_DECODE;
			end
			STATE_DECODE: begin
				next_state = STATE_EXECUTE;
			end
			STATE_EXECUTE: begin
				if (ir[`OC] == `OC_LDI) begin
					next_state = STATE_EXECUTE_I;	
				end
				else if (ir[`OC] == `OC_HLT) begin
					next_state = STATE_HALT;
				end
				else begin 
					next_state = STATE_FETCH;
				end
			end
			STATE_EXECUTE_I: begin
				next_state = STATE_FETCH;
			end
		endcase
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			state <= STATE_INIT;
		end
		else begin
			state <= next_state;
		end
	end

endmodule

