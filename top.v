`timescale 1ns / 1ps

module top(
    input clk, rst, switch, mode, dashes, dots, confirm, backspace, screenBackspace,
    input [3 : 0] row,
    input [1 : 0] speed_mode,
    input [7 : 0] encoder_switch,
    output buzzer,
    output [3 : 0] col,
    output reg [7 : 0] seg_en,
    output reg [7 : 0] seg_out,
    output reg [13 : 0]led,
    output decode_light,
    output encode_light,
    output reg[1 : 0] speed_led
);
wire [1 : 0] speed_led_encoder;
wire [7 : 0] seg_en_decoder;
wire [7 : 0] seg_out_decoder;
wire [7 : 0] seg_en_encoder;
wire [7 : 0] seg_out_encoder;
wire [13 : 0] led_docoder;

decoder_controler decode(switch & ~mode, dots, dashes, confirm, clk, rst, backspace, screenBackspace, seg_out_decoder, seg_en_decoder, led_docoder);
encode_controller encode(switch & mode, row, confirm, clk, rst, speed_mode, encoder_switch, col, seg_en_encoder, seg_out_encoder, buzzer, speed_led_encoder);
assign decode_light = switch & ~mode;
assign encode_light = switch & mode;
always @(*) begin
    if(decode_light)
    begin
        seg_en = seg_en_decoder;
        seg_out = seg_out_decoder;
        led = led_docoder;
        speed_led = 0;
    end
    else if(encode_light)
    begin
        seg_en = seg_en_encoder;
        seg_out = seg_out_encoder;
        led = 0;
        speed_led = speed_led_encoder;
    end
    else
    begin
        seg_en = 8'b1111_1111;
        seg_out = 8'b1111_1111;
        led = 0;
        speed_led = 0;
    end
end
endmodule