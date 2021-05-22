
`timescale 1ns/1ns

module interface_tb();

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
wire [15:0] Diff1;
wire [15:0] Diff2;
wire [15:0] Diff3;
wire filter_out;

wire [7:0] sobel_out;
wire sobel_valid;
wire CHL_X;
wire CHL_Y;
wire sobel_done;

wire [31:0] keypoint_out;
wire keypoint_valid;
wire keypoint_done;

wire descriptor_valid;
wire [31:0] keypoint_value;
wire [15:0] channel1;
wire [15:0] channel2;
wire [15:0] channel3;
wire [15:0] channel4;
wire descriptor_done;

Controller control (clk, rst_n, RWM_1_done, RWM_2_done, GS_done, start, RWM_1_enable, rw_1, RWM_2_enable, rw_2, camera_enable, GS_enable);

image interface (clk, camera_enable, data_valid, camera_data);

Grayscaler GS (clk, rst_n, GS_enable, RWM_1_valid, RWM_1_data, GS_data, GS_valid, pause, GS_done);

RWM_1 Memory_1 (clk, rst_n, RWM_1_enable, rw_1, clear, pause, camera_data, RWM_1_data, RWM_1_valid, RWM_1_done);

RWM_2 Memory_2 (clk, rst_n, RWM_2_enable, rw_2, clear, GS_valid, GS_data, RWM_2_data, RWM_2_valid, RWM_2_done);

sobel_filter SOBEL(clk, rst_n, RWM_2_valid, RWM_2_data, sobel_valid, sobel_out, CHL_X, CHL_Y, sobel_done);

filter5x5 FILTER(RWM_2_data, RWM_2_valid, rst_n, clk, fill_now, Diff1, Diff2, Diff3, filter_out);

keypoints KEYPOINT(clk, rst_n, fill_now, Diff1, Diff2, Diff3, keypoint_out, keypoint_valid, keypoint_done);

descriptor DESRCIPTOR(clk, rst_n, keypoint_valid, keypoint_out, keypoint_done, sobel_valid, sobel_out, CHL_X, CHL_Y, descriptor_valid, keypoint_value, channel1, channel2, channel3, channel4, descriptor_done);

//display Display(clk, RWM_2_valid, RWM_2_data);

//display Display(clk, keypoint_valid, Dout);

initial
begin
 clk = 0;
 $dumpfile("../vcd/interface_tb.vcd");
 $dumpvars(0, interface_tb);

 rst_n = 0;
 clear = 0;
 start = 0;
 #2;
 rst_n = 1;
 start = 1;
 #2;
 start = 0;
 #7680050;
 $finish;
end

always
begin
 clk = ~clk;
 #1;
end

endmodule
