module RAM_Controller (
	input clk_fast,
	input clk_slow_even,
	input clk_slow_odd,
	output error_1,
	output error_2
);

	reg [9:0] address;
	wire [9:0] next_address;
	wire [7:0] q_odd, q_even;
	wire wren;
	wire clk_enable;
	wire [7:0] data_to_write;
	wire [7:0] data_even;
	assign data_even = 8'b11111111;
	wire [7:0] data_odd;
	assign data_odd = 8'b00000000;
	
	assign clk_enable = 1'b1;
	assign wren = 1'b0;
	assign data_to_write = 8'd0;
	
	

	RAM RAM1(
		.clk_fast( clk_fast ),
		.clk_slow_even( clk_slow_even ),
		.clk_slow_odd( clk_slow_odd ),
		.clk_enable( clk_enable ),
		.address( address ),
		.wren( wren),
		.data_to_write( data_to_write ),
		.q_odd( q_odd ),
		.q_even( q_even )
	);
	
	reg [8:0] address_top;
	
	always @ (posedge clk_slow_even) begin
		address_top <= address_top + 9'd1;
	end
	

	reg address_last_bit;
	always @ (posedge clk_fast) begin
		address_last_bit <= ~address_last_bit;
	end
	

	assign next_address[9] = address_last_bit;
	//assign next_address[8:0] = address_top[8:0];
	assign next_address[8:0] = 9'b011111111;
	
	always @ (posedge clk_fast) begin
		address <= next_address;
	end	

	wire error1a, error1b, error2a, error2b;
	assign error_1 = error1a & error1b;
	assign error_2 = error2a & error2b;
	
//	error_check_tree check_evena(
//		.clk(clk_slow_even),
//		.read(q_even),
//		.expected(data_even),
//		.error(error1a)
//	);
//	
//	error_check_tree check_evenb(
//		.clk(clk_slow_even),
//		.read(q_even),
//		.expected(data_odd),
//		.error(error1b)
//	);
//
//	error_check_tree check_odda(
//		.clk(clk_slow_odd),
//		.read(q_odd),
//		.expected(data_odd),
//		.error(error2a)
//	);
//	
//	error_check_tree check_oddb(
//		.clk(clk_slow_odd),
//		.read(q_odd),
//		.expected(data_even),
//		.error(error2b)
//	);

	error_check_tree check_evena(
		.clk(clk_slow_even),
		.read({data_even[7:5], q_even[4:3], data_even[2:0]}),
		.expected(data_even),
		.error(error1a)
	);
	
	error_check_tree check_evenb(
		.clk(clk_slow_even),
		.read({data_odd[7:5], q_even[4:3], data_odd[2:0]}),
		.expected(data_odd),
		.error(error1b)
	);

	error_check_tree check_odda(
		.clk(clk_slow_odd),
		.read({data_odd[7:5], q_odd[4:3], data_odd[2:0]}),
		.expected(data_odd),
		.error(error2a)
	);
	
	error_check_tree check_oddb(
		.clk(clk_slow_odd),
		.read({data_even[7:5], q_odd[4:3], data_even[2:0]}),
		.expected(data_even),
		.error(error2b)
	);




endmodule
