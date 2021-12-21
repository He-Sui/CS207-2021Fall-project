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

always @ ( posedge clk or posedge rst)
if(rst)
    delay <= 0;
else
    delay <= {delay[1:0], ori_signal} ;
assign pos_signal = delay[1] && ( ~delay[2] );
endmodule
