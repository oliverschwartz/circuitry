//==============================================================================
// Stoplight Testbench Module for Lab 4
//==============================================================================
`timescale 1ns/100ps

`include "Stoplight.v"

module StoplightTest;

	// Local Vars
	reg clk = 1;
	reg rst = 0;
	reg car = 0;
	wire [2:0] lp, lw;

	// Light Colors
	localparam GRN = 3'b100;
	localparam YLW = 3'b010;
	localparam RED = 3'b001;

	// VCD Dump
	initial begin
		$dumpfile("StoplightTest.vcd");
		$dumpvars;
	end

	// Stoplight Module
	Stoplight light(
		.clk        (clk),
		.rst        (rst),
		.car_present(car),
		.light_pros (lp),
		.light_wash (lw)
	);

	// Clock
	always begin
		#2.5 clk = ~clk;
	end

	// Main Test Logic
	initial begin
		// Write your set of test cases here
		rst = 1;
		#5;
		rst = 0;
		#35;
		car = 1;
		#10;
		car = 0;
		#15;
		car = 1;
		#10;
		car = 1;
		#10;
		car = 0;
		#20;
		car = 1;
		#10;
		car = 0;
		#15;
		car = 1;
		#5;
		car = 0;
		#4;
		
		$finish;
	end

endmodule

