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
    input clk		,		//时钟输入
	input rst  	,		//复位按键输入
	input confirm,
	input [4:0] r0,r1,r2,r3,r4,r5,r6,r7,
	output reg buzzer			     //驱动蜂鸣器
	);
	parameter M0 = 98800,
                MS = 75850,
                ML = 75851;
        
        reg flag;
        reg [16:0] cnt0;    //计数每个音符对应的时序周期，一个周期触发蜂鸣器响一次，但是非常短，耳朵听不到
        reg [10:0] cishu_cnt;    //计数每个音符重复次数，重复周期数，让它多响几次就能听到了
        reg [5 :0] LONG;    //计数曲谱中音符个数，48个，5*8+8，有8个休止符
        reg [10:0] cishu;    //定义不同音符重复不同次数
        wire [10:0] cishu_div;    //音符重复次数占空比
        reg [16:0] pre_set;    //预装载值
        wire [16:0] pre_div;    //占空比
        
        wire confirm_key;
        debounce confirm_out(clk,rst,confirm,confirm_key);
            
    //首先设定 flag 的默认值为 0,当confirm信号为1时开始输出
    always @ (posedge clk or posedge rst) begin
        if(rst)
            flag<= 1'b0;
        else if(confirm_key)
            flag <= 1'b1;
    end 
    
    //其中，最开始会计数一个音符的周期，直至计满不同音符所对应的周期数
    //它就会归零，重新开始计数。
    //此处应该是在分频
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
    
    //计满一个周期后，计数周期重复次数的计数器就会 +1，
    //直至计满不同音符所对应的重复次数，它就会归零，重新开始计数。 
    //计数每个音符重复次数，也就是表示一个音符的响鸣持续时长
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
     
    //计数有多少个音符，也就是曲谱中有共多少个音符
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
              
    //定义音符重复次数
    always @ (*) begin
        case(pre_set)
            M0:cishu = 242;
            MS:cishu = 315;
            ML:cishu = 630;
        endcase
    end
    
    //编码
    always @(posedge clk or posedge rst) begin
        if(rst)
            pre_set <= M0;//这样写相比组合逻辑的优势是可以在任意时刻终止播放
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
    
    assign pre_div = pre_set >> 1;    //除以2
    assign cishu_div = cishu * 1/2;   //设置了一个时间占空比为 1/2，也就是前 1/2 发声，后 1/2 的时间不发声，防止连续不断的播放发音。
        
    //向蜂鸣器输出脉冲
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

