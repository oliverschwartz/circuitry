module Popcount(
    input [2:0] bitstring,
    output [1:0] popcount
);
    reg [1:0] popcount;
    
    always @( * ) begin
        popcount[0] = (~bitstring[2]&~bitstring[1]&bitstring[0]) | (~bitstring[2]&bitstring[1]&~bitstring[0]) | (bitstring[2]&~bitstring[1]&~bitstring[0]) | (bitstring[2]&bitstring[1]&bitstring[0]);
        popcount[1] = (~bitstring[2]&bitstring[1]&bitstring[0]) | (bitstring[2]&~bitstring[1]&bitstring[0]) | (bitstring[2]&bitstring[1]&~bitstring[0]) | (bitstring[2]&bitstring[1]&bitstring[0]);
    end

endmodule