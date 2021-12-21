`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/16 14:16:02
// Design Name: 
// Module Name: encoder
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


module encoder(
input [3:0] number,//输入的数字
output reg [4:0] code //每个数字对应的摩尔编码为5位,1表示长码，0表示短码
);
always @ (*)
    begin
       case (number)
            4'b0000: code = 5'b11111;//0
            4'b0001: code = 5'b01111;//1
            4'b0010: code = 5'b00111;//2
            4'b0011: code = 5'b00011;//3
            4'b0100: code = 5'b00001;//4
            4'b0101: code = 5'b00000;//5
            4'b0110: code = 5'b10000;//6
            4'b0111: code = 5'b11000;//7
            4'b1000: code = 5'b11100;//8
            4'b1001: code = 5'b11110;//9
            default: code = 5'b10101;
        endcase
    end
endmodule
