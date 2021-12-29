`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/16 16:22:10
// Design Name: 
// Module Name: encode_controller
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


module encode_controller(
input [3:0] row,
input confirm,
input clk,
input rst,
input backspace,
output [3:0] col,
output [7:0] seg_en,
output [7:0] seg_out,
output [3:0] state,
output buzzer
);
 //0:初始态 1：输入一个数 2：输入两个数 …… 8：输入八个数  …… 15：确认


wire row_key, backspace_key; //敏感列表：键盘按键、确认按键、撤回按键
wire [7:0] buffer [7:0];
wire [4 : 0] result [7 : 0]; //经过编码器编码后的长短码

keyboard_to_result u0(clk,rst,row,col,buffer[0],buffer[1],buffer[2],buffer[3],buffer[4],buffer[5],buffer[6],buffer[7],
result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],state);

encoder_display u1(clk,rst,state,buffer[0],buffer[1],buffer[2],buffer[3],buffer[4],buffer[5],buffer[6],buffer[7],seg_en,seg_out);//显示键盘输入

buzzer u2(clk,rst,confirm,result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],buzzer);
//按键防抖

debounce backspace_out(clk, rst, backspace, backspace_key);


//always @ ( posedge clk or posedge rst) begin
//        if(rst) begin
//            buffer[0] <= 8'b0;
//            buffer[1] <= 8'b0;
//            buffer[2] <= 8'b0;
//            buffer[3] <= 8'b0;
//            buffer[4] <= 8'b0;
//            buffer[5] <= 8'b0;
//            buffer[6] <= 8'b0;
//            buffer[7] <= 8'b0;
//            end
//        else
//            begin
//            if(row_key) begin //键盘扫描行时有效，表示有按键按下
//                if(state < 4'b1000) begin//输入没有爆
//                    buffer[state] <= bufferout;
//                    result[state] <= resultout;
//                    state <= state + 1'b1;
//                    end
//                 else
//                    state <= state; //TODO: throw error   
//            end 
//            if(confirm_key)
//                begin
//                if(state != 4'b1111)
//                    state <= 4'b1111 ;//进入蜂鸣器嗡鸣状态
//                else     
//                    state <= state; //TODO: throw error
//                end
//            if(backspace_key)
//                begin
//                if(state != 4'b0000)
                
//                end
//           end
endmodule
