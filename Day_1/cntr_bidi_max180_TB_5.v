`timescale 1ns / 1ps

module cntr_bidi_max180_TB ();
  parameter BIT_WIDTH = 8;
  reg clk, rst, en, load, direction;
  reg [BIT_WIDTH - 1 : 0] load_data;
  wire max_tick, min_tick;
  wire [BIT_WIDTH - 1 : 0] count;
  integer i = 0;

  cntr_bidi_max180_Top #(BIT_WIDTH) dut (
      .clk(clk),
      .rst(rst),
      .en(en),
      .load(load),
      .direction(direction),
      .load_data(load_data),
      .max_tick(max_tick),
      .min_tick(min_tick),
      .count(count)
  );

  initial begin
    clk = 1'b0;
    rst = 1'b0;
    en = 1'b0;
    load = 1'b0;
    direction = 1'b0;
    load_data = 8'd0;
  end

  always #1 clk = ~clk;

  initial begin
    #4 rst = 1'b1;
    #4 en = 1'b1;
    #4 rst = 1'b0;

    load_data = 8'd4;
    load = 1'b1;
    #4 load = 1'b0;
    load_data = 8'b0;

    for (i = 0; i < 10; i = i + 1) begin
      @(posedge clk);
    end

    #4 rst = 1'b1;
    direction = 1'b1;
    #4 en = 1'b1;
    #4 rst = 1'b0;

    load_data = 8'd176;
    load = 1'b1;
    #4 load = 1'b0;
    load_data = 8'b0;

    for (i = 0; i < 10; i = i + 1) begin
      @(posedge clk);
    end

    #4 $finish();

  end

endmodule
