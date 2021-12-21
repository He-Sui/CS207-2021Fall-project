`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/20 16:28:18
// Design Name: 
// Module Name: encoder_display
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


module encoder_display(
    input clk,
    input rst,
    input [3:0] state,//需要展示的个数
    input [3:0] row,
    output [7:0] seg_en,//big selection
    output [7:0] seg_out  //seg selection
   
);
 reg [3:0] col;                // 矩阵键盘 列
//++++++++++++++++++++++++++++++++++++++
// 分频部分 开始
//++++++++++++++++++++++++++++++++++++++
reg [19:0] cout;                         // 计数子
wire key_clk;

always @ (posedge clk or posedge rst)
 if (rst)
   cout <= 0;
 else
   cout <= cout + 1'b1;
   
assign key_clk = cout[19];                // (2^20/50M = 21)ms 
//--------------------------------------
// 分频部分 结束
//--------------------------------------

//++++++++++++++++++++++++++++++++++++++
// 状态机部分 开始
//++++++++++++++++++++++++++++++++++++++
// 状态数较少，独热码编码
parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下  
parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列 
parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列 
parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列 
parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列 
parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下

reg [5:0] current_state, next_state;    // 现态、次态


reg [6:0] buffer [7:0];//寄存传入的数


always @ (posedge key_clk or posedge rst)
 if (rst)
   current_state <= NO_KEY_PRESSED;
 else
   current_state <= next_state;

// 根据条件转移状态
always @ (*)
 case (current_state)
   NO_KEY_PRESSED :                    // 没有按键按下
       if (row != 4'hF)
         next_state = SCAN_COL0;
       else
         next_state = NO_KEY_PRESSED;
   SCAN_COL0 :                         // 扫描第0列 
       if (row != 4'hF)
         next_state = KEY_PRESSED;
       else
         next_state = SCAN_COL1;
   SCAN_COL1 :                         // 扫描第1列 
       if (row != 4'hF)
         next_state = KEY_PRESSED;
       else
         next_state = SCAN_COL2;    
   SCAN_COL2 :                         // 扫描第2列
       if (row != 4'hF)
         next_state = KEY_PRESSED;
       else
         next_state = SCAN_COL3;
   SCAN_COL3 :                         // 扫描第3列
       if (row != 4'hF)
         next_state = KEY_PRESSED;
       else
         next_state = NO_KEY_PRESSED;
   KEY_PRESSED :                       // 有按键按下
       if (row != 4'hF)
         next_state = KEY_PRESSED;
       else
         next_state = NO_KEY_PRESSED;                      
 endcase

reg       key_pressed_flag;             // 键盘按下标志
reg [3:0] col_val, row_val;             // 列值、行值

// 根据次态，给相应寄存器赋值
always @ (posedge key_clk or posedge rst)
 if (rst)
 begin
   col              <= 4'h0;
   key_pressed_flag <=    0;
 end
 else
   case (next_state)
     NO_KEY_PRESSED :                  // 没有按键按下
     begin
       col              <= 4'h0;
       key_pressed_flag <=    0;       // 清键盘按下标志
     end
     SCAN_COL0 :                       // 扫描第0列
       col <= 4'b1110;
     SCAN_COL1 :                       // 扫描第1列
       col <= 4'b1101;
     SCAN_COL2 :                       // 扫描第2列
       col <= 4'b1011;
     SCAN_COL3 :                       // 扫描第3列
       col <= 4'b0111;
     KEY_PRESSED :                     // 有按键按下
     begin
       col_val          <= col;        // 锁存列值
       row_val          <= row;        // 锁存行值
       key_pressed_flag <= 1;          // 置键盘按下标志  
     end
   endcase
//--------------------------------------
// 状态机部分 结束
//--------------------------------------


//++++++++++++++++++++++++++++++++++++++
// 扫描行列值部分 开始
//++++++++++++++++++++++++++++++++++++++

always @ (posedge key_clk or posedge rst)
 if (rst) begin
   buffer[0] <= 7'h0;
   buffer[1] <= 7'h0;
   buffer[2] <= 7'h0;
   buffer[3] <= 7'h0;
   buffer[4] <= 7'h0;
   buffer[5] <= 7'h0;
   buffer[6] <= 7'h0;
   buffer[7] <= 7'h0;
   end
 else
   if (key_pressed_flag)
     case ({col_val, row_val})
       8'b1110_1110 : buffer[state] <= 7'b0000110;//1
       8'b1110_1101 : buffer[state] <= 7'b1100110;//4
       8'b1110_1011 : buffer[state] <= 7'b0100111;//7

       8'b1101_1110 : buffer[state] <= 7'b1011011;//2
       8'b1101_1101 : buffer[state] <= 7'b1101101;//5
       8'b1101_1011 : buffer[state] <= 7'b1111111;//8
       8'b1101_0111 : buffer[state] <= 7'b0111111;//0
        
       8'b1011_1110 : buffer[state] <= 7'b1001111;//3
       8'b1011_1101 : buffer[state] <= 7'b1111101;//6
       8'b1011_1011 : buffer[state] <= 7'b0010000;//9
//        8'b1011_0111 : keyboard_val <= 4'hF;
//        8'b1110_0111 : keyboard_val <= 4'hE;
//        8'b0111_1110 : keyboard_val <= 4'hA; 
//        8'b0111_1101 : keyboard_val <= 4'hB;
//        8'b0111_1011 : keyboard_val <= 4'hC;
//        8'b0111_0111 : keyboard_val <= 4'hD; 
       default : buffer[state] <= 7'b0000000;
     endcase
//--------------------------------------
//  扫描行列值部分 结束
//--------------------------------------

//-------------------------------------------------------------------显示--------------------------------------------------------------------------
//--------------------------------------
//  数码管译码显示
//--------------------------------------
reg clkout;
reg [31:0] cnt;
reg [2:0] scan_cnt;
parameter period = 200000;

reg [6:0] Y_r;
reg [7:0] DIG_r;
assign seg_out = {1'b1,(~Y_r[6:0])};//
assign seg_en = ~DIG_r;          //那一盏灯亮


always @ (posedge clk or negedge rst) begin // frequency division  clk->clkout
        if(!rst) begin
            cnt<= 0;
            clkout<=0;
        end
        else begin
            if(cnt == (period>>1)-1) begin
               clkout <= ~clkout;
               cnt <= 0;
            end
            else 
                cnt <= cnt+1;
        end
    end
    
always @ (posedge clk or negedge rst) //chance scan_cnt based on clkout
    begin
    if(!rst)
        scan_cnt <= 0;
    else begin 
        scan_cnt <= scan_cnt + 1;
        if(scan_cnt == 3'd7)
            scan_cnt <= 0;
    end
    end
        
always @ (scan_cnt)//select tube
begin
case (scan_cnt)
    3'b000: DIG_r = 8'b0000_0001;
    3'b001: DIG_r = 8'b0000_0010;
    3'b010: DIG_r = 8'b0000_0100;
    3'b011: DIG_r = 8'b0000_1000;
    3'b100: DIG_r = 8'b0001_0000;
    3'b101: DIG_r = 8'b0010_0000;
    3'b110: DIG_r = 8'b0100_0000;
    3'b111: DIG_r = 8'b1000_0000;
    default : DIG_r = 8'b0000_0000;
endcase
end

always @ (scan_cnt) begin
//    if(buffer[state]!=8'b0) begin
        case(scan_cnt)
//            0: Y_r = buffer[state];// 0
//            1: Y_r = buffer[state];// 1
//            2: Y_r = buffer[state];// 2
//            3: Y_r = buffer[state];// 3
//            4: Y_r = buffer[state];// 4
//            5: Y_r = buffer[state];// 5
//            6: Y_r = buffer[state];// 6
//            7: Y_r = buffer[state];// 7
//            8: Y_r = buffer[state];// 8
                0: Y_r = 7'b0111111;//0
                1: Y_r = 7'b0000110; // 1
                2: Y_r = 7'b1011011;// 2
                3: Y_r = 7'b1001111;//3
                4: Y_r = 7'b1100110;//4
                5: Y_r = 7'b1101101;//5
                6: Y_r = 7'b1111101;// 6
                7: Y_r = 7'b0100111;//7
                8: Y_r = 7'b1111111;//8

            //9:8'b00010000;
            default: Y_r = 7'b0000000;
        endcase
     end
//end
endmodule
