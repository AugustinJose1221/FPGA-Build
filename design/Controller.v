
//`timescale 1ns/1ns

module Controller(
input             clk,                      //clock
input             rst_n,                    //external asynchronous active low reset
input             RWM_1_done,               //status signal from the RWM_1 module
input             RWM_2_done,               //status signal from the RWM_2 module
input             GS_done,                  //status signal from the Grayscaler module
input             start,                    //external start command from user
output            RWM_1_enable,             //status signal to the RWM_1 module
output            rw_1,                     //status signal to the RWM_1 module
output            RWM_2_enable,             //status signal to the RWM_2 module
output            rw_2,                     //status signal to the RWM_2 module
output            camera_enable,            //status signal to the camera
output            GS_enable                 //status signal to the Grayscaler module
);

parameter [2:0] IDLE = 3'b000, CAMERA_READ = 3'b001, GRAYSCALE = 3'b010, FILTER = 3'b011;
reg [2:0] CS, NS;

//Sequential logic
always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  CS <= IDLE;
 else CS <= NS;
end

//Combinatorial logic
always @(start, GS_done, RWM_1_done, RWM_2_done)
begin
 case (CS)
 IDLE:
 begin
  if (start == 1'b1)
   NS = CAMERA_READ;
  else NS = IDLE;
 end
 CAMERA_READ:
 begin
  if (RWM_1_done == 1'b1)
   NS = GRAYSCALE;
  else NS = CAMERA_READ;
 end
 GRAYSCALE:
 begin
  if (RWM_1_done == 1'b1)
   NS = FILTER;
  else NS = GRAYSCALE;
 end
 FILTER:
 begin
  if ((GS_done == 1'b1) || RWM_2_done == 1'b0)
   NS = FILTER;
  else NS = IDLE;
 end
 default: NS = IDLE;
 endcase
end

assign camera_enable = (CS == CAMERA_READ) ? 1'b1 : 1'b0;
assign RWM_1_enable = ((CS == CAMERA_READ) || (CS == GRAYSCALE)) ? 1'b1 : 1'b0;
assign rw_1 = (CS == CAMERA_READ) ? 1'b1 :((CS == GRAYSCALE) ? 1'b0 : 1'bz);
assign RWM_2_enable = ((CS == GRAYSCALE) || (CS == FILTER)) ? 1'b1 : 1'b0;
assign rw_2 = (CS == GRAYSCALE) ? 1'b1 : ((CS == FILTER) ? 1'b0 : 1'bz);
assign GS_enable = (CS == GRAYSCALE) ? 1'b1 : 1'b0;

endmodule
