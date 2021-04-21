
`timescale 1ns/1ns

module Controller(
input             clk,                      //clock
input             rst_n,                    //external asynchronous active low reset
input             RWM_1_done,               //status signal from the RWM module
input             GS_done,                  //status signal from the Grayscaler module
input             start,                    //external start command from user
output reg        RWM_enable,          //status signal to the RWM module
output reg        rw,                  //status signal to the RWM module
output            camera_enable,           //status signal to the camera
output            GS_enable                //status signal to the Grayscaler module
);

parameter [1:0] IDLE = 2'b00, CAMERA_READ = 2'b01, GRAY_WRITE = 2'b10;
reg [1:0] CS, NS;

//Sequential logic
always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  CS <= IDLE;
 else CS <= NS;
end

//Combinatorial logic
always @(start, GS_done, RWM_1_done)
begin
 case (CS)
 IDLE:
 begin
  RWM_enable = 1'b0;
  rw = 1'bz;
  if (start == 1'b1)
   NS = CAMERA_READ;
  else NS = IDLE;
 end
 CAMERA_READ:
 begin
  RWM_enable = 1'b1;
  rw = 1'b1;
  if (RWM_1_done == 1'b1)
   NS = GRAY_WRITE;
  else NS = CAMERA_READ;
 end
 GRAY_WRITE:
 begin
  RWM_enable = 1'b1;
  rw = 1'b0;
  if (GS_done == 1'b1 || RWM_1_done == 1'b1)
   NS = IDLE;
  else NS = GRAY_WRITE;
 end
 default: NS = IDLE;
 endcase
end

assign camera_enable = (CS == CAMERA_READ) ? 1'b1 : 1'b0;
assign GS_enable = (CS == GRAY_WRITE) ? 1'b1 : 1'b0;

endmodule
