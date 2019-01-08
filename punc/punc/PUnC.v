//==============================================================================
// Module for PUnC LC3 Processor
//==============================================================================

`include "PUnCDatapath.v"
`include "PUnCControl.v"

module PUnC(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset

	// Debug Signals
	input  wire [15:0] mem_debug_addr,
	input  wire [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data
);

	//----------------------------------------------------------------------
	// Interconnect Wires
	//----------------------------------------------------------------------

	// Inputs from datapath
	wire [15:0] ir;
	wire p;
	wire n;
	wire z;

	// Memory controls
	wire mem_w_en;
	wire [1:0] mem_w_addr_sel;
	wire mem_w_data_sel;
	wire [1:0] mem_r_addr_sel;

	// Register file controls
	wire rf_w_en;
	wire rf_r0_addr_sel;
	wire rf_r1_addr_sel;
	wire [1:0] rf_w_data_sel;
	wire rf_w_addr_sel;

	// Instruction register controls
	wire ir_ld;

	// Program counter controls
	wire pc_ld;
	wire pc_clr;
	wire pc_inc;
	wire [1:0] pc_ld_data_sel;

	// ALU controls
	wire [2:0] alu_sel;
  
	// Condition code controls
	wire cond_ld;
	wire cond_ld_data_sel;

	// LDI controls
	wire ldi_reg_ld;

	//----------------------------------------------------------------------
	// Control Module
	//----------------------------------------------------------------------
	PUnCControl ctrl(
		.clk             (clk),
		.rst             (rst),

		.ir (ir),
		.p (p),
		.n (n),
		.z (z),

		.mem_w_en (mem_w_en),
		.mem_w_addr_sel (mem_w_addr_sel),
		.mem_w_data_sel (mem_w_data_sel),
		.mem_r_addr_sel (mem_r_addr_sel),

		.rf_w_en (rf_w_en),
		.rf_r0_addr_sel (rf_r0_addr_sel),
		.rf_r1_addr_sel (rf_r1_addr_sel),
		.rf_w_data_sel (rf_w_data_sel),
		.rf_w_addr_sel (rf_w_addr_sel),

		.ir_ld (ir_ld),

		.pc_ld (pc_ld),
		.pc_clr (pc_clr),
		.pc_inc (pc_inc),
		.pc_ld_data_sel (pc_ld_data_sel),

		.alu_sel (alu_sel),

		.cond_ld (cond_ld),
		.cond_ld_data_sel (cond_ld_data_sel),

		.ldi_reg_ld (ldi_reg_ld)
	);

	//----------------------------------------------------------------------
	// Datapath Module
	//----------------------------------------------------------------------
	PUnCDatapath dpath(
		.clk             (clk),
		.rst             (rst),

		.mem_debug_addr   (mem_debug_addr),
		.rf_debug_addr    (rf_debug_addr),
		.mem_debug_data   (mem_debug_data),
		.rf_debug_data    (rf_debug_data),
		.pc_debug_data    (pc_debug_data),

		.ir (ir),
		.p (p),
		.n (n),
		.z (z),

		.mem_w_en (mem_w_en),
		.mem_w_addr_sel (mem_w_addr_sel),
		.mem_w_data_sel (mem_w_data_sel),
		.mem_r_addr_sel (mem_r_addr_sel),

		.rf_w_en (rf_w_en),
		.rf_r0_addr_sel (rf_r0_addr_sel),
		.rf_r1_addr_sel (rf_r1_addr_sel),
		.rf_w_data_sel (rf_w_data_sel),
		.rf_w_addr_sel (rf_w_addr_sel),

		.ir_ld (ir_ld),

		.pc_ld (pc_ld),
		.pc_clr (pc_clr),
		.pc_inc (pc_inc),
		.pc_ld_data_sel (pc_ld_data_sel),

		.alu_sel (alu_sel),

		.cond_ld (cond_ld),
		.cond_ld_data_sel (cond_ld_data_sel),

		.ldi_reg_ld (ldi_reg_ld)
	);

endmodule
