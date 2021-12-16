`timescale 1ns / 1ps

module decoder_display(r0, r1, r2, r3, r4, r5, r6, r7, state, clk, rst, seg_en, seg_out);
input [5 : 0] r0, r1, r2, r3, r4, r5, r6, r7;
input clk;
input [3 : 0]state;
input rst;
reg clkout;
reg [2 : 0] scan_cnt;
parameter period = 200000;
output reg [7 : 0] seg_en;
output [7 : 0] seg_out;
reg [6 : 0] seg;
reg [31:0] cnt;
wire [5 : 0] result [7 : 0];
assign result[0] = r0;
assign result[1] = r1;
assign result[2] = r2;
assign result[3] = r3;
assign result[4] = r4;
assign result[5] = r5;
assign result[6] = r6;
assign result[7] = r7;
assign seg_out = {1'b1, ~seg[6 : 0]};
always @(scan_cnt) begin
    case (scan_cnt)
        0: seg_en = 8'b0111_1111;
        1: seg_en = 8'b1011_1111;
        2: seg_en = 8'b1101_1111;
        3: seg_en = 8'b1110_1111;
        4: seg_en = 8'b1111_0111;
        5: seg_en = 8'b1111_1011;
        6: seg_en = 8'b1111_1101;
        7: seg_en = 8'b1111_1110;
        default: seg_en = 8'b1111_1111;
    endcase
end

always @(scan_cnt)
begin
    if(scan_cnt < state)
    case (result[scan_cnt])
        6'b000000: seg = 7'b0111111;//0
        6'b000001: seg = 7'b0000110;//1
        6'b000010: seg = 7'b1011011;//2
        6'b000011: seg = 7'b1001111;//3
        6'b000100: seg = 7'b1100110;//4
        6'b000101: seg = 7'b1101101;//5
        6'b000110: seg = 7'b1111101;//6
        6'b000111: seg = 7'b0100111;//7
        6'b001000: seg = 7'b1111111;//8
        6'b001001: seg = 7'b1101111;//9
        6'b001010: seg = 7'b1110111;//A
        6'b001011: seg = 7'b1111100;//B
        6'b001100: seg = 7'b0111001;//C
        6'b001101: seg = 7'b1011110;//D
        6'b001110: seg = 7'b1111001;//E
        6'b001111: seg = 7'b1110001;//F
        6'b010000: seg = 7'b0111101;//G
        6'b010001: seg = 7'b1110110;//H
        6'b010010: seg = 7'b0001111;//I
        6'b010011: seg = 7'b0001110;//J
        6'b010100: seg = 7'b1110101;//K
        6'b010101: seg = 7'b0111000;//L
        6'b010110: seg = 7'b0110111;//M
        6'b010111: seg = 7'b1010100;//N
        6'b011000: seg = 7'b1011100;//O
        6'b011001: seg = 7'b1110011;//P
        6'b011010: seg = 7'b1100111;//Q
        6'b011011: seg = 7'b0110001;//R
        6'b011100: seg = 7'b1001001;//S
        6'b011101: seg = 7'b1111000;//T
        6'b011110: seg = 7'b0111110;//U
        6'b011111: seg = 7'b0011100;//V
        6'b100000: seg = 7'b1111110;//W
        6'b100001: seg = 7'b1100100;//X
        6'b100010: seg = 7'b1101110;//Y
        6'b100011: seg = 7'b1011010;//Z
        default: seg = 7'b0000000;
    endcase
    else
        seg = 7'b0000000;
end

always @(posedge clkout, posedge rst)
begin
    if(rst)
    scan_cnt <= 0;
    else
    scan_cnt <= scan_cnt + 1;
end


always @(posedge clk, posedge rst)
if(rst)
begin
    clkout <= 0;
    cnt <= 0;
end
else 
if(cnt == (period >> 1) - 1)
begin
    clkout <= ~clkout;
    cnt <= 0;
end
else
    cnt <= cnt + 1;
endmodule
