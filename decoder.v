`timescale 1ns / 1ps

module decoder(
input [4 : 0]code,
input [2 : 0]digit,
output reg[5 : 0]result
);

always @(*) begin
    case(digit)
        1:
        casex(code)
            5'b0xxxx: result = 6'b001110;//E
            5'b1xxxx: result = 6'b011101;//T
            default: result = 6'b111111;
        endcase
        2:
        casex(code)
            5'b00xxx: result = 6'b010010;//I
            5'b01xxx: result = 6'b001010;//A
            5'b10xxx: result = 6'b010111;//N
            5'b11xxx: result = 6'b010110;//M
        endcase
        3:
        casex (code)
            5'b000xx: result = 6'b011100;//S
            5'b001xx: result = 6'b011110;//U
            5'b010xx: result = 6'b011011;//R
            5'b011xx: result = 6'b100000;//W
            5'b100xx: result = 6'b001101;//D
            5'b101xx: result = 6'b010100;//K
            5'b110xx: result = 6'b010000;//G
            5'b111xx: result = 6'b011000;//O 
            default: result = 6'b111111;
        endcase
        4:
        casex (code)
            5'b0000x: result = 6'b010001;//H
            5'b0001x: result = 6'b011111;//V
            5'b0010x: result = 6'b001111;//F
            5'b0100x: result = 6'b010101;//L
            5'b0110x: result = 6'b011001;//P
            5'b0111x: result = 6'b010011;//J
            5'b1000x: result = 6'b001011;//B
            5'b1001x: result = 6'b100001;//X
            5'b1010x: result = 6'b001100;//C
            5'b1011x: result = 6'b100010;//Y
            5'b1100x: result = 6'b100011;//Z
            5'b1101x: result = 6'b011010;//Q
            default: result = 6'b111111;
        endcase
        5:
        case (code)
            5'b01111: result = 6'b000001;//1
            5'b00111: result = 6'b000010;//2
            5'b00011: result = 6'b000011;//3
            5'b00001: result = 6'b000100;//4
            5'b00000: result = 6'b000101;//5
            5'b10000: result = 6'b000110;//6
            5'b11000: result = 6'b000111;//7
            5'b11100: result = 6'b001000;//8
            5'b11110: result = 6'b001001;//9
            5'b11111: result = 6'b000000;//0 
            default: result = 6'b111111;
        endcase
        default: result = 6'b111111;
    endcase
end
endmodule