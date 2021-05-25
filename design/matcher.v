module matcher(
input           clk,
input           rst_n,
input           left_valid,
input [31:0]    left_keypoint,
input [15:0]    left_descriptor_channel_1,
input [15:0]    left_descriptor_channel_2,
input [15:0]    left_descriptor_channel_3,
input [15:0]    left_descriptor_channel_4,
input [15:0]    left_done,
input           right_valid,
input [31:0]    right_keypoint,
input [15:0]    right_descriptor_channel_1,
input [15:0]    right_descriptor_channel_2,
input [15:0]    right_descriptor_channel_3,
input [15:0]    right_descriptor_channel_4,
input [15:0]    right_done,
output          data_valid,
output [31:0]   left_point,
output [31:0]   right_point);

reg [31:0] left_keypoints[0:(N*M)/9];
reg [15:0] left_descriptor1[0:(N*M)/9];
reg [15:0] left_descriptor2[0:(N*M)/9];
reg [15:0] left_descriptor3[0:(N*M)/9];
reg [15:0] left_descriptor4[0:(N*M)/9];
reg [31:0] right_keypoints[0:(N*M)/9];
reg [15:0] right_descriptor1[0:(N*M)/9];
reg [15:0] right_descriptor2[0:(N*M)/9];
reg [15:0] right_descriptor3[0:(N*M)/9];
reg [15:0] right_descriptor4[0:(N*M)/9];

reg [2:0]  PS, NS;
reg flag1;
reg flag2;

parameter IDLE = 3'b000, STORE = 3'b001, LOAD = 3'b010, MATCH = 3'b011, DONE = 3'b100;
parameter N = 450, M = 450;

integer i, j, p, q, left_limit, right_limit, least_error, error, error_channel1, error_channel2, error_channel3, error_channel4, sample_keypoint1, sample_keypoint2, final_keypoint1, final_keypoint2;

always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  PS <= IDLE;
 else
  PS <= NS;
end

always @(posedge clk)
begin
 if (left_valid)
 begin
  left_keypoints[i] <= left_keypoint;
  left_descriptor1[i] <= left_descriptor_channel_1;
  left_descriptor2[i] <= left_descriptor_channel_2;
  left_descriptor3[i] <= left_descriptor_channel_3;
  left_descriptor4[i] <= left_descriptor_channel_4;
  i <=  i + 1;
  left_limit <= i;
 end
 else
 begin
  i <= i;
  left_limit <= i;
 end
end

always @(posedge clk)
begin
 if (right_valid)
 begin
  right_keypoints[j] <= right_keypoint;
  right_descriptor1[j] <= right_descriptor_channel_1;
  right_descriptor2[j] <= right_descriptor_channel_2;
  right_descriptor3[j] <= right_descriptor_channel_3;
  right_descriptor4[j] <= right_descriptor_channel_4;
  j <=  j + 1;
  right_limit <= j;
 end
 else
 begin
  j <= j;
  right_limit <= j;
 end
end

always @(left_valid, right_valid, left_done, right_done, PS, i, j, p, q)
begin
 case (PS)
 IDLE: begin
        i = 0;
        j = 0;
        p = 0;
        q = 0;
        left_limit = 0;
        right_limit = 0;
        flag1 = 1'b0;
        flag2 = 1'b0;
        least_error = 32'h0fffffff;
        error = 0;
        error_channel1 = 0;
        error_channel2 = 0;
        error_channel3 = 0;
        error_channel4 = 0;
        sample_keypoint1 = 0;
        sample_keypoint2 = 0;
        final_keypoint1 = 0;
        final_keypoint2 = 0;
        if (left_valid || right_valid)
         NS = STORE;
        else
         NS = IDLE;
       end
 STORE: begin
         flag1 = (left_done == 1) ? 1'b1 : flag1;
         flag2 = (right_done == 1) ? 1'b1 : flag2;
         NS = (flag1 == 1 && flag2 == 1) ? LOAD : STORE;
        end
 LOAD: begin
        error_channel1 = (left_descriptor1[p] > right_descriptor1[q]) ? left_descriptor1[p]-right_descriptor1[q] : right_descriptor1[q]-left_descriptor1[p];
        error_channel2 = (left_descriptor2[p] > right_descriptor2[q]) ? left_descriptor2[p]-right_descriptor2[q] : right_descriptor2[q]-left_descriptor2[p];
        error_channel3 = (left_descriptor3[p] > right_descriptor3[q]) ? left_descriptor3[p]-right_descriptor3[q] : right_descriptor3[q]-left_descriptor3[p];
        error_channel4 = (left_descriptor4[p] > right_descriptor4[q]) ? left_descriptor4[p]-right_descriptor4[q] : right_descriptor4[q]-left_descriptor4[p];
        error = error_channel1 + error_channel2 + error_channel3 + error_channel4;
        sample_keypoint1 = left_keypoints[p];
        sample_keypoint2 = right_keypoints[q];
        p = (p == left_limit-1) ? 0 : p + 1;
        q = (p == 0) ? q + 1 : q;
        NS = (q == right_limit) ? DONE : MATCH;
       end
 MATCH: begin
         final_keypoint1 = (least_error < error) ? final_keypoint1 : sample_keypoint1;
         final_keypoint2 = (least_error < error) ? final_keypoint2 : sample_keypoint2;
         least_error = (least_error < error) ? least_error : error;
         NS = LOAD;
        end
 DONE: begin
        NS = IDLE;
       end
 endcase
end
assign data_valid = (PS == DONE) ? 1'b1 : 1'b0;
assign left_point = (PS == DONE) ? final_keypoint1 : 32'hzzzzzzzz;
assign right_point = (PS == DONE) ? final_keypoint2 : 32'hzzzzzzzz;
endmodule
