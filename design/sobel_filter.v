module sobel_filter(
input         clk,
input         rst_n,
input         data_valid,
input [7:0]   Din,
output        output_valid,
output [15:0] Dout,
output        CHL_X,
output        CHL_Y,
output        done);

reg [7:0] storage[0: (N*M)-1];
reg [7:0] sobel_kernal[0:8];

reg [15:0] sobel_x;
reg [15:0] sobel_y;
reg [15:0] result;
reg channel_x;
reg channel_y;

reg [2:0] PS, NS;

integer count, i, j, k, p, q, o;
parameter IDLE = 3'b000, STORE = 3'b001, FIX = 3'b010, CONVOLUTE = 3'b011;

parameter N = 450, M = 450;

//sequential logic
always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  PS <= IDLE;
 else PS <= NS;
end

always @(posedge clk)
begin
 if(data_valid)
 begin
  storage[i] <= Din;  
  i <= (i == N*M-1) ? 0 : i + 1;
 end
 else i <= 0;
end

always @(Din,data_valid,i,count,k,PS)
begin
 case (PS)
 IDLE: begin
        sobel_x = 16'h0000;
        sobel_y = 16'h0000;
        j = 0;
        k = 0;
        o = 0;
        count = 0;
        if(data_valid)
         NS = STORE;
        else NS = IDLE;
       end
 STORE: begin
        NS = (i == N*M-1) ? FIX : STORE;
        end
 FIX: begin
       o = 0;
       for(p = 0; p < 3; p = p+1)
       begin
        for(q = 0; q < 3; q = q+1)
        begin
         sobel_kernal[o] = storage[j + (p*M) + q];
         o = o + 1;
        end
       end

       NS = CONVOLUTE;
      end
 CONVOLUTE: begin
              sobel_x = (sobel_kernal[2] + (2*sobel_kernal[5]) + sobel_kernal[8]) - (sobel_kernal[0] + (2*sobel_kernal[3]) + sobel_kernal[6]);
              sobel_y = (sobel_kernal[0] + (2*sobel_kernal[1]) + sobel_kernal[2]) - (sobel_kernal[6] + (2*sobel_kernal[7]) + sobel_kernal[8]);
              channel_x = ((sobel_kernal[0] + (2*sobel_kernal[3]) + sobel_kernal[6]) > (sobel_kernal[2] + (2*sobel_kernal[5]) + sobel_kernal[8])) ? 1'b0 : 1'b1;
              channel_y = ((sobel_kernal[6] + (2*sobel_kernal[7]) + sobel_kernal[8]) > (sobel_kernal[0] + (2*sobel_kernal[1]) + sobel_kernal[2])) ? 1'b0 : 1'b1;
              result = ((sobel_x * sobel_x) + (sobel_y * sobel_y))**0.5;

              k = (k == M-3) ? 0 : k + 1;
              j = (k == 0) ? j + 3 : j + 1;

              count = count + 1;
              NS = (count==(N-2)*(M-2)) ? IDLE : FIX;
            end
 endcase
end

assign output_valid = (PS==CONVOLUTE) ? 1'b1 : 1'b0;
assign Dout = (PS==CONVOLUTE) ? result : 16'hzzzz;
assign CHL_X = (PS==CONVOLUTE) ? channel_x : 1'bz;
assign CHL_Y = (PS==CONVOLUTE) ? channel_y : 1'bz;
assign done = (count == (N-2)*(M-2)) ? 1'b1 : 1'b0;
endmodule
