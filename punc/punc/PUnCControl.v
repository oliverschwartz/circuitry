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

	// Register file controls
	output wire rf_w_en,
	output wire [1:0] rf_w_data_sel,

	// Instruction register controls
	output wire ir_ld,

	// Program counter controls
	output wire pc_ld,
	output wire pc_clr,
	output wire pc_inc,

	// ALU controls
	output wire [1:0] alu_sel
);

	// FSM States
	localparam STATE_INIT        = 5'd0;
	localparam STATE_FETCH       = 5'd1;
	localparam STATE_DECODE      = 5'd2;
	localparam STATE_ADD         = 5'd3;
	localparam STATE_ADD_I       = 5'd4;
	localparam STATE_AND         = 5'd5;
	localparam STATE_AND_I       = 5'd6;
	localparam STATE_BR          = 5'd7;
	localparam STATE_JMP_NZP     = 5'd8;
	localparam STATE_JMP_RET     = 5'd9;
	localparam STATE_JSR         = 5'd10;
	localparam STATE_JSR_2       = 5'd11;
	localparam STATE_LD          = 5'd12;
	localparam STATE_LDI         = 5'd13;
	localparam STATE_LDI_2       = 5'd14;
	localparam STATE_LDR         = 5'd15;
	localparam STATE_LDR_2       = 5'd16;
	localparam STATE_LEA         = 5'd17;
	localparam STATE_NOT         = 5'd18;
	localparam STATE_RTI         = 5'd19;
	localparam STATE_ST          = 5'd20;
	localparam STATE_STI         = 5'd21;
	localparam STATE_STR         = 5'd22;
	localparam STATE_HALT        = 5'd23;

	// State, Next State
	reg [4:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Set default values for outputs here (prevents implicit latching)

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
