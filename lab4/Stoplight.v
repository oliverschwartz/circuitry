//==============================================================================
// Stoplight Module for Lab 4
//
// Note on lights:
// 	Each bit represents the on/off signal for a light.
// 	Bit | Light
// 	------------
// 	0   | Red
// 	1   | Yellow
// 	2   | Green
//==============================================================================

module Stoplight(
	input            clk,         // Clock signal
	input            rst,         // Reset signal for FSM
	input            car_present, // Is there a car on Prospect?
	output reg [2:0] light_pros,  // Prospect Avenue Light
	output reg [2:0] light_wash   // Washington Road Light
);

	// Variables for state and next state
	reg [3:0] state;
	reg [3:0] next_state;

	// Declare State Names Here
	localparam STATE_ZERO  = 4'd0;
	localparam STATE_ONE   = 4'd1;
	localparam STATE_TWO   = 4'd2;
	localparam STATE_THREE = 4'd3;
	localparam STATE_FOUR  = 4'd4;
	localparam STATE_FIVE  = 4'd5;
	localparam STATE_SIX   = 4'd6;
	localparam STATE_SEVEN = 4'd7;
	localparam STATE_EIGHT = 4'd8;
	localparam STATE_NINE  = 4'd9;
	localparam STATE_TEN   = 4'd10;

	// Light Colors
	localparam RED = 3'b001;
	localparam YLW = 3'b010;
	localparam GRN = 3'b100;

	// Output Combinational Logic
	always @( * ) begin
		light_pros = 3'b000;
		light_wash = 3'b000;

		// Write your output logic here
		if (state == STATE_ZERO) begin
			light_wash = GRN;
			light_pros = RED;
		end
		if (state == STATE_ONE) begin
			light_wash = GRN;
			light_pros = RED;
		end
		if (state == STATE_TWO) begin
			light_wash = GRN;
			light_pros = RED;
		end
		if (state == STATE_THREE) begin
			light_wash = GRN;
			light_pros = RED;
		end
		if (state == STATE_FOUR) begin
			light_wash = YLW;
			light_pros = RED;	
		end
		if (state == STATE_FIVE) begin
			light_wash = RED;
			light_pros = GRN;
		end
		if (state == STATE_SIX) begin
			light_wash = RED;
			light_pros = GRN;
		end
		if (state == STATE_SEVEN) begin
			light_wash = RED;
			light_pros = GRN;
		end
		if (state == STATE_EIGHT) begin
			light_wash = RED;
			light_pros = GRN;
		end
		if (state == STATE_NINE) begin
			light_wash = RED;
			light_pros = YLW;
		end
	end

	// Next State Combinational Logic
	always @( * ) begin
		if (state == STATE_ZERO) begin
			next_state = STATE_ONE;
		end 
		else if (state == STATE_ONE) begin
			next_state = STATE_TWO;
		end 
		else if (state == STATE_TWO) begin
			next_state = STATE_THREE;
		end 
		else if (state == STATE_THREE) begin
			if (car_present) begin
				next_state = STATE_FOUR;
			end
			else begin
				next_state = STATE_THREE;
			end
		end
		else if (state == STATE_FOUR) begin
			next_state = STATE_FIVE;
		end 
		else if (state == STATE_FIVE) begin
			next_state = STATE_SIX;
		end 
		else if (state == STATE_SIX) begin
			next_state = STATE_SEVEN;
		end 
		else if (state == STATE_SEVEN) begin
			next_state = STATE_EIGHT;
		end 
		else if (state == STATE_EIGHT) begin
			next_state = STATE_NINE;
		end 
		else if (state == STATE_NINE) begin
			next_state = STATE_ZERO;
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
