//==============================================================================
// Control Module for Simon Project
//==============================================================================

module SimonControl(
	// External Inputs
	input        clk,           // Clock
	input        rst,           // Reset

	// Datapath Inputs
	input     correctInput,
	input     finishedSequence,
	input 	  validInput,


	// Datapath Control Outputs
	output    reg [1:0] current_state,
	output 	  reg count,
	output    reg reset,
	output    reg done,


	// External Outputs
	output [2:0] mode_leds
);

	// Declare Local Vars Here
	reg [1:0] state;
	reg [1:0] next_state;

	// LED Light Parameters
	localparam LED_MODE_INPUT    = 3'b001;
	localparam LED_MODE_PLAYBACK = 3'b010;
	localparam LED_MODE_REPEAT   = 3'b100;
	localparam LED_MODE_DONE     = 3'b111;

	// Declare State Names Here
	localparam STATE_ONE   = 2'd0;
	localparam STATE_TWO   = 2'd1;
	localparam STATE_THREE = 2'd2;
	localparam STATE_FOUR  = 2'd3;

	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
		// signal_one = 0; ...

		// Write your output logic here
	end

	// Next State Combinational Logic
	always @( * ) begin
		// Write your Next State Logic Here
		next_state = state
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			state <= STATE_ONE;
		end
		else begin
			// Update state to next state
			state <= next_state;
		end
	end

endmodule
