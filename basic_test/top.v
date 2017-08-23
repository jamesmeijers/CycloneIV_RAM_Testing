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
	output reg [6:0] HEX5
	
);
	reg reset, next_frequency;
	wire freq_ready, clk_fast, clk_slow_even, clk_slow_odd;
	wire [8:0] frequency;
	wire [7:0] UART_data;
	wire send_UART_data;
	
	pll pll1(
		.CLK_50( CLOCK_50 ),
		.reset( reset ),
		.next_frequency( next_frequency ),
		.frequency( frequency ),
		.freq_ready( freq_ready),
		.reconfig_CLK( clk_fast ),
		.half_CLK_1( clk_slow_even ),
		.half_CLK_2( clk_slow_odd ),
		.add( 4'd1 )
	); 
	
	wire [27:0] hex0, hex1, hex2, hex3, hex4, hex5;
	wire [3:0] reseta, next_frequencya;
	
	reg [19:0] test_length;
	always @ (*) begin
		case(SW[3:2]) 
			2'd0: test_length = 20'd32768; //2^15 * 10 tests
			2'd1:	test_length = 20'd131072; //2^17 * 10 tests
			2'd2: test_length = 20'd524288; //2^19 * 10 tests
			2'd3: test_length = 20'd2048; //2^11 * 10 tests
			default: test_length = 20'd32768; //2^15 * 10 tests
		endcase
	end
	
	
	
	
	always @ (*) begin
		case(SW[17:16])
			2'd0: begin
				HEX0 = hex0[6:0];
				HEX1 = hex1[6:0];
				HEX2 = hex2[6:0];
				HEX3 = hex3[6:0];
				HEX4 = hex4[6:0];
				HEX5 = hex5[6:0];
				reset = reseta[0];
				next_frequency = next_frequencya[0];
			end
			2'd1: begin
				HEX0 = hex0[13:7];
				HEX1 = hex1[13:7];
				HEX2 = hex2[13:7];
				HEX3 = hex3[13:7];
				HEX4 = hex4[13:7];
				HEX5 = hex5[13:7];
				reset = reseta[1];
				next_frequency = next_frequencya[1];
			
			end
			2'd2: begin
				HEX0 = hex0[20:14];
				HEX1 = hex1[20:14];
				HEX2 = hex2[20:14];
				HEX3 = hex3[20:14];
				HEX4 = hex4[20:14];
				HEX5 = hex5[20:14];
				reset = reseta[2];
				next_frequency = next_frequencya[2];
			
			end
			2'd3: begin
				HEX0 = hex0[27:21];
				HEX1 = hex1[27:21];
				HEX2 = hex2[27:21];
				HEX3 = hex3[27:21];
				HEX4 = hex4[27:21];
				HEX5 = hex5[27:21];
				reset = reseta[3];
				next_frequency = next_frequencya[3];
			
			end
			default: begin
				HEX0 = hex0[6:0];
				HEX1 = hex1[6:0];
				HEX2 = hex2[6:0];
				HEX3 = hex3[6:0];
				HEX4 = hex4[6:0];
				HEX5 = hex5[6:0];
				reset = reseta[0];
				next_frequency = next_frequencya[0];
			end
		endcase
	end
	
	
	ram_top ram_top1(
		.CLOCK_50(CLOCK_50),
		.SW(SW),
		.HEX0(hex0[6:0]),
		.HEX1(hex1[6:0]),
		.HEX2(hex2[6:0]),
		.HEX3(hex3[6:0]),
		.HEX4(hex4[6:0]),
		.HEX5(hex5[6:0]),
		.clk_fast(clk_fast),
		.clk_slow_even(clk_slow_even),
		.clk_slow_odd(clk_slow_odd),
		.reset(reseta[0]),
		.next_frequency(next_frequencya[0]),
		.frequency(frequency),
		.freq_ready(freq_ready),
		.test_length(test_length)
	);
	
	ram_top ram_top2(
		.CLOCK_50(CLOCK_50),
		.SW(SW),
		.HEX0(hex0[13:7]),
		.HEX1(hex1[13:7]),
		.HEX2(hex2[13:7]),
		.HEX3(hex3[13:7]),
		.HEX4(hex4[13:7]),
		.HEX5(hex5[13:7]),
		.clk_fast(clk_fast),
		.clk_slow_even(clk_slow_even),
		.clk_slow_odd(clk_slow_odd),
		.reset(reseta[1]),
		.next_frequency(next_frequencya[1]),
		.frequency(frequency),
		.freq_ready(freq_ready),
		.test_length(test_length)
	);
	
	ram_top ram_top3(
		.CLOCK_50(CLOCK_50),
		.SW(SW),
		.HEX0(hex0[20:14]),
		.HEX1(hex1[20:14]),
		.HEX2(hex2[20:14]),
		.HEX3(hex3[20:14]),
		.HEX4(hex4[20:14]),
		.HEX5(hex5[20:14]),
		.clk_fast(clk_fast),
		.clk_slow_even(clk_slow_even),
		.clk_slow_odd(clk_slow_odd),
		.reset(reseta[2]),
		.next_frequency(next_frequencya[2]),
		.frequency(frequency),
		.freq_ready(freq_ready),
		.test_length(test_length)
	);
	
	ram_top ram_top4(
		.CLOCK_50(CLOCK_50),
		.SW(SW),
		.HEX0(hex0[27:21]),
		.HEX1(hex1[27:21]),
		.HEX2(hex2[27:21]),
		.HEX3(hex3[27:21]),
		.HEX4(hex4[27:21]),
		.HEX5(hex5[27:21]),
		.clk_fast(clk_fast),
		.clk_slow_even(clk_slow_even),
		.clk_slow_odd(clk_slow_odd),
		.reset(reseta[3]),
		.next_frequency(next_frequencya[3]),
		.frequency(frequency),
		.freq_ready(freq_ready),
		.test_length(test_length)
	);
	

endmodule





module ram_top (
	input                 CLOCK_50,
	input         [17:0]  SW,
	output        [17:0]   LEDR,
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
	input 		  [19:0]	 test_length
	
);
	
	wire error_1, error_2;



	RAM_Controller RAM_Controller1(
		.clk_fast( clk_fast ),
		.clk_slow_even( clk_slow_even ),
		.clk_slow_odd( clk_slow_odd),
		.error_1( error_1 ),
		.error_2( error_2 )
	);

	assign LEDR[0] = error_1;
	assign LEDR[1] = error_2;
	
	localparam test_state = 2'd0;
	localparam cycle_freq_state = 2'd1;
	localparam wait_freq_state = 2'd2;
	localparam settle_clock = 2'd3;
	reg [1:0] state;
	
	reg counter_reset;
	reg [19:0] counter;
	reg capture_errors;
	
	reg [5:0] counter_2;
	reg pause_counter;
	
	always @ (posedge CLOCK_50) begin
		if(counter_reset) counter <= 20'd0;
		else if (pause_counter) counter <= counter;
		else counter <= counter + 20'd1;
	end
	
	
	always @ (posedge CLOCK_50) begin
		next_frequency <= 1'b0;
		reset <= 1'b0;
		capture_errors <= 1'b0;
		counter_2 <= counter_2;
		pause_counter <= 1'b0;
		
		if(SW[0]) begin
		
			state <= wait_freq_state;
			counter_reset <= 1'b1;
			reset <= 1'b1;
		end
		
		else begin
			case(state)
				test_state: begin
					if(counter >= test_length) state <= cycle_freq_state;
					else if(~freq_ready) begin
						state <= settle_clock;
						counter_2 <= 6'd0;
					end
					else state <= test_state;
					counter_reset <= 1'b0;
					if(freq_ready) capture_errors <= 1'b1;
					else capture_errors <= 1'b0;
				end
				cycle_freq_state: begin
					state <= wait_freq_state;
					next_frequency <= 1'b1;
					counter_reset <= 1'b1;
				end
				wait_freq_state: begin
					if(freq_ready && SW[1]) state <= test_state;
					else state <= wait_freq_state;
					counter_reset <= 1'b1;
				end
				settle_clock: begin
					if(freq_ready) counter_2 <= counter_2 + 6'd1;
					else counter_2 <= 6'd0;
					if(counter_2 >= 6'd32 && freq_ready) state <= test_state;
					else state <= settle_clock;
					pause_counter <= 1'b1;
				end
				default: begin
					state <= settle_clock;
					counter_reset <= 1'b1;
				end
			endcase
		
		end
	end
	
	reg[8:0] fail_freq;
	
	
	
	always @ (posedge CLOCK_50) begin
		if(SW[0]) fail_freq <= 9'd0;
		else if((error_1 || error_2) && fail_freq == 9'd0 && capture_errors) 
			fail_freq <= frequency;
		else fail_freq <= fail_freq;
	end  
	
	reg[10:0] fail_count;
	
	always @ (posedge error_1 or posedge SW[0]/*or posedge error_2*/) begin
		if(SW[0]) fail_count <= 11'b0;
		else if(capture_errors) fail_count <= fail_count+ 11'd1;
		else fail_count <= fail_count;
	end
	
	assign LEDR [17:7] = fail_count;
	
	hex_display hexa0 (frequency[3:0], HEX0);
	hex_display hexa1 (frequency[7:4], HEX1);
	hex_display hexa2 ({3'd0, frequency[8]}, HEX2);
	


	hex_display hexa3 (fail_freq[3:0], HEX3);
	hex_display hexa4 (fail_freq[7:4], HEX4);
	hex_display hexa5 ({3'd0, fail_freq[8]}, HEX5);
	
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
