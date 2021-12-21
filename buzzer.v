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
    input				clk		,		//ʱ������
	input				rst_n	,		//��λ��������
	input				key_in	,		//��������
	
	output	reg			buzzer			//����������
	);
	
	wire				press	;		//�ߣ����Ӱ�����־�ź�
	
	//���ð���ģ��
	
	//��������ʱ��������
	localparam			M0 	= 98800,
						M1	= 95600,//DO
						M2	= 85150,//RE
						M3	= 75850,//MI
						M4	= 71600,//FA
						M5  = 63750,//SO
						M6	= 56800,//LA
						M7	= 50600;//TI
	
	//�źŶ���
	reg		[16:0]		cnt0		;	//����ÿ��������Ӧ��ʱ������
	reg		[10:0]		cnt1		;	//����ÿ�������ظ�����
	reg		[5 :0]		cnt2		;	//������������������
	
	reg		[16:0]		pre_set		;	//Ԥװ��ֵ
	wire	[16:0]		pre_div		;	//ռ�ձ�
	
	reg		[10:0]		cishu		;	//���岻ͬ�����ظ���ͬ����
	wire	[10:0]		cishu_div	;	//�����ظ�����ռ�ձ�
	
	reg 				flag		;	//���������־��0С���ǣ�1��ֻ�ϻ�
	reg		[5 :0]		YINFU		;	//������������������
	
	//���������־λ
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			flag <= 1'b0;
		end
		else if(press) begin
			flag <= ~flag;
		end
	end
	
	//���������ĸ���
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			YINFU <= 48;//С����
		else if(flag == 1'b1)
			YINFU <= 36;//��ֻ�ϻ�
		else
			YINFU <= 48;
	end
	
	//����ÿ�����������ڣ�Ҳ���Ǳ�ʾ������һ������
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt0 <= 0;
		end
		else if (press)
			cnt0 <= 0;
		else begin
			if(cnt0 == pre_set - 1) 
				cnt0 <= 0;
			else
				cnt0 <= cnt0 + 1;
		end
	end
	
	//����ÿ�������ظ�������Ҳ���Ǳ�ʾһ����������������ʱ��
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt1 <= 0;
		end
		else if(press)
			cnt1 <= 0;
		else begin
			if(cnt0 == pre_set - 1)begin
				if(cnt1 == cishu)
					cnt1 <= 0;
				else
					cnt1 <= cnt1 + 1;
			end
		end
	end
	
	//�����ж��ٸ�������Ҳ�����������й����ٸ�����
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt2 <= 0;
		end
		else if(press)
			cnt2 <= 0;
		else begin
			if(cnt1 == cishu && cnt0 == pre_set - 1) begin
				if(cnt2 == YINFU - 1) begin
					cnt2 <= 0;
				end
				else
					cnt2 <= cnt2 + 1;
			end
		end
	end
	
	
	//���׶���
	always @(*) begin
		if(flag == 1'b0) begin
			case(cnt2)	//С���Ǹ���
				0 : pre_set = M1;
				1 : pre_set = M1;
				2 : pre_set = M5;
				3 : pre_set = M5;
				4 : pre_set = M6;
				5 : pre_set = M6;
				6 : pre_set = M5;
				7 : pre_set = M0;
				
				8 : pre_set = M4;
				9 : pre_set = M4;
				10: pre_set = M3;
				11: pre_set = M3;
				12: pre_set = M2;
				13: pre_set = M2;
				14: pre_set = M1;
				15: pre_set = M0;
				
				16: pre_set = M5;
				17: pre_set = M5;
				18: pre_set = M4;
				19: pre_set = M4;
				20: pre_set = M3;
				21: pre_set = M3;
				22: pre_set = M2;
				23: pre_set = M0;
				
				24: pre_set = M5;
				25: pre_set = M5;
				26: pre_set = M4;
				27: pre_set = M4;
				28: pre_set = M3;
				29: pre_set = M3;
				30: pre_set = M2;
				31: pre_set = M0;
				
				32: pre_set = M1;
				33: pre_set = M1;
				34: pre_set = M5;
				35: pre_set = M5;
				36: pre_set = M6;
				37: pre_set = M6;
				38: pre_set = M5;
				39: pre_set = M0;
				
				40: pre_set = M4;
				41: pre_set = M4;
				42: pre_set = M3;
				43: pre_set = M3;
				44: pre_set = M2;
				45: pre_set = M2;
				46: pre_set = M1;
				47: pre_set = M0;
			endcase
		end
		else begin
			case(cnt2)	//��ֻ�ϻ�����
				0 : pre_set = M1;
				1 : pre_set = M2;
				2 : pre_set = M3;
				3 : pre_set = M1;
				4 : pre_set = M1;
				5 : pre_set = M2;
				6 : pre_set = M3;
				7 : pre_set = M1;
				8 : pre_set = M3;
				9 : pre_set = M4;
				10: pre_set = M5;
				11: pre_set = M0;
				
				12: pre_set = M3;
				13: pre_set = M4;
				14: pre_set = M5;
				15: pre_set = M0;
				
				16: pre_set = M5;
				17: pre_set = M6;
				18: pre_set = M5;
				19: pre_set = M4;
				20: pre_set = M3;
				21: pre_set = M1;
				22: pre_set = M5;
				23: pre_set = M6;
				24: pre_set = M5;
				25: pre_set = M4;
				26: pre_set = M3;
				27: pre_set = M1;
				28: pre_set = M2;
				29: pre_set = M5;
				30: pre_set = M1;
				31: pre_set = M0;
				
				32: pre_set = M2;
				33: pre_set = M5;
				34: pre_set = M1;
				35: pre_set = M0;
			endcase
		end
	end
	
	//���������ظ�����
        always @(*) begin
            case(pre_set)
                M0:cishu = 242;
                M1:cishu = 250;
                M2:cishu = 281;
                M3:cishu = 315;
                M4:cishu = 334;
                M5:cishu = 375;
                M6:cishu = 421;
                M7:cishu = 472;
            endcase
        end
	
	assign pre_div = pre_set >> 1;	//����2
	assign cishu_div = cishu * 4 / 5;
	
	//��������������
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			buzzer <= 1'b1;
		end
		else if(pre_set != M0) begin
			if(cnt1 < cishu_div) begin
				if(cnt0 < pre_div) begin
						buzzer <= 1'b1;
				end
				else begin
						buzzer <= 1'b0;
				end
			end
			else begin
				buzzer <= 1'b1;
			end
		end
		else
			buzzer <= 1'b1;
	end

endmodule
