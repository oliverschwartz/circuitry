//==============================================================================
// Simon Module for Simon Project
//==============================================================================

`include "ButtonDebouncer.v"
`include "SimonControl.v"
`include "SimonDatapath.v"

module Simon(
	input        sysclk,
	input        pclk,
	input        rst,
	input        level,
	input  [3:0] pattern,

	output [3:0] pattern_leds,
	output [2:0] mode_leds
);

	// Declare local connections here
	wire InputValid, InputEqPat, RWeq, mux_control, clear, increase, w_en, done;
	wire [1:0] st;

	//============================================
	// Button Debouncer Section
	//============================================

	//--------------------------------------------
	// IMPORTANT!!!! If simulating, use this line:
	//--------------------------------------------
	wire uclk = pclk;
	//--------------------------------------------
	// IMPORTANT!!!! If using FPGA, use this line:
	//--------------------------------------------
	//wire uclk;
	//ButtonDebouncer debouncer(
	//	.sysclk(sysclk),
	//	.noisy_btn(pclk),
	//	.clean_btn(uclk)
	//);

	//============================================
	// End Button Debouncer Section
	//============================================

	// Datapath -- Add port connections
	SimonDatapath dpath(
		.clk           (uclk),
		.level         (level),
		.pattern       (pattern),

		.mux_control   (mux_control),
		.st						 (st),
		.clear         (clear),
		.increase      (increase),
		.w_en          (w_en),
		.done          (done),

		.InputValid    (InputValid),
		.RWeq          (RWeq),
		.InputEqPat    (InputEqPat),
		.pattern_leds  (pattern_leds)
	);


	// Control -- Add port connections
	SimonControl ctrl(
		.clk           (uclk),
		.rst           (rst),

		.InputValid    (InputValid),
		.RWeq          (RWeq),
		.InputEqPat    (InputEqPat),

		.mux_control   (mux_control),
		.st            (st),
		.clear         (clear),
		.increase      (increase),
		.w_en          (w_en),
		.done          (done),

		.mode_leds     (mode_leds)
	);

endmodule
