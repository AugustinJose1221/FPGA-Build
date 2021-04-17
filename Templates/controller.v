
module controller(
input clk,                 //clock
input rst_n,               //external reset
input done_1,              //
input done_2,
input start,               //external start command
output trigger_1,          //
output trigger_2
);

parameter [1:0] IDLE = 2'b00, SLAVE_1 = 2'b01, SLAVE_2 = 2'b10;
reg [1:0] CS, NS;

always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  CS <= IDLE;
 else CS <= NS;
end

always @(start, done_1, done_2)
begin
 case(CS)
 IDLE: begin
        if (start == 1'b1)
         NS = SLAVE_1;
        else NS = IDLE;
       end
 SLAVE_1: begin
               if (done_1 == 1'b1)
                NS = SLAVE_2;
               else NS = SLAVE_1;
              end
 SLAVE_2: begin
               if (done_2 == 1'b1)
                NS = IDLE;
               else NS = SLAVE_2;
             end
 default: NS = IDLE;
 endcase
end

assign trigger_1 = (CS == SLAVE_1) ? 1'b1 : 1'b0; 
assign trigger_2 = (CS == SLAVE_2) ? 1'b1 : 1'b0; 

endmodule