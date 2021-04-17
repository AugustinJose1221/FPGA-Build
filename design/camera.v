
`timescale 1ns/1ns

module camera(
  input clk,                                  // clock
  input camera_en,                            // camera enable
  output reg data_valid,                      // data valid
  output reg [7:0] data_out);                 // output data bus


reg [7:0] DATA [0:11];                        // Camera Data
integer ptr;

initial
begin
  ptr <= 0;
  DATA[0] <= 8'hBC;
  DATA[1] <= 8'h27;
  DATA[2] <= 8'h81;
  DATA[3] <= 8'hFF;
  DATA[4] <= 8'hCE;
  DATA[5] <= 8'h1F;
  DATA[6] <= 8'hE0;
  DATA[7] <= 8'hA9;
  DATA[8] <= 8'h38;
  DATA[9] <= 8'h2B;
  DATA[10] <= 8'hD4;
  DATA[11] <= 8'h11;
end

always @(posedge clk)
begin
 if(camera_en)
 begin
  data_valid <= 1'b1;
  data_out <= DATA[ptr];
  ptr <= ptr + 1;
 end
 else 
 begin
  data_valid <= 1'b0;
  ptr <= 0;
  data_out <= 8'hzz;
 end
 if(ptr == 11)
  ptr <= 0;
end


endmodule
