module Popcount(
    input [2:0] bitstring,
    output [1:0] popcount
);

    // introduce wire vars for readability
    wire a = bitstring[2];
    wire b = bitstring[1];
    wire c = bitstring[0];

    // boolean expression for bits 0 and 1
    assign popcount[0] = (~a&~b&c) | (~a&b&~c) | (a&~b&~c) | (a&b&c);
    assign popcount[1] = (~a&b&c) | (a&~b&c) | (a&b&~c) | (a&b&c);

endmodule
