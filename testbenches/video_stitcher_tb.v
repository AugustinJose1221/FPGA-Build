
`timescale 1ns/1ns

module video_stitcher_tb;

reg  clk, rst_n, start, clear;

wire camera_enable;
wire RWM_1_enable;
wire RWM_2_enable;
wire GS_enable;

wire rw_1;
wire rw_2;

wire data_valid;
wire RWM_1_valid;
wire RWM_2_valid;
wire GS_valid;

wire RWM_1_done;
wire RWM_2_done;
wire GS_done;
wire pause;

wire [7:0] camera_data;
wire [7:0] RWM_1_data;
wire [7:0] RWM_2_data;
wire [7:0] GS_data;

wire fill_now;
wire [15:0] Dout;

Controller control (clk, rst_n, RWM_1_done, RWM_2_done, GS_done, start, RWM_1_enable, rw_1, RWM_2_enable, rw_2, camera_enable, GS_enable);

camera interface (clk, camera_enable, data_valid, camera_data);

Grayscaler GS (clk, rst_n, GS_enable, RWM_1_valid, RWM_1_data, GS_data, GS_valid, pause, GS_done);

RWM_1 Memory_1 (clk, rst_n, RWM_1_enable, rw_1, clear, pause, camera_data, RWM_1_data, RWM_1_valid, RWM_1_done);

RWM_2 Memory_2 (clk, rst_n, RWM_2_enable, rw_2, clear, GS_valid, GS_data, RWM_2_data, RWM_2_valid, RWM_2_done);

filter5x5 FILTER(RWM_2_data, RWM_2_valid, rst_n, clk, fill_now, Dout);

initial
begin
 $dumpfile("../vcd/video_stitcher_tb.vcd");
 $dumpvars(0, video_stitcher_tb);

 rst_n = 0;
 clear = 0;
 start = 0;
 #2;
 rst_n = 1;
 start = 1;
 #2;
 start = 0;
 #130;
 #150;
 #1500;
 $finish;
end

always
begin
 clk = 1'b1;
 #1;
 clk = 1'b0;
 #1;
end

endmodule
