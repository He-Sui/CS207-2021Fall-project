`timescale 1ns / 1ps

module encode_controller(
input EN,
input [3:0] row,
input confirm,
input clk,
input rst,
input [1:0] speed_mode,
input [7 : 0] encoder_switch,
output [3:0] col,
output [7:0] seg_en,
output [7:0] seg_out,
output buzzer,
output [1:0] speed_led
);
assign {speed_led[1],speed_led[0]} = {speed_mode[1],speed_mode[0]};

wire row_key, backspace_key;
wire [7:0] buffer [7:0];
wire [4 : 0] result [7 : 0];
wire [3:0] state;
keyboard_to_result u0(EN, clk,rst,row,col,buffer[0],buffer[1],buffer[2],buffer[3],buffer[4],buffer[5],buffer[6],buffer[7],
result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],state);

encoder_display u1(clk,rst,state,buffer[0],buffer[1],buffer[2],buffer[3],buffer[4],buffer[5],buffer[6],buffer[7],seg_en,seg_out);//  ʾ        

buzzer u2(EN, clk,rst,confirm,state,result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],speed_mode, encoder_switch, buzzer);

endmodule
