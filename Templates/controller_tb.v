

module controller_tb();

reg clk, rst_n, start;
wire done_1, done_2, trigger_1, trigger_2;
wire [3:0] slave_out_1, slave_out_2;

slave_1 one (clk, rst_n, trigger_1, done_1, slave_out_1);
slave_1 two (clk, rst_n, trigger_2, done_2, slave_out_2);
controller control (clk, rst_n, done_1, done_2, start, trigger_1, trigger_2);

initial
begin
 $dumpfile("controller_tb.vcd");
 $dumpvars(0, controller_tb);

 rst_n = 0;
 start = 0;
 #10;
 rst_n = 1;
 start = 1;
 #200;
 $finish;
end

always
begin
 clk = 1'b1;
 #5;
 clk = 1'b0;
 #5;
end
endmodule
