/*
MODULE OVERVIEW:
Purpose of this module:
To store the RGB pixel bytes coming from the camera. It works with the camera, controller and the grayscaling module.

Working:
The 5 states of the FSM used in this module are described below:-
1)INACTIVE: Whenever the module is not in use, it is in this state. It waits for further commands from the controller.

2)WRITE: Writes the contents of the input data bus to the internal register array. After completion, it goes back to INACTIVE.

3)READ: Writes the contents of the internal data bus to the output data bus. After completion, it goes back to INACTIVE.

4)WAIT: The grayscaling module can interrupt this module during the READ operation by asserting the 'pause' signal.
        If this happens, the module goes to this state, where it preserves the location address.
        It then waits for the 'pause' signal to be disabled so that it can go back to READ state.

5)CLEANUP: Clears the contents of the internal register array to 8'h00 upon receiving the 'clear' command from the controller.
           After completion, it goes back to INACTIVE.
*/


module RWM_1(
input           clk,                      // clock
input           rst_n,                    // external asynchronous active low reset
input           RWM_enable,               // to enable or disable the R/W memory. Driven by controller
input           rw,                       // rw = 0: read, rw = 1: write. Driven by controller
input           clear,                    // an active high signal to clear all the contents of the R/W memory. Driven by controller
input           pause,                    // an active high signal that tells the module to pause whatever operation it is doing. Driven by Grayscaler
input [7:0]     data_in,                  // input data bus. Comes from the camera
output [7:0]    data_out,                 // ouput data bus. Connected to Grayscaling module
output          RWM_valid,                // an active high signal indicating the presence of desired data at the output data bus
output reg      RWM_done                  // after the completion of an operation done is set to 1. It is a status signal to drive the controller
);

parameter N = 450, M = 450;

reg [7:0] DATA[0:(3*N*M - 1)];            // RWM register array

reg [2:0] CS, NS;                         // RWM state variables

//RWM states
parameter INACTIVE = 3'b000, READ = 3'b001, WRITE = 3'b010, WAIT = 3'b011, CLEANUP = 3'b100;

integer i, j, k = 0;                      // Loop variable for addressing the RWM register array

// Sequential Logic
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
    CS <= INACTIVE;
  else
  begin
   CS <= NS;
   k = (CS == READ) ? k + 1 : 0;
  end
end

always @(posedge clk)
begin
 case (CS)
 INACTIVE: i <= 0;                        // Keep the memory address pointer at 0
 WRITE:
 begin
  DATA[i] <= data_in;                     // Writing into RWM
  i <= (i == 3*N*M - 1) ? 0 : i + 1;
 end
 READ:
 begin                                    // Reading from RWM
  i <= (i == 3*N*M - 1) ? 0 : i + 1;
 end
 WAIT: i <= i;                            // Preserve the address location
 CLEANUP:
 begin
  for(j = 0; j < N*M*3; j = j+1)
  begin
   DATA[j] <= 8'h00;                      // Clearing RWM registers
  end
 end
 endcase
end

// Combinatorial Logic
always @(RWM_enable, rw, i, pause)
begin
  case (CS)
  INACTIVE:
  begin
   RWM_done = 1'b0;
   if (RWM_enable == 1'b0)
    NS = INACTIVE;
   else if (clear == 1'b1)
    NS = CLEANUP;
   else NS = (rw == 1) ? WRITE : READ;
  end
  WRITE:
  begin
   NS = (i == 3*N*M - 1) ? INACTIVE : WRITE;
   RWM_done = (i == 3*N*M - 1) ? 1'b1 : 1'b0;
  end
  READ:
  begin
   if (k == 2 && i != 3*N*M - 1)
    NS = WAIT;
   else NS = (i == 3*N*M - 1) ? INACTIVE : READ;
   RWM_done = (i == 3*N*M - 1) ? 1'b1 : 1'b0;
  end
  WAIT:
  begin
   RWM_done = 1'b0;
   if (k == 3)
    NS = READ;
   else NS = WAIT;
  end
  CLEANUP:
  begin
   NS = (j == 3*N*M - 1) ? INACTIVE : CLEANUP;
   RWM_done = (j == 3*N*M - 1) ? 1'b1 : 1'b0;
  end
  default: NS = INACTIVE;
  endcase
end

assign data_out = (CS == READ) ? DATA[i] : 8'hzz;
assign RWM_valid = (CS == READ) ? 1'b1 : 1'b0;

endmodule
