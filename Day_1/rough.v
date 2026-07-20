module bidi_cntr #(
    parameter CNT_MSB = 8
) (
    input clk,
    en,
    rst,
    load,
    direc,
    input [CNT_MSB - 1 : 0] ld_data,
    output max_tik,
    min_tik,
    output [CNT_MSB - 1 : 0] cnt
);
  reg [CNT_MSB - 1 : 0] cnt_prsnt, cnt_nxt;  // present state logic //    

  always @(posedge clk) begin
    if (rst) cnt_prsnt <= 0;
    else cnt_prsnt <= cnt_nxt;
  end  // next state logic //     

  always @(*) begin
    if (load) cnt_prsnt <= ld_data;
    else begin
      if (en & direc) cnt_nxt <= cnt_prsnt + 1'b1;
      if (cnt_nxt == 8'd181) cnt_nxt <= 8'b0;
      else if (en & ~direc) cnt_nxt = cnt_prsnt - 1'b0;
      if (cnt_nxt == 8'd0) cnt_nxt <= 8'd180;
      else cnt_nxt <= cnt_prsnt;
    end
  end  // drive cnt //     

  assign cnt = cnt_prsnt;
  assign max_tik = (cnt_prsnt == (2 ** CNT_MSB)) ? 1'b1 : 1'b0;
  assign min_tik = (cnt_prsnt == 0) ? 1'b1 : 1'b0;
endmodule
