`timescale 1ns / 1ps

module encoder_display(
    input clk,
    input rst,
    input [3:0] state,
    input [7:0] b0,b1,b2,b3,b4,b5,b6,b7,
    output reg [7:0] seg_en,
    output reg [7:0] seg_out   
);
reg clkout;
reg [31:0] cnt;
reg [2:0] scan_cnt;
parameter period = 200000;

always @ (posedge clk or posedge rst) begin // frequency division  clk->clkout
            if(rst) begin
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
        
always @ (posedge clkout or posedge rst) begin //chance scan_cnt based on clkout
    if(rst)
        scan_cnt <= 0;
    else begin 
        scan_cnt <= scan_cnt + 1;
        if(scan_cnt == 3'd7)
            scan_cnt <= 0;
    end
end
        
always @ (scan_cnt) begin //select tube
       case (scan_cnt)
           3'b000: seg_en = ~8'b1000_0000;
           3'b001: seg_en = ~8'b0100_0000;
           3'b010: seg_en = ~8'b0010_0000;
           3'b011: seg_en = ~8'b0001_0000;
           3'b100: seg_en = ~8'b0000_1000;
           3'b101: seg_en = ~8'b0000_0100;
           3'b110: seg_en = ~8'b0000_0010;
           3'b111: seg_en = ~8'b0000_0001;
           default : seg_en = ~8'b0000_0000;
       endcase
   end

always @ (scan_cnt,state) begin
    case(state)
        0:seg_out = ~8'b0000_0000;//none
        1:case(scan_cnt)
            0:seg_out = b0;// 0
            default: seg_out = ~8'b0000_0000;
          endcase
        2:case(scan_cnt)
            0:seg_out = b0;// 0
            1:seg_out = b1;// 1
            default: seg_out = ~8'b0000_0000;
          endcase
        3:case(scan_cnt)                    
            0:seg_out = b0;// 0
            1:seg_out = b1;// 1
            2:seg_out = b2;// 2
            default: seg_out = ~8'b0000_0000;
          endcase                     
        4:case(scan_cnt)
            0:seg_out = b0;// 0 
            1:seg_out = b1;// 1 
            2:seg_out = b2;// 2 
            3:seg_out = b3;// 3 
            default: seg_out = ~8'b0000_0000;
           endcase
        5:case(scan_cnt)
            0:seg_out = b0;// 0
            1:seg_out = b1;// 1
            2:seg_out = b2;// 2
            3:seg_out = b3;// 3
            4:seg_out = b4;// 4
            default: seg_out = ~8'b0000_0000;
            endcase
        6:case(scan_cnt)
            0:seg_out = b0;// 0
            1:seg_out = b1;// 1
            2:seg_out = b2;// 2
            3:seg_out = b3;// 3
            4:seg_out = b4;// 4
            5:seg_out = b5;// 5
            default: seg_out = ~8'b0000_0000;
            endcase
        7:case(scan_cnt)
            0:seg_out = b0;// 0
            1:seg_out = b1;// 1
            2:seg_out = b2;// 2
            3:seg_out = b3;// 3
            4:seg_out = b4;// 4
            5:seg_out = b5;// 5
            6:seg_out = b6;// 6
            default: seg_out = ~8'b0000_0000;
            endcase
        8:case(scan_cnt)
            0:seg_out = b0;// 0
            1:seg_out = b1;// 1
            2:seg_out = b2;// 2
            3:seg_out = b3;// 3
            4:seg_out = b4;// 4
            5:seg_out = b5;// 5
            6:seg_out = b6;// 6
            7:seg_out = b7;// 7
            default: seg_out = ~8'b0000_0000;
            endcase
        endcase
   end     
endmodule
