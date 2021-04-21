
`timescale 1ns/1ns

module BRWM_tb();

reg         clk, on_off, clear, rw, pause;
reg [7:0]   data_in;
wire [7:0]  data_out;
wire        done;

BRWM DUT (clk, on_off, rw, clear, pause, data_in, data_out, done);

initial
begin
 $dumpfile("../vcd/BRWM_tb.vcd");
 $dumpvars(0, BRWM_tb);

 data_in = 8'h00;
 pause = 0;
 on_off = 0;
 #150;
 clear = 0;
 on_off = 1;
 rw = 1;
 #150;
 rw = 0;
 #150;
 clear = 1;
 #150;
 on_off = 0;
 clear = 0;
 #30;
 $finish;
end

always
begin
 clk = 1'b0;
 #1;
 clk = 1'b1;
 #1;
end

endmodule
