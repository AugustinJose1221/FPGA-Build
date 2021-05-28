
//`timescale 1ns/1ns

module camera(
input               clk,                                  // clock
input               camera_en,                            // camera enable
output reg          data_valid,                           // data valid
output reg [7:0]    data_out);                            // output data bus


reg [7:0] DATA [0:74];                                    // Camera Data
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
 DATA[12] <= 8'h10;
 DATA[13] <= 8'h0F;
 DATA[14] <= 8'h6E;
 DATA[15] <= 8'hBF;
 DATA[16] <= 8'h50;
 DATA[17] <= 8'hA3;
 DATA[18] <= 8'h45;
 DATA[19] <= 8'h2C;
 DATA[20] <= 8'h44;
 DATA[21] <= 8'h01;
 DATA[22] <= 8'h21;
 DATA[23] <= 8'hDF;
 DATA[24] <= 8'h1E;
 DATA[25] <= 8'h7F;
 DATA[26] <= 8'h80;
 DATA[27] <= 8'h39;
 DATA[28] <= 8'h48;
 DATA[29] <= 8'hCB;
 DATA[30] <= 8'hC4;
 DATA[31] <= 8'hCC;
 DATA[32] <= 8'h8F;
 DATA[33] <= 8'hF2;
 DATA[34] <= 8'hC4;
 DATA[35] <= 8'h10;
 DATA[36] <= 8'hE1;
 DATA[37] <= 8'hA0;
 DATA[38] <= 8'h30;
 DATA[39] <= 8'h24;
 DATA[40] <= 8'hD6;
 DATA[41] <= 8'h16;
 DATA[42] <= 8'h91;
 DATA[43] <= 8'hF9;
 DATA[44] <= 8'h43;
 DATA[45] <= 8'h13;
 DATA[46] <= 8'hE0;
 DATA[47] <= 8'hA2;
 DATA[48] <= 8'h38;
 DATA[49] <= 8'h2F;
 DATA[50] <= 8'hD4;
 DATA[51] <= 8'h15;
 DATA[52] <= 8'h8C;
 DATA[53] <= 8'hFF;
 DATA[54] <= 8'hC1;
 DATA[55] <= 8'h1F;
 DATA[56] <= 8'hE5;
 DATA[57] <= 8'hA9;
 DATA[58] <= 8'h3B;
 DATA[59] <= 8'h2B;
 DATA[60] <= 8'hDD;
 DATA[61] <= 8'h11;
 DATA[62] <= 8'h8E;
 DATA[63] <= 8'hFF;
 DATA[64] <= 8'hCA;
 DATA[65] <= 8'h1F;
 DATA[66] <= 8'hEE;
 DATA[67] <= 8'hA9;
 DATA[68] <= 8'h37;
 DATA[69] <= 8'h2B;
 DATA[70] <= 8'hE4;
 DATA[71] <= 8'h11;
 DATA[72] <= 8'hE1;
 DATA[73] <= 8'hFF;
 DATA[74] <= 8'hDE;
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
 if(ptr == 74)
  ptr <= 0;
end


endmodule
