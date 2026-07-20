`timescale 10ns / 10ps

// Wrapper module //
module cntr_bidirectional_Top #(
    parameter BIT_WIDTH = 8
) (
    input clk,
    rst,
    en,
    load,
    direction,
    input [BIT_WIDTH - 1 : 0] load_data,
    output max_tick,
    min_tick,
    output [BIT_WIDTH - 1 : 0] count
);

  cntr_bidirectional #(BIT_WIDTH) instance0 (
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

endmodule


// Actual logic module //
module cntr_bidirectional #(
    parameter BIT_WIDTH = 8
) (
    input clk,
    rst,
    en,
    load,
    direction,
    input [BIT_WIDTH - 1 : 0] load_data,
    output max_tick,
    min_tick,
    output [BIT_WIDTH - 1 : 0] count
);
  reg [BIT_WIDTH - 1 : 0] cnt_present, cnt_next;  //following State Machine theory

  // present state update logic //
  always @(posedge clk) begin
    if (rst) cnt_present <= {BIT_WIDTH{1'b0}};
    else cnt_present <= cnt_next;
  end

  // next state update logic //
  always @(*) begin
    if (load) cnt_present = load_data;
    else begin
      if (en == 1'b1 & direction == 1'b1)
        cnt_next = cnt_present + 1'b1;  //over flow loops to all 0s
      else if (en == 1'b1 & direction == 1'b0)
        cnt_next = cnt_present - 1'b1;  //overflow loops to all 1s
      else cnt_next = cnt_present;
    end
  end

  // drive output //
  assign max_tick = (cnt_present == (2 ** BIT_WIDTH)) ? 1'b1 : 1'b0;
  assign min_tick = (cnt_present == 0) ? 1'b1 : 1'b0;

  assign count = cnt_present;
endmodule
