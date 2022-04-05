`timescale 1ns / 1ps
module clock (
input clk, rst, output clkout
);
reg [19:0] cnt;

always @ (posedge clk or posedge rst)
  if (rst)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;
assign clkout = cnt[19];
endmodule