`timescale 10fs/1fs

module tb_square_root_stage ();
	parameter integer WIDTH = 9;

	reg[WIDTH-1:0] r_int_in; 
	reg[WIDTH-1:0] q_int;
	wire q_out;
	wire[WIDTH-1:0] r_int_out;
	
	reg signed [WIDTH:0] sub_int;
	
	reg[WIDTH:0] i;
	reg[WIDTH:0] j;
	reg[2*WIDTH:0] errors;

	square_root_stage_wrapper #(.N(WIDTH)) dut(	
		.r_int_in(r_int_in),
		.q_int(q_int), 
		.q_out(q_out), 
		.r_int_out(r_int_out)
	);

	initial begin
		errors = 0;
		
		$display ("Square root stage (%0d) test start.", WIDTH);
		for (i = 0; i < 2**WIDTH; i = i + 1) begin
			r_int_in = i;
			for (j = 0; j < 2**WIDTH; j = j + 1) begin
				q_int = j;
				#1 sub_int = r_int_in - q_int;
				#1
				if (sub_int < 0) begin
					if (q_out == 0 && r_int_out == r_int_in) begin
						$display ("[OK] r_int_in=%0d q_int=%0d q_out=%0d r_int_out=%0d", r_int_in, q_int, q_out, r_int_out);
					end else begin
						$display ("[ERROR] r_int_in=%0d q_int=%0d q_out=%0d r_int_out=%0d sub_int=%0d", r_int_in, q_int, q_out, r_int_out, sub_int);
						errors = errors + 1;
					end
				end else begin
					if (q_out == 1 && r_int_out == sub_int) begin
						$display ("[OK] r_int_in=%0d q_int=%0d q_out=%0d r_int_out=%0d", r_int_in, q_int, q_out, r_int_out);
					end else begin
						$display ("[ERROR] r_int_in=%0d q_int=%0d q_out=%0d r_int_out=%0d sub_int=%0d", r_int_in, q_int, q_out, r_int_out, sub_int);
						errors = errors + 1;
					end
				end
			end
		end
		$display ("Square root stage (%0d) test complete with %0d errors.", WIDTH, errors);
	end 
endmodule

config tb_square_root_stage_config;
	design work.tb_square_root_stage;
	default liblist work;
	//cell square_root_stage_wrapper use work.square_root_stage_beh_cfg;
	//cell square_root_stage_wrapper use work.square_root_stage_CSA_sub_cfg;
	cell square_root_stage_wrapper use work.square_root_stage_CSS_cfg;
endconfig
