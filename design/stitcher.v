module stitcher(
input         clk,
input         rst_n,
input         left_data_valid,
input [7:0]   left_data,
input         right_data_valid,
input [7:0]   right_data,
input         keypoint_valid,
input [31:0]  left_keypoint,
input [31:0]  right_keypoint,
output        data_valid,
output [7:0]  data);

reg [7:0] L_DATA[0:(3*N*M - 1)];
reg [7:0] R_DATA[0:(3*N*M - 1)];
reg [7:0] IMAGE[0:(6*N*M - 1)];
reg [7:0] pixel_value;
reg [7:0] out;
reg [2:0] PS, NS;

parameter IDLE = 3'b000, STORE = 3'b001, LOAD = 3'b010, COMPUTE = 3'b011, BLEND = 3'b100, DISPLAY = 3'b101;
parameter N = 450, M = 450;

integer i, j, k, p, q, o, row1, row2, col1, col2, ref_keypoint1, ref_keypoint2;

always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  PS <= IDLE;
 else
  PS <= NS;
end

always @(posedge clk)
begin
 if (left_data_valid)
 begin
  L_DATA[i] <= left_data;
  i <= i + 1;
 end
 else
  i <= i;
end

always @(posedge clk)
begin
 if (right_data_valid)
 begin
  R_DATA[i] <= right_data;
  j <= j + 1;
 end
 else
  j <= j;
end

always @(left_data_valid, right_data_valid,left_data, right_data, keypoint_valid, PS)
begin
 case (PS)
 IDLE: begin
        i = 0;
        j = 0;
        k = 0;
        p = 0;
        q = 0;
        o = 0;
        row1 = 0;
        row2 = 0;
        col1 = 0;
        col2 = 0;
        ref_keypoint1 = 0;
        ref_keypoint2 = 0;
        pixel_value = 0;
        for(p = 0; p < 6*N*M; p = p+1)
        begin
         IMAGE[p] = 0;
        end
        if (left_data_valid || right_data_valid)
         NS = STORE;
        else
         NS = IDLE;
       end
 STORE: begin
         NS = (i == 3*N*M - 1 && j == 3*N*M - 1) ? LOAD : STORE;
        end
 LOAD: begin
        ref_keypoint1 = (keypoint_valid == 1'b1) ? left_keypoint : ref_keypoint1;
        ref_keypoint2 = (keypoint_valid == 1'b1) ? right_keypoint : ref_keypoint2;
        NS = (keypoint_valid == 1'b1) ? COMPUTE : LOAD;
       end
 COMPUTE: begin
           row1 = ref_keypoint1/M;
           row2 = ref_keypoint2/M;
           col1 = 3*(ref_keypoint1 - (row1*M));
           col2 = 3*(ref_keypoint2 - (row2*M));
           NS = BLEND;
          end
 BLEND: begin
         pixel_value = (q <= col1) ? L_DATA[q + (o*3*M)] : R_DATA[col2 + (q - col1) + (o*3*M)];
         IMAGE[q + (6*o*M)] = pixel_value;
         o = (q == (((3*M)-col2)+col1)-1) ? o + 1 : o;
         q = (q == (((3*M)-col2)+col1)-1) ? 0 : q + 1;
         NS = DISPLAY;
        end
 DISPLAY: begin
           out = IMAGE[k];
           k = k + 1;
           NS = (k == 6*N*M) ? IDLE : BLEND;
          end
 endcase
end
assign data_valid = (PS == DISPLAY) ? 1'b1 : 1'b0;
assign data = (PS == DISPLAY) ? out : 8'hzz;
endmodule
