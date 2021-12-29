`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/16 15:35:01
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce(
input clk, rst, ori_signal, output pos_signal
);
reg[2:0] delay;
parameter period = 200000;
reg [31:0] cnt;
reg clkout;
always @(posedge clk, posedge rst) begin
if(rst)
begin
    clkout <= 0;
    cnt <= 0;
end
else 
if(cnt == (period >> 1) - 1)
begin
    clkout <= ~clkout;
    cnt <= 0;
end

else
    cnt <= cnt + 1;
end

always @ ( posedge clkout or posedge rst)
if(rst)
    delay <= 0;
else
    delay <= {delay[1:0], ori_signal} ;
assign pos_signal = delay[1] && ( ~delay[2] );
endmodule
