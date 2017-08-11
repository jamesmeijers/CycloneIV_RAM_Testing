This git contains various applications for testing RAM on a Cyclone IV FPGA included in a DE2-115 board. 

There are four Quartus projects with a lot of repeated code. Comments are not repeated in repeated code.
For the most detailed information, look at the comments in the num_failures project folder. 
The failure_address project folder has more detailed comments for the address reporting application. 

All tests use an 8x1024 RAM

Data from the UART can be read using the CoolTerm program, the de2.stc file contains the required settings. To parse the data
you must capture the results to a text file, available as an option in CoolTerm. 

The Quartus Projects are as follows:
num_failures: cycles through frequencies from 125 -> ~600 MHz incrementing by 1.25 MHz
		Samples RAM read errors at each speed at a rate of 50 MHz for 2^14 cycles
		Samples 2 tests per cycle so actually samples 2^15 times
		After testing each frequency, outputs through RS-232 UART the number of errors found
		Before reporting the failures, it outputs 00 to represent a cycle of the frequency

		The results of this test as captured by Coolterm using the de2.stc file can be converted
		to space delimated values by num_failures_data_parser.cpp, the program requires the HEX txt file
		and desired output file as inputs

num_failures_multi: Same as num failures, but the tester is replicated accross the board on 24 different RAMs
		The RAM on which the tester is currently run can be selected using SW[17:13] on the DE2 board
		When the switches are selected and reset is done, it behaves exactly as num_failures

		When captured seperately for the different RAMs the results can be processed by the same cpp program

failure_address: cycles throught frequencies the same as num_failures
		instead of counting failures, failures and their addresses are latched and sent through the UART
		each frequency is tested for ~400000 cycles (testing is paused while data is being sent)
		this means that once failures start happening, the tester takes awhile to cycle
		A new frequency is signalled by sending 01111111
		One or two errors being sent is signalled by sending 01000000
		Each error is sent in two parts, the first contains the lower 5 bits, the second the upper 5 bits

		The results of this test can be parsed by address_failure_data_parser.cpp. The program takes the 
		name of the HEX txt file produced by CoolTerm and the names of two output files. Each output file 
		containes space and newline delimated values in an 8x128 array, each value representing one word. 
		One file contains the initial frequency of failure of the byte. The other file contains the total
		number of failures counted for the byte. 

failure_address_multi: Is to failure_address as num_failures_multi is to num_failures


In my testing some results were as follows:
	RAMs started failing around 520 MHz
	BRAM location had a large effect on speed (up to 20MHz of difference)
	The words written to the RAM have a large effect on speed as well (1111111 was about 5MHz slower than 00000000)
	The location of a word within the RAM has a relatively small effect on the the speed (up to 5MHz but usually only 2.5MHz)
	There did not appear to be significant or consistent spatial correlation of failures
	The tester ran mostly reliably but would occassionally would report errors way too early. I believe this is a timing 
	issue with the PLL or could also be a write issue or read disturb issue. I am unsure. 
