module testbench;
  
  reg clk_t;
  reg rst_t;
  reg [63:0] number_t;
  reg valid_t;
  reg ready_t;
  reg signed [63:0] index_t;
  reg index_valid_t;
  
  task test_num;
    input [63:0] my_num;
    begin
      valid_t <= 1;
      number_t <= my_num;
      #15;
      wait (index_valid_t);
      $display(" << At time %gns: The index of %0d is %0d. >> ", $time, number_t, index_t);
      wait (ready_t);
    end
  endtask
  
  fibonacci DUT 
  (
    .clk	(clk_t),
    .rst	(rst_t),
    .number	(number_t),
    .valid	(valid_t),
    .ready	(ready_t),
    .index	(index_t),
    .index_valid	(index_valid_t)
  );
  
  always #5 clk_t <= ~clk_t;
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
  initial begin
    $display(" << Starting simulation. >> ");
    clk_t <= 0;
    rst_t <= 0;
    number_t <= 0;
    valid_t <= 0;
    
    $display(" << Reset started. >> ");
    #10 rst_t <= 1;
    #10 rst_t <= 0;
    $display(" << Reset finished. >> ");
    wait (ready_t);
    
    test_num(0);
    test_num(1);
    test_num(2);
    test_num(3);
    test_num(4);
    test_num(5);
    test_num(20);
    test_num(21);
    test_num(22);
    test_num(88);
    test_num(89);
    test_num(64'hA94FAD42221F2702);
    test_num(64'hA94FAD42221F2701);
    
    #20 $finish;
  end
  
endmodule