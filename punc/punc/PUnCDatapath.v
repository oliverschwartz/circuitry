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
	input wire mem_w_addr_sel,
	input wire mem_w_data_sel,
	input wire [1:0] mem_r_addr_sel,
	
	// Register file controls
	input wire rf_w_en,
	input wire rf_r0_addr_sel,
	input wire rf_r1_addr_sel,
	input wire [1:0] rf_w_data_sel,
	input wire rf_w_addr_sel,

	// Instruction register controls
	input wire ir_ld, 

	// Program counter controls
	input wire pc_ld,
	input wire pc_clr,
	input wire pc_inc,
	input wire [1:0] pc_ld_data_sel,

	// ALU controls
	input wire [2:0] alu_sel,

	// Condition code signals
	input wire cond_ld,
	input wire cond_ld_data_sel,

	// Output signals to control
	output reg [15:0] ir,
	output reg n, // condition code registers
	output reg p,
	output reg z
);

	// Local Registers
	reg  [15:0] pc;

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

	// PC load data
	wire [15:0] pc_ld_data;

	// Condition code data
	wire [15:0] cond_data;

	// Sign extension module
	wire [15:0] sext_11;
	wire [15:0] sext_9;
	wire [15:0] sext_6;
	wire [15:0] sext_5;

	// Sign Extension Module
	assign sext_11 = {{5{ir[10]}}, ir[10:0]};
	assign sext_9  = {{7{ir[8]}}, ir[8:0]};
	assign sext_6  = {{10{ir[5]}}, ir[5:0]};
	assign sext_5  = {{11{ir[4]}}, ir[4:0]};

	//----------------------------------------------------------------------
	// Memory Module
	//----------------------------------------------------------------------

	assign mem_w_data = (mem_w_data_sel == `MEM_W_DATA_SEL_RF)  ? rf_r0_data:
	                    (mem_w_data_sel == `MEM_W_DATA_SEL_MEM) ? mem_r_data:
						16'd0;

	assign mem_w_addr = (mem_w_addr_sel == `MEM_W_ADDR_SEL_A) ? pc + sext_9:
						(mem_w_addr_sel == `MEM_W_ADDR_SEL_B) ? rf_r1_data + sext_6:
						16'd0;

	assign mem_r_addr = (mem_r_addr_sel == `MEM_R_ADDR_SEL_PC) ? pc:
						(mem_r_addr_sel == `MEM_R_ADDR_SEL_A)  ? pc + sext_9:
						(mem_r_addr_sel == `MEM_R_ADDR_SEL_B)  ? rf_r0_data + sext_6:
						16'd0;

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
						(rf_r0_addr_sel == `RF_R0_ADDR_SEL_B) ? ir[`REG_C]:
						3'd0;

	assign rf_r1_addr = (rf_r1_addr_sel == `RF_R1_ADDR_SEL_A) ? ir[`REG_A]:
						(rf_r1_addr_sel == `RF_R1_ADDR_SEL_B) ? ir[`REG_B]:
						3'd0;

	assign rf_w_data = (rf_w_data_sel == `RF_W_DATA_SEL_ALU) ? alu_out:
					   (rf_w_data_sel == `RF_W_DATA_SEL_MEM) ? mem_r_data:
					   (rf_w_data_sel == `RF_W_DATA_SEL_PC) ? pc:
					   (rf_w_data_sel == `RF_W_DATA_SEL_A) ? pc + sext_9:
					   16'd0;

	assign rf_w_addr = (rf_w_addr_sel == `RF_W_ADDR_SEL_A) ? ir[`REG_C]:
					   (rf_w_addr_sel == `RF_W_ADDR_SEL_B) ? `R7:
					   3'd0;

	assign rf_w_data = (rf_w_data_sel == `RF_W_DATA_SEL_ALU) ? alu_out:
					   (rf_w_data_sel == `RF_W_DATA_SEL_MEM) ? mem_r_data:
					   (rf_w_data_sel == `RF_W_DATA_SEL_PC) ? pc:
					   (rf_w_data_sel == `RF_W_DATA_SEL_A) ? pc + sext_9:
					   16'd0;

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

	assign pc_ld_data = (pc_ld_data_sel == `PC_LD_DATA_SEL_A) ? pc + sext_9:
						(pc_ld_data_sel == `PC_LD_DATA_SEL_B) ? rf_r0_data:
						(pc_ld_data_sel == `PC_LD_DATA_SEL_C) ? pc + sext_11:
						16'd0;

	always @(posedge clk) begin
		if (pc_clr) begin
			pc <= 16'd0;
		end
		else if (pc_ld) begin
			pc <= pc + pc_ld_data - 16'd1;
		end
		else if (pc_inc) begin
			pc <= pc + 16'd1;
		end
	end

	//----------------------------------------------------------------------
	// ALU
	//----------------------------------------------------------------------
	assign alu_out = (alu_sel == `ALU_FN_ADD) ? (rf_r0_data + rf_r1_data) :
					 (alu_sel == `ALU_FN_ADD_I) ? (rf_r0_data + sext_5) :
	                 (alu_sel == `ALU_FN_NOT) ? (~rf_r0_data) :
					 (alu_sel == `ALU_FN_AND) ? (rf_r0_data & rf_r1_data) :
					 (alu_sel == `ALU_FN_AND_I) ? (rf_r0_data + sext_5) :
					 (alu_sel == `ALU_FN_PASS) ? rf_r0_data:
					 16'd0;

	//----------------------------------------------------------------------
	// Condition code registers
	//----------------------------------------------------------------------
	// condition code can test: alu_out OR rf_w_data
	assign cond_data = (cond_ld_data_sel == `COND_LD_DATA_SEL_ALU) ? alu_out:
					   (cond_ld_data_sel == `COND_LD_DATA_SEL_RF)  ? rf_w_data:
					   16'd0;
	
	always @(posedge clk) begin
		if (rst) begin
			n <= 1'b0;
			p <= 1'b0;
			z <= 1'b0;
		end
		else if (cond_ld) begin
			p <= (cond_data > 16'b0);
			n <= (cond_data < 16'b0);
			z <= (cond_data == 16'b0);
		end		
	end


endmodule
