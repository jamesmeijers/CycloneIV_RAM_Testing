#create_clock -name {clk} -period 6  [get_ports {SMA_CLKIN}]
create_clock -name {CLOCK_50} -period 20 -waveform { 0 5} [get_ports {CLOCK_50}]

create_generated_clock -name clk_fast -source [get_ports {CLOCK_50}] -divide_by 40 -multiply_by 480  [get_ports clk_fast]
create_generated_clock -name clk_slow_even -source [get_ports {clk_fast}] -divide_by 2  [get_ports clk_slow_even]
create_generated_clock -name clk_slow_odd -source [get_ports {clk_slow_even}] -divide_by 1  -phase 180 [get_ports clk_slow_odd]
#set_multicycle_path -from [get_cells {clock_gate_from_fsm*}] -setup -end 3
#set_multicycle_path -from [get_cells {clock_gate_from_fsm*}] -hold -end 2

#set_max_delay -to [get_cells -compatibility_mode *inst_mem\|in_fast*] 0.2
#set_max_delay -from [get_registers {all_mem_CDC:mem_and_testing0|memory_and_tester_with_cdc:mem[*].inst_mem|ram_1_port:memory|altsyncram:altsyncram_component|altsyncram_86i1:auto_generated|*}] -to [get_registers {all_mem_CDC:mem_and_testing0|memory_and_tester_with_cdc:mem[*].inst_mem|ram_1_port:memory|altsyncram:altsyncram_component|altsyncram_86i1:auto_generated|*}] 3.184

#derive_pll_clocks

