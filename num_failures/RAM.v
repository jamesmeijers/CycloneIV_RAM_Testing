//Simply a RAM made for high speeds
//q_fast is read from q every fast cycle
//clk_slow_odd and clk_slow_even then alternate reading from q_fast at half speed
//This allows us to test the values for errors at half speed while still reading
//them at the full speed.

module RAM (
	input clk_fast,
	input clk_slow_even,
	input clk_slow_odd,
	input clk_enable,
	input [9:0] address,
	input wren,
	input [7:0] data_to_write,
	output reg [7:0] q_odd,
	output reg [7:0] q_even
);

	wire [7:0] q;
	reg [7:0] q_fast;


	ram_1_port the_ram(
		.clken( clk_enable),
		.address( address),
		.clock( clk_fast ),
		.data( data_to_write ),
		.wren( wren),
		.q( q )
	);

	always @(posedge clk_fast) begin
		q_fast <= q;
	end
	
	always @(posedge clk_slow_even) begin
		q_even <= q_fast;
	end

	always @(posedge clk_slow_odd) begin
		q_odd <= q_fast;
	end

endmodule
