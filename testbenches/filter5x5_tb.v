module filter5x5_tb;

reg [7:0]     Din;
reg           rst, clk, data_valid;
wire          fill_now;
wire [1:0]    state;
wire [15:0]   Dout;

filter5x5 UUT (Din, data_valid, rst, clk, fill_now, Dout);

initial
begin
 clk = 0;
 $dumpfile("vcd/filter5x5.vcd");
 $dumpvars(0, filter5x5_tb);
 rst = 1;
 Din = 8'h00;
 data_valid = 0;
 #2;
 rst = 0;
 data_valid = 1;
 Din = 8'h23;
 #2;
 Din = 8'h55;
 #2;
 Din = 8'h14;
 #2;
 Din = 8'hf5;
 #2;
 Din = 8'h4c;
 #2;
 Din = 8'h56;
 #2;
 Din = 8'h11;
 #2;
 Din = 8'haa;
 #2;
 Din = 8'hae;
 #2;
 Din = 8'hcd;
 #2;
 Din = 8'hc6;
 #2;
 Din = 8'h44;
 #2;
 Din = 8'he7;
 #2;
 Din = 8'hd9;
 #2;
 Din = 8'hf0;
 #2;
 #1000;
 $finish;
end

always
begin
 clk = ~clk;
 #1;
end

endmodule
