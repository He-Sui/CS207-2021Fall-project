`timescale 1ns / 1ps

module keyboard_to_result(
    input EN, 
    input clk,rst,
    input [3:0] row,
    output reg [3:0] col,
    output [7:0] b0,b1,b2,b3,b4,b5,b6,b7,
    output [4:0] r0,r1,r2,r3,r4,r5,r6,r7,
    output reg  [3 : 0] state
    );
    reg [7:0] buffer [7:0];
    reg [4:0] result [7:0];
    reg [19:0] cnt_s;
    wire key_clk;
    always @ (posedge clk or posedge rst)
     if (rst) begin
       cnt_s <= 0;
       end
     else
       cnt_s <= cnt_s + 1'b1;
       
    assign key_clk = cnt_s[19];                // (2^20/50M = 21)ms 

    parameter NO_KEY_PRESSED = 6'b000_001;
    parameter SCAN_COL0      = 6'b000_010;
    parameter SCAN_COL1      = 6'b000_100;
    parameter SCAN_COL2      = 6'b001_000;
    parameter SCAN_COL3      = 6'b010_000;
    parameter KEY_PRESSED    = 6'b100_000; 
    
    reg [5:0] current_state, next_state; 
    assign b0 = buffer[0];
    assign b1 = buffer[1];
    assign b2 = buffer[2];
    assign b3 = buffer[3];
    assign b4 = buffer[4];
    assign b5 = buffer[5];
    assign b6 = buffer[6];
    assign b7 = buffer[7];
    assign r0 = result[0];
    assign r1 = result[1];
    assign r2 = result[2];
    assign r3 = result[3];
    assign r4 = result[4];
    assign r5 = result[5];
    assign r6 = result[6];
    assign r7 = result[7];
    
always @ (posedge key_clk or posedge rst)
     if (rst)
       current_state <= NO_KEY_PRESSED;
     else
       current_state <= next_state;
    
    // ?????????????
    always @ (*)
     case (current_state)
       NO_KEY_PRESSED :    
           if (row != 4'hF)
             next_state = SCAN_COL0;
           else
             next_state = NO_KEY_PRESSED;
       SCAN_COL0 :                 
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = SCAN_COL1;
       SCAN_COL1 :                       
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = SCAN_COL2;    
       SCAN_COL2 :                      
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = SCAN_COL3;
       SCAN_COL3 :                       
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = NO_KEY_PRESSED;
       KEY_PRESSED :                      
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = NO_KEY_PRESSED;                      
     endcase
    
    reg       key_pressed_flag;             
    reg [3:0] col_val, row_val;            
    
    always @ (posedge key_clk or posedge rst)
     if (rst)
     begin
       col              <= 4'h0;
       key_pressed_flag <=    0;
     end
     else
       case (next_state)
         NO_KEY_PRESSED :                 
         begin
           col              <= 4'h0;
           key_pressed_flag <=    0;     
         end
         SCAN_COL0 :                      
           col <= 4'b1110;
         SCAN_COL1 :                      
           col <= 4'b1101;
         SCAN_COL2 :                      
           col <= 4'b1011;
         SCAN_COL3 :                     
           col <= 4'b0111;
         KEY_PRESSED :                   
         begin
           col_val          <= col;       
           row_val          <= row;        
           key_pressed_flag <= 1;         
         end
       endcase

reg[2:0] delay;
wire key_pressed_pos_signal;
always @ ( posedge key_clk or posedge rst)
if(rst)
    delay <= 0;
else
    delay <= { delay[1:0], key_pressed_flag} ;
assign key_pressed_pos_signal = delay[1] && ( ~delay[2] );

reg [3:0] keyboard_val;
    
    always @ (posedge key_clk or posedge rst)
     if (rst) begin
     if(EN)begin
       keyboard_val <= 4'h0;
       state <= 0;
       end
       end
     else
       if (key_pressed_pos_signal) begin
       if(EN)begin
       if(state < 8)
         case ({col_val, row_val})
           8'b1110_1110 : begin buffer[state] <= ~8'b0000_0110; result[state] <= 5'b01111;   state <= state + 1;end//1
           8'b1110_1101 : begin buffer[state] <= ~8'b0110_0110; result[state] <= 5'b00001;   state <= state + 1;end// 4
           8'b1110_1011 : begin buffer[state] <= ~8'b0010_0111; result[state] <= 5'b11000;   state <= state + 1; end// 7

            
           8'b1101_1110 : begin buffer[state] <= ~8'b0101_1011; result[state] <= 5'b00111;   state <= state + 1;end// 2
           8'b1101_1101 : begin buffer[state] <= ~8'b0110_1101; result[state] <= 5'b00000;   state <= state + 1;end// 5
           8'b1101_1011 : begin buffer[state] <= ~8'b0111_1111; result[state] <= 5'b11100;   state <= state + 1;end// 8
           8'b1101_0111 : begin buffer[state] <= ~8'b0011_1111; result[state] <= 5'b11111;  state <= state + 1; end//0
            
           8'b1011_1110 : begin buffer[state] <= ~8'b0100_1111; result[state] <= 5'b00011;   state <= state + 1;end// 3
           8'b1011_1101 : begin buffer[state] <= ~8'b0111_1101; result[state] <= 5'b10000;   state <= state + 1;end// 6
           8'b1011_1011 : begin buffer[state] <= ~8'b0110_1111; result[state] <= 5'b11110;   state <= state + 1;end// 9

           8'b0111_1101 : if(state > 0) state <= state -1;              
         endcase
          else if(state == 8 & {col_val, row_val} == 8'b0111_1101)
            state <= state - 1;
           end
     end
endmodule
