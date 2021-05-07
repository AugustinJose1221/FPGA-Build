/*
Working of this module:
It uses two reg arrays, one to store the image of resolution n x m pixels in one frame and the other to select the required pixels for the convolution.
Here one pixel is considered to be of 1 byte wide. To do this, the entire operation is divided into 3 subtasks:-
a) storage of the n x m pixels
b) selecting the 9 bytes needed to perform the sobel filter convolution
c) performing the 3 x 3 sobel convolution
This cycle repeats for every subsequent frames. A FSM with 4 states is defined to sequence these subtasks correctly.
*/
module filter5x5(
input [7:0]         Din,
input               data_valid, rst, clk,
output              fill_now,                                                 //status signal to indicate whether the first reg matrix is empty or not
output [15:0]       Dout
);


reg [7:0] storage[0:(N*M)-1];                                                   //reg array to store the image pixels in a frame of operation
reg [7:0] padded_image[0:((N+18)*(M+18))-1];
reg [7:0] image_kernal[0:24];                                                  //reg array to house the 9 bytes for the sobel convolution
reg [15:0] result;
reg [15:0] result0;
reg [15:0] result1;
reg [15:0] result2;
reg [15:0] result3;
reg [15:0] result4;
reg [2:0] PS, NS;

integer count, i, j, k, p, q, r, s, o, pos;

parameter IDLE = 3'b000, STORE = 3'b001, FIX = 3'b010, CONVOLUTE = 3'b011, PADDING = 3'b100;
parameter N = 480, M = 320;                                                       //resolution of the image


//sequential logic
always @(posedge clk or posedge rst)
begin
 if (~rst)
  PS <= IDLE;    //every value is reset to its default value in IDLE
 else PS <= NS;
end

always @(posedge clk)
begin
 if(data_valid)//PS == STORE)
 begin
  storage[i] <= Din;    //to store the incoming pixel byte into the next position in the storage array
  i <= (i == N*M-1) ? 0 : i + 1;
 end
 else i <= 0;
end

always @(Din,data_valid,i,count,k,PS)
begin
 case (PS)
 IDLE: begin
       result = 16'h0000;
       result0 = 16'h0000;
       result1 = 16'h0000;
       result2 = 16'h0000;
       result3 = 16'h0000;
       result4 = 16'h0000;
       count = 0;  //to count the number of convolutions in a frame
       j = 7;
       k = 0;
       o = 0;
       if(data_valid)
        NS = STORE;
       else NS = IDLE;
      end
 STORE: begin
         NS = (i == N*M-1) ? PADDING : STORE;
        end
 PADDING: begin
          for(r = 0; r < 9*(M+18); r = r+1)
          begin
           padded_image[r] = 0;
          end
          pos = r;
          for(s = 0; s < N; s = s+1)
          begin
           for(r = 0; r < 9; r = r+1)
           begin
            padded_image[pos+r] = 0;
           end
           pos = pos + r;
           for(r = 0; r < M; r = r+1)
           begin
            padded_image[pos+r] = storage[(M*s)+r];
           end
           pos = pos + r;
           for(r = 0; r < 9; r = r+1)
           begin
            padded_image[pos+r] = 0;
           end
           pos = pos + r;
          end
          for(r = 0; r < 9*(M+18); r = r+1)
          begin
           padded_image[pos+r] = 0;
          end
          NS = FIX;
          end
 FIX:  begin
        // sigma = 1
        o = 0;
        for(p = 0; p < 5; p = p+1)
        begin
         for(q = 0; q < 5; q = q+1)
         begin
          image_kernal[o] = padded_image[j + (p*(M+18)) + q + (7*(M+18))];
          o = o + 1;
         end
        end
        NS = CONVOLUTE;
       end
 CONVOLUTE: begin
             result0 = (0.002915 * image_kernal[0]) + (0.013064 * image_kernal[1]) + (0.021539 * image_kernal[2]) + (0.013064 * image_kernal[3]) + (0.002915 * image_kernal[4]) + (0.013064 * image_kernal[5]) + (0.05855 * image_kernal[6]) + (0.096532 * image_kernal[7]) + (0.05855 * image_kernal[8]) + (0.013064 * image_kernal[9]) + (0.021539 * image_kernal[10]) + (0.096532 * image_kernal[11]) + (0.159155 * image_kernal[12]) + (0.096532 * image_kernal[13]) + (0.021539 * image_kernal[14]) + (0.013064 * image_kernal[15]) + (0.05855 * image_kernal[16]) + (0.096532 * image_kernal[17]) + (0.05855 * image_kernal[18]) + (0.013064 * image_kernal[19]) + (0.002915 * image_kernal[20]) + (0.013064 * image_kernal[21]) + (0.021539 * image_kernal[22]) + (0.013064 * image_kernal[23]) + (0.002915 * image_kernal[24]);
             //result = image_kernal[0];
             result = result0;

             //sigma = 1
             k = (k == M-1) ? 0 : k + 1;
             j = (k == 0) ? j + 3 + 9 + 7 : j + 1;

             
             count = count + 1;
             NS = (count==(N)*(M)) ? IDLE : FIX;
            end
 endcase
end


assign fill_now = (PS==CONVOLUTE) ? 1'b1 : 1'b0; //storage is full when PS is in FIX and CONVOLUTE states.
assign Dout = (PS==CONVOLUTE) ? result : 16'hzzzz;  //output data is available when PS is in CONVOLUTE state.

endmodule
