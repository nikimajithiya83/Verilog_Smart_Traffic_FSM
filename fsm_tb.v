module tb_TLC_FSM;

  // DUT connections
  reg  clk, rst;
  wire [1:0] rA, rB;

  TLC_FSM uut ( .clk(clk), .rst(rst), .rA(rA), .rB(rB) );

  //10 ns period clock
  initial clk = 0;
  always  #5 clk = ~clk;      // toggles every 5 ns ⇒ 10 ns period

  //reset sequence
  initial begin
    rst = 1;
    #12 rst = 0;              // stays high past first posedge clk
  end

  //simulation run time
  initial begin
    $display(" time   state rA rB");
    $monitor("%4t   %b   %b %b", $time, uut.state, rA, rB);
    #120 $finish;             // run long enough to see several cycles
  end

  //waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_TLC_FSM); // TB signals
    $dumpvars(0, uut);        // ALL signals inside the DUT
  end

endmodule
