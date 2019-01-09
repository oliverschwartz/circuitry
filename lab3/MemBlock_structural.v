module MemBlock(
	input x,
	input y,
	output q,
	output nq
);
    wire w0; 
    wire w1;
    wire w2;
    wire w3;

    // latch at top of diagram
	Latch l0(
        .ns(w0),
        .nr(x),
        .q(w1),
        .nq(w2)
    );

    // latch at bottom of page
    Latch l1(
        .ns(x & w2),
        .nr(y),
        .q(w3),
        .nq(w0)
    );

    // latch next to output
    Latch l2(
        .ns(w2),
        .nr(w3),
        .q(q),
        .nq(nq)
    );

endmodule
