module top(
input     clk,
input     rst_n,
input     l_start,
input     r_start,
input     l_clear,
input     r_clear);

wire l_camera_enable, r_camera_enable;
wire l_data_valid, r_data_valid;
wire [7:0] l_camera_data, r_camera_data;

wire l_RWM_1_enable, r_RWM_1_enable;
wire l_rw_1, r_rw_1;
wire l_pause, r_pause;
wire [7:0] l_RWM_1_data, r_RWM_1_data;
wire l_RWM_1_valid, r_RWM_1_valid;
wire l_RWM_1_done, r_RWM_1_done;

wire l_GS_enable, r_GS_enable;
wire [7:0] l_GS_data, r_GS_data;
wire l_GS_valid, r_GS_valid;
wire l_GS_done, r_GS_done;

wire l_RWM_2_enable, r_RWM_2_enable;
wire l_rw_2, r_rw_2;
wire [7:0] l_RWM_2_data, r_RWM_2_data;
wire l_RWM_2_valid, r_RWM_2_valid;
wire l_RWM_2_done, r_RWM_2_done;

wire l_sobel_valid, r_sobel_valid;
wire [7:0] l_sobel_out, r_sobel_out;
wire l_CHL_X, r_CHL_X;
wire l_CHL_Y, r_CHL_Y;
wire l_sobel_done, r_sobel_done;

wire l_filter_valid, r_filter_valid;
wire [15:0] l_Diff1, r_Diff1;
wire [15:0] l_Diff2, r_Diff2;
wire [15:0] l_Diff3, r_Diff3;
wire l_filter_out, r_filter_out;

wire [31:0] l_keypoint_out, r_keypoint_out;
wire l_keypoint_valid, r_keypoint_valid;
wire l_keypoint_done, r_keypoint_done;

wire l_descriptor_valid, r_descriptor_valid;
wire [31:0] l_keypoint_value, r_keypoint_value;
wire [15:0] l_channel1, r_channel1;
wire [15:0] l_channel2, r_channel2;
wire [15:0] l_channel3, r_channel3;
wire [15:0] l_channel4, r_channel4;
wire l_descriptor_done, r_descriptor_done;

wire matcher_valid;
wire [31:0] left_keypoint;
wire [31:0] right_keypoint;

wire stitcher_valid;
wire [7:0] stitcher_data;

image L_CAM(clk, l_camera_enable, l_data_valid, l_camera_data);
image2 R_CAM(clk, r_camera_enable, r_data_valid, r_camera_data);

RWM_1 L_MEM_1(clk, rst_n, l_RWM_1_enable, l_rw_1, l_clear, l_pause, l_camera_data, l_RWM_1_data, l_RWM_1_valid, l_RWM_1_done);
RWM_1 R_MEM_1(clk, rst_n, r_RWM_1_enable, r_rw_1, r_clear, r_pause, r_camera_data, r_RWM_1_data, r_RWM_1_valid, r_RWM_1_done);

Grayscaler L_GRAY(clk, rst_n, l_GS_enable, l_RWM_1_valid, l_RWM_1_data, l_GS_data, l_GS_valid, l_pause, l_GS_done);
Grayscaler R_GRAY(clk, rst_n, r_GS_enable, r_RWM_1_valid, r_RWM_1_data, r_GS_data, r_GS_valid, r_pause, r_GS_done);

RWM_2 L_MEM_2(clk, rst_n, l_RWM_2_enable, l_rw_2, l_clear, l_GS_valid, l_GS_data, l_RWM_2_data, l_RWM_2_valid, l_RWM_2_done);
RWM_2 R_MEM_2(clk, rst_n, r_RWM_2_enable, r_rw_2, r_clear, r_GS_valid, r_GS_data, r_RWM_2_data, r_RWM_2_valid, r_RWM_2_done);

Controller L_CONTROL(clk, rst_n, l_RWM_1_done, l_RWM_2_done, l_GS_done, l_start, l_RWM_1_enable, l_rw_1, l_RWM_2_enable, l_rw_2, l_camera_enable, l_GS_enable);
Controller R_CONTROL(clk, rst_n, r_RWM_1_done, r_RWM_2_done, r_GS_done, r_start, r_RWM_1_enable, r_rw_1, r_RWM_2_enable, r_rw_2, r_camera_enable, r_GS_enable);

sobel_filter L_SOBEL(clk, rst_n, l_RWM_2_valid, l_RWM_2_data, l_sobel_valid, l_sobel_out, l_CHL_X, l_CHL_Y, l_sobel_done);
sobel_filter R_SOBEL(clk, rst_n, r_RWM_2_valid, r_RWM_2_data, r_sobel_valid, r_sobel_out, r_CHL_X, r_CHL_Y, r_sobel_done);

filter5x5 L_FILTER(l_RWM_2_data, l_RWM_2_valid, rst_n, clk, l_filter_valid, l_Diff1, l_Diff2, l_Diff3, l_filter_out);
filter5x5 R_FILTER(r_RWM_2_data, r_RWM_2_valid, rst_n, clk, r_filter_valid, r_Diff1, r_Diff2, r_Diff3, r_filter_out);

keypoints L_KEYPOINT(clk, rst_n, l_filter_valid, l_Diff1, l_Diff2, l_Diff3, l_keypoint_out, l_keypoint_valid, l_keypoint_done);
keypoints R_KEYPOINT(clk, rst_n, r_filter_valid, r_Diff1, r_Diff2, r_Diff3, r_keypoint_out, r_keypoint_valid, r_keypoint_done);

descriptor L_DESCRIPTOR(clk, rst_n, l_keypoint_valid, l_keypoint_out, l_keypoint_done, l_sobel_valid, l_sobel_out, l_CHL_X, l_CHL_Y, l_descriptor_valid, l_keypoint_value, l_channel1, l_channel2, l_channel3, l_channel4, l_descriptor_done);
descriptor R_DESCRIPTOR(clk, rst_n, r_keypoint_valid, r_keypoint_out, r_keypoint_done, r_sobel_valid, r_sobel_out, r_CHL_X, r_CHL_Y, r_descriptor_valid, r_keypoint_value, r_channel1, r_channel2, r_channel3, r_channel4, r_descriptor_done);

matcher MATCH(clk, rst_n, l_descriptor_valid, l_keypoint_value, l_channel1, l_channel2, l_channel3, l_channel4, l_descriptor_done, r_descriptor_valid, r_keypoint_value, r_channel1, r_channel2, r_channel3, r_channel4, r_descriptor_done, matcher_valid, left_keypoint, right_keypoint);

stitcher STITCH(clk, rst_n, l_data_valid, l_camera_data, r_data_valid, r_camera_data, matcher_valid, left_keypoint, right_keypoint, stitcher_valid, stitcher_data);

display DISPLAY(clk, stitcher_valid, stitcher_data);

endmodule
