module Decoder3x8(
    input [2:0] i,
    output [7:0] d
);
    // declare 3 wires for readability
    wire a = i[2];
    wire b = i[1];
    wire c = i[0];

    assign d[0] = ~a & ~b & ~c;
    assign d[1] = ~a & ~b & c;
    assign d[2] = ~a & b & ~c;
    assign d[3] = ~a & b & c;
    assign d[4] = a & ~b & ~c;
    assign d[5] = a & ~b & c;
    assign d[6] = a & b & ~c;
    assign d[7] = a & b & c;  

endmodule
