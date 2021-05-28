module image_tb();

reg           clk;
reg           camera_en;
wire          data_valid;
wire [7:0]    data_out;

image UUT(clk, camera_en, data_valid, data_out);

initial
begin
 clk = 0;
 $dumpfile("vcd/image.vcd");
 $dumpvars(0, image_tb);
 camera_en = 0;
 #2;
 camera_en = 1;
 #1000;
 $finish;
end

always
begin
 clk = ~clk;
 #1;
end
endmodule
