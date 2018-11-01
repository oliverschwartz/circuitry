//==============================================================================
// Testbench for MemBlock
//==============================================================================

module MemBlock_test;

  // Local variables
  reg a, b;
  wire f, g;

  // VCD Dump
  initial begin
    $dumpfile("MemBlock_test.vcd");
    $dumpvars;
  end

  // MemBlock module
  MemBlock memblock(
    .x(a),
    .y(b),
    .q(f),
    .nq(g)
  );

  // Main test
  initial begin
    a = 0;
    b = 0;

    // all 11 transition cases
    a = 0;
    b = 1;
    #1
    a = 0;
    b = 0;
    #1
    a = 1;
    b = 0;
    #1
    a = 0;
    b = 0;
    #1
    a = 1;
    b = 1;
    #1
    a = 0;
    b = 1;
    #1
    a = 1;
    b = 1;
    #1 
    a = 1;
    b = 0;
    #1
    a = 0;
    b = 1;
    #1
    a = 1;
    b = 0;
    #1
    a = 1;
    b = 1;
    #1
    a = 0;
    b = 0;   

    $finish;
  end

endmodule
