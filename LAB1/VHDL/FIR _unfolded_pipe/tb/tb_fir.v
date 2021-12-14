//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire [12:0] DIN1_i;
   wire [12:0] DIN2_i;
   wire [12:0] DIN3_i;
   wire VIN_i;
   wire [12:0] B0_i;
   wire [12:0] B1_i;
   wire [12:0] B2_i;
   wire [12:0] B3_i;
   wire [12:0] B4_i;
   wire [12:0] B5_i;
   wire [12:0] DOUT1_i;
   wire [12:0] DOUT2_i;
   wire [12:0] DOUT3_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(	.END_SIM(END_SIM_i),
				.CLK(CLK_i),
				.RST_n(RST_n_i));

   data_maker SM(	.CLK(CLK_i),
					.RST_n(RST_n_i),
					.VOUT(VIN_i),
					.DOUT1(DIN1_i),
					.DOUT2(DIN2_i),
					.DOUT3(DIN3_i),
					.B0(B0_i),
					.B1(B1_i),
					.B2(B2_i),
					.B3(B3_i),
					.B4(B4_i),
					.B5(B5_i),
					.END_SIM(END_SIM_i));

   myfir UUT(	.CLK(CLK_i),
				.RST_n(RST_n_i),
				.DIN1(DIN1_i),
				.DIN2(DIN2_i),
				.DIN3(DIN3_i),
				.VIN(VIN_i),
				.B0(B0_i),
				.B1(B1_i),
				.B2(B2_i),
				.B3(B3_i),
				.B4(B4_i),
				.B5(B5_i),
				.DOUT1(DOUT1_i),
				.DOUT2(DOUT2_i),
				.DOUT3(DOUT3_i),
				.VOUT(VOUT_i));

   data_sink DS(.CLK(CLK_i),
				.RST_n(RST_n_i),
				.VIN(VOUT_i),
				.DIN1(DOUT1_i),
				.DIN2(DOUT2_i),
				.DIN3(DOUT3_i));   

endmodule

		   