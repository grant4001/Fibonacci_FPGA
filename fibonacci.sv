module fibonacci 
  (
    input clk,
    input rst,
    input [63:0] number,
    input valid,
    output reg ready,
    output reg signed [63:0] index,
    output reg index_valid
  );
  
  reg [63:0] number_reg_next;
  reg [63:0] number_reg;
  reg state, state_next;
  reg [63:0] temp1;
  reg [63:0] temp1_next;
  reg [63:0] temp2;
  reg [63:0] temp2_next;
  reg signed [63:0] index_next;
  reg index_valid_next;
  
  always @(posedge clk or posedge rst)
    begin
      if (rst) begin
        number_reg <= 0;
        state <= 0;
        temp1 <= 0;
        temp2 <= 1;
        index <= 0;
        index_valid <= 0;
      end else begin
        number_reg <= number_reg_next;
        state <= state_next;
        temp1 <= temp1_next;
        temp2 <= temp2_next;
        index <= index_next;
        index_valid <= index_valid_next;
      end
    end
  
  always @(*) begin
    ready = 0;
    number_reg_next = number_reg;
    state_next = state;
    temp1_next = temp1;
    temp2_next = temp2;
    index_next = index;
    index_valid_next = 0;
    case (state)
      0 : 
        begin
          ready = 1;
          number_reg_next = number;
          if (valid) begin
            if (number == 0) begin
              state_next = 0;
              index_valid_next = 1;
              index_next = 0;
            end else if (number == 1) begin
              state_next = 0;
              index_valid_next = 1;
              index_next = 1;
            end else begin
              state_next = 1;
              index_next = 2;
              temp1_next = temp2;
              temp2_next = temp1 + temp2;
            end
          end
        end
      1 :
        begin
          if (temp2 > number_reg) begin
            state_next = 0;
            index_valid_next = 1;
            index_next = -1;
            temp1_next = 0;
            temp2_next = 1;
          end else if (temp2 == number_reg) begin
            state_next = 0;
            index_valid_next = 1;
            temp1_next = 0;
            temp2_next = 1;
          end else begin
            index_next = index + 1;
            temp1_next = temp2;
            temp2_next = temp1 + temp2;
          end
        end
    endcase
  end    
  
endmodule