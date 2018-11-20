//==============================================================================
// Control Module for Simon Project
//==============================================================================

module SimonControl(
	// External Inputs
	input        clk,           // Clock
	input        rst,           // Reset

	// Datapath Inputs
	input     InputValid,
	input     RWeq,
	input     InputEqPat,

	// Datapath Control Outputs
	output  reg  mux_control,
	output  reg [1:0] st,
	output  reg clear,
	output  reg increase,
	output  reg w_en,
	output  reg done,

	// External Outputs
	output reg [2:0] mode_leds

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
	localparam STATE_ONE = 2'd0;
	localparam STATE_TWO = 2'd1;
	localparam STATE_THREE = 2'd2;
	localparam STATE_FOUR = 2'd3;


	// Output Combinational Logic
	always @( * ) begin
		// Set defaults
		w_en = 0;
		st = STATE_ONE;
		mux_control = 0;
		mode_leds = LED_MODE_DONE;
		if(state == STATE_ONE) begin
		    mux_control = 0;
				st = state;
		    mode_leds = LED_MODE_INPUT;
				w_en = 1;
		end
		if(state == STATE_TWO) begin
		    mux_control = 1;
				st = state;
		    mode_leds = LED_MODE_PLAYBACK;
				w_en = 0;
		end
		if(state == STATE_THREE) begin
		    mux_control = 0;
				st = state;
		    mode_leds = LED_MODE_REPEAT;
				w_en = 0;
		end
		if(state == STATE_FOUR) begin
		    mux_control = 1;
				st = state;
		    mode_leds = LED_MODE_DONE;
				w_en = 0;
		end

	end

	// Next State Combinational Logic
	always @( * ) begin
		// Write your Next State Logic Here
		increase = 0;
		done = 0;
		clear = rst;
		next_state = state;
		if ((state==STATE_ONE)&&(InputValid)) begin
				next_state = STATE_TWO;
		end
		if ((state==STATE_TWO)&&(RWeq)) begin
				next_state = STATE_THREE;
		end
		if ((state==STATE_THREE)&&((InputEqPat==0))) begin
				next_state = STATE_FOUR;
				done = 1;
		end
		if ((state==STATE_THREE)&&((RWeq)&&(InputEqPat))) begin
				next_state = STATE_ONE;
				increase = 1;
		end
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
