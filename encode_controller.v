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

reg [3:0] state; //0:��ʼ̬ 1������һ���� 2������������ ���� 8������˸���  ���� 15��ȷ��
wire [6 : 0] num_buffer [7 : 0]; //���뻺��,����
reg [4 : 0] result [7 : 0]; //���������������ĳ�����
wire row_key, confirm_key, backspace_key; //�����б����̰�����ȷ�ϰ��������ذ���
reg [5:0] current_state, next_state;    // ��̬����̬


//��������
multi_debounce row_out(clk, rst, row, row_key);
debounce confirm_out(clk, rst, confirm, confirm_key);
debounce backspace_out(clk, rst, backspace, backspace_key);
encoder_display dispalay(clk,rst,state,row,seg_en,seg_out);//��ʾ��������

always @ ( posedge clk or posedge rst) begin
        if(rst)
            state <= 4'b0000;
        else
            begin
            if(row_key) begin //����ɨ����ʱ��Ч����ʾ�а�������
                if(state < 4'b0100)//����û�б�
                    state <= state + 1'b1;
                 else
                    state <= state; //TODO: throw error   
            end 
//            if(confirm_key)
//                begin
//                if(state != 4'b1111)
//                    state <= 4'b1111 ;//�������������״̬
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
