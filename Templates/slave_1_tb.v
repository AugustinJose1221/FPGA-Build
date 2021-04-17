

module slave_1_tb();

reg clk, rst_n, slave_en;
wire slave_done;
wire [3:0] slave_out;

slave_1 obey (clk, rst_n, slave_en, slave_done, slave_out);

initial 
begin
 $dumpfile("slave_1_tb.vcd");
 $dumpvars(0, slave_1_tb);

 rst_n = 0;
 slave_en = 0;
 #10;
 rst_n = 1;
 slave_en = 1;
 #40;
 slave_en = 0;
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
