`timescale 1ns / 1ps

module mod_10_up_cntr_tb ();
  reg clk, en, rst;
  wire [3:0] cnt;
  integer i;

  mod_10_counter_Top dut (
      .clk(clk),
      .en (en),
      .rst(rst),
      .cnt(cnt)
  );

  initial begin
    clk = 1'b0;
    rst = 1'b0;
    en  = 1'b0;
  end

  always #1 clk = ~clk;

  initial begin
    #10 rst = 1'b1;
    #10 en = 1'b1;
    #10 rst = 1'b0;

    for (i = 0; i < 16; i = i + 1) begin
      @(posedge clk);
    end

    #10 $finish();
  end

endmodule
