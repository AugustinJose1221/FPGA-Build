module filter5x5(
input [7:0]         Din,
input               data_valid, rst, clk,
output              fill_now,
output [15:0]       Diff1,
output [15:0]       Diff2,
output [15:0]       Diff3,
output              done);


reg [7:0] storage[0:(N*M)-1];
reg [7:0] padded_image[0:((N+18)*(M+18))-1];
reg [7:0] image_kernal[0:24];       // 5x5
reg [7:0] image_kernal1[0:80];      // 9x9
reg [7:0] image_kernal2[0:120];     // 11x11
reg [7:0] image_kernal3[0:224];     // 15x15
reg [7:0] image_kernal4[0:360];     // 19x19

reg [15:0] result;
reg [15:0] result0;
reg [15:0] result1;
reg [15:0] result2;
reg [15:0] result3;
reg [15:0] result4;
reg [2:0] PS, NS;

integer count, i, j, k, p, q, r, s, o, pos;
integer j1, j2, j3, j4;
integer k1, k2, k3;
parameter IDLE = 3'b000, STORE = 3'b001, FIX = 3'b010, CONVOLUTE = 3'b011, PADDING = 3'b100;

parameter N = 450, M = 450;
//parameter N = 480, M = 320;

//sequential logic
always @(posedge clk or negedge rst)
begin
 if (~rst)
  PS <= IDLE;
 else PS <= NS;
end

always @(posedge clk)
begin
 if(data_valid)
 begin
  storage[i] <= Din;
  i <= (i == N*M-1) ? 0 : i + 1;
 end
 else i <= 0;
end

always @(Din,data_valid,i,count,k,PS)
begin
 case (PS)
 IDLE: begin
       result = 16'h0000;
       result0 = 16'h0000;
       result1 = 16'h0000;
       result2 = 16'h0000;
       result3 = 16'h0000;
       result4 = 16'h0000;
       count = 0;
       j = 7;
       k = 0;
       o = 0;
       j1 = 5;
       j2 = 4;
       j3 = 2;
       j4 = 0;
       if(data_valid)
        NS = STORE;
       else NS = IDLE;
      end
 STORE: begin
         NS = (i == N*M-1) ? PADDING : STORE;
        end
 PADDING: begin
          for(r = 0; r < 9*(M+18); r = r+1)
          begin
           padded_image[r] = 0;
          end
          pos = r;
          for(s = 0; s < N; s = s+1)
          begin
           for(r = 0; r < 9; r = r+1)
           begin
            padded_image[pos+r] = 0;
           end
           pos = pos + r;
           for(r = 0; r < M; r = r+1)
           begin
            padded_image[pos+r] = storage[(M*s)+r];
           end
           pos = pos + r;
           for(r = 0; r < 9; r = r+1)
           begin
            padded_image[pos+r] = 0;
           end
           pos = pos + r;
          end
          for(r = 0; r < 9*(M+18); r = r+1)
          begin
           padded_image[pos+r] = 0;
          end
          NS = FIX;
          end
 FIX:  begin
        // sigma = 1
        o = 0;
        for(p = 0; p < 5; p = p+1)
        begin
         for(q = 0; q < 5; q = q+1)
         begin
          image_kernal[o] = padded_image[j + (p*(M+18)) + q + (7*(M+18))];
          o = o + 1;
         end
        end

        // sigma = 1.6
        o = 0;
        for(p = 0; p < 9; p = p+1)
        begin
         for(q = 0; q < 9; q = q+1)
         begin
          image_kernal1[o] = padded_image[j1 + (p*(M+18)) + q + (5*(M+18))];
          o = o + 1;
         end
        end

        // sigma = 2.26
        o = 0;
        for(p = 0; p < 11; p = p+1)
        begin
         for(q = 0; q < 11; q = q+1)
         begin
          image_kernal2[o] = padded_image[j2 + (p*(M+18)) + q + (4*(M+18))];
          o = o + 1;
         end
        end

        // sigma = 3.2
        o = 0;
        for(p = 0; p < 15; p = p+1)
        begin
         for(q = 0; q < 15; q = q+1)
         begin
          image_kernal3[o] = padded_image[j3 + (p*(M+18)) + q + (2*(M+18))];
          o = o + 1;
         end
        end

        // sigma = 4.5
        o = 0;
        for(p = 0; p < 19; p = p+1)
        begin
         for(q = 0; q < 19; q = q+1)
         begin
          image_kernal4[o] = padded_image[j4 + (p*(M+18)) + q];
          o = o + 1;
         end
        end

        NS = CONVOLUTE;
       end
 CONVOLUTE: begin
             // sigma = 1
             result0 = (0.002915 * image_kernal[0]) + (0.013064 * image_kernal[1]) + (0.021539 * image_kernal[2]) + (0.013064 * image_kernal[3]) + (0.002915 * image_kernal[4]) + (0.013064 * image_kernal[5]) + (0.05855 * image_kernal[6]) + (0.096532 * image_kernal[7]) + (0.05855 * image_kernal[8]) + (0.013064 * image_kernal[9]) + (0.021539 * image_kernal[10]) + (0.096532 * image_kernal[11]) + (0.159155 * image_kernal[12]) + (0.096532 * image_kernal[13]) + (0.021539 * image_kernal[14]) + (0.013064 * image_kernal[15]) + (0.05855 * image_kernal[16]) + (0.096532 * image_kernal[17]) + (0.05855 * image_kernal[18]) + (0.013064 * image_kernal[19]) + (0.002915 * image_kernal[20]) + (0.013064 * image_kernal[21]) + (0.021539 * image_kernal[22]) + (0.013064 * image_kernal[23]) + (0.002915 * image_kernal[24]);
             //result = image_kernal[0];

             // sigma = 1.6
             result1 = (0.00012 * image_kernal1[0]) + (0.000471 * image_kernal1[1]) + (0.001251 * image_kernal1[2]) + (0.002247 * image_kernal1[3]) + (0.002732 * image_kernal1[4]) + (0.002247 * image_kernal1[5]) + (0.001251 * image_kernal1[6]) + (0.000471 * image_kernal1[7]) + (0.00012 * image_kernal1[8]) + (0.000471 * image_kernal1[9]) + (0.001848 * image_kernal1[10]) + (0.004908 * image_kernal1[11]) + (0.008818 * image_kernal1[12]) + (0.010719 * image_kernal1[13]) + (0.008818 * image_kernal1[14]) + (0.004908 * image_kernal1[15]) + (0.001848 * image_kernal1[16]) + (0.000471 * image_kernal1[17]) + (0.001251 * image_kernal1[18]) + (0.004908 * image_kernal1[19]) + (0.013032 * image_kernal1[20]) + (0.023413 * image_kernal1[21]) + (0.028463 * image_kernal1[22]) + (0.023413 * image_kernal1[23]) + (0.013032 * image_kernal1[24]) + (0.004908 * image_kernal1[25]) + (0.001251 * image_kernal1[26]) + (0.002247 * image_kernal1[27]) + (0.008818 * image_kernal1[28]) + (0.023413 * image_kernal1[29]) + (0.042066 * image_kernal1[30]) + (0.05114 * image_kernal1[31]) + (0.042066 * image_kernal1[32]) + (0.023413 * image_kernal1[33]) + (0.008818 * image_kernal1[34]) + (0.002247 * image_kernal1[35]) + (0.002732 * image_kernal1[36]) + (0.010719 * image_kernal1[37]) + (0.028463 * image_kernal1[38]) + (0.05114 * image_kernal1[39]) + (0.06217 * image_kernal1[40]) + (0.05114 * image_kernal1[41]) + (0.028463 * image_kernal1[42]) + (0.010719 * image_kernal1[43]) + (0.002732 * image_kernal1[44]) + (0.002247 * image_kernal1[45]) + (0.008818 * image_kernal1[46]) + (0.023413 * image_kernal1[47]) + (0.042066 * image_kernal1[48]) + (0.05114 * image_kernal1[49]) + (0.042066 * image_kernal1[50]) + (0.023413 * image_kernal1[51]) + (0.008818 * image_kernal1[52]) + (0.002247 * image_kernal1[53]) + (0.001251 * image_kernal1[54]) + (0.004908 * image_kernal1[55]) + (0.013032 * image_kernal1[56]) + (0.023413 * image_kernal1[57]) + (0.028463 * image_kernal1[58]) + (0.023413 * image_kernal1[59]) + (0.013032 * image_kernal1[60]) + (0.004908 * image_kernal1[61]) + (0.001251 * image_kernal1[62]) + (0.000471 * image_kernal1[63]) + (0.001848 * image_kernal1[64]) + (0.004908 * image_kernal1[65]) + (0.008818 * image_kernal1[66]) + (0.010719 * image_kernal1[67]) + (0.008818 * image_kernal1[68]) + (0.004908 * image_kernal1[69]) + (0.001848 * image_kernal1[70]) + (0.000471 * image_kernal1[71]) + (0.00012 * image_kernal1[72]) + (0.000471 * image_kernal1[73]) + (0.001251 * image_kernal1[74]) + (0.002247 * image_kernal1[75]) + (0.002732 * image_kernal1[76]) + (0.002247 * image_kernal1[77]) + (0.001251 * image_kernal1[78]) + (0.000471 * image_kernal1[79]) + (0.00012 * image_kernal1[80]);

             // sigma = 2.26
             result2 =  (0.000233 * image_kernal2[0]) + (0.000563 * image_kernal2[1]) + (0.001117 * image_kernal2[2]) + (0.001823 * image_kernal2[3]) + (0.002445 * image_kernal2[4]) + (0.002696 * image_kernal2[5]) + (0.002445 * image_kernal2[6]) + (0.001823 * image_kernal2[7]) + (0.001117 * image_kernal2[8]) + (0.000563 * image_kernal2[9]) + (0.000233 * image_kernal2[10]) + (0.000563 * image_kernal2[11]) + (0.001359 * image_kernal2[12]) + (0.002696 * image_kernal2[13]) + (0.004399 * image_kernal2[14]) + (0.0059 * image_kernal2[15]) + (0.006507 * image_kernal2[16]) + (0.0059 * image_kernal2[17]) + (0.004399 * image_kernal2[18]) + (0.002696 * image_kernal2[19]) + (0.001359 * image_kernal2[20]) + (0.000563 * image_kernal2[21]) + (0.001117 * image_kernal2[22]) + (0.002696 * image_kernal2[23]) + (0.00535 * image_kernal2[24]) + (0.008728 * image_kernal2[25]) + (0.011707 * image_kernal2[26]) + (0.012911 * image_kernal2[27]) + (0.011707 * image_kernal2[28]) + (0.008728 * image_kernal2[29]) + (0.00535 * image_kernal2[30]) + (0.002696 * image_kernal2[31]) + (0.001117 * image_kernal2[32]) + (0.001823 * image_kernal2[33]) + (0.004399 * image_kernal2[34]) + (0.008728 * image_kernal2[35]) + (0.014239 * image_kernal2[36]) + (0.0191 * image_kernal2[37]) + (0.021064 * image_kernal2[38]) + (0.0191 * image_kernal2[39]) + (0.014239 * image_kernal2[40]) + (0.008728 * image_kernal2[41]) + (0.004399 * image_kernal2[42]) + (0.001823 * image_kernal2[43]) + (0.002445 * image_kernal2[44]) + (0.0059 * image_kernal2[45]) + (0.011707 * image_kernal2[46]) + (0.0191 * image_kernal2[47]) + (0.02562 * image_kernal2[48]) + (0.028255 * image_kernal2[49]) + (0.02562 * image_kernal2[50]) + (0.0191 * image_kernal2[51]) + (0.011707 * image_kernal2[52]) + (0.0059 * image_kernal2[53]) + (0.002445 * image_kernal2[54]) + (0.002696 * image_kernal2[55]) + (0.006507 * image_kernal2[56]) + (0.012911 * image_kernal2[57]) + (0.021064 * image_kernal2[58]) + (0.028255 * image_kernal2[59]) + (0.03116 * image_kernal2[60]) + (0.028255 * image_kernal2[61]) + (0.021064 * image_kernal2[62]) + (0.012911 * image_kernal2[63]) + (0.006507 * image_kernal2[64]) + (0.002696 * image_kernal2[65]) + (0.002445 * image_kernal2[66]) + (0.0059 * image_kernal2[67]) + (0.011707 * image_kernal2[68]) + (0.0191 * image_kernal2[69]) + (0.02562 * image_kernal2[70]) + (0.028255 * image_kernal2[71]) + (0.02562 * image_kernal2[72]) + (0.0191 * image_kernal2[73]) + (0.011707 * image_kernal2[74]) + (0.0059 * image_kernal2[75]) + (0.002445 * image_kernal2[76]) + (0.001823 * image_kernal2[77]) + (0.004399 * image_kernal2[78]) + (0.008728 * image_kernal2[79]) + (0.014239 * image_kernal2[80]) + (0.0191 * image_kernal2[81]) + (0.021064 * image_kernal2[82]) + (0.0191 * image_kernal2[83]) + (0.014239 * image_kernal2[84]) + (0.008728 * image_kernal2[85]) + (0.004399 * image_kernal2[86]) + (0.001823 * image_kernal2[87]) + (0.001117 * image_kernal2[88]) + (0.002696 * image_kernal2[89]) + (0.00535 * image_kernal2[90]) + (0.008728 * image_kernal2[91]) + (0.011707 * image_kernal2[92]) + (0.012911 * image_kernal2[93]) + (0.011707 * image_kernal2[94]) + (0.008728 * image_kernal2[95]) + (0.00535 * image_kernal2[96]) + (0.002696 * image_kernal2[97]) + (0.001117 * image_kernal2[98]) + (0.000563 * image_kernal2[99]) + (0.001359 * image_kernal2[100]) + (0.002696 * image_kernal2[101]) + (0.004399 * image_kernal2[102]) + (0.0059 * image_kernal2[103]) + (0.006507 * image_kernal2[104]) + (0.0059 * image_kernal2[105]) + (0.004399 * image_kernal2[106]) + (0.002696 * image_kernal2[107]) + (0.001359 * image_kernal2[108]) + (0.000563 * image_kernal2[109]) + (0.000233 * image_kernal2[110]) + (0.000563 * image_kernal2[111]) + (0.001117 * image_kernal2[112]) + (0.001823 * image_kernal2[113]) + (0.002445 * image_kernal2[114]) + (0.002696 * image_kernal2[115]) + (0.002445 * image_kernal2[116]) + (0.001823 * image_kernal2[117]) + (0.001117 * image_kernal2[118]) + (0.000563 * image_kernal2[119]) + (0.000233 * image_kernal2[120]);

             // sigma = 3.2
             result3 =  (0.00013 * image_kernal3[0]) + (0.000245 * image_kernal3[1]) + (0.000419 * image_kernal3[2]) + (0.00065 * image_kernal3[3]) + (0.000915 * image_kernal3[4]) + (0.001168 * image_kernal3[5]) + (0.001353 * image_kernal3[6]) + (0.00142 * image_kernal3[7]) + (0.001353 * image_kernal3[8]) + (0.001168 * image_kernal3[9]) + (0.000915 * image_kernal3[10]) + (0.00065 * image_kernal3[11]) + (0.000419 * image_kernal3[12]) + (0.000245 * image_kernal3[13]) + (0.00013 * image_kernal3[14]) + (0.000245 * image_kernal3[15]) + (0.000462 * image_kernal3[16]) + (0.000791 * image_kernal3[17]) + (0.001227 * image_kernal3[18]) + (0.001727 * image_kernal3[19]) + (0.002204 * image_kernal3[20]) + (0.002552 * image_kernal3[21]) + (0.00268 * image_kernal3[22]) + (0.002552 * image_kernal3[23]) + (0.002204 * image_kernal3[24]) + (0.001727 * image_kernal3[25]) + (0.001227 * image_kernal3[26]) + (0.000791 * image_kernal3[27]) + (0.000462 * image_kernal3[28]) + (0.000245 * image_kernal3[29]) + (0.000419 * image_kernal3[30]) + (0.000791 * image_kernal3[31]) + (0.001353 * image_kernal3[32]) + (0.002099 * image_kernal3[33]) + (0.002955 * image_kernal3[34]) + (0.003772 * image_kernal3[35]) + (0.004367 * image_kernal3[36]) + (0.004585 * image_kernal3[37]) + (0.004367 * image_kernal3[38]) + (0.003772 * image_kernal3[39]) + (0.002955 * image_kernal3[40]) + (0.002099 * image_kernal3[41]) + (0.001353 * image_kernal3[42]) + (0.000791 * image_kernal3[43]) + (0.000419 * image_kernal3[44]) + (0.00065 * image_kernal3[45]) + (0.001227 * image_kernal3[46]) + (0.002099 * image_kernal3[47]) + (0.003258 * image_kernal3[48]) + (0.004585 * image_kernal3[49]) + (0.005853 * image_kernal3[50]) + (0.006777 * image_kernal3[51]) + (0.007116 * image_kernal3[52]) + (0.006777 * image_kernal3[53]) + (0.005853 * image_kernal3[54]) + (0.004585 * image_kernal3[55]) + (0.003258 * image_kernal3[56]) + (0.002099 * image_kernal3[57]) + (0.001227 * image_kernal3[58]) + (0.00065 * image_kernal3[59]) + (0.000915 * image_kernal3[60]) + (0.001727 * image_kernal3[61]) + (0.002955 * image_kernal3[62]) + (0.004585 * image_kernal3[63]) + (0.006454 * image_kernal3[64]) + (0.008238 * image_kernal3[65]) + (0.009538 * image_kernal3[66]) + (0.010015 * image_kernal3[67]) + (0.009538 * image_kernal3[68]) + (0.008238 * image_kernal3[69]) + (0.006454 * image_kernal3[70]) + (0.004585 * image_kernal3[71]) + (0.002955 * image_kernal3[72]) + (0.001727 * image_kernal3[73]) + (0.000915 * image_kernal3[74]) + (0.001168 * image_kernal3[75]) + (0.002204 * image_kernal3[76]) + (0.003772 * image_kernal3[77]) + (0.005853 * image_kernal3[78]) + (0.008238 * image_kernal3[79]) + (0.010517 * image_kernal3[80]) + (0.012176 * image_kernal3[81]) + (0.012785 * image_kernal3[82]) + (0.012176 * image_kernal3[83]) + (0.010517 * image_kernal3[84]) + (0.008238 * image_kernal3[85]) + (0.005853 * image_kernal3[86]) + (0.003772 * image_kernal3[87]) + (0.002204 * image_kernal3[88]) + (0.001168 * image_kernal3[89]) + (0.001353 * image_kernal3[90]) + (0.002552 * image_kernal3[91]) + (0.004367 * image_kernal3[92]) + (0.006777 * image_kernal3[93]) + (0.009538 * image_kernal3[94]) + (0.012176 * image_kernal3[95]) + (0.014096 * image_kernal3[96]) + (0.014802 * image_kernal3[97]) + (0.014096 * image_kernal3[98]) + (0.012176 * image_kernal3[99]) + (0.009538 * image_kernal3[100]) + (0.006777 * image_kernal3[101]) + (0.004367 * image_kernal3[102]) + (0.002552 * image_kernal3[103]) + (0.001353 * image_kernal3[104]) + (0.00142 * image_kernal3[105]) + (0.00268 * image_kernal3[106]) + (0.004585 * image_kernal3[107]) + (0.007116 * image_kernal3[108]) + (0.010015 * image_kernal3[109]) + (0.012785 * image_kernal3[110]) + (0.014802 * image_kernal3[111]) + (0.015542 * image_kernal3[112]) + (0.014802 * image_kernal3[113]) + (0.012785 * image_kernal3[114]) + (0.010015 * image_kernal3[115]) + (0.007116 * image_kernal3[116]) + (0.004585 * image_kernal3[117]) + (0.00268 * image_kernal3[118]) + (0.00142 * image_kernal3[119]) + (0.001353 * image_kernal3[120]) + (0.002552 * image_kernal3[121]) + (0.004367 * image_kernal3[122]) + (0.006777 * image_kernal3[123]) + (0.009538 * image_kernal3[124]) + (0.012176 * image_kernal3[125]) + (0.014096 * image_kernal3[126]) + (0.014802 * image_kernal3[127]) + (0.014096 * image_kernal3[128]) + (0.012176 * image_kernal3[129]) + (0.009538 * image_kernal3[130]) + (0.006777 * image_kernal3[131]) + (0.004367 * image_kernal3[132]) + (0.002552 * image_kernal3[133]) + (0.001353 * image_kernal3[134]) + (0.001168 * image_kernal3[135]) + (0.002204 * image_kernal3[136]) + (0.003772 * image_kernal3[137]) + (0.005853 * image_kernal3[138]) + (0.008238 * image_kernal3[139]) + (0.010517 * image_kernal3[140]) + (0.012176 * image_kernal3[141]) + (0.012785 * image_kernal3[142]) + (0.012176 * image_kernal3[143]) + (0.010517 * image_kernal3[144]) + (0.008238 * image_kernal3[145]) + (0.005853 * image_kernal3[146]) + (0.003772 * image_kernal3[147]) + (0.002204 * image_kernal3[148]) + (0.001168 * image_kernal3[149]) + (0.000915 * image_kernal3[150]) + (0.001727 * image_kernal3[151]) + (0.002955 * image_kernal3[152]) + (0.004585 * image_kernal3[153]) + (0.006454 * image_kernal3[154]) + (0.008238 * image_kernal3[155]) + (0.009538 * image_kernal3[156]) + (0.010015 * image_kernal3[157]) + (0.009538 * image_kernal3[158]) + (0.008238 * image_kernal3[159]) + (0.006454 * image_kernal3[160]) + (0.004585 * image_kernal3[161]) + (0.002955 * image_kernal3[162]) + (0.001727 * image_kernal3[163]) + (0.000915 * image_kernal3[164]) + (0.00065 * image_kernal3[165]) + (0.001227 * image_kernal3[166]) + (0.002099 * image_kernal3[167]) + (0.003258 * image_kernal3[168]) + (0.004585 * image_kernal3[169]) + (0.005853 * image_kernal3[170]) + (0.006777 * image_kernal3[171]) + (0.007116 * image_kernal3[172]) + (0.006777 * image_kernal3[173]) + (0.005853 * image_kernal3[174]) + (0.004585 * image_kernal3[175]) + (0.003258 * image_kernal3[176]) + (0.002099 * image_kernal3[177]) + (0.001227 * image_kernal3[178]) + (0.00065 * image_kernal3[179]) + (0.000419 * image_kernal3[180]) + (0.000791 * image_kernal3[181]) + (0.001353 * image_kernal3[182]) + (0.002099 * image_kernal3[183]) + (0.002955 * image_kernal3[184]) + (0.003772 * image_kernal3[185]) + (0.004367 * image_kernal3[186]) + (0.004585 * image_kernal3[187]) + (0.004367 * image_kernal3[188]) + (0.003772 * image_kernal3[189]) + (0.002955 * image_kernal3[190]) + (0.002099 * image_kernal3[191]) + (0.001353 * image_kernal3[192]) + (0.000791 * image_kernal3[193]) + (0.000419 * image_kernal3[194]) + (0.000245 * image_kernal3[195]) + (0.000462 * image_kernal3[196]) + (0.000791 * image_kernal3[197]) + (0.001227 * image_kernal3[198]) + (0.001727 * image_kernal3[199]) + (0.002204 * image_kernal3[200]) + (0.002552 * image_kernal3[201]) + (0.00268 * image_kernal3[202]) + (0.002552 * image_kernal3[203]) + (0.002204 * image_kernal3[204]) + (0.001727 * image_kernal3[205]) + (0.001227 * image_kernal3[206]) + (0.000791 * image_kernal3[207]) + (0.000462 * image_kernal3[208]) + (0.000245 * image_kernal3[209]) + (0.00013 * image_kernal3[210]) + (0.000245 * image_kernal3[211]) + (0.000419 * image_kernal3[212]) + (0.00065 * image_kernal3[213]) + (0.000915 * image_kernal3[214]) + (0.001168 * image_kernal3[215]) + (0.001353 * image_kernal3[216]) + (0.00142 * image_kernal3[217]) + (0.001353 * image_kernal3[218]) + (0.001168 * image_kernal3[219]) + (0.000915 * image_kernal3[220]) + (0.00065 * image_kernal3[221]) + (0.000419 * image_kernal3[222]) + (0.000245 * image_kernal3[223]) + (0.00013 * image_kernal3[224]);

             // sigma = 4.5
             result4 =  (0.000144 * image_kernal4[0]) + (0.000219 * image_kernal4[1]) + (0.000317 * image_kernal4[2]) + (0.000437 * image_kernal4[3]) + (0.000574 * image_kernal4[4]) + (0.000717 * image_kernal4[5]) + (0.000852 * image_kernal4[6]) + (0.000964 * image_kernal4[7]) + (0.001038 * image_kernal4[8]) + (0.001064 * image_kernal4[9]) + (0.001038 * image_kernal4[10]) + (0.000964 * image_kernal4[11]) + (0.000852 * image_kernal4[12]) + (0.000717 * image_kernal4[13]) + (0.000574 * image_kernal4[14]) + (0.000437 * image_kernal4[15]) + (0.000317 * image_kernal4[16]) + (0.000219 * image_kernal4[17]) + (0.000144 * image_kernal4[18]) + (0.000219 * image_kernal4[19]) + (0.000333 * image_kernal4[20]) + (0.000483 * image_kernal4[21]) + (0.000665 * image_kernal4[22]) + (0.000873 * image_kernal4[23]) + (0.00109 * image_kernal4[24]) + (0.001296 * image_kernal4[25]) + (0.001466 * image_kernal4[26]) + (0.001579 * image_kernal4[27]) + (0.001618 * image_kernal4[28]) + (0.001579 * image_kernal4[29]) + (0.001466 * image_kernal4[30]) + (0.001296 * image_kernal4[31]) + (0.00109 * image_kernal4[32]) + (0.000873 * image_kernal4[33]) + (0.000665 * image_kernal4[34]) + (0.000483 * image_kernal4[35]) + (0.000333 * image_kernal4[36]) + (0.000219 * image_kernal4[37]) + (0.000317 * image_kernal4[38]) + (0.000483 * image_kernal4[39]) + (0.000699 * image_kernal4[40]) + (0.000964 * image_kernal4[41]) + (0.001264 * image_kernal4[42]) + (0.001579 * image_kernal4[43]) + (0.001877 * image_kernal4[44]) + (0.002124 * image_kernal4[45]) + (0.002287 * image_kernal4[46]) + (0.002344 * image_kernal4[47]) + (0.002287 * image_kernal4[48]) + (0.002124 * image_kernal4[49]) + (0.001877 * image_kernal4[50]) + (0.001579 * image_kernal4[51]) + (0.001264 * image_kernal4[52]) + (0.000964 * image_kernal4[53]) + (0.000699 * image_kernal4[54]) + (0.000483 * image_kernal4[55]) + (0.000317 * image_kernal4[56]) + (0.000437 * image_kernal4[57]) + (0.000665 * image_kernal4[58]) + (0.000964 * image_kernal4[59]) + (0.001328 * image_kernal4[60]) + (0.001743 * image_kernal4[61]) + (0.002177 * image_kernal4[62]) + (0.002587 * image_kernal4[63]) + (0.002927 * image_kernal4[64]) + (0.003152 * image_kernal4[65]) + (0.003231 * image_kernal4[66]) + (0.003152 * image_kernal4[67]) + (0.002927 * image_kernal4[68]) + (0.002587 * image_kernal4[69]) + (0.002177 * image_kernal4[70]) + (0.001743 * image_kernal4[71]) + (0.001328 * image_kernal4[72]) + (0.000964 * image_kernal4[73]) + (0.000665 * image_kernal4[74]) + (0.000437 * image_kernal4[75]) + (0.000574 * image_kernal4[76]) + (0.000873 * image_kernal4[77]) + (0.001264 * image_kernal4[78]) + (0.001743 * image_kernal4[79]) + (0.002287 * image_kernal4[80]) + (0.002856 * image_kernal4[81]) + (0.003395 * image_kernal4[82]) + (0.003841 * image_kernal4[83]) + (0.004136 * image_kernal4[84]) + (0.004239 * image_kernal4[85]) + (0.004136 * image_kernal4[86]) + (0.003841 * image_kernal4[87]) + (0.003395 * image_kernal4[88]) + (0.002856 * image_kernal4[89]) + (0.002287 * image_kernal4[90]) + (0.001743 * image_kernal4[91]) + (0.001264 * image_kernal4[92]) + (0.000873 * image_kernal4[93]) + (0.000574 * image_kernal4[94]) + (0.000717 * image_kernal4[95]) + (0.00109 * image_kernal4[96]) + (0.001579 * image_kernal4[97]) + (0.002177 * image_kernal4[98]) + (0.002856 * image_kernal4[99]) + (0.003567 * image_kernal4[100]) + (0.004239 * image_kernal4[101]) + (0.004797 * image_kernal4[102]) + (0.005165 * image_kernal4[103]) + (0.005294 * image_kernal4[104]) + (0.005165 * image_kernal4[105]) + (0.004797 * image_kernal4[106]) + (0.004239 * image_kernal4[107]) + (0.003567 * image_kernal4[108]) + (0.002856 * image_kernal4[109]) + (0.002177 * image_kernal4[110]) + (0.001579 * image_kernal4[111]) + (0.00109 * image_kernal4[112]) + (0.000717 * image_kernal4[113]) + (0.000852 * image_kernal4[114]) + (0.001296 * image_kernal4[115]) + (0.001877 * image_kernal4[116]) + (0.002587 * image_kernal4[117]) + (0.003395 * image_kernal4[118]) + (0.004239 * image_kernal4[119]) + (0.005039 * image_kernal4[120]) + (0.005702 * image_kernal4[121]) + (0.00614 * image_kernal4[122]) + (0.006293 * image_kernal4[123]) + (0.00614 * image_kernal4[124]) + (0.005702 * image_kernal4[125]) + (0.005039 * image_kernal4[126]) + (0.004239 * image_kernal4[127]) + (0.003395 * image_kernal4[128]) + (0.002587 * image_kernal4[129]) + (0.001877 * image_kernal4[130]) + (0.001296 * image_kernal4[131]) + (0.000852 * image_kernal4[132]) + (0.000964 * image_kernal4[133]) + (0.001466 * image_kernal4[134]) + (0.002124 * image_kernal4[135]) + (0.002927 * image_kernal4[136]) + (0.003841 * image_kernal4[137]) + (0.004797 * image_kernal4[138]) + (0.005702 * image_kernal4[139]) + (0.006451 * image_kernal4[140]) + (0.006947 * image_kernal4[141]) + (0.00712 * image_kernal4[142]) + (0.006947 * image_kernal4[143]) + (0.006451 * image_kernal4[144]) + (0.005702 * image_kernal4[145]) + (0.004797 * image_kernal4[146]) + (0.003841 * image_kernal4[147]) + (0.002927 * image_kernal4[148]) + (0.002124 * image_kernal4[149]) + (0.001466 * image_kernal4[150]) + (0.000964 * image_kernal4[151]) + (0.001038 * image_kernal4[152]) + (0.001579 * image_kernal4[153]) + (0.002287 * image_kernal4[154]) + (0.003152 * image_kernal4[155]) + (0.004136 * image_kernal4[156]) + (0.005165 * image_kernal4[157]) + (0.00614 * image_kernal4[158]) + (0.006947 * image_kernal4[159]) + (0.007481 * image_kernal4[160]) + (0.007668 * image_kernal4[161]) + (0.007481 * image_kernal4[162]) + (0.006947 * image_kernal4[163]) + (0.00614 * image_kernal4[164]) + (0.005165 * image_kernal4[165]) + (0.004136 * image_kernal4[166]) + (0.003152 * image_kernal4[167]) + (0.002287 * image_kernal4[168]) + (0.001579 * image_kernal4[169]) + (0.001038 * image_kernal4[170]) + (0.001064 * image_kernal4[171]) + (0.001618 * image_kernal4[172]) + (0.002344 * image_kernal4[173]) + (0.003231 * image_kernal4[174]) + (0.004239 * image_kernal4[175]) + (0.005294 * image_kernal4[176]) + (0.006293 * image_kernal4[177]) + (0.00712 * image_kernal4[178]) + (0.007668 * image_kernal4[179]) + (0.00786 * image_kernal4[180]) + (0.007668 * image_kernal4[181]) + (0.00712 * image_kernal4[182]) + (0.006293 * image_kernal4[183]) + (0.005294 * image_kernal4[184]) + (0.004239 * image_kernal4[185]) + (0.003231 * image_kernal4[186]) + (0.002344 * image_kernal4[187]) + (0.001618 * image_kernal4[188]) + (0.001064 * image_kernal4[189]) + (0.001038 * image_kernal4[190]) + (0.001579 * image_kernal4[191]) + (0.002287 * image_kernal4[192]) + (0.003152 * image_kernal4[193]) + (0.004136 * image_kernal4[194]) + (0.005165 * image_kernal4[195]) + (0.00614 * image_kernal4[196]) + (0.006947 * image_kernal4[197]) + (0.007481 * image_kernal4[198]) + (0.007668 * image_kernal4[199]) + (0.007481 * image_kernal4[200]) + (0.006947 * image_kernal4[201]) + (0.00614 * image_kernal4[202]) + (0.005165 * image_kernal4[203]) + (0.004136 * image_kernal4[204]) + (0.003152 * image_kernal4[205]) + (0.002287 * image_kernal4[206]) + (0.001579 * image_kernal4[207]) + (0.001038 * image_kernal4[208]) + (0.000964 * image_kernal4[209]) + (0.001466 * image_kernal4[210]) + (0.002124 * image_kernal4[211]) + (0.002927 * image_kernal4[212]) + (0.003841 * image_kernal4[213]) + (0.004797 * image_kernal4[214]) + (0.005702 * image_kernal4[215]) + (0.006451 * image_kernal4[216]) + (0.006947 * image_kernal4[217]) + (0.00712 * image_kernal4[218]) + (0.006947 * image_kernal4[219]) + (0.006451 * image_kernal4[220]) + (0.005702 * image_kernal4[221]) + (0.004797 * image_kernal4[222]) + (0.003841 * image_kernal4[223]) + (0.002927 * image_kernal4[224]) + (0.002124 * image_kernal4[225]) + (0.001466 * image_kernal4[226]) + (0.000964 * image_kernal4[227]) + (0.000852 * image_kernal4[228]) + (0.001296 * image_kernal4[229]) + (0.001877 * image_kernal4[230]) + (0.002587 * image_kernal4[231]) + (0.003395 * image_kernal4[232]) + (0.004239 * image_kernal4[233]) + (0.005039 * image_kernal4[234]) + (0.005702 * image_kernal4[235]) + (0.00614 * image_kernal4[236]) + (0.006293 * image_kernal4[237]) + (0.00614 * image_kernal4[238]) + (0.005702 * image_kernal4[239]) + (0.005039 * image_kernal4[240]) + (0.004239 * image_kernal4[241]) + (0.003395 * image_kernal4[242]) + (0.002587 * image_kernal4[243]) + (0.001877 * image_kernal4[244]) + (0.001296 * image_kernal4[245]) + (0.000852 * image_kernal4[246]) + (0.000717 * image_kernal4[247]) + (0.00109 * image_kernal4[248]) + (0.001579 * image_kernal4[249]) + (0.002177 * image_kernal4[250]) + (0.002856 * image_kernal4[251]) + (0.003567 * image_kernal4[252]) + (0.004239 * image_kernal4[253]) + (0.004797 * image_kernal4[254]) + (0.005165 * image_kernal4[255]) + (0.005294 * image_kernal4[256]) + (0.005165 * image_kernal4[257]) + (0.004797 * image_kernal4[258]) + (0.004239 * image_kernal4[259]) + (0.003567 * image_kernal4[260]) + (0.002856 * image_kernal4[261]) + (0.002177 * image_kernal4[262]) + (0.001579 * image_kernal4[263]) + (0.00109 * image_kernal4[264]) + (0.000717 * image_kernal4[265]) + (0.000574 * image_kernal4[266]) + (0.000873 * image_kernal4[267]) + (0.001264 * image_kernal4[268]) + (0.001743 * image_kernal4[269]) + (0.002287 * image_kernal4[270]) + (0.002856 * image_kernal4[271]) + (0.003395 * image_kernal4[272]) + (0.003841 * image_kernal4[273]) + (0.004136 * image_kernal4[274]) + (0.004239 * image_kernal4[275]) + (0.004136 * image_kernal4[276]) + (0.003841 * image_kernal4[277]) + (0.003395 * image_kernal4[278]) + (0.002856 * image_kernal4[279]) + (0.002287 * image_kernal4[280]) + (0.001743 * image_kernal4[281]) + (0.001264 * image_kernal4[282]) + (0.000873 * image_kernal4[283]) + (0.000574 * image_kernal4[284]) + (0.000437 * image_kernal4[285]) + (0.000665 * image_kernal4[286]) + (0.000964 * image_kernal4[287]) + (0.001328 * image_kernal4[288]) + (0.001743 * image_kernal4[289]) + (0.002177 * image_kernal4[290]) + (0.002587 * image_kernal4[291]) + (0.002927 * image_kernal4[292]) + (0.003152 * image_kernal4[293]) + (0.003231 * image_kernal4[294]) + (0.003152 * image_kernal4[295]) + (0.002927 * image_kernal4[296]) + (0.002587 * image_kernal4[297]) + (0.002177 * image_kernal4[298]) + (0.001743 * image_kernal4[299]) + (0.001328 * image_kernal4[300]) + (0.000964 * image_kernal4[301]) + (0.000665 * image_kernal4[302]) + (0.000437 * image_kernal4[303]) + (0.000317 * image_kernal4[304]) + (0.000483 * image_kernal4[305]) + (0.000699 * image_kernal4[306]) + (0.000964 * image_kernal4[307]) + (0.001264 * image_kernal4[308]) + (0.001579 * image_kernal4[309]) + (0.001877 * image_kernal4[310]) + (0.002124 * image_kernal4[311]) + (0.002287 * image_kernal4[312]) + (0.002344 * image_kernal4[313]) + (0.002287 * image_kernal4[314]) + (0.002124 * image_kernal4[315]) + (0.001877 * image_kernal4[316]) + (0.001579 * image_kernal4[317]) + (0.001264 * image_kernal4[318]) + (0.000964 * image_kernal4[319]) + (0.000699 * image_kernal4[320]) + (0.000483 * image_kernal4[321]) + (0.000317 * image_kernal4[322]) + (0.000219 * image_kernal4[323]) + (0.000333 * image_kernal4[324]) + (0.000483 * image_kernal4[325]) + (0.000665 * image_kernal4[326]) + (0.000873 * image_kernal4[327]) + (0.00109 * image_kernal4[328]) + (0.001296 * image_kernal4[329]) + (0.001466 * image_kernal4[330]) + (0.001579 * image_kernal4[331]) + (0.001618 * image_kernal4[332]) + (0.001579 * image_kernal4[333]) + (0.001466 * image_kernal4[334]) + (0.001296 * image_kernal4[335]) + (0.00109 * image_kernal4[336]) + (0.000873 * image_kernal4[337]) + (0.000665 * image_kernal4[338]) + (0.000483 * image_kernal4[339]) + (0.000333 * image_kernal4[340]) + (0.000219 * image_kernal4[341]) + (0.000144 * image_kernal4[342]) + (0.000219 * image_kernal4[343]) + (0.000317 * image_kernal4[344]) + (0.000437 * image_kernal4[345]) + (0.000574 * image_kernal4[346]) + (0.000717 * image_kernal4[347]) + (0.000852 * image_kernal4[348]) + (0.000964 * image_kernal4[349]) + (0.001038 * image_kernal4[350]) + (0.001064 * image_kernal4[351]) + (0.001038 * image_kernal4[352]) + (0.000964 * image_kernal4[353]) + (0.000852 * image_kernal4[354]) + (0.000717 * image_kernal4[355]) + (0.000574 * image_kernal4[356]) + (0.000437 * image_kernal4[357]) + (0.000317 * image_kernal4[358]) + (0.000219 * image_kernal4[359]) + (0.000144 * image_kernal4[360]);

             k = (k == M-1) ? 0 : k + 1;
             j = (k == 0) ? j + 3 + 9 + 7 : j + 1;

             j1 = (k == 0) ? j1 + 5 + 9 + 5 : j1 + 1;
             j2 = (k == 0) ? j2 + 5 + 9 + 5 : j2 + 1;
             j3 = (k == 0) ? j3 + 5 + 9 + 5 : j3 + 1;
             j4 = (k == 0) ? j4 + 5 + 9 + 5 : j4 + 1;

             count = count + 1;
             NS = (count==(N)*(M)) ? IDLE : FIX;
            end
 endcase
end


assign fill_now = (PS==CONVOLUTE) ? 1'b1 : 1'b0;
assign Diff1 = (PS==CONVOLUTE) ? result2-result1 : 16'hzzzz;
assign Diff2 = (PS==CONVOLUTE) ? result3-result2 : 16'hzzzz;
assign Diff3 = (PS==CONVOLUTE) ? result4-result3 : 16'hzzzz;
assign done = (count == N*M) ? 1'b1 : 1'b0;
endmodule
