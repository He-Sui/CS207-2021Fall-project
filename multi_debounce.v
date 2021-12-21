`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/21 21:33:26
// Design Name: 
// Module Name: multi_debounce
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


module multi_debounce(
input clk, rst, 
inout [3:0]ori_signal, 
output pos_signal
);

reg [2:0] delay;

always @ ( posedge clk or posedge rst)
if(rst)
    delay <= 0;
else
    delay <= {delay[1:0], ~(ori_signal[0]+ori_signal[1]+ori_signal[2]+ori_signal[3])} ;
assign pos_signal = delay[1] && ( ~delay[2] );
endmodule
