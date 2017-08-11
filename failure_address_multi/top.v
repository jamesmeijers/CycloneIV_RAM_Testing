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
	
	//24 different versions of the controller are made
	//they all share inputs and each has its own outputs
	//the outputs that are listened to by the external hardware are selected using the switches
	//changing external switches only results in reliable data when reset is set during or after the change
	//tests are run simultaneously, but only the test of the one selected is guaranteed to run properly

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
	
	
	
	//for loop to generate all the RAM testers
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
	input                 CLOCK_50,
	input         [4:0]   KEY,
	input         [17:0]  SW,
	output        [7:0]   LEDG,
	output        [17:0]  LEDR,
	output        [6:0]   HEX0,
	output        [6:0]   HEX1,
	output        [6:0]   HEX2,
	output        [6:0]   HEX3,
	output        [6:0]   HEX4,
	output        [6:0]   HEX5,
	input  wire           clk_fast,
	input  wire           clk_slow_even,
	input  wire           clk_slow_odd,
	output reg            reset,
	output reg            next_frequency,
	input         [8:0]   frequency,
	input                 freq_ready,
	output reg    [7:0]   UART_data,
	output reg            send_UART_data
	
);
	
	wire error_1, error_2;
	wire [9:0] error_address_1, error_address_2;



	RAM_Controller RAM_Controller1(
		.clk_fast( clk_fast ),
		.clk_slow_even( clk_slow_even ),
		.clk_slow_odd( clk_slow_odd),
		.align( align ),
		.write_mem( write_mem ),
		.error_1( error_1 ),
		.error_2( error_2 ),
		.error_address_1( error_address_1 ),
		.error_address_2( error_address_2 )
	);


	

	

	//FSM to sense erros and send them to the UART
	reg [5:0] state_a, next_state_a;
	reg [14:0] uart_counter;
	reg write_freq;
	reg reset_uart_counter, pause_main_counter;
	reg latch_errors, reset_error_latches, error_latch_1, error_latch_2;
	reg sync_error;
	reg [9:0] address_latch_1, address_latch_2;
	reg run_error_test, freq_written;
	reg [9:0] error_address;
	reg latch_past_address, past_address_latch;
	
	assign LEDG[5:0] = state_a;
	
	localparam hold              =  6'd12;
	localparam wait_for_error    =  6'd0;
	localparam write_frequency   =  6'd1;
	localparam wait_frequency    =  6'd2;
	localparam done_write_freq   =  6'd11;
	localparam write_err_1       =  6'd3;
	localparam wait_err_1        =  6'd4;
	localparam write_err_2       =  6'd5;
	localparam wait_err_2        =  6'd6;
	localparam write_err_3       =  6'd7;
	localparam wait_err_3        =  6'd8;
	localparam write_err_4       =  6'd9;
	localparam wait_err_4        =  6'd10;
	localparam write_start_err   =  6'd13;
	localparam wait_start_err    =  6'd14;
	localparam write_start_freq  =  6'd15;
	localparam wait_start_freq   =  6'd16;
	localparam wait_to_continue  =  6'd21;
	
	
	always @ (posedge CLOCK_50) begin
		if(reset_uart_counter) uart_counter <= 15'd0;
		else uart_counter <= uart_counter + 15'd1;
	end
	
	always @ (posedge CLOCK_50) begin
		if(SW[0]) state_a <= hold;
		else state_a <= next_state_a;
	end
	
	always @ (*) begin
		case(state_a) 
			hold: next_state_a = wait_for_error;
			wait_for_error: if( ~run_error_test ) next_state_a = write_start_freq;
				else if( sync_error ) next_state_a = write_start_err;
				else next_state_a = wait_for_error;
			write_start_freq: if(write_freq) next_state_a = wait_start_freq;
				else next_state_a = write_start_freq;
			wait_start_freq: if( uart_counter > 15'd10000 ) next_state_a = write_frequency;
				else next_state_a = wait_start_freq;
			write_frequency: next_state_a = wait_frequency;
			wait_frequency: if( uart_counter > 15'd10000 ) next_state_a = done_write_freq;
				else next_state_a = wait_frequency;
			done_write_freq: if( run_error_test ) next_state_a = wait_for_error;
				else next_state_a = done_write_freq;
			write_start_err: next_state_a = wait_start_err;	
			wait_start_err: if( uart_counter > 15'd10000 ) next_state_a = write_err_1;
				else next_state_a = wait_start_err;
			write_err_1: next_state_a = wait_err_1;
			wait_err_1: if( uart_counter > 15'd10000 ) next_state_a = write_err_2;
				else next_state_a = wait_err_1;
			write_err_2: next_state_a = wait_err_2;
			wait_err_2: if( uart_counter > 15'd10000 ) next_state_a = write_err_3;
				else next_state_a = wait_err_2;
			write_err_3: next_state_a = wait_err_3;
			wait_err_3: if( uart_counter > 15'd10000 ) next_state_a = write_err_4;
				else next_state_a = wait_err_3;
			write_err_4: next_state_a = wait_err_4;
			wait_err_4: if( uart_counter > 15'd10000 ) next_state_a = wait_to_continue;
				else next_state_a = wait_err_4;
			wait_to_continue: if(past_address_latch) next_state_a = wait_for_error;
				else next_state_a = wait_to_continue;
			default: next_state_a = wait_for_error;
		endcase
	end
	
	always @ ( posedge CLOCK_50) begin
		reset_uart_counter <= 1'b0;
		UART_data <= 8'd0;
		send_UART_data <= 1'b0;
		latch_errors <= 1'b0;
		reset_error_latches <= 1'b0;
		pause_main_counter <= 1'b0;
		freq_written <= 1'b0;
		error_address <= error_address;
		latch_past_address <= 1'b0;
		
		case (state_a) 
			hold: begin
				reset_error_latches <= 1'b1;
			end
			wait_for_error: begin
				latch_errors <= 1'b1;
			end
			write_start_freq: begin
				UART_data <= {1'b0, 7'b1111111};
				if( write_freq) send_UART_data <= 1'b1; 
				else send_UART_data <= 1'b0;
				reset_uart_counter <= 1'b1;
				reset_error_latches <= 1'b1;
			end
			wait_start_freq: begin
				UART_data <= {1'b0, 7'b1111111};
				pause_main_counter <= 1'b1;
			end
			write_frequency: begin
				UART_data <= {1'b0, 1'b1, frequency[5:0]};
				send_UART_data <= 1'b0; //not sending frequency for now
				reset_uart_counter <= 1'b1;
				reset_error_latches <= 1'b1;
				//pause_main_counter <= 1'b1;
			end
			wait_frequency: begin
				UART_data <= {1'b0, 1'b1, frequency[5:0]};
				pause_main_counter <= 1'b1;
			end
			done_write_freq: begin
				freq_written <= 1'b1;
			end
			write_start_err: begin
				UART_data <= {1'b0, 1'b1, 6'b0 };
				send_UART_data <= 1'b1;
				reset_uart_counter <= 1'b1;
				pause_main_counter <= 1'b1;
				latch_errors <= 1'b1;
			end
			wait_start_err: begin
				pause_main_counter <= 1'b1;
				UART_data <= {1'b0, 1'b1, 6'b0};
				latch_errors <= 1'b1;
			end
			write_err_1: begin
				UART_data <= {1'b0, 1'b0, address_latch_1[5:0]};
				if(error_latch_1) send_UART_data <= 1'b1;
				if(error_latch_1) error_address <= address_latch_1;
				reset_uart_counter <= 1'b1;
				pause_main_counter <= 1'b1;
			end
			wait_err_1: begin
				pause_main_counter <= 1'b1;
				UART_data <= {1'b0, 1'b0, address_latch_1[5:0]};
			end
			write_err_2: begin
				UART_data <= {1'b0, 3'b0, address_latch_1[9:6]};
				if(error_latch_1) send_UART_data <= 1'b1;
				reset_uart_counter <= 1'b1;
				pause_main_counter <= 1'b1;
			end
			wait_err_2: begin
				pause_main_counter <= 1'b1;
				UART_data <= {1'b0, 3'b0, address_latch_1[9:6]};
			end
			write_err_3: begin
				UART_data <= {1'b0, 1'b0, address_latch_2[5:0]};
				if(error_latch_2) send_UART_data <= 1'b1;
				if(~error_latch_1) error_address <= address_latch_2;
				reset_uart_counter <= 1'b1;
				pause_main_counter <= 1'b1;
			end
			wait_err_3: begin
				UART_data <= {1'b0, 1'b0, address_latch_2[5:0]};
				pause_main_counter <= 1'b1;
			end
			write_err_4: begin
				UART_data <= {1'b0, 3'b0, address_latch_2[9:6]};
				if(error_latch_2) send_UART_data <= 1'b1;
				reset_uart_counter <= 1'b1;
				pause_main_counter <= 1'b1;
			end
			wait_err_4: begin
				UART_data <= {1'b0, 3'b0, address_latch_2[9:6]};
				reset_error_latches <= 1'b1;
				pause_main_counter <= 1'b1;
			end
			wait_to_continue: begin
				reset_error_latches <= 1'b1;
				pause_main_counter <= 1'b1;
				latch_past_address <= 1'b1;
			end
			default: begin
			
			end
		
		endcase
	
	end
	
	reg next_past_address_latch;
	
	always @ (*) begin
		if(latch_past_address) begin
			//if(error_address_1 > (error_address) || error_address_1 > error_address + 10'd20) past_address_latch <= 1'b1;
			if(error_address_1 == error_address || error_address_2 == error_address) next_past_address_latch <= 1'b1;
			else next_past_address_latch <= next_past_address_latch;
		end
		else next_past_address_latch <= 1'b0;
	end
	
	always @ (posedge CLOCK_50) begin
		past_address_latch <= next_past_address_latch;
	end
	
	
	
	
	//FSM to control writing and the cycling of frequencies
	
	reg [4:0] state_b, next_state_b;
	reg [20:0] counter;
	reg reset_counter, align, write_mem, sense_errors;
	
	localparam reset_PLL      = 5'd0;
	localparam reset_lock     = 5'd6;
	localparam write_ram      = 5'd1;
	localparam wait_write     = 5'd7;
	localparam start_setup    = 5'd8;
	localparam wait_setup     = 5'd2;
	localparam run_test       = 5'd3;
	localparam cycle_PLL      = 5'd4;
	localparam wait_lock      = 5'd5;
	localparam wait_for_write = 5'd9;

	always @ ( posedge CLOCK_50 )
		if( reset_counter) counter <= 21'd0;
		else if(pause_main_counter) counter <= counter;
		else counter <= counter + 21'd1;
	
	always @ ( posedge CLOCK_50 ) 
		if ( SW[0] ) state_b <= reset_PLL;
		else state_b <= next_state_b;
		
		
	always @ (*) begin
		case (state_b)
			reset_PLL: next_state_b = reset_lock;
			reset_lock: if(freq_ready) next_state_b = write_ram;
				else next_state_b = reset_lock;
			write_ram: next_state_b = wait_write;
			wait_write: if(counter > 3000) next_state_b = start_setup;
				else next_state_b = write_ram;
			start_setup: next_state_b = wait_setup;
			wait_setup: if(counter > 10000) next_state_b = run_test;
				else next_state_b = wait_setup;
			run_test: if(counter > 420000) next_state_b = cycle_PLL;
				else next_state_b = run_test;
			cycle_PLL: next_state_b = wait_lock;
			wait_lock: if(freq_ready) next_state_b = wait_for_write;
				else next_state_b = wait_lock;
			wait_for_write: if(freq_written) next_state_b = start_setup;
				else next_state_b = wait_for_write;
			default: next_state_b = start_setup;//wait_for_write;
		endcase
	end
	
	always @ (posedge CLOCK_50) begin
		write_freq <= 1'b0;
		next_frequency <= 1'b0;
		reset <= 1'b0;
		align <= 1'b0;
		write_mem <= 1'b0;
		reset_counter <= 1'b0;
		sense_errors <= 1'b0;
		run_error_test <= 1'b0;
		
		case (state_b)
			reset_PLL: begin
				reset <= 1'b1;
			end
			reset_lock: begin
				
			end
			write_ram: begin
				write_mem <= 1'b1;
				reset_counter <= 1'b1;
			end
			wait_write: begin
			end
			start_setup: begin
				align <= 1'b1;
				reset_counter <= 1'b1;
			end
			wait_setup: begin
			end
			run_test: begin
				sense_errors <= 1'b1;
				run_error_test <= 1'b1;
			end
			cycle_PLL: begin
				next_frequency <= 1'b1;
			end
			wait_lock: begin
			
			end
			wait_for_write: begin
				write_freq <= 1'b1;
			end
			default: begin
			end
		endcase 
	
	end
	
	
	
	
	hex_display hexa0 (frequency[3:0], HEX0);
	hex_display hexa1 (frequency[7:4], HEX1);
	hex_display hexa2 ({3'd0, frequency[8]}, HEX2);
	

	
	
	
	
	always @(posedge CLOCK_50) begin
		if(reset_error_latches | ~sense_errors) sync_error <= 1'b0;
		else sync_error <= error_latch_2 | error_latch_1;
	end
	
//	always @ (posedge clk_slow_even) begin
//		if(reset_error_latches | ~sense_errors) begin
//			error_latch_1 <= 1'b0;
//			address_latch_1 <= 10'd0;
//		end
//		
//		else if(latch_errors) begin
//			if(error_1 == 1'b1 && error_latch_1 == 1'b0) begin
//				error_latch_1 <= 1'b1;
//				address_latch_1 <= error_address_1;
//			end
//			else begin
//				error_latch_1 <= error_latch_1;
//				address_latch_1 <= address_latch_1;
//			end
//		end
//		
//		else begin
//			error_latch_1 <= error_latch_1;
//			address_latch_1 <= address_latch_1;
//		end
//	end
//	
//	always @ (posedge clk_slow_odd) begin
//		if(reset_error_latches | ~sense_errors) begin
//			error_latch_2 <= 1'b0;
//			address_latch_2 <= 10'd0;
//		end
//		
//		else if(latch_errors) begin
//			if(error_2 == 1'b1 && error_latch_2 == 1'b0) begin
//				error_latch_2 <= 1'b1;
//				address_latch_2 <= error_address_2;
//			end
//			else begin
//				error_latch_2 <= error_latch_2;
//				address_latch_2 <= address_latch_2;
//			end
//		end
//		
//		else begin
//			error_latch_2 <= error_latch_2;
//			address_latch_2 <= address_latch_2;
//		end
//	end
	
	
	always @ (*) begin
		if(reset_error_latches | ~sense_errors) begin
			error_latch_1 <= 1'b0;
			address_latch_1 <= 10'd0;
			error_latch_2 <= 1'b0;
			address_latch_2 <= 10'd0;
		end

		else if(latch_errors) begin
			if(error_1 && ~error_latch_1) begin
				error_latch_1 <= 1'b1;
				address_latch_1 <= error_address_1;
			end
			else begin
				error_latch_1 <= error_latch_1;
				address_latch_1 <= address_latch_1;
			end
			if(error_2 && ~error_latch_2) begin
				error_latch_2 <= 1'b1;
				address_latch_2 <= error_address_2;
			end
			else begin
				error_latch_2 <= error_latch_2;
				address_latch_2 <= address_latch_2;
			end
		end
		else begin
			error_latch_1 <= error_latch_1;
			error_latch_2 <= error_latch_2;
			address_latch_1 <= address_latch_1;
			address_latch_2 <= address_latch_2;
		end


	end
	
	
	reg [9:0] first_fail_freq;
	
	always @ (*) begin
		if(SW[0]) first_fail_freq = 10'd0;
		else if (sense_errors && (error_2 || error_1) && first_fail_freq == 10'd0) first_fail_freq = frequency;
		else first_fail_freq = first_fail_freq;
	end
	
	hex_display hexa3 (first_fail_freq[3:0], HEX3);
	hex_display hexa4 (first_fail_freq[7:4], HEX4);
	hex_display hexa5 ({3'd0, first_fail_freq[8]}, HEX5);
	
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
