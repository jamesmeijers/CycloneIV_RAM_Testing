module top (
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
	output UART_TXD
//	input clk_fast,
//	input clk_slow_even,
//	input clk_slow_odd
	
);
	wire reset, next_frequency, freq_ready, clk_fast, clk_slow_even, clk_slow_odd;
	wire [8:0] frequency;
	wire [7:0] UART_data;
	wire send_UART_data;
	
	//clock generator, produces three clocks from 1 50MHz input clock
	//clk_fast is frequency*1.25 MHz
	//clk_slow_even is half the frequency of clk_fast
	//clk_slow_odd is half the frequency of clk_fast and 180 degrees out of phase with clk_slow_even
	//add is the frequency step taken / 1.25, e.g. add = 2 -> frequency step = 1.5
	//freq_ready is high when clock is locked
	//setting next_frequency high for 1 50MHz cycle increments the frequency by add*1.25
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
	
	ram_top ram_top1(
		.CLOCK_50(CLOCK_50),
		.KEY(KEY),
		.SW(SW),
		.LEDG(LEDG),
		.LEDR(LEDR),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.clk_fast(clk_fast),
		.clk_slow_even(clk_slow_even),
		.clk_slow_odd(clk_slow_odd),
		.reset(reset),
		.next_frequency(next_frequency),
		.frequency(frequency),
		.freq_ready(freq_ready),
		.UART_data(UART_data),
		.send_UART_data(send_UART_data)
	);
	
	//pared down UART, only used to send data
	//to_uart_data is 8 bit data being sent
	//to_uart_valid goes high for one cycle to send the data
	//UART_TXD is the output pin for the UART on the DE1-115 board
	RS232UART UART(
		.to_uart_data(UART_data),
		.to_uart_valid(send_UART_data),
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


	//the RAM
	//align and write_mem are control signals to reset the RAM and start testing
	//error_1 & error_2 go high whenever there is an error detected
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

	
	always @ (posedge CLOCK_50) begin
		if (SW[0]) begin //any time the switch is high, restart the whole test
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
				start_write: begin //start the write by setting write_mem to high
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
				wait_write: begin //wait for the write to complete (only 512 cycles is neccessary, but extra cycles don't hurt)
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
				align_reads: begin //align the reads, doesn't really do anything but prep for the test
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
				wait_align: begin //let the RAM run for awhile before testing
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
				test: begin //count errors for 2^14 cycles (2 errors tested each cycle -> 2^15 tests)
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
				write_1_uart: begin //The 0 represents a cycle in frequency
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
				write_2_uart: begin //send the lower six bits of the error counter
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
				write_3_uart: begin //send the middle 6 bits of the error counter
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
				write_4_uart: begin //send the upper 4 bits of the error counter
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
				cycle_freq: begin //send the cycle frequency signal
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
				wait_freq: begin //wait for the new frequency to lock
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
				finish_state: begin //all tested frequencies are complete
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
	
	always @ (*) begin //latch the speed of the first error found
		if(SW[0]) 
			freq_latch <= 9'd0;
		else if ((error_1 | error_2) && freq_latch == 9'd0 && latch_errors) 
			freq_latch <= frequency;
		else freq_latch <= freq_latch;
	
	
	end

	//display the current frequency and the frequency of the first error (display = (actual_freq/1.25) in HEX)
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
	
	//both errors are sampled at 50MHz and summed, then the two sums are added together for the total error
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
