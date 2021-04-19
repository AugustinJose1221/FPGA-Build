/*
Function of this module:
To calculate the grayscale values of each colour pixel(R,G,B respectively) stored in first memory module.
It communicates with the controller and the memory modules.

Working:
The module makes use of a FSM with 3 states:-
1)IDLE: Whenever the module is not in use, it is in this state. It waits for further commands from the controller.

2)FILL: Here every three pixel bytes at the input data bus is loaded into the internal registers for grayscale calculation.
        Every byte is first loaded into a temporary register named 'cache' from the bus in one clock period.
        The cache register then transfers its contents to the internal registers in the following manner:
        First byte is stored in 'red', second in 'green' and third in 'blue'.
        After the third byte is recieved, a status signal is sent to the memory module to pause its operation.

3)CALCULATE: To find the grayscale value of the three bytes recieved.

*/

`timescale 1ns/1ns

module Grayscaler(
 input          clk,                     //clock
 input          rst_n,                   //external asynchronous active low reset
 input          GS_enable,               //to enable or disable this module. Driven by controller
 input          RWM_valid,               // an active high signal indicating the presence of desired data at the output data bus
 input [7:0]    Din,                     //input data bus. Connected to BRWM module
 output [7:0]   Dout,                    //output data bus.
 output         pause,                   //an active high signal that tells the BRWM module to pause whatever operation it is doing.
 output reg     GS_done                  //after the completion of an operation done is set to 1. It is a status signal to drive the controller
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
  //cache <= Din;
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
        if(GS_enable && RWM_valid)
         NS = FILL;
        else NS = IDLE;
       end
 FILL: begin
        GS_done = 1'b0;
        if(c == 0)
        begin
         red = Din;//cache;
         NS = FILL;
        end
        else if(c == 1)
        begin
         green = Din;//cache;
         NS = FILL;
        end
        else
        begin
         blue = Din;//''cache;
         NS = CALCULATE;
         d = d + 1;
        end
        c = c + 1;
       end
 CALCULATE: begin
             c = 0;
             result = (red>>2) + (red>>5) + (green>>1) + (green>>4) + (blue>>4) + (blue>>5);
             NS = (d == N*M) ? IDLE : FILL;
             GS_done = (d == N*M) ? 1'b1 : 1'b0;
            end
 default: NS = IDLE;
 endcase
end

assign pause = ((CS == FILL) && (c == 3) && (d != N*M)) ? 1'b1 : 1'b0;
assign Dout = (CS == CALCULATE) ? result : 8'hzz;

endmodule
