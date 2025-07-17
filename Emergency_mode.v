module TLC_FSM (
    input  clk,
    input  rst,
    input ped_req, //pedestrian request call
    input emergency, //emergency mode
    output reg [1:0] rA,
    output reg [1:0] rB
);

  //state encoding (one-hot)
  localparam S0 = 5'b0001,   // A-Green  B-Red
             S1 = 5'b0010,   // A-Yellow B-Red
             S2 = 5'b0100,   // A-Red    B-Green
             S3 = 5'b1000,   // A-Red    B-Yellow
             S4 = 5'b10000; // One-hot S4: Pedestrian walk

  //colour codes
  localparam RED = 2'b00,
             YEL = 2'b01,
             GRN = 2'b10;

  //registers
  reg [4:0] state, next_state;
  
  //timers
  parameter T_S0=5;
  parameter T_S1=2;
  parameter T_S2=5;
  parameter T_S3=2;
  parameter T_S4=4;
  
  reg[2:0] count;
  
  reg[2:0] timer_display;

  //sequential part
  always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= S0;
    count <= 0;
  end
    if(emergency) begin
      state<=S4;
      count<=0;
      
  end else begin
    case (state)
      S0: begin
        if (count < T_S0 - 1) begin
             count <= count + 1;
             state <= S0;
        end else if(ped_req) begin
           count<=0;
           state<=S4;
          end else begin
             count <= 0;
             state <= S1;
          end
        timer_display<=T_S0 - count;
      end
      

      S1: begin
        if (count < T_S1 - 1) begin
             count <= count + 1;
             state <= S1;
        end else if(ped_req) begin
           count<=0;
           state<=S4;
          end else begin
             count <= 0;
             state <= S2;
          end
        timer_display<=T_S1-count;
      end

      S2: begin
        if (count < T_S2 - 1) begin
             count <= count + 1;
             state <= S2;
        end else if(ped_req) begin
            count<=0;
            state<=S4;
          end else begin
             count <= 0;
             state <= S3;
          end
        timer_display<=T_S2-count;
      end

      S3: begin
        if (count < T_S3 - 1) begin
             count <= count + 1;
             state <= S3;
        end else if(ped_req) begin
          count<=0;
          state<=S4;
          end else begin
             count <= 0;
             state <= S0;
          end
        timer_display<=T_S3-count;
      end
      S4: begin
        if(count<T_S4 - 1) begin
          count<=count+1;
          state<=S4;
        end else begin
          count<=0;
          state<=S0;
        end
      end

      default: begin
        count <= 0;
        state <= S0;
      end
    endcase
  end
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
