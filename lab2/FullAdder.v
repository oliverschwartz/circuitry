//==============================================================================
// One-Bit Full Adder Module
//==============================================================================

module FullAdder(
	input  a,  // Operand A
	input  b,  // Operand B
	input  ci, // Carry-In
	output s,  // Sum
	output co  // Carry-Out
);

	// combinational logic
	assign s = a^b^ci;                         // XOR all inputs together
	assign co = (a & b) | (b & ci) | (a & ci); // 3 way OR gate

endmodule
