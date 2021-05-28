module interface();
reg         clk;
reg         camera_en;
wire        data_valid;
wire [7:0]  data_out;

parameter N = 64, M = 64;

image IMAGE(clk, camera_en, data_valid, data_out);
display DISPLAY(clk, data_valid, data_out);

initial
begin
 clk = 0;
 camera_en = 0;
 #2;
 camera_en = 1;
 #((N*M*6)+2);
 $finish;
end
always
begin
 clk = ~clk;
 #1;
end
endmodule
