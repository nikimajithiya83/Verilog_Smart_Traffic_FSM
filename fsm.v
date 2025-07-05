module TLC_FSM (
    input  clk,
    input  rst,
    output reg [1:0] rA,
    output reg [1:0] rB
);

  //state encoding (one-hot)
  localparam S0 = 4'b0001,   // A-Green  B-Red
             S1 = 4'b0010,   // A-Yellow B-Red
             S2 = 4'b0100,   // A-Red    B-Green
             S3 = 4'b1000;   // A-Red    B-Yellow

  //colour codes
  localparam RED = 2'b00,
             YEL = 2'b01,
             GRN = 2'b10;

  //registers
  reg [3:0] state, next_state;

  //sequential part
  always @(posedge clk or posedge rst) begin
    if (rst)
      state <= S0;            // synchronous reset to S0
    else
      state <= next_state;
  end

  //next-state combinational logic
  always @(*) begin
    case (state)
      S0: next_state = S1;
      S1: next_state = S2;
      S2: next_state = S3;
      S3: next_state = S0;
      default: next_state = S0;
    endcase
  end

  //output logic
  always @(*) begin
    case (state)
      S0: begin rA = GRN; rB = RED; end
      S1: begin rA = YEL; rB = RED; end
      S2: begin rA = RED; rB = GRN; end
      S3: begin rA = RED; rB = YEL; end
      default: begin rA = RED; rB = RED; end
    endcase
  end

endmodule
