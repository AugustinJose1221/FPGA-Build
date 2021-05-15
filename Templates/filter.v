/*
Working of this module:
It uses two reg arrays, one to store the image of resolution n x m pixels in one frame and the other to select the required pixels for the convolution.
Here one pixel is considered to be of 1 byte wide. To do this, the entire operation is divided into 3 subtasks:-
a) storage of the n x m pixels
b) selecting the 9 bytes needed to perform the sobel filter convolution
c) performing the 3 x 3 sobel convolution
This cycle repeats for every subsequent frames. A FSM with 4 states is defined to sequence these subtasks correctly.
*/
`timescale 1ns/1ns

module filter(
input [7:0]         Din,
input               data_valid, rst, clk,
output              fill_now,                                                 //status signal to indicate whether the first reg matrix is empty or not
output [15:0]       Dout
);


reg [7:0] storage[0:N*M-1];                                                   //reg array to store the image pixels in a frame of operation
reg [7:0] image_kernal[0:24];                                                  //reg array to house the 9 bytes for the sobel convolution
reg [15:0] result;
reg [15:0] result0;
reg [15:0] result1;
reg [15:0] result2;
reg [15:0] result3;
reg [15:0] result4;
reg [1:0] PS, NS;

integer count, i, j, k;

parameter IDLE = 2'b00, STORE = 2'b01, FIX = 2'b10, CONVOLUTE = 2'b11;
parameter N = 450, M = 600;                                                       //resolution of the image


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

//combinatorial logic
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
        j = 0;
        k = 0;

        if(data_valid)
         NS = STORE;
        else NS = IDLE;
       end
 STORE: begin
         NS = (i == N*M-1) ? FIX : STORE;
        end
 FIX: begin
       //to place the the required bytes in the kernal for convolution
       image_kernal[0] = storage[j];
       image_kernal[1] = storage[j+1];
       image_kernal[2] = storage[j+2];
       image_kernal[3] = storage[j+3];
       image_kernal[4] = storage[j+4];

       image_kernal[5] = storage[j+M];
       image_kernal[6] = storage[j+M+1];
       image_kernal[7] = storage[j+M+2];
       image_kernal[8] = storage[j+M+3];
       image_kernal[9] = storage[j+M+4];

       image_kernal[10] = storage[j+(2*M)];
       image_kernal[11] = storage[j+(2*M)+1];
       image_kernal[12] = storage[j+(2*M)+2];
       image_kernal[13] = storage[j+(2*M)+3];
       image_kernal[14] = storage[j+(2*M)+4];

       image_kernal[15] = storage[j+(3*M)];
       image_kernal[16] = storage[j+(3*M)+1];
       image_kernal[17] = storage[j+(3*M)+2];
       image_kernal[18] = storage[j+(3*M)+3];
       image_kernal[19] = storage[j+(3*M)+4];

       image_kernal[20] = storage[j+(4*M)];
       image_kernal[21] = storage[j+(4*M)+1];
       image_kernal[22] = storage[j+(4*M)+2];
       image_kernal[23] = storage[j+(4*M)+3];
       image_kernal[23] = storage[j+(4*M)+4];

       NS = CONVOLUTE;
      end
 CONVOLUTE: begin
             // sigma = 3
             result0 = (0.011339 * image_kernal[0]) + (0.013395 * image_kernal[1]) + (0.01416 * image_kernal[2]) + (0.013395 * image_kernal[3]) + (0.011339 * image_kernal[4]) + (0.013395 * image_kernal[5]) + (0.015824 * image_kernal[6]) + (0.016728 * image_kernal[7]) + (0.015824 * image_kernal[8]) + (0.013395 * image_kernal[9]) + (0.01416 * image_kernal[10]) + (0.016728 * image_kernal[11]) + (0.017684 * image_kernal[12]) + (0.016728 * image_kernal[13]) + (0.01416 * image_kernal[14]) + (0.013395 * image_kernal[15]) + (0.015824 * image_kernal[16]) + (0.016728 * image_kernal[17]) + (0.015824 * image_kernal[18]) + (0.013395 * image_kernal[19]) + (0.011339 * image_kernal[20]) + (0.013395 * image_kernal[21]) + (0.01416 * image_kernal[22]) + (0.013395 * image_kernal[23]) + (0.011339 * image_kernal[24]);
             // sigma = 5
             result1 = (0.005425 * image_kernal[0]) + (0.00576 * image_kernal[1]) + (0.005877 * image_kernal[2]) + (0.00576 * image_kernal[3]) + (0.005425 * image_kernal[4]) + (0.00576 * image_kernal[5]) + (0.006117 * image_kernal[6]) + (0.00624 * image_kernal[7]) + (0.006117 * image_kernal[8]) + (0.00576 * image_kernal[9]) + (0.005877 * image_kernal[10]) + (0.00624 * image_kernal[11]) + (0.006366 * image_kernal[12]) + (0.00624 * image_kernal[13]) + (0.005877 * image_kernal[14]) + (0.00576 * image_kernal[15]) + (0.006117 * image_kernal[16]) + (0.00624 * image_kernal[17]) + (0.006117 * image_kernal[18]) + (0.00576 * image_kernal[19]) + (0.005425 * image_kernal[20]) + (0.00576 * image_kernal[21]) + (0.005877 * image_kernal[22]) + (0.00576 * image_kernal[23]) + (0.005425 * image_kernal[24]);
             // sigma = 7
             result2 = (0.002993 * image_kernal[0]) + (0.003086 * image_kernal[1]) + (0.003118 * image_kernal[2]) + (0.003086 * image_kernal[3]) + (0.002993 * image_kernal[4]) + (0.003086 * image_kernal[5]) + (0.003182 * image_kernal[6]) + (0.003215 * image_kernal[7]) + (0.003182 * image_kernal[8]) + (0.003086 * image_kernal[9]) + (0.003118 * image_kernal[10]) + (0.003215 * image_kernal[11]) + (0.003248 * image_kernal[12]) + (0.003215 * image_kernal[13]) + (0.003118 * image_kernal[14]) + (0.003086 * image_kernal[15]) + (0.003182 * image_kernal[16]) + (0.003215 * image_kernal[17]) + (0.003182 * image_kernal[18]) + (0.003086 * image_kernal[19]) + (0.002993 * image_kernal[20]) + (0.003086 * image_kernal[21]) + (0.003118 * image_kernal[22]) + (0.003086 * image_kernal[23]) + (0.002993 * image_kernal[24]);
             // sigma = 9
             result3 =  (0.00187 * image_kernal[0]) + (0.001905 * image_kernal[1]) + (0.001917 * image_kernal[2]) + (0.001905 * image_kernal[3]) + (0.00187 * image_kernal[4]) + (0.001905 * image_kernal[5]) + (0.001941 * image_kernal[6]) + (0.001953 * image_kernal[7]) + (0.001941 * image_kernal[8]) + (0.001905 * image_kernal[9]) + (0.001917 * image_kernal[10]) + (0.001953 * image_kernal[11]) + (0.001965 * image_kernal[12]) + (0.001953 * image_kernal[13]) + (0.001917 * image_kernal[14]) + (0.001905 * image_kernal[15]) + (0.001941 * image_kernal[16]) + (0.001953 * image_kernal[17]) + (0.001941 * image_kernal[18]) + (0.001905 * image_kernal[19]) + (0.00187 * image_kernal[20]) + (0.001905 * image_kernal[21]) + (0.001917 * image_kernal[22]) + (0.001905 * image_kernal[23]) + (0.00187 * image_kernal[24]);

             result4 = (0.002915 * image_kernal[0]) + (0.013064 * image_kernal[1]) + (0.021539 * image_kernal[2]) + (0.013064 * image_kernal[3]) + (0.002915 * image_kernal[4]) + (0.013064 * image_kernal[5]) + (0.05855 * image_kernal[6]) + (0.096532 * image_kernal[7]) + (0.05855 * image_kernal[8]) + (0.013064 * image_kernal[9]) + (0.021539 * image_kernal[10]) + (0.096532 * image_kernal[11]) + (0.159155 * image_kernal[12]) + (0.096532 * image_kernal[13]) + (0.021539 * image_kernal[14]) + (0.013064 * image_kernal[15]) + (0.05855 * image_kernal[16]) + (0.096532 * image_kernal[17]) + (0.05855 * image_kernal[18]) + (0.013064 * image_kernal[19]) + (0.002915 * image_kernal[20]) + (0.013064 * image_kernal[21]) + (0.021539 * image_kernal[22]) + (0.013064 * image_kernal[23]) + (0.002915 * image_kernal[24]);

             result = image_kernal[0];
             count = count + 1;
             if(count != (N-4)*(M-4))
             begin
              if(k != (M-4))
              begin
               j = j + 1;
               k = k + 1;
               NS = FIX;
              end
              else
              begin
               j = j + 5;
               k = 0;
               NS = FIX;
              end
             end
             else NS = IDLE;
            end

 endcase
end

assign fill_now = (PS==CONVOLUTE) ? 1'b1 : 1'b0; //storage is full when PS is in FIX and CONVOLUTE states.
assign Dout = (PS==CONVOLUTE) ? result : 16'hzzzz;  //output data is available when PS is in CONVOLUTE state.

endmodule
