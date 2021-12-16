`timescale 1ns / 1ps

module decoder_controler(
input dots,
input dashes,
input confirm,
input clk,
input rst,
input backspace,
output [7 : 0]seg_out,
output [7 : 0]seg_en,
output reg [13 : 0]led,
output reg [3 : 0] buffer_index
);
reg [3 : 0] state;
reg [3 : 0] light_index;
reg [4 : 0] code [7 : 0];
reg [2 : 0] length [7 : 0];
wire [5 : 0] result [7 : 0];
wire rst_key, dots_key, dashes_key, confirm_key, backspace_key;
decoder decoder0(code[0], length[0], result[0]);
decoder decoder1(code[1], length[1], result[1]);
decoder decoder2(code[2], length[2], result[2]);
decoder decoder3(code[3], length[3], result[3]);
decoder decoder4(code[4], length[4], result[4]);
decoder decoder5(code[5], length[5], result[5]);
decoder decoder6(code[6], length[6], result[6]);
decoder decoder7(code[7], length[7], result[7]);
decoder_display display(result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], state, clk, rst, seg_en, seg_out);

parameter period = 200000;
reg [31:0] cnt;
reg clkout;
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

debounce dots_out(clkout, rst, dots, dots_key);
debounce dashes_out(clkout, rst, dashes, dashes_key);
debounce confirm_out(clkout, rst, confirm, confirm_key);
debounce backspace_out(clkout, rst, backspace, backspace_key);

always @(posedge clkout or posedge rst) begin
    if(rst)
    begin
    length[0] = 3'd0;
    length[1] = 3'd0;
    length[2] = 3'd0;
    length[3] = 3'd0;
    length[4] = 3'd0;
    length[5] = 3'd0;
    length[6] = 3'd0;
    length[7] = 3'd0;
    state = 4'b0000;
    buffer_index = 4'b0000;
    light_index = 4'b0000;
    led = 14'd0;
    end
    else
    begin
    if(dots_key)
    begin
        if(buffer_index < 5)
        begin
            code[state][4 - buffer_index] = 1'b0;
            length[state] = length[state] + 1;
            buffer_index = buffer_index + 1;
            led[light_index] = 1'b1;
            light_index = light_index + 2;
        end
    end
    if(dashes_key)
    begin
        if(buffer_index < 5)
        begin
            code[state][4 - buffer_index] = 1'b1;
            length[state] = length[state] + 1;
            buffer_index = buffer_index + 1;
            led[light_index] = 1'b1;
            led[light_index + 1] = 1'b1; 
            light_index = light_index + 3;
        end
    end
    if(confirm_key)
    begin
        if(state != 4'b1000)
        begin
            if(result[state] != 6'b111111)
            begin
                state = state + 1;
                buffer_index = 4'd0;
                light_index = 4'd0;
                led = 14'd0;
            end
            else
            begin
                buffer_index = 4'd0;
                light_index = 4'd0;
                led = 14'd0;
            end
        end
    end
    if(backspace_key)
    begin
        if(buffer_index != 4'b0000)
        begin
            buffer_index = buffer_index - 1;
            light_index = light_index - 4'b0010;
            case(code[state][4 - buffer_index])
            0: led[light_index] = 0;
            1:
            begin
                led[light_index] = 0;
                led[light_index - 1] = 0;
                light_index = light_index - 1;
            end
            endcase
            length[state] = length[state] - 1;
        end
    end
    end
end

endmodule
