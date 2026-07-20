`timescale 1ns / 1ps

// Wrapper module //
module down_counter_Top (
    input clk,
    en,
    rst,
    output [3:0] cnt
);

  down_counter instance0 (
      .clk(clk),
      .en (en),
      .rst(rst),
      .cnt(cnt)
  );

endmodule


// Actual logic module //
module down_counter (
    input clk,
    en,
    rst,
    output [3:0] cnt
);
  reg [3:0] cnt_present, cnt_next;  //following State Machine theory

  // present state update logic //
  always @(posedge clk) begin
    if (rst) begin
      cnt_present <= 4'b1;
    end else begin
      cnt_present <= cnt_next;
    end
  end

  // next state update logic //
  always @(*) begin
    if (en) begin
      cnt_next = cnt_present - 1;
    end else begin
      cnt_next = cnt_present;
    end
  end

  // drive output //
  assign cnt = cnt_present;

endmodule
