
module slave_1(
 input              clk,
 input              rst_n,
 input              slave_en,
 output             slave_done,
 output reg [3:0]   slave_out
);
always @(posedge clk or negedge rst_n)
begin
 if (~rst_n)
  slave_out <= 0;
 else if (slave_en)
  slave_out <= slave_out + 1;
 else slave_out <= 0;
end
assign slave_done = (slave_out == 4) ? 1'b1 : 1'b0;
endmodule
