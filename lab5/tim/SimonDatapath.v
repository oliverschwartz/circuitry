//==============================================================================
// Datapath for Simon Project
//==============================================================================

`include "Memory.v"

module SimonDatapath(
	// External Inputs
	input        clk,           // Clock
	input        level,        // Switch for setting level
	input  [3:0] pattern,       // Switches for creating pattern
	input        clear,
	input        increase,
	input        w_en,
	input done,

	// Datapath Control Signals
	input        mux_control,
	input		 [1:0] st,
	// Datapath Outputs to Control

	// External Outputs
	output   reg  InputValid,
	output   reg  RWeq,
	output   reg  InputEqPat,
	output   reg  [3:0]   pattern_leds
);

	// Declare Local Vars Here


	// fl 1 is the input mode
	// fl 2 is the playback mode
	// fl 3 is the repeat mode
	// fl 4 is the done mode
	reg [5:0] counter = 6'b000000;
	reg levelHOLD;
	wire rst;
	wire write;
	reg[5:0] hardCount = 6'b000000;
	wire [3:0] read;
	wire [1:0] fl1 = 2'b00;
	wire [1:0] fl2 = 2'b01;
	wire [1:0] fl3 = 2'b10;
	wire [1:0] fl4 = 2'b11;
	reg [3:0] patternOut;
	wire [1:0] sum = (pattern[0]+pattern[1]+pattern[2]+pattern[3]);
	always @(posedge clk) begin
		// Sequential Internal Logic Here
		if (clear) begin
				levelHOLD <= level;
				hardCount <= 6'b000000;
				counter <= 6'b000000;
		end
			if (increase) begin
				 hardCount <= hardCount + 6'b000001;
			end
				if(done)begin
				counter = 6'b000000;
				end
			if (st == fl1) begin
			end
			else if (st == fl2) begin
			if (counter >= hardCount) begin
				counter <= 6'b000000;
			end
			else begin
				counter <= counter +  6'b000001;
			end
			end
			else if (st == fl3) begin
			if (counter >= hardCount) begin
				counter <= 6'b000000;
			end
			else if (done == 0) begin
				counter <= counter +  6'b000001;
			end
			end
			else if (st == fl4) begin
				if ((counter >= hardCount) || (done)) begin
					counter <= 6'b000000;
				end
				else if (done == 0) begin
					counter <= counter +  6'b000001;
				end
			end
		end


	// 64-entry 4-bit memory (from Memory.v) -- Fill in Ports!
	Memory mem(
		.clk     (clk),
		.rst     (clear),
		.r_addr  (counter),
		.w_addr  (hardCount),
		.w_data  (pattern),
		.w_en    (w_en),
		.r_data  (read)
	);
	//----------------------------------------------------------------------
	// Output Logic -- Set Datapath Outputs
	//----------------------------------------------------------------------

	always @( * ) begin
	  pattern_leds = 4'b0000;
		InputEqPat = 0;
		RWeq = (counter == hardCount);
		InputValid = (((levelHOLD==0)&&(sum == 2'b01)) || (levelHOLD));
		// Output Logic Here
		if (pattern == read) begin
			InputEqPat = 1;
		end
		if (mux_control == 0) begin
			pattern_leds = pattern;
		end
		if (mux_control == 1) begin
			pattern_leds = read;
		end
		end


endmodule
