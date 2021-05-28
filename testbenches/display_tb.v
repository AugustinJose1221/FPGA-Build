module display_tb();
reg       clk;
reg       data_valid;
reg [7:0] data_out;

display UUT(clk, data_valid, data_out);

initial
begin
 clk = 0;
 data_valid = 0;
 #2;
 data_valid = 1;
 data_out = 8'h34;
 #2;
 data_out = 8'h57;
 #2;
 data_out = 8'h9B;
 #2;
 data_valid = 0;
 data_out = 8'h11;
 #2;
 data_out = 8'h13;
 #2;
 $finish;
end
always
begin
 clk = ~clk;
 #1;
end
endmodule
