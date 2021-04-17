
`timescale 1ns/1ns

module Grayscaler(
 input clk,                     //clock
 input rst_n,                   //external asynchronous active low reset
 input GS_enable,               //to enable or disable this module. Driven by controller
 input [7:0] Din,               //input data bus. Connected to BRWM module
 output [7:0] Dout,             //output data bus. 
 output pause,                  //an active high signal that tells the BRWM module to pause whatever operation it is doing.
 output reg GS_done             //after the completion of an operation done is set to 1. It is a status signal to drive the controller
);

parameter N = 2, M = 2;           // Height and width of the image
reg [7:0] red, green, blue, cache, result;
integer c, d;

parameter IDLE = 2'b00, FILL = 2'b01, CALCULATE = 2'b10;
reg [1:0] CS, NS;

always @(posedge clk or negedge rst_n) 
begin
if(~rst_n)
  CS <= IDLE;
 else 
 begin
  CS <= NS;
  cache <= Din;
 end
end

always @(*) 
begin
 case (CS) 
 IDLE: begin
        d = 0;
        c = 0;
        red = 8'h00;
        green = 8'h00;
        blue = 8'h00;
        GS_done = 1'b0;
        if(GS_enable == 1'b1)
         NS = FILL;
        else NS = IDLE;
       end
 FILL: begin
        GS_done = 1'b0;
        if(c == 0)
        begin
         red = cache;
         c = c + 1;
         NS = FILL;
        end
        else if(c == 1)
             begin
              green = cache;
              c = c + 1;
              NS = FILL;
             end
             else
             begin
              blue = cache;
              c = c + 1;
              NS = CALCULATE;  
             end
       end
 CALCULATE: begin
             c = 0;
             result = (red>>2) + (red>>5) + (green>>1) + (green>>4) + (blue>>4) + (blue>>5);
             d = d + 1;
             if (d == N*M)
              begin
              NS = IDLE;
              GS_done = 1'b1;
              end
             else 
             begin
              NS = FILL;
              GS_done = 1'b0;
             end
            end
 default: NS = IDLE;
 endcase
end

assign pause = ((CS == FILL) && (c == 2)) ? 1'b1 : 1'b0;
assign Dout = (CS == CALCULATE) ? result : 8'hzz;

endmodule