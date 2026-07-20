`timescale 10ns / 10ps

// Wrapper module //
module cntr_bidi_max180_Top #(
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

  cntr_bidi_max180 #(BIT_WIDTH) instance0 (
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
module cntr_bidi_max180 #(
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
      if (en == 1'b1 & direction == 1'b1) begin
        cnt_next = cnt_present + 1'b1;
        if (cnt_next == 8'd181) cnt_next = {BIT_WIDTH{1'b0}};  // loop to 0 after 180 (B4 hex)
      end else if (en == 1'b1 & direction == 1'b0) begin
        cnt_next = cnt_present - 1'b1;
        if (cnt_next == 8'd1) cnt_next = 8'd180;  // loop to 180 (B4 hex) after 0
      end else cnt_next = cnt_present;
    end
  end

  // drive output //
  assign max_tick = (cnt_present == (2 ** BIT_WIDTH)) ? 1'b1 : 1'b0;
  assign min_tick = (cnt_present == 0) ? 1'b1 : 1'b0;

  assign count = cnt_present;
endmodule
