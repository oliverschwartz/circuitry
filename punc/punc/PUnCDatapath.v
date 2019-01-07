//==============================================================================
// Datapath for PUnC LC3 Processor
//==============================================================================

`include "Memory.v"
`include "RegisterFile.v"
`include "Defines.v"

module PUnCDatapath(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset

	// DEBUG Signals
	input  wire [15:0] mem_debug_addr,
	input  wire [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data,

	// Memory controls
	input wire mem_w_en, 
	
	// Register file controls
	input wire rf_w_en,
	input wire [1:0] rf_w_data_sel,
	input wire rf_r0_addr_sel,
	input wire rf_r1_addr_sel, 

	// Instruction register controls
	input wire ir_ld, 

	// Program counter controls
	input wire pc_ld,
	input wire pc_clr,
	input wire pc_inc,

	// ALU controls
	input wire [1:0] alu_sel,

	// Output signals to control
	output reg [15:0] ir
);

	// Local Registers
	reg  [15:0] pc;
	reg  [15:0] ir;

	// Memory read/write channels
	wire [15:0] mem_w_addr;
	wire [15:0] mem_w_data;
	wire [15:0] mem_r_addr;
	wire [15:0] mem_r_data;

	// Register file read/write channels
	wire [2:0]  rf_w_addr;
	wire [15:0] rf_w_data;
	wire [15:0] rf_r0_data;
	wire [15:0] rf_r1_data;
	wire [2:0]  rf_r0_addr;
	wire [2:0]  rf_r1_addr;

	// Assign PC debug net
	assign pc_debug_data = pc;

	// ALU wires
	wire [15:0] alu_out;

	//----------------------------------------------------------------------
	// Memory Module
	//----------------------------------------------------------------------

	// 1024-entry 16-bit memory (connect other ports)
	Memory mem(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (mem_r_addr),
		.r_addr_1 (mem_debug_addr),
		.w_addr   (mem_w_addr),
		.w_data   (mem_w_data),
		.w_en     (mem_w_en),
		.r_data_0 (mem_r_data),
		.r_data_1 (mem_debug_data)
	);

	//----------------------------------------------------------------------
	// Register File Module
	//----------------------------------------------------------------------

	assign rf_r0_addr = (rf_r0_addr_sel == `RF_R0_ADDR_SEL_A) ? ir[`REG_B]:
						(rf_r0_addr_sel == `RF_R0_ADDR_SEL_B) ? ir[`REG_C];
	assign rf_r1_addr = (rf_r1_addr_sel == `RF_R1_ADDR_SEL_A) ? ir[`REG_A]:
						(rf_r1_addr_sel == `RF_R1_ADDR_SEL_B) ? ir[`REG_B];

	assign rf_w_data = (rf_w_data_sel == `RF_W_DATA_SEL_ALU) ? alu_out:
					   (rf_w_data_sel == `RF_W_DATA_SEL_MEM) ? mem_r_data:
					   (rf_w_data_sel == `RF_W_DATA_SEL_PC) ? pc;

	// 8-entry 16-bit register file (connect other ports)
	RegisterFile rfile(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (rf_r0_addr),
		.r_addr_1 (rf_r1_addr),
		.r_addr_2 (rf_debug_addr),
		.w_addr   (rf_w_addr),
		.w_data   (rf_w_data),
		.w_en     (rf_w_en),
		.r_data_0 (rf_r0_data),
		.r_data_1 (rf_r1_data),
		.r_data_2 (rf_debug_data)
	);

	//----------------------------------------------------------------------
	// Instruction register
	//----------------------------------------------------------------------
	always @(posedge clk) begin
		if (rst) begin
			ir <= 16'd0;
		end
		else if (ir_ld) begin
			ir <= mem_r_data;
		end
	end

	//----------------------------------------------------------------------
	// Program Counter
	//----------------------------------------------------------------------

	always @(posedge clk) begin
		if (pc_clr) begin
			pc <= 16'd0;
		end
		else if (pc_ld) begin
			pc <= pc + ir[`OFFSET] - 16'd1;
		end
		else if (pc_inc) begin
			pc <= pc + 16'd1;
		end
	end

	//----------------------------------------------------------------------
	// ALU
	//----------------------------------------------------------------------
	assign alu_out = (alu_sel == `ALU_FN_ADD) ? (rf_r0_data + rf_r1_data) :
	                 (alu_sel == `ALU_FN_NOT) ? (~rf_r0_data) :
					 (alu_sel == `ALU_FN_AND) ? (rf_r0_data & rf_r1_data) :
					 (alu_sel == `ALU_FN_PASS) ? rf_r0_data

endmodule
