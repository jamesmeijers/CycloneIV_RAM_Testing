module RAM_Controller (
	input clk_fast,
	input clk_slow_even,
	input clk_slow_odd,
	input align,
	input write_mem,
	output error_1,
	output error_2
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
	assign data_even = 8'b10101010;
	wire [7:0] data_odd;
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
	
	
	assign next_address [9:1] = address_top;
	assign next_address [0] = address_last_bit;
	
	

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
			//address_bottom <= 1'b0;
			data_to_write <= data_even;
			wren <= 1'b0;
		end
		
		else begin
			data_to_write <= data_even;
			case(state)
				reset_to_write: begin
					if(clk_slow_odd == 1'b1) data_to_write <= data_even;
					else data_to_write <= data_odd;
					//address_bottom <= 1'b0;
					data_to_write <= data_even;
					state <= write_data;
					wren <= 1'b1;
				end
				write_data: begin
					data_to_write <= ~data_to_write;
				
					if(counter[11]) begin 
						state <= align_read;
						wren <= 1'b0;
					end
					else begin 
						state <= write_data;
						wren <= 1'b1;
					end
					
					//address_bottom <= ~address_bottom;
					
				end
				align_read: begin
					wren <= 1'b0;
					//address_bottom <= 1'b0;
					state <= align_read_2;
					
				end
				align_read_2: begin
					wren <= 1'b0;
//					if( clk_slow_even && ~clk_slow_odd ) begin //clk_slow_even just read address 0
//						//address_bottom <= ~address_bottom;
//						state <= read_data;
//					end
//					else begin
//						address_bottom <= 1'b0;
//						state <= align_read_2;
//					end
					state <= read_data;
				end
				read_data: begin
					wren <= 1'b0;
					//address_bottom <= ~address_bottom;
					state <= read_data;
				end
				default: begin
					wren <= 1'b0;
					//address_bottom <= address_bottom;
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





endmodule
