
`timescale 1ns/1ns

module video_stitcher_tb;

reg clk, rst_n, start, clear;
wire camera_enable, data_valid, RWM_enable, rw, BRWM_1_done, GS_done, GS_enable, pause;
wire [7:0] BRWM_data, camera_data, GS_data;

Controller control (clk, rst_n, BRWM_1_done, GS_done, start, RWM_enable, rw, camera_enable, GS_enable);
camera interface (clk, camera_enable, data_valid, camera_data);
Grayscaler GS (clk, rst_n, GS_enable, BRWM_data, GS_data, pause, GS_done);
BRWM MUT (clk, rst_n, RWM_enable, rw, clear, pause, camera_data, BRWM_data, BRWM_1_done);

initial 
begin
 $dumpfile("video_stitcher_tb.vcd");
 $dumpvars(0, video_stitcher_tb);

 rst_n = 0;
 clear = 0;
 start = 0;
 #150;
 rst_n = 1;
 start = 1;
 #2;
 start = 0;
 #130;
 #150;
 #150
 $finish;
end

always 
begin
 clk = 1'b0;
 #1;
 clk = 1'b1;
 #1;
end

endmodule