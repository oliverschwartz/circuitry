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

	// Declare Local Vars Here
	// reg [X:0] state;
	// reg [X:0] next_state;
	// ...

	// Declare State Names Here
	// localparam STATE_ONE = X'd0;
	// ...

	// Light Colors
	localparam RED = 3'b001;
	localparam YLW = 3'b010;
	localparam GRN = 3'b100;

	// Output Combinational Logic
	always @( * ) begin
		light_pros = 3'b000;
		light_wash = 3'b000;

		// Write your output logic here
	end

	// Next State Combinational Logic
	always @( * ) begin
		// Write your Next State Logic Here
		// next_state = ???
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			// state <= STATE_ONE;
		end
		else begin
			// Update state to next state
			// state <= next_state;
		end
	end

endmodule
