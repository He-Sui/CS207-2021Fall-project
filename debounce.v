`timescale 1ns / 1ps
module debounce (
input clk, rst, ori_signal, output pos_signal
);
reg[2:0] delay;

always @ ( posedge clk or posedge rst)
if(rst)
    delay <= 0;
else
    delay <= { delay[1:0], ori_signal} ;

assign pos_signal = delay[1] && ( ~delay[2] );

endmodule