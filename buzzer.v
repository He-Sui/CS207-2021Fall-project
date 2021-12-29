`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/16 22:01:44
// Design Name: 
// Module Name: buzzer
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


module buzzer(
    input clk		,		//ʱ������
	input rst  	,		//��λ��������
	input confirm,
	input [4:0] r0,r1,r2,r3,r4,r5,r6,r7,
	output reg buzzer			     //����������
	);
	parameter M0 = 98800,
                MS = 75850,
                ML = 75851;
        
        reg flag;
        reg [16:0] cnt0;    //����ÿ��������Ӧ��ʱ�����ڣ�һ�����ڴ�����������һ�Σ����Ƿǳ��̣�����������
        reg [10:0] cishu_cnt;    //����ÿ�������ظ��������ظ����������������켸�ξ���������
        reg [5 :0] LONG;    //��������������������48����5*8+8����8����ֹ��
        reg [10:0] cishu;    //���岻ͬ�����ظ���ͬ����
        wire [10:0] cishu_div;    //�����ظ�����ռ�ձ�
        reg [16:0] pre_set;    //Ԥװ��ֵ
        wire [16:0] pre_div;    //ռ�ձ�
        
        wire confirm_key;
        debounce confirm_out(clk,rst,confirm,confirm_key);
            
    //�����趨 flag ��Ĭ��ֵΪ 0,��confirm�ź�Ϊ1ʱ��ʼ���
    always @ (posedge clk or posedge rst) begin
        if(rst)
            flag<= 1'b0;
        else if(confirm_key)
            flag <= 1'b1;
    end 
    
    //���У��ʼ�����һ�����������ڣ�ֱ��������ͬ��������Ӧ��������
    //���ͻ���㣬���¿�ʼ������
    //�˴�Ӧ�����ڷ�Ƶ
    always @ (posedge clk or posedge rst) begin 
        if(rst)
            cnt0 <= 0;
        else if(confirm_key)
            cnt0 <= 0;
        else begin
             if(cnt0 == pre_set - 1)
                cnt0 <= 0;
             else 
                cnt0 <= cnt0 + 1;
         end
    end         
    
    //����һ�����ں󣬼��������ظ������ļ������ͻ� +1��
    //ֱ��������ͬ��������Ӧ���ظ����������ͻ���㣬���¿�ʼ������ 
    //����ÿ�������ظ�������Ҳ���Ǳ�ʾһ����������������ʱ��
        always @(posedge clk or posedge rst) begin
            if(rst)
               cishu_cnt <= 0;
            else if(confirm_key)
              cishu_cnt <= 0;
            else begin
              if(cnt0 == pre_set - 1)begin
                  if(cishu_cnt == cishu)
                      cishu_cnt <= 0;
                  else
                      cishu_cnt <= cishu_cnt + 1;
               end
             end
          end
     
    //�����ж��ٸ�������Ҳ�����������й����ٸ�����
    always @(posedge clk or posedge rst) begin
                  if(rst) begin
                      LONG <= 0;
                  end
                  else if(confirm_key)
                      LONG <= 0;
                  else begin
                      if(cishu_cnt == cishu & cnt0 == pre_set - 1) begin
                        if(LONG == 39) begin
                             LONG <= 0;
                        end
                        else
                            LONG <= LONG + 1;
                      end
                  end
              end
              
    //���������ظ�����
    always @ (*) begin
        case(pre_set)
            M0:cishu = 242;
            MS:cishu = 315;
            ML:cishu = 630;
        endcase
    end
    
    //����
    always @(posedge clk or posedge rst) begin
        if(rst)
            pre_set <= M0;//����д�������߼��������ǿ���������ʱ����ֹ����
        else if (flag == 1'b1) begin
            case(LONG)    
              0:case(r0[4])
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase
              1:case(r0[3])        
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase
              2:case(r0[2])
                    0:pre_set = MS;
                    1:pre_set = ML; 
                 endcase             
              3:case(r0[1])
                    0:pre_set = MS;
                    1:pre_set = ML;  
                 endcase            
              4:case(r0[0])
                    0:pre_set = MS;
                    1:pre_set = ML;    
                 endcase          
              5:pre_set = M0;
              
              6:case(r1[4])        
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase           
              7:case(r1[3])        
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase           
              8:case(r1[2])        
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase           
              9:case(r1[1])        
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase           
              10:case(r1[0])        
                    0:pre_set = MS;
                    1:pre_set = ML;
                 endcase           
              11:pre_set = M0;                   
              
              default : pre_set = M0;
            endcase
        end
    end
    
    assign pre_div = pre_set >> 1;    //����2
    assign cishu_div = cishu * 1/2;   //������һ��ʱ��ռ�ձ�Ϊ 1/2��Ҳ����ǰ 1/2 �������� 1/2 ��ʱ�䲻��������ֹ�������ϵĲ��ŷ�����
        
    //��������������
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            buzzer <= 1'b0;
        end
        else if(pre_set != M0) begin
            if(cishu_cnt < cishu_div) begin
                if(cnt0 < pre_div)
                    buzzer <= 1'b1;
                else
                    buzzer <= 1'b0;
            end
            else
                buzzer <= 1'b0;
            
            end 
        else
            buzzer <= 1'b0;
    end
endmodule

