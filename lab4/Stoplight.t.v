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
		// reset goes high
		$display("\nTime 1: Resetting the Controller (Washington -> GREEN)...");
		#1; rst = 1; @(posedge clk);
		
		// reset goes low
		$display("\nTime 6: Reset goes to low (Washington stays on GREEN)...");
		#4; rst = 0; @(posedge clk);
		#1;

		// check correct colours
		if (lp != RED || lw != GRN) begin
			$display("Error at time %t", $time);
		end
		
		// car signal goes high (car waiting on prospect)
		$display("\nTime 41: Car arrives on prospect (Washington -> YELLOW)...");
		#34; car = 1; @(posedge clk);
		#1;
		if (lp != RED || lw != YLW) begin
			$display("Error at time %t", $time);
		end
		
		#4; // at time 46 
		$display("\nTime 46: Car still waiting (Prospect -> GREEN)...");
		#1;
		if (lp != GRN || lw != RED) begin
			$display("Error at time %t", $time);
		end
		
		#4; car = 0; @(posedge clk); // at time 51
		$display("\nTime 51: Car gets green, has moved, car signal goes low ...");
		#1;
		if (lp != GRN || lw != RED) begin
			$display("Error at time %t", $time);
		end
		
		#14; car = 1; @(posedge clk); // at time 66
		$display("\nTime 66: Prospect green for 20 sec. More cars arrive (Prospect -> YELLOW) ...");
		#1;
		if (lp != YLW || lw != RED) begin
			$display("Error at time %t", $time);
		end
		
		#4; // at time 71
		$display("\nTime 71: Car signal still high, light finishes change (Washington -> GREEN, Propsect -> RED) ...");
		#1;
		if (lp != RED || lw != GRN) begin
			$display("Error at time %t", $time);
		end
		
		#4; // at time 76
		$display("\nTime 76: One car still trapped on Prospect ...");
		#1;
		if (lp != RED || lw != GRN) begin
			$display("Error at time %t", $time);
		end
		
		#9; car = 0; @(posedge clk); // at time 86
		$display("\nTime 86: Car makes right on red, car signal low ...");
		#1;
		if (lp != RED || lw != GRN) begin
			$display("Error at time %t", $time);
		end
		
		#19; car = 1; @(posedge clk); // at time 106
		$display("\nTime 106: Car appears, signal goes high (Washigton -> YELLOW) ...");
		#1;
		if (lp != RED || lw != YLW) begin
			$display("Error at time %t", $time);
		end
		
		#9; car = 0; @(posedge clk); // at time 116
		$display("\nTime 116: Car turns, signal goes low (Washigton is RED) ...");
		#1;
		if (lp != GRN || lw != RED) begin
			$display("Error at time %t", $time);
		end
		
		#14; car = 1; @(posedge clk); // at time 131
		$display("\nTime 131: Another car shows up (but it has been 20 sec.) ...");
		#1;
		if (lp != YLW || lw != RED) begin
			$display("Error at time %t", $time);
		end
		
		#4; car = 0; @(posedge clk); // at time 136
		$display("\nTime 136: Last car leaves ...");
		#1;
		if (lp != RED || lw != GRN) begin
			$display("Error at time %t", $time);
		end
		#3; 
		$finish;
	end

endmodule

