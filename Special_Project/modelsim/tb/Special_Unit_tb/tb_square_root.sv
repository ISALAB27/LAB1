`timescale 10fs/1fs

module tb_square_root ();
	parameter integer WIDTH = 16;

	reg[WIDTH-1:0] rad; 
	wire[((WIDTH+1)/2):0] r;
	wire[((WIDTH+1)/2)-1:0] q;
	
	//integer i;
	reg[WIDTH:0] i;
	reg[WIDTH:0] errors;

	square_root #(.N(WIDTH)) dut(.rad(rad), .r(r), .q(q));
	
	//defparam WIDTH = 16;

	initial begin
		errors = 0;
		
		$display ("Square root unit (%0d) test start.", WIDTH);
		for (i = 0; i < 2**WIDTH; i = i + 1) begin
			#1 rad = i;
			#1
			if ((q**2)+r == rad) begin
				$display ("[OK] rad=%0d q=%0d r=%0d", rad, q, r);
			end else begin
				$display ("[ERROR] rad=%0d q=%0d r=%0d", rad, q, r);
				errors = errors + 1;
			end
		end
		$display ("Square root unit (%0d) test complete with %0d errors.", WIDTH, errors);
	end 
endmodule

config tb_square_root_config;
	design work.tb_square_root;
	default liblist work;
	//cell square_root use work.square_root_beh_cfg;
	//cell square_root use work.square_root_CSA_sub_cfg;
	cell square_root use work.square_root_CSS_cfg;
endconfig