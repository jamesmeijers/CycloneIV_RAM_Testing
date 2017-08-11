module RAM_Controller (
	input clk_fast,
	input clk_slow_even,
	input clk_slow_odd,
	input align,
	input write_mem,
	output error_1,
	output error_2,
	output reg [9:0] error_address_1,
	output reg [9:0] error_address_2,
	output [7:0] q_odd,
	output [7:0] q_even
);

	//assign q_tmp = q_odd;
	reg [9:0] address;
	wire [9:0] next_address;
	reg wren;
	wire clk_enable;
	reg [7:0] data_to_write;
	//wire [7:0] q_odd;
	//wire [7:0] q_even;	
	wire [7:0] data_even;
	//assign data_even = 8'b10101010;
	assign data_even = 8'b10101010;
	wire [7:0] data_odd;
	//assign data_odd = 8'b01010101;
	assign data_odd = 8'b01010101;
	
	assign clk_enable = 1'b1;
	

	RAM RAM1(
		.clk_fast( clk_fast ),
		.clk_slow_even( clk_slow_even ),
		.clk_slow_odd( clk_slow_odd ),
		.clk_enable( clk_enable ),
		.address( address ),
		.wren( wren ),
		.data_to_write( data_to_write ),
		.q_odd( q_odd ),
		.q_even( q_even )
	);

	localparam reset_to_write =      4'd0;
	localparam write_data     =      4'd1;
	localparam align_read     =      4'd2;
	localparam align_read_2   =      4'd3;
	localparam read_data      =      4'd4;

	reg [3:0] state;
	
	reg [1:0] state_counter;
	reg [8:0] address_top;
	reg [12:0] counter;
	
	always @ (posedge clk_slow_even) begin
		if(align | write_mem) begin
			address_top <= 9'd0;
			counter <= 13'd0;
		end
		else begin 
			address_top <= address_top + 9'd1;
			counter <= counter + 13'd1;
		end
	end
	

	reg address_last_bit;
	always @ (posedge clk_fast) address_last_bit <= ~address_last_bit;
	
	
//	assign next_address [9:2] = address_top[7:0];
//	assign next_address [1] = address_last_bit;
//	assign next_address [0] = 1'b1;//address_last_bit;
//	assign next_address [9:1] = address_top[8:0];
//	assign next_address [0] = address_last_bit;
	assign next_address[9] = address_last_bit;
	assign next_address[8:6] = address_top[2:0];
	assign next_address[5:3] = address_top[8:6];
	assign next_address[2:0] = address_top[5:3];

	
	

	always @(posedge clk_fast) begin
		address <= next_address;
		if(write_mem) begin 
			state <= reset_to_write;
			//address_bottom <= 1'b0;
			data_to_write <= data_even;
			wren <= 1'b0;
		end
		else if(align) begin
			state <= align_read;
			data_to_write <= data_even;
			wren <= 1'b0;
		end
		else begin
			data_to_write <= data_even;
			case(state)
				reset_to_write: begin
					data_to_write <= data_even;
					state <= write_data;
					wren <= 1'b1;
				end
				write_data: begin
					data_to_write <= ~data_to_write; 
					state <= write_data;
					wren <= 1'b1;
				end
				align_read: begin
					wren <= 1'b0;
					state <= read_data;
				end
				read_data: begin
					wren <= 1'b0;
					state <= read_data;
				end
				default: begin
					wren <= 1'b0;
					state <= read_data;
				end
			endcase
		end
	end
	
	reg [9:0] prev_add;

	always @ (posedge clk_fast) begin
		prev_add <= address;
	end	

	wire error1a, error1b, error2a, error2b;
	assign error_1 = error1a & error1b;
	assign error_2 = error2a & error2b;
	
	error_check_tree check_evena(
		.clk(clk_slow_even),
		.read(q_even),
		.expected(data_even),
		.error(error1a)
	);
	
	error_check_tree check_evenb(
		.clk(clk_slow_even),
		.read(q_even),
		.expected(data_odd),
		.error(error1b)
	);

	error_check_tree check_odda(
		.clk(clk_slow_odd),
		.read(q_odd),
		.expected(data_odd),
		.error(error2a)
	);
	
	error_check_tree check_oddb(
		.clk(clk_slow_odd),
		.read(q_odd),
		.expected(data_even),
		.error(error2b)
	);


	reg [9:0] even_add_1, even_add_2, even_add_3, even_add_4;

	always @ (posedge clk_slow_even) begin
		even_add_1 <= prev_add; //even_add_1 = address of mem_read in main mem-out register
		even_add_2 <= even_add_1; //even_add_2 = address of mem_read in clk_slow_even first register
		even_add_3 <= even_add_2; 
		even_add_4 <= even_add_3;
		error_address_1 <= even_add_4;
	end

	reg [9:0] odd_add_1, odd_add_2, odd_add_3, odd_add_4;

	always @ (posedge clk_slow_odd) begin
		odd_add_1 <= prev_add; //even_add_1 = address of mem_read in main mem-out register
		odd_add_2 <= odd_add_1; //even_add_2 = address of mem_read in clk_slow_even first register
		odd_add_3 <= odd_add_2; 
		odd_add_4 <= odd_add_3;
		error_address_2 <= odd_add_4;
	end



endmodule
