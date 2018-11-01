module Latch(
  input ns,
  input nr,
  output q,
  output nq
);

  reg q;
  reg nq;

  always @( * ) begin
    q  <= ns ~& nq;
    nq <= nr ~& q;
  end

endmodule
