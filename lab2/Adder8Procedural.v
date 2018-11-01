//==============================================================================
// 8-bit Procedural Adder Module
//==============================================================================

module Adder8Procedural(
	input      [7:0] a,  // Operand A
	input      [7:0] b,  // Operand B
	input            ci, // Carry-In
	output reg [7:0] s,  // Sum
	output reg       co  // Carry-Out
);
	// declare register to hold sum
	reg [8:0] tmp;

	// use arithmetic operators to simulate 8-bit adder
	always @( * ) begin
		tmp = a + b + ci;
		s = tmp[7:0];
		co = tmp[8];     // store largest bit in carry-out
	end

endmodule
