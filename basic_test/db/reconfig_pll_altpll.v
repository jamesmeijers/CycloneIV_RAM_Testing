//altpll c0_high=5 c0_initial=1 c0_low=5 c0_mode="EVEN" c0_ph=0 c1_high=10 c1_initial=1 c1_low=10 c1_mode="EVEN" c1_ph=0 c2_high=10 c2_initial=11 c2_low=10 c2_mode="EVEN" c2_ph=0 CBX_DECLARE_ALL_CONNECTED_PORTS="OFF" charge_pump_current_bits=1 clk0_counter="C0" clk1_counter="C1" clk2_counter="C2" compensate_clock="CLK0" device_family="Cyclone IV E" inclk0_input_frequency=20000 intended_device_family="Cyclone IV E" loop_filter_c_bits=0 loop_filter_r_bits=19 lpm_hint="CBX_MODULE_PREFIX=reconfig_pll" m=101 m_initial=1 m_ph=0 n=5 operation_mode="normal" pll_type="AUTO" port_clk0="PORT_USED" port_clk1="PORT_USED" port_clk2="PORT_USED" port_clk3="PORT_UNUSED" port_clk4="PORT_UNUSED" port_clk5="PORT_UNUSED" port_extclk0="PORT_UNUSED" port_extclk1="PORT_UNUSED" port_extclk2="PORT_UNUSED" port_extclk3="PORT_UNUSED" port_inclk1="PORT_UNUSED" port_phasecounterselect="PORT_UNUSED" port_phasedone="PORT_UNUSED" port_scandata="PORT_USED" port_scandataout="PORT_USED" scan_chain_mif_file="reconfig_pll.mif" self_reset_on_loss_lock="OFF" vco_post_scale=1 width_clock=5 areset clk configupdate inclk locked scanclk scanclkena scandata scandataout scandone CARRY_CHAIN="MANUAL" CARRY_CHAIN_LENGTH=48
//VERSION_BEGIN 15.1 cbx_altclkbuf 2015:10:14:18:59:15:SJ cbx_altiobuf_bidir 2015:10:14:18:59:15:SJ cbx_altiobuf_in 2015:10:14:18:59:15:SJ cbx_altiobuf_out 2015:10:14:18:59:15:SJ cbx_altpll 2015:10:14:18:59:15:SJ cbx_cycloneii 2015:10:14:18:59:15:SJ cbx_lpm_add_sub 2015:10:14:18:59:15:SJ cbx_lpm_compare 2015:10:14:18:59:15:SJ cbx_lpm_counter 2015:10:14:18:59:15:SJ cbx_lpm_decode 2015:10:14:18:59:15:SJ cbx_lpm_mux 2015:10:14:18:59:15:SJ cbx_mgl 2015:10:21:19:02:34:SJ cbx_nadder 2015:10:14:18:59:15:SJ cbx_stratix 2015:10:14:18:59:15:SJ cbx_stratixii 2015:10:14:18:59:15:SJ cbx_stratixiii 2015:10:14:18:59:15:SJ cbx_stratixv 2015:10:14:18:59:15:SJ cbx_util_mgl 2015:10:14:18:59:15:SJ  VERSION_END
//CBXI_INSTANCE_NAME="top_pll_pll1_reconfig_pll_pll1_altpll_altpll_component"
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus Prime License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = cycloneive_pll 1 reg 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
(* ALTERA_ATTRIBUTE = {"SUPPRESS_DA_RULE_INTERNAL=C104;SUPPRESS_DA_RULE_INTERNAL=R101"} *)
module  reconfig_pll_altpll
	( 
	areset,
	clk,
	configupdate,
	inclk,
	locked,
	scanclk,
	scanclkena,
	scandata,
	scandataout,
	scandone) /* synthesis synthesis_clearbox=1 */;
	input   areset;
	output   [4:0]  clk;
	input   configupdate;
	input   [1:0]  inclk;
	output   locked;
	input   scanclk;
	input   scanclkena;
	input   scandata;
	output   scandataout;
	output   scandone;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0   areset;
	tri0   configupdate;
	tri0   [1:0]  inclk;
	tri0   scanclk;
	tri1   scanclkena;
	tri0   scandata;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	reg	pll_lock_sync;
	wire  [4:0]   wire_pll1_clk;
	wire  wire_pll1_fbout;
	wire  wire_pll1_locked;
	wire  wire_pll1_scandataout;
	wire  wire_pll1_scandone;

	// synopsys translate_off
	initial
		pll_lock_sync = 0;
	// synopsys translate_on
	always @ ( posedge wire_pll1_locked or  posedge areset)
		if (areset == 1'b1) pll_lock_sync <= 1'b0;
		else  pll_lock_sync <= 1'b1;
	cycloneive_pll   pll1
	( 
	.activeclock(),
	.areset(areset),
	.clk(wire_pll1_clk),
	.clkbad(),
	.configupdate(configupdate),
	.fbin(wire_pll1_fbout),
	.fbout(wire_pll1_fbout),
	.inclk(inclk),
	.locked(wire_pll1_locked),
	.phasedone(),
	.scanclk(scanclk),
	.scanclkena(scanclkena),
	.scandata(scandata),
	.scandataout(wire_pll1_scandataout),
	.scandone(wire_pll1_scandone),
	.vcooverrange(),
	.vcounderrange()
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.clkswitch(1'b0),
	.pfdena(1'b1),
	.phasecounterselect({3{1'b0}}),
	.phasestep(1'b0),
	.phaseupdown(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		pll1.c0_high = 5,
		pll1.c0_initial = 1,
		pll1.c0_low = 5,
		pll1.c0_mode = "even",
		pll1.c0_ph = 0,
		pll1.c1_high = 10,
		pll1.c1_initial = 1,
		pll1.c1_low = 10,
		pll1.c1_mode = "even",
		pll1.c1_ph = 0,
		pll1.c2_high = 10,
		pll1.c2_initial = 11,
		pll1.c2_low = 10,
		pll1.c2_mode = "even",
		pll1.c2_ph = 0,
		pll1.charge_pump_current_bits = 1,
		pll1.clk0_counter = "c0",
		pll1.clk1_counter = "c1",
		pll1.clk2_counter = "c2",
		pll1.compensate_clock = "clk0",
		pll1.inclk0_input_frequency = 20000,
		pll1.loop_filter_c_bits = 0,
		pll1.loop_filter_r_bits = 19,
		pll1.m = 101,
		pll1.m_initial = 1,
		pll1.m_ph = 0,
		pll1.n = 5,
		pll1.operation_mode = "normal",
		pll1.pll_type = "auto",
		pll1.scan_chain_mif_file = "reconfig_pll.mif",
		pll1.self_reset_on_loss_lock = "off",
		pll1.vco_post_scale = 1,
		pll1.lpm_type = "cycloneive_pll";
	assign
		clk = {wire_pll1_clk[4:0]},
		locked = (wire_pll1_locked & pll_lock_sync),
		scandataout = wire_pll1_scandataout,
		scandone = wire_pll1_scandone;
endmodule //reconfig_pll_altpll
//VALID FILE
