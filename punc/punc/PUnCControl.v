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

	// Memory controls
	output wire mem_w_en,
	output wire mem_w_addr_sel,
	output wire mem_r_addr_sel,

	// Register file controls
	output wire rf_w_en,
	output wire rf_r0_addr_sel,
	output wire rf_r1_addr_sel,
	output wire [1:0] rf_w_data_sel,
	output wire rf_w_addr_sel,

	// Instruction register controls
	output wire ir_ld,

	// Program counter controls
	output wire pc_ld,
	output wire pc_clr,
	output wire pc_inc,
	output wire [1:0] pc_ld_data_sel,

	// ALU controls
	output wire [1:0] alu_sel
);

	// FSM States
   	localparam STATE_INIT      = 3'b000;
   	localparam STATE_FETCH     = 3'b001;
   	localparam STATE_DECODE    = 3'b010;
 	localparam STATE_EXECUTE   = 3'b011;
   	localparam STATE_EXECUTE_I = 3'b100;
   	localparam STATE_HALT      = 3'b101;

	// State, Next State
	reg [4:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Set default values for outputs here (prevents implicit latching)
		mem_w_en = 1'd0;
		mem_w_addr_sel = 1'd0;
		mem_r_addr_sel = 1'd0;
		rf_w_en = 1'd0;
		rf_r_addr_sel = 2'd0;
		rf_w_data_sel = 2'd0;
		rf_r0_addr_sel = 1'd0;
		rf_r1_addr_sel = 1'd0;
		ir_ld = 1'd0;
		pc_ld = 1'd0;
		pc_clr = 1'd0;
		pc_inc = 1'd0;
		pc_ld_data_sel = 2'd0;

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
					`OC_ADD begin
						if (ir[5] == 0) begin
							rf_w_addr_sel = 1'b0;
							rf_w_data_sel = 2'b00;
							rf_w_en = 1'b0;
							rf_r0_addr_sel = 1'b0;
							rf_r1_addr_sel = 1'b0;
						end
						else begin
						end
					end

					`OC_AND begin
						if () begin
							end
						else begin
						end
					end

					`OC_BR begin
					end

					`OC_JMP begin
					end

					`OC_JSR begin
						if () begin
						end
						else begin
						end
					end

					`OC_LD begin
					end

					`OC_LDI begin
					end

					`OC_LDR begin
					end

					`OC_LEA begin
					end

					`OC_NOT begin
					end

					`OC_ST begin
					end

					`OC_STI begin
					end

					`OC_STR begin
					end

					`OC_HLT begin
					end
				endcase
			end
		endcase
	end

	// Next State Combinational Logic
	always @( * ) begin
		next_state = state;

		// Add your next-state logic here
		//case (state)
		//	STATE_FETCH: begin
		//
		//	end
		//endcase
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
