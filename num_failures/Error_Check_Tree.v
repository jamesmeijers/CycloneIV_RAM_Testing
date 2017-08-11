//The error check tree compares the inputted read with the expected value
//Starts by XOR'ing all the bits to confirm they are the same
//Then OR's the results over several cycles to see if any bits are different
//outputs the result

module error_check_tree (
	input clk,
	input [7:0] read,
	input [7:0] expected,
	output error
);
	reg [3:0] errors_one;
	reg [1:0] errors_two;
	reg total_error;
	assign error = total_error;

	always @(posedge clk) begin
		errors_one[0] <= (read[0] ^ expected[0]) | (read[1] ^ expected[1]);
		errors_one[1] <= (read[2] ^ expected[2]) | (read[3] ^ expected[3]);
		errors_one[2] <= (read[4] ^ expected[4]) | (read[5] ^ expected[5]);
		errors_one[3] <= (read[6] ^ expected[6]) | (read[7] ^ expected[7]);
		errors_two[0] <= errors_one[0] | errors_one[1];
		errors_two[1] <= errors_one[2] | errors_one[3];
		total_error <= errors_two[0] | errors_two[1];
	end

endmodule
