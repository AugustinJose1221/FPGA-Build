module keypoints(
input               clk,
input               rst_n,
input               data_valid,
input [15:0]        Diff1,
input [15:0]        Diff2,
input [15:0]        Diff3,
output [31:0]       Dout,
output              output_valid,
output              done);


parameter N = 450, M = 450;

parameter IDLE = 3'b000, STORE = 3'b001, LOAD = 3'b010, CALCULATE = 3'b011;

integer i, j, k, p, q, o, count;

reg [15:0] image1[0:(N*M)-1];
reg [15:0] image2[0:(N*M)-1];
reg [15:0] image3[0:(N*M)-1];
reg [15:0] w1[0:8];
reg [15:0] w2[0:8];
reg [15:0] w3[0:8];

reg [31:0] result;

reg [2:0] PS;
reg [2:0] NS;

always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  PS <= IDLE;
 else
  PS <= NS;
end

always @(posedge clk)
begin
 if(data_valid)
 begin
  image1[i] <= Diff1;
  image2[i] <= Diff2;
  image3[i] <= Diff3;
  i <= (i == (N*M)-1) ? 0 : i + 1;
 end
 else
 begin
  i <= i;
 end
 if(NS == CALCULATE)
 begin
  k = (k == M-2) ? 0 : k + 1;
  count = count + 1;
 end
end

always @(Diff1, data_valid, i, count, k, PS)
begin
 case (PS)
 IDLE: begin
        i = 0;
        j = 0;
        k = 0;
        p = 0;
        q = 0;
        o = 0;
        count = 0;
        if (data_valid)
          NS = STORE;
        else
          NS = IDLE;
       end
 STORE: begin
         NS = (i == (N*M)-1) ? LOAD : STORE;
        end
 LOAD: begin
        o = 0;
        for(p = 0; p < 3; p = p+1)
        begin
         for(q = 0; q < 3; q = q+1)
         begin
          w1[o] = image1[j + (p*M) + q];
          w2[o] = image2[j + (p*M) + q];
          w3[o] = image3[j + (p*M) + q];
          o = o + 1;
         end
        end

        NS = CALCULATE;
       end
 CALCULATE: begin
             //result = ((w2[4] > w1[0] && w2[4] > w1[1] && w2[4] > w1[2] && w2[4] > w1[3] && w2[4] > w1[4] && w2[4] > w1[5] && w2[4] > w1[6] && w2[4] > w1[7] && w2[4] > w1[8] && w2[4] > w2[0] && w2[4] > w2[1] && w2[4] > w2[2] && w2[4] > w2[3] && w2[4] > w2[5] && w2[4] > w2[6] && w2[4] > w2[7] && w2[4] > w2[8] && w2[4] > w3[0] && w2[4] > w3[1] && w2[4] > w3[2] && w2[4] > w3[3] && w2[4] > w3[4] && w2[4] > w3[5] && w2[4] > w3[6] && w2[4] > w3[7] && w2[4] > w3[8]) || (w2[4] < w1[0] && w2[4] < w1[1] && w2[4] < w1[2] && w2[4] < w1[3] && w2[4] < w1[4] && w2[4] < w1[5] && w2[4] < w1[6] && w2[4] < w1[7] && w2[4] < w1[8] && w2[4] < w2[0] && w2[4] < w2[1] && w2[4] < w2[2] && w2[4] < w2[3] && w2[4] < w2[5] && w2[4] < w2[6] && w2[4] < w2[7] && w2[4] < w2[8] && w2[4] < w3[0] && w2[4] < w3[1] && w2[4] < w3[2] && w2[4] < w3[3] && w2[4] < w3[4] && w2[4] < w3[5] && w2[4] < w3[6] && w2[4] < w3[7] && w2[4] < w3[8])) ? 8'hff : 8'h00;
             result = (w2[4] < w1[0] && w2[4] < w1[1] && w2[4] < w1[2] && w2[4] < w1[3] && w2[4] < w1[4] && w2[4] < w1[5] && w2[4] < w1[6] && w2[4] < w1[7] && w2[4] < w1[8] && w2[4] < w2[0] && w2[4] < w2[1] && w2[4] < w2[2] && w2[4] < w2[3] && w2[4] < w2[5] && w2[4] < w2[6] && w2[4] < w2[7] && w2[4] < w2[8] && w2[4] < w3[0] && w2[4] < w3[1] && w2[4] < w3[2] && w2[4] < w3[3] && w2[4] < w3[4] && w2[4] < w3[5] && w2[4] < w3[6] && w2[4] < w3[7] && w2[4] < w3[8]) ? j : 8'h00;

             j = (k == 0) ? j + 3 : j + 1;
             NS = (count == (N-2)*(M-2)) ? IDLE : LOAD;
            end
 endcase
end
assign output_valid = (PS==CALCULATE && result != 8'h00) ? 1'b1 : 1'b0;
assign Dout = (PS==CALCULATE) ? result : 8'hzz;
assign done = (count == (N-2)*(M-2)) ? 1'b1 : 1'b0;
endmodule
