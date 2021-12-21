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
output [7:0] seg_en,
output [7:0] seg_out
);

reg [3:0] state; //0:初始态 1：输入一个数 2：输入两个数 …… 8：输入八个数  …… 15：确认
wire [6 : 0] num_buffer [7 : 0]; //输入缓存,储存
reg [4 : 0] result [7 : 0]; //经过编码器编码后的长短码
wire row_key, confirm_key, backspace_key; //敏感列表：键盘按键、确认按键、撤回按键
reg [5:0] current_state, next_state;    // 现态、次态


//按键防抖
multi_debounce row_out(clk, rst, row, row_key);
debounce confirm_out(clk, rst, confirm, confirm_key);
debounce backspace_out(clk, rst, backspace, backspace_key);
encoder_display dispalay(clk,rst,state,row,seg_en,seg_out);//显示键盘输入

always @ ( posedge clk or posedge rst) begin
        if(rst)
            state <= 4'b0000;
        else
            begin
            if(row_key) begin //键盘扫描行时有效，表示有按键按下
                if(state < 4'b0100)//输入没有爆
                    state <= state + 1'b1;
                 else
                    state <= state; //TODO: throw error   
            end 
//            if(confirm_key)
//                begin
//                if(state != 4'b1111)
//                    state <= 4'b1111 ;//进入蜂鸣器嗡鸣状态
//                else     
//                    state <= state; //TODO: throw error
//                end
            if(backspace_key)
                begin
                if(state != 4'b0000)
                state <= state - 1;
                end
            end    
       end
endmodule
