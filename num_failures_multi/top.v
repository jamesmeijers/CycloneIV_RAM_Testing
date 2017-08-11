module top (
	input CLOCK_50,
	input [4:0] KEY,
	input [17:0] SW,
	output [7:0] LEDG,
	output [17:0] LEDR,
	output reg [6:0] HEX0,
	output reg [6:0] HEX1,
	output reg [6:0] HEX2,
	output reg [6:0] HEX3,
	output reg [6:0] HEX4,
	output reg [6:0] HEX5,
	output UART_TXD
//	input clk_fast,
//	input clk_slow_even,
//	input clk_slow_odd
	
);
	reg reset, next_frequency; 
	wire freq_ready, clk_fast, clk_slow_even, clk_slow_odd;
	wire [8:0] frequency;
	reg [7:0] UART_data;
	reg send_uart_data;
	
	pll pll1(
		.CLK_50( CLOCK_50 ),
		.reset( reset ),
		.next_frequency( next_frequency ),
		.frequency( frequency ),
		.freq_ready( freq_ready),
		.reconfig_CLK( clk_fast ),
		.half_CLK_1( clk_slow_even ),
		.half_CLK_2( clk_slow_odd ),
		.add( 4'b1 )
	); 
	
	
	wire [167:0] HEX0_sel, HEX1_sel, HEX2_sel, HEX3_sel, HEX4_sel, HEX5_sel;
	wire [24:0] reset_sel, next_frequency_sel, send_uart_data_sel;
	wire [191:0] UART_data_sel;
	
	//outputs are selected based on the Switches
	//only the test currently selected upon exit from reset is guaranteed to run properly
	//switches should only be changed before or during a reset, otherwise values are likely incorrect


	//currently the RAMs are set up like so (though this can be changed by changing the logiclock regions

	//
	//   X  15  37  51  64  78 104
	// Y
	// 9     0   4   8  12  16  20
	//27     1   5   9  13  17  21
	//45     2   6  10  14  18  22
	//63     3   7  11  15  19  23
	//


	always @ (*) begin
		case (SW[17:13])
			5'd0: begin 
				HEX0 = HEX0_sel[6:0];
				HEX1 = HEX1_sel[6:0];
				HEX2 = HEX2_sel[6:0];
				HEX3 = HEX3_sel[6:0];
				HEX4 = HEX4_sel[6:0];
				HEX5 = HEX5_sel[6:0];
				reset = reset_sel[0];
				next_frequency = next_frequency_sel[0];
				send_uart_data = send_uart_data_sel[0];
				UART_data = UART_data_sel[7:0];
			end
			5'd1: begin 
				HEX0 = HEX0_sel[13:7];
				HEX1 = HEX1_sel[13:7];
				HEX2 = HEX2_sel[13:7];
				HEX3 = HEX3_sel[13:7];
				HEX4 = HEX4_sel[13:7];
				HEX5 = HEX5_sel[13:7];
				reset = reset_sel[1];
				next_frequency = next_frequency_sel[1];
				send_uart_data = send_uart_data_sel[1];
				UART_data = UART_data_sel[15:8];
			end
			5'd2: begin 
				HEX0 = HEX0_sel[20:14];
				HEX1 = HEX1_sel[20:14];
				HEX2 = HEX2_sel[20:14];
				HEX3 = HEX3_sel[20:14];
				HEX4 = HEX4_sel[20:14];
				HEX5 = HEX5_sel[20:14];
				reset = reset_sel[2];
				next_frequency = next_frequency_sel[2];
				send_uart_data = send_uart_data_sel[2];
				UART_data = UART_data_sel[23:16];
			end
			5'd3: begin 
				HEX0 = HEX0_sel[27:21];
				HEX1 = HEX1_sel[27:21];
				HEX2 = HEX2_sel[27:21];
				HEX3 = HEX3_sel[27:21];
				HEX4 = HEX4_sel[27:21];
				HEX5 = HEX5_sel[27:21];
				reset = reset_sel[3];
				next_frequency = next_frequency_sel[3];
				send_uart_data = send_uart_data_sel[3];
				UART_data = UART_data_sel[31:24];
			end
			5'd4: begin 
				HEX0 = HEX0_sel[34:28];
				HEX1 = HEX1_sel[34:28];
				HEX2 = HEX2_sel[34:28];
				HEX3 = HEX3_sel[34:28];
				HEX4 = HEX4_sel[34:28];
				HEX5 = HEX5_sel[34:28];
				reset = reset_sel[4];
				next_frequency = next_frequency_sel[4];
				send_uart_data = send_uart_data_sel[4];
				UART_data = UART_data_sel[39:32];
			end
			5'd5: begin 
				HEX0 = HEX0_sel[41:35];
				HEX1 = HEX1_sel[41:35];
				HEX2 = HEX2_sel[41:35];
				HEX3 = HEX3_sel[41:35];
				HEX4 = HEX4_sel[41:35];
				HEX5 = HEX5_sel[41:35];
				reset = reset_sel[5];
				next_frequency = next_frequency_sel[5];
				send_uart_data = send_uart_data_sel[5];
				UART_data = UART_data_sel[47:40];
			end
			5'd6: begin 
				HEX0 = HEX0_sel[48:42];
				HEX1 = HEX1_sel[48:42];
				HEX2 = HEX2_sel[48:42];
				HEX3 = HEX3_sel[48:42];
				HEX4 = HEX4_sel[48:42];
				HEX5 = HEX5_sel[48:42];
				reset = reset_sel[6];
				next_frequency = next_frequency_sel[6];
				send_uart_data = send_uart_data_sel[6];
				UART_data = UART_data_sel[55:48];
			end
			5'd7: begin 
				HEX0 = HEX0_sel[55:49];
				HEX1 = HEX1_sel[55:49];
				HEX2 = HEX2_sel[55:49];
				HEX3 = HEX3_sel[55:49];
				HEX4 = HEX4_sel[55:49];
				HEX5 = HEX5_sel[55:49];
				reset = reset_sel[7];
				next_frequency = next_frequency_sel[7];
				send_uart_data = send_uart_data_sel[7];
				UART_data = UART_data_sel[63:56];
			end
			5'd8: begin 
				HEX0 = HEX0_sel[62:56];
				HEX1 = HEX1_sel[62:56];
				HEX2 = HEX2_sel[62:56];
				HEX3 = HEX3_sel[62:56];
				HEX4 = HEX4_sel[62:56];
				HEX5 = HEX5_sel[62:56];
				reset = reset_sel[8];
				next_frequency = next_frequency_sel[8];
				send_uart_data = send_uart_data_sel[8];
				UART_data = UART_data_sel[71:64];
			end
			5'd9: begin 
				HEX0 = HEX0_sel[69:63];
				HEX1 = HEX1_sel[69:63];
				HEX2 = HEX2_sel[69:63];
				HEX3 = HEX3_sel[69:63];
				HEX4 = HEX4_sel[69:63];
				HEX5 = HEX5_sel[69:63];
				reset = reset_sel[9];
				next_frequency = next_frequency_sel[9];
				send_uart_data = send_uart_data_sel[9];
				UART_data = UART_data_sel[79:72];
			end
			5'd10: begin 
				HEX0 = HEX0_sel[76:70];
				HEX1 = HEX1_sel[76:70];
				HEX2 = HEX2_sel[76:70];
				HEX3 = HEX3_sel[76:70];
				HEX4 = HEX4_sel[76:70];
				HEX5 = HEX5_sel[76:70];
				reset = reset_sel[10];
				next_frequency = next_frequency_sel[10];
				send_uart_data = send_uart_data_sel[10];
				UART_data = UART_data_sel[87:80];
			end
			5'd11: begin 
				HEX0 = HEX0_sel[83:77];
				HEX1 = HEX1_sel[83:77];
				HEX2 = HEX2_sel[83:77];
				HEX3 = HEX3_sel[83:77];
				HEX4 = HEX4_sel[83:77];
				HEX5 = HEX5_sel[83:77];
				reset = reset_sel[11];
				next_frequency = next_frequency_sel[11];
				send_uart_data = send_uart_data_sel[11];
				UART_data = UART_data_sel[95:88];
			end
			5'd12: begin 
				HEX0 = HEX0_sel[90:84];
				HEX1 = HEX1_sel[90:84];
				HEX2 = HEX2_sel[90:84];
				HEX3 = HEX3_sel[90:84];
				HEX4 = HEX4_sel[90:84];
				HEX5 = HEX5_sel[90:84];
				reset = reset_sel[12];
				next_frequency = next_frequency_sel[12];
				send_uart_data = send_uart_data_sel[12];
				UART_data = UART_data_sel[103:96];
			end
			5'd13: begin 
				HEX0 = HEX0_sel[97:91];
				HEX1 = HEX1_sel[97:91];
				HEX2 = HEX2_sel[97:91];
				HEX3 = HEX3_sel[97:91];
				HEX4 = HEX4_sel[97:91];
				HEX5 = HEX5_sel[97:91];
				reset = reset_sel[13];
				next_frequency = next_frequency_sel[13];
				send_uart_data = send_uart_data_sel[13];
				UART_data = UART_data_sel[111:104];
			end
			5'd14: begin 
				HEX0 = HEX0_sel[104:98];
				HEX1 = HEX1_sel[104:98];
				HEX2 = HEX2_sel[104:98];
				HEX3 = HEX3_sel[104:98];
				HEX4 = HEX4_sel[104:98];
				HEX5 = HEX5_sel[104:98];
				reset = reset_sel[14];
				next_frequency = next_frequency_sel[14];
				send_uart_data = send_uart_data_sel[14];
				UART_data = UART_data_sel[119:112];
			end
			5'd15: begin 
				HEX0 = HEX0_sel[111:105];
				HEX1 = HEX1_sel[111:105];
				HEX2 = HEX2_sel[111:105];
				HEX3 = HEX3_sel[111:105];
				HEX4 = HEX4_sel[111:105];
				HEX5 = HEX5_sel[111:105];
				reset = reset_sel[15];
				next_frequency = next_frequency_sel[15];
				send_uart_data = send_uart_data_sel[15];
				UART_data = UART_data_sel[127:120];
			end
			5'd16: begin 
				HEX0 = HEX0_sel[118:112];
				HEX1 = HEX1_sel[118:112];
				HEX2 = HEX2_sel[118:112];
				HEX3 = HEX3_sel[118:112];
				HEX4 = HEX4_sel[118:112];
				HEX5 = HEX5_sel[118:112];
				reset = reset_sel[16];
				next_frequency = next_frequency_sel[16];
				send_uart_data = send_uart_data_sel[16];
				UART_data = UART_data_sel[135:128];
			end
			5'd17: begin 
				HEX0 = HEX0_sel[125:119];
				HEX1 = HEX1_sel[125:119];
				HEX2 = HEX2_sel[125:119];
				HEX3 = HEX3_sel[125:119];
				HEX4 = HEX4_sel[125:119];
				HEX5 = HEX5_sel[125:119];
				reset = reset_sel[17];
				next_frequency = next_frequency_sel[17];
				send_uart_data = send_uart_data_sel[17];
				UART_data = UART_data_sel[143:136];
			end
			5'd18: begin 
				HEX0 = HEX0_sel[132:126];
				HEX1 = HEX1_sel[132:126];
				HEX2 = HEX2_sel[132:126];
				HEX3 = HEX3_sel[132:126];
				HEX4 = HEX4_sel[132:126];
				HEX5 = HEX5_sel[132:126];
				reset = reset_sel[18];
				next_frequency = next_frequency_sel[18];
				send_uart_data = send_uart_data_sel[18];
				UART_data = UART_data_sel[151:144];
			end
			5'd19: begin 
				HEX0 = HEX0_sel[139:133];
				HEX1 = HEX1_sel[139:133];
				HEX2 = HEX2_sel[139:133];
				HEX3 = HEX3_sel[139:133];
				HEX4 = HEX4_sel[139:133];
				HEX5 = HEX5_sel[139:133];
				reset = reset_sel[19];
				next_frequency = next_frequency_sel[19];
				send_uart_data = send_uart_data_sel[19];
				UART_data = UART_data_sel[159:152];
			end
			5'd20: begin 
				HEX0 = HEX0_sel[146:140];
				HEX1 = HEX1_sel[146:140];
				HEX2 = HEX2_sel[146:140];
				HEX3 = HEX3_sel[146:140];
				HEX4 = HEX4_sel[146:140];
				HEX5 = HEX5_sel[146:140];
				reset = reset_sel[20];
				next_frequency = next_frequency_sel[20];
				send_uart_data = send_uart_data_sel[20];
				UART_data = UART_data_sel[167:160];
			end
			5'd21: begin 
				HEX0 = HEX0_sel[153:147];
				HEX1 = HEX1_sel[153:147];
				HEX2 = HEX2_sel[153:147];
				HEX3 = HEX3_sel[153:147];
				HEX4 = HEX4_sel[153:147];
				HEX5 = HEX5_sel[153:147];
				reset = reset_sel[21];
				next_frequency = next_frequency_sel[21];
				send_uart_data = send_uart_data_sel[21];
				UART_data = UART_data_sel[175:168];
			end
			5'd22: begin 
				HEX0 = HEX0_sel[160:154];
				HEX1 = HEX1_sel[160:154];
				HEX2 = HEX2_sel[160:154];
				HEX3 = HEX3_sel[160:154];
				HEX4 = HEX4_sel[160:154];
				HEX5 = HEX5_sel[160:154];
				reset = reset_sel[22];
				next_frequency = next_frequency_sel[22];
				send_uart_data = send_uart_data_sel[22];
				UART_data = UART_data_sel[183:176];
			end
			5'd23: begin 
				HEX0 = HEX0_sel[167:161];
				HEX1 = HEX1_sel[167:161];
				HEX2 = HEX2_sel[167:161];
				HEX3 = HEX3_sel[167:161];
				HEX4 = HEX4_sel[167:161];
				HEX5 = HEX5_sel[167:161];
				reset = reset_sel[23];
				next_frequency = next_frequency_sel[23];
				send_uart_data = send_uart_data_sel[23];
				UART_data = UART_data_sel[191:184];
			end
			default: begin 
				HEX0 = HEX0_sel[6:0];
				HEX1 = HEX1_sel[6:0];
				HEX2 = HEX2_sel[6:0];
				HEX3 = HEX3_sel[6:0];
				HEX4 = HEX4_sel[6:0];
				HEX5 = HEX5_sel[6:0];
				reset = reset_sel[0];
				next_frequency = next_frequency_sel[0];
				send_uart_data = send_uart_data_sel[0];
				UART_data = UART_data_sel[7:0];
			end
		
		endcase
	
	end
	
	
	
	//for loop to generate RAM controllers
	genvar i;
	generate
		for (i = 0; i < 24; i=i+1)
			begin: memories
				ram_top ram_top_i(
					.CLOCK_50(CLOCK_50),
					.KEY(KEY),
					.SW(SW),
					.HEX0(HEX0_sel[7*i+6:7*i]),
					.HEX1(HEX1_sel[7*i+6:7*i]),
					.HEX2(HEX2_sel[7*i+6:7*i]),
					.HEX3(HEX3_sel[7*i+6:7*i]),
					.HEX4(HEX4_sel[7*i+6:7*i]),
					.HEX5(HEX5_sel[7*i+6:7*i]),
					.clk_fast(clk_fast),
					.clk_slow_even(clk_slow_even),
					.clk_slow_odd(clk_slow_odd),
					.reset(reset_sel[i]),
					.next_frequency(next_frequency_sel[i]),
					.frequency(frequency),
					.freq_ready(freq_ready),
					.UART_data(UART_data_sel[i*8+7:i*8]),
					.send_UART_data(send_uart_data_sel[i])
				);
			end
	endgenerate 
	
	
	
	
	RS232UART UART(
		.to_uart_data(UART_data),
		.to_uart_valid(send_uart_data),
		.clk(CLOCK_50),
		.reset(reset),
		.UART_TXD(UART_TXD)
	);
	
endmodule





module ram_top (
	input CLOCK_50,
	input [4:0] KEY,
	input [17:0] SW,
	output [7:0] LEDG,
	output [17:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	input wire clk_fast,
	input wire clk_slow_even,
	input wire clk_slow_odd,
	output reg reset,
	output reg next_frequency,
	input [8:0] frequency,
	input freq_ready,
	output reg [7:0] UART_data,
	output reg send_UART_data
	
);
	
	wire error_1, error_2;
	reg align, write_mem, latch_errors, reset_errors;



	RAM_Controller RAM_Controller1(
		.clk_fast( clk_fast ),
		.clk_slow_even( clk_slow_even ),
		.clk_slow_odd( clk_slow_odd),
		.align( align ),
		.write_mem( write_mem ),
		.error_1( error_1 ),
		.error_2( error_2 ),
	);


	

	reg reset_counter;
	
	reg [29:0] counter;

	
	
	reg reset_error_counter;
	
	always @ (posedge CLOCK_50 or posedge reset_counter) begin
		if(reset_counter) counter <= 30'd0;
		else counter <= counter + 30'd1;
	end

	assign LEDR[3:0] = state;

	reg [3:0] state, next_state;

	localparam start_write   =  4'd0;
	localparam wait_write    =  4'd1;
	localparam align_reads   =  4'd2;
	localparam wait_align    =  4'd3;
	localparam test          =  4'd4;
	localparam cycle_freq    =  4'd5;
	localparam wait_freq     =  4'd6;
	localparam write_1_uart  =  4'd7;
	localparam wait_1_uart   =  4'd8;
	localparam write_2_uart  =  4'd9;
	localparam wait_2_uart   = 4'd10;
	localparam write_3_uart  = 4'd11;
	localparam wait_3_uart   = 4'd12;
	localparam finish_state  = 4'd13;
	localparam write_4_uart  = 4'd14;
	localparam wait_4_uart   = 4'd15;

	
//	assign reset = SW[0];
//	
//	always @ (posedge CLOCK_50) begin
//		if(SW[0]) state <= start_write;
//		else state <= next_state;
//	end
//	
//	always @ (*) begin
//		case (state)
//			start_write: next_state <= wait_write;
//			wait_write: if(counter >= 30'd4096) next_state <= align_reads;
//				else next_state <= wait_write;
//			align_reads: next_state <= wait_align;
//			wait_align: if(counter >= 30'd4096) next_state <= test;
//				else next_state <= wait_align;
//			test: if(counter >= 30'd420480) next_state <= write_1_uart;
//				else next_state <= test;
//			cycle_freq: if(frequency >= 9'd500) next_state <= finish_state;
//				else next_state <= wait_freq;
//			wait_freq: if(freq_ready) next_state <= align_reads;
//				else next_state <= wait_freq;
//			write_1_uart: next_state <= wait_1_uart;
//			wait_1_uart: if(counter >= 30'd10000) next_state <= write_2_uart;
//				else next_state <= wait_1_uart;
//			write_2_uart: next_state <= wait_2_uart;
//			wait_2_uart: if(counter >= 30'd10000) next_state <= write_3_uart;
//				else next_state <= wait_2_uart;
//			write_3_uart: next_state <= wait_3_uart;
//			wait_3_uart: if(counter >= 30'd10000) next_state <= write_4_uart;
//				else next_state <= wait_3_uart;
//			write_4_uart: next_state <= wait_4_uart;
//			wait_4_uart: if(counter >= 30'd10000) next_state <= cycle_freq;
//				else next_state <= wait_4_uart;
//			finish_state: next_state <= finish_state;
//			default: next_state <= align_reads;
//		endcase
//	end
//	
//	
//	always @ (posedge CLOCK_50) begin
//		UART_data <= 8'b0;
//		reset_error_counter <= 1'b0;
//		reset_counter <= 1'b0;
//		reset_errors <= 1'b0;
//		latch_errors <= 1'b0;
//		next_frequency <= 1'b0;
//		align <= 1'b0;
//		write_mem <= 1'b0;
//		send_UART_data <= 1'b0;
//		case (state)
//				start_write: begin
//					reset_counter <= 1'b1;
//					write_mem <= 1'b1;
//				end
//				wait_write: begin
//					
//				end
//				align_reads: begin
//					reset_counter <= 1'b1;
//					align <= 1'b1;
//				end
//				wait_align: begin
//					reset_errors <= 1'b1;
//				end
//				test: begin
//					latch_errors <= 1'b1;
//				end
//				cycle_freq: begin
//					next_frequency <= 1'b1;
//				end
//				wait_freq: begin
//					
//				end
//				write_1_uart: begin
//					UART_data <= {8'b0};
//					send_UART_data <= 1'b1;
//				end
//				wait_1_uart: begin
//					UART_data <= {8'b0};
//				end
//				write_2_uart: begin
//					UART_data <= {1'b0, 1'b1, total_error_counter[5:0]};
//					send_UART_data <= 1'b1;
//				end
//				wait_2_uart: begin
//					UART_data <= {1'b0, 1'b1, total_error_counter[5:0]};
//				end
//				write_3_uart: begin
//					UART_data <= {1'b0, 1'b1, total_error_counter[11:6]};
//					send_UART_data <= 1'b1;
//				end
//				wait_3_uart: begin
//					UART_data <= {1'b0, 1'b1, total_error_counter[11:6]};
//				end
//				write_4_uart: begin
//					UART_data <= {1'b0, 1'b1, 2'b0, total_error_counter[15:12]};
//					send_UART_data <= 1'b1;
//				end
//				wait_4_uart: begin
//					UART_data <= {1'b0, 1'b1, 2'b0, total_error_counter[15:12]};
//				end
//				finish_state: begin
//				
//				end
//				default: begin
//				
//				end
//			endcase
//		
//		
//	
//	end
	
	
	
	
	
	always @ (posedge CLOCK_50) begin
		if (SW[0]) begin
			state <= start_write;
			reset_counter <= 1'b1;
			reset_errors <= 1'b1;
			latch_errors <= 1'b0;
			next_frequency <= 1'b0;
			reset <= 1'b1;
			align <= 1'b0;
			write_mem <= 1'b1;
			state <= wait_write;
			send_UART_data <= 1'b0;
			reset_error_counter <= 1'b1;
		end
		else begin
			UART_data <= {1'b1, frequency[6:0]};
			reset_error_counter <= 1'b0;
			case (state)
				start_write: begin
					reset_counter <= 1'b1;
					reset_errors <= 1'b1;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b1;
					align <= 1'b0;
					write_mem <= 1'b1;
					state <= wait_write;
					send_UART_data <= 1'b0;
					reset_error_counter <= 1'b1;
				end
				wait_write: begin
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					if (counter >= 30'd2048) state <= align_reads;
					else state <= wait_write;
					send_UART_data <= 1'b0;
					reset_error_counter <= 1'b1;
				end
				align_reads: begin
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b1;
					write_mem <= 1'b0;
					state <= wait_align;
					send_UART_data <= 1'b0;
					reset_error_counter <= 1'b1;
				end
				wait_align: begin
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					if (counter >= 30'd2048) begin 
						state <= test;
						reset_counter <= 1'b1;
					end
					else  begin
						state <= wait_align;
						reset_counter <= 1'b0;
					end
					send_UART_data <= 1'b0;
					reset_error_counter <= 1'b1;
				end
				test: begin
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b1;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					if (counter >= 30'd16384) state <= write_1_uart;
					else state <= test;
					send_UART_data <= 1'b0;
				end
				write_1_uart: begin
					UART_data <= {8'b0};
					state <= wait_1_uart;
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b1;
				end
				wait_1_uart: begin
					UART_data <= {8'b0};
					if (counter >= 30'd10000) state <= write_2_uart; //10000 takes ~3500 50MHz cycles to send 8 bits at 115200 baud
					else state <= wait_1_uart;
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b0;
				end
				write_2_uart: begin
					UART_data <= {1'b0, 1'b1, total_error_counter[5:0]};
					state <= wait_2_uart;
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b1;
				end
				wait_2_uart: begin
					UART_data <= {1'b0, 1'b1, total_error_counter[5:0]};
					if (counter >= 30'd10000) state <= write_3_uart;
					else state <= wait_2_uart;
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b0;
				end
				write_3_uart: begin
					UART_data <= {1'b0, 1'b1, total_error_counter[11:6]};
					state <= wait_3_uart;
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b1;
				end
				wait_3_uart: begin
					UART_data <= {1'b0, 1'b1, total_error_counter[11:6]};
					if (counter >= 30'd10000 ) state <= write_4_uart;
					else state <= wait_3_uart;
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b0;
				end
				write_4_uart: begin
					UART_data <= {1'b0, 1'b1, 2'b0, total_error_counter[15:12]};
					state <= wait_4_uart;
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b1;
				end
				wait_4_uart: begin
					UART_data <= {1'b0, 1'b1, 2'b0, total_error_counter[15:12]};
					if (counter >= 30'd10000 && frequency < 9'd510) state <= cycle_freq;
					else if(frequency > 9'd510) state <= finish_state;
					else state <= wait_4_uart;
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					send_UART_data <= 1'b0;
				end
				cycle_freq: begin
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b1;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					state <= wait_freq;
					send_UART_data <= 1'b0;
				end
				wait_freq: begin
					reset_counter <= 1'b1;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					if(freq_ready) state <= align_reads;
					else state <= wait_freq;
					send_UART_data <= 1'b0;
				end
				finish_state: begin
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					state <= finish_state;
					if(~KEY[0] && counter > 30'd1000000) begin 
						send_UART_data <= 1'b1;
						reset_counter <= 1'b1;
					end
					else begin
						reset_counter <= 1'b0;
						send_UART_data <= 1'b0;
					end
					UART_data <= 8'd0;
				end
				default: begin
					reset_counter <= 1'b0;
					reset_errors <= 1'b0;
					latch_errors <= 1'b0;
					next_frequency <= 1'b0;
					reset <= 1'b0;
					align <= 1'b0;
					write_mem <= 1'b0;
					state <= align_reads;
					send_UART_data <= 1'b0;
				end
			endcase

		end
	end
	
	reg finish_signal;
	always @ (*)
		if(state == finish_state) 
			finish_signal = 1'b1;
		else 
			finish_signal = 1'b0;
	
	assign LEDR[10] = finish_signal;
	
	
	reg [8:0] freq_latch;
	reg error_latch_1;
	reg error_latch_2;
	
	always @ (*) begin
		if(SW[0]) 
			freq_latch <= 9'd0;
		else if ((error_1 | error_2) && freq_latch == 9'd0 && latch_errors) 
			freq_latch <= frequency;
		else freq_latch <= freq_latch;
	
	
	end

	hex_display hexa0 (frequency[3:0], HEX0);
	hex_display hexa1 (frequency[7:4], HEX1);
	hex_display hexa2 ({3'd0, frequency[8]}, HEX2);
	hex_display hexa3 (freq_latch[3:0], HEX3);
	hex_display hexa4 (freq_latch[7:4], HEX4);
	hex_display hexa5 ({3'd0, freq_latch[8]}, HEX5);
	
	
	always @ (*) begin
		if(SW[0]) begin
			error_latch_1 <= 1'b0;
			error_latch_2 <= 1'b0;
		end

		else if(latch_errors) begin
			if(error_1 && ~error_latch_1) begin
				error_latch_1 <= 1'b1;
			end
			else begin
				error_latch_1 <= error_latch_1;
			end
			if(error_2 && ~error_latch_2) begin
				error_latch_2 <= 1'b1;
			end
			else begin
				error_latch_2 <= error_latch_2;
			end
		end
		else begin
			error_latch_1 <= error_latch_1;
			error_latch_2 <= error_latch_2;
		end


	end
	
	reg [14:0] error_counter_1, error_counter_2;
	wire [15:0] total_error_counter;
	
	always @ (posedge CLOCK_50) begin
		if (reset_error_counter) error_counter_1 <= 15'b0;
		else if(error_1 && latch_errors) error_counter_1 <= error_counter_1 + 15'd1;
		else error_counter_1 <= error_counter_1;
	
	end
	
	always @ (posedge CLOCK_50) begin
		if (reset_error_counter) error_counter_2 <= 15'b0;
		else if(error_2 && latch_errors) error_counter_2 <= error_counter_2 + 15'd1;
		else error_counter_2 <= error_counter_2;
	end
	
	assign total_error_counter = error_counter_1 + error_counter_2;
	
	
	

	
	
	
endmodule


module hex_display (
	input [3:0] number,
	output [6:0] hex
);
	reg [6:0] r_Hex_Encoding;
	
	assign hex[0] = ~r_Hex_Encoding[6];
	assign hex[1] = ~r_Hex_Encoding[5];
	assign hex[2] = ~r_Hex_Encoding[4];
	assign hex[3] = ~r_Hex_Encoding[3];
	assign hex[4] = ~r_Hex_Encoding[2];
	assign hex[5] = ~r_Hex_Encoding[1];
	assign hex[6] = ~r_Hex_Encoding[0];
	
	
	always @ (*) 
	begin
      case (number)
        4'b0000 : r_Hex_Encoding <= 7'h7E;
        4'b0001 : r_Hex_Encoding <= 7'h30;
        4'b0010 : r_Hex_Encoding <= 7'h6D;
        4'b0011 : r_Hex_Encoding <= 7'h79;
        4'b0100 : r_Hex_Encoding <= 7'h33;          
        4'b0101 : r_Hex_Encoding <= 7'h5B;
        4'b0110 : r_Hex_Encoding <= 7'h5F;
        4'b0111 : r_Hex_Encoding <= 7'h70;
        4'b1000 : r_Hex_Encoding <= 7'h7F;
        4'b1001 : r_Hex_Encoding <= 7'h7B;
        4'b1010 : r_Hex_Encoding <= 7'h77;
        4'b1011 : r_Hex_Encoding <= 7'h1F;
        4'b1100 : r_Hex_Encoding <= 7'h4E;
        4'b1101 : r_Hex_Encoding <= 7'h3D;
        4'b1110 : r_Hex_Encoding <= 7'h4F;
        4'b1111 : r_Hex_Encoding <= 7'h47;
      endcase
    end 



endmodule
