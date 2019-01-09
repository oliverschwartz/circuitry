//==============================================================================
// 8-bit Hierarchical Adder Module
//==============================================================================

`include "FullAdder.v"

module Adder8Hierarchical(
	input  [7:0] a,  // Operand A
	input  [7:0] b,  // Operand B
	input        ci, // Carry-In
	output [7:0] s,  // Sum
	output       co  // Carry-Out
);

	// Wire vector for carry-out and carry-in values
	wire [6:0] carry;

	// Instantiate eight FullAdder modules 
	// Connect them to the inputs and outputs appropriately.
	FullAdder adder0(
		.a(a[0]),
		.b(b[0]),
		.ci(ci),
		.s(s[0]),
		.co(carry[0])
	);

	FullAdder adder1(
		.a(a[1]),
		.b(b[1]),
		.ci(carry[0]),
		.s(s[1]),
		.co(carry[1])
	);

	FullAdder adder2(
		.a(a[2]),
		.b(b[2]),
		.ci(carry[1]),
		.s(s[2]),
		.co(carry[2])
	);

	FullAdder adder3(
		.a(a[3]),
		.b(b[3]),
		.ci(carry[2]),
		.s(s[3]),
		.co(carry[3])
	);

	FullAdder adder4(
		.a(a[4]),
		.b(b[4]),
		.ci(carry[3]),
		.s(s[4]),
		.co(carry[4])
	);

	FullAdder adder5(
		.a(a[5]),
		.b(b[5]),
		.ci(carry[4]),
		.s(s[5]),
		.co(carry[5])
	);

	FullAdder adder6(
		.a(a[6]),
		.b(b[6]),
		.ci(carry[5]),
		.s(s[6]),
		.co(carry[6])
	);
	
	FullAdder adder7(
		.a(a[7]),
		.b(b[7]),
		.ci(carry[6]),
		.s(s[7]),
		.co(co)
	);

endmodule
