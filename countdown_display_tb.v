module tb_TLC_FSM;

  // DUT connections
  reg  clk, rst;
  wire [1:0] rA, rB;

  TLC_FSM uut ( .clk(clk), .rst(rst), .rA(rA), .rB(rB) );

  //10 ns period clock
  initial clk = 0;
  always  #5 clk = ~clk;      // toggles every 5 ns ⇒ 10 ns period
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_TLC_FSM); // Testbench level
    $dumpvars(0, uut);        // DUT signals inside FSM
  end


  //reset sequence
  initial begin
    rst = 1;
    #12 rst = 0;              // stays high past first posedge clk
  end

  // ---------- simulation run time ----------
  initial begin
    $display(" time   state rA rB timer_display");
    $monitor("%4t   %b   %b %b %d", $time, uut.state, rA, rB, uut.timer_display);
    #120 $finish;             // run long enough to see several cycles
  end

endmodule
