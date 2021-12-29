`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 14:37:01
// Design Name: 
// Module Name: keyboard_to_result
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


module keyboard_to_result(
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

    parameter NO_KEY_PRESSED = 6'b000_001;  // ??§Ñ???????  
    parameter SCAN_COL0      = 6'b000_010;  // ????0?? 
    parameter SCAN_COL1      = 6'b000_100;  // ????1?? 
    parameter SCAN_COL2      = 6'b001_000;  // ????2?? 
    parameter SCAN_COL3      = 6'b010_000;  // ????3?? 
    parameter KEY_PRESSED    = 6'b100_000;  // ?§Ñ???????
    
    reg [5:0] current_state, next_state;    // ????????
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
       NO_KEY_PRESSED :                    // ??§Ñ???????
           if (row != 4'hF)
             next_state = SCAN_COL0;
           else
             next_state = NO_KEY_PRESSED;
       SCAN_COL0 :                         // ????0?? 
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = SCAN_COL1;
       SCAN_COL1 :                         // ????1?? 
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = SCAN_COL2;    
       SCAN_COL2 :                         // ????2??
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = SCAN_COL3;
       SCAN_COL3 :                         // ????3??
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = NO_KEY_PRESSED;
       KEY_PRESSED :                       // ?§Ñ???????
           if (row != 4'hF)
             next_state = KEY_PRESSED;
           else
             next_state = NO_KEY_PRESSED;                      
     endcase
    
    reg       key_pressed_flag;             // ??????¡À??
    reg [3:0] col_val, row_val;             // ????????
    
    always @ (posedge key_clk or posedge rst)
     if (rst)
     begin
       col              <= 4'h0;
       key_pressed_flag <=    0;
     end
     else
       case (next_state)
         NO_KEY_PRESSED :                  // ??§Ñ???????
         begin
           col              <= 4'h0;
           key_pressed_flag <=    0;       // ???????¡À??
         end
         SCAN_COL0 :                       // ????0??
           col <= 4'b1110;
         SCAN_COL1 :                       // ????1??
           col <= 4'b1101;
         SCAN_COL2 :                       // ????2??
           col <= 4'b1011;
         SCAN_COL3 :                       // ????3??
           col <= 4'b0111;
         KEY_PRESSED :                     // ?§Ñ???????
         begin
           col_val          <= col;        // ???????
           row_val          <= row;        // ???????
           key_pressed_flag <= 1;          // ?¨¹?????¡À??  
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
//    always @ (posedge key_clk or posedge rst)
//     if (rst) begin
//       keyboard_val <= 4'h0;
//       state <= 0;
//       end
//     else
//       if (key_pressed_pos_signal) begin
//         case ({col_val, row_val})
//           8'b1110_1110 : keyboard_val <= 4'h1;
//           8'b1110_1101 : keyboard_val <= 4'h4;
//           8'b1110_1011 : keyboard_val <= 4'h7;
////           8'b1110_0111 : keyboard_val <= 4'hE;
            
//           8'b1101_1110 : keyboard_val <= 4'h2;
//           8'b1101_1101 : keyboard_val <= 4'h5;
//           8'b1101_1011 : keyboard_val <= 4'h8;
//           8'b1101_0111 : keyboard_val <= 4'h0;
            
//           8'b1011_1110 : keyboard_val <= 4'h3;
//           8'b1011_1101 : keyboard_val <= 4'h6;
//           8'b1011_1011 : keyboard_val <= 4'h9;
////           8'b1011_0111 : keyboard_val <= 4'hF;

////           8'b0111_1110 : keyboard_val <= 4'hA; 
////           8'b0111_1101 : keyboard_val <= 4'hB;
////           8'b0111_1011 : keyboard_val <= 4'hC;
////           8'b0111_0111 : keyboard_val <= 4'hD;        
//         endcase
//            state = state + 1;
//     end
    
    always @ (posedge key_clk or posedge rst)
     if (rst) begin
       keyboard_val <= 4'h0;
       state <= 0;
       end
     else
       if (key_pressed_pos_signal) begin
       if(state < 8)
         case ({col_val, row_val})
           8'b1110_1110 : begin buffer[state] <= ~8'b0000_0110; result[state] <= 5'b01111;   state <= state + 1;end//1
           8'b1110_1101 : begin buffer[state] <= ~8'b0110_0110; result[state] <= 5'b00001;   state <= state + 1;end// 4
           8'b1110_1011 : begin buffer[state] <= ~8'b0010_0111; result[state] <= 5'b11000;  state <= state + 1; end// 7
//           8'b1110_0111 : keyboard_val <= 4'hE;
            
           8'b1101_1110 : begin buffer[state] <= ~8'b0101_1011; result[state] <= 5'b00111;   state <= state + 1;end// 2
           8'b1101_1101 : begin buffer[state] <= ~8'b0110_1101; result[state] <= 5'b00000;   state <= state + 1;end// 5
           8'b1101_1011 : begin buffer[state] <= ~8'b0111_1111; result[state] <= 5'b11100;   state <= state + 1;end// 8
           8'b1101_0111 : begin buffer[state] <= ~8'b0011_1111; result[state] <= 5'b11111;  state <= state + 1; end//0
            
           8'b1011_1110 : begin buffer[state] <= ~8'b0100_1111; result[state] <= 5'b00011;   state <= state + 1;end// 3
           8'b1011_1101 : begin buffer[state] <= ~8'b0111_1101; result[state] <= 5'b10000;   state <= state + 1;end// 6
           8'b1011_1011 : begin buffer[state] <= ~8'b0110_0111; result[state] <= 5'b11110;   state <= state + 1;end// 9
//           8'b1011_0111 : keyboard_val <= 4'hF;

//           8'b0111_1110 : keyboard_val <= 4'hA; 
//           8'b0111_1101 : keyboard_val <= 4'hB;
//           8'b0111_1011 : keyboard_val <= 4'hC;
//           8'b0111_0111 : keyboard_val <= 4'hD;        
         endcase
          
     end
    
//    always @ (keyboard_val)
//        begin 
//        case (keyboard_val)
//            4'h0: begin buffer[state] = ~8'b0011_1111; result = 5'b11111; end // 0
//            4'h1: begin buffer[state] = ~8'b0000_0110; result = 5'b01111; end// 1
//            4'h2: begin buffer[state] = ~8'b0101_1011; result = 5'b00111; end// 2
//            4'h3: begin buffer[state] = ~8'b0100_1111; result = 5'b00011; end// 3
//            4'h4: begin buffer[state] = ~8'b0110_0110; result = 5'b00001; end// 4
//            4'h5: begin buffer[state] = ~8'b0110_1101; result = 5'b00000; end// 5
//            4'h6: begin buffer[state] = ~8'b0111_1101; result = 5'b10000; end// 6
//            4'h7: begin buffer[state] = ~8'b0010_0111; result = 5'b11000; end// 7
//            4'h8: begin buffer[state] = ~8'b0111_1111; result = 5'b11100; end// 8
//            4'h9: begin buffer[state] = ~8'b0110_0111; result = 5'b11110; end// 9
//         default: begin buffer[state] = ~8'b0000_0000; result = 5'b10101; end
//        endcase
     
//        end    
    //     vio_0 your_instance_name (
    //  .clk(clk),                // input wire clk
    //  .probe_out0(seg_out)  // output wire [7 : 0] probe_out0
    //);
endmodule
