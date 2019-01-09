//==============================================================================
// Memory with 2 read ports, 1 write port
//==============================================================================

module Memory
#(
	parameter N_ELEMENTS = 128,      // Number of Memory Elements
	parameter ADDR_WIDTH = 16,        // Address Width (in bits)
	parameter DATA_WIDTH = 16         // Data Width (in bits)
)(
	// Clock + Reset
	input                   clk,      // Clock
	input                   rst,      // Reset (All entries -> 0)

	// Read Address Channel
	input  [ADDR_WIDTH-1:0] r_addr_0, // Read Address 0
	input  [ADDR_WIDTH-1:0] r_addr_1, // Read Address 1

	// Write Address, Data Channel
	input  [ADDR_WIDTH-1:0] w_addr,   // Write Address
	input  [DATA_WIDTH-1:0] w_data,   // Write Data
	input                   w_en,     // Write Enable

	// Read Data Channel
	output [DATA_WIDTH-1:0] r_data_0, // Read Data 0
	output [DATA_WIDTH-1:0] r_data_1  // Read Data 1

);

	// Memory Unit
	reg [DATA_WIDTH-1:0] mem[N_ELEMENTS-1:0];


	//---------------------------------------------------------------------------
	// BEGIN MEMORY INITIALIZATION BLOCK
	//   - Paste the code you generate for memory initialization in synthesis
	//     here, deleting the current code.
	//   - Use the LC3 Assembler on Blackboard to generate your Verilog.
	//---------------------------------------------------------------------------
	localparam PROGRAM_LENGTH = 70;
	wire [DATA_WIDTH-1:0] mem_init[PROGRAM_LENGTH-1:0];

	assign mem_init[0] = 16'h203F;   // LD    R0, #63
	assign mem_init[1] = 16'h0C18;   // BRnz  #24
	assign mem_init[2] = 16'h223E;   // LD    R1, #62
	assign mem_init[3] = 16'h0C16;   // BRnz  #22
	assign mem_init[4] = 16'h243D;   // LD    R2, #61
	assign mem_init[5] = 16'h0C14;   // BRnz  #20
	assign mem_init[6] = 16'h1601;   // ADD   R3, R0, R1
	assign mem_init[7] = 16'h1842;   // ADD   R4, R1, R2
	assign mem_init[8] = 16'h1A02;   // ADD   R5, R0, R2
	assign mem_init[9] = 16'h9CBF;   // NOT   R6, R2
	assign mem_init[10] = 16'h1DA1;   // ADD   R6, R6, #1
	assign mem_init[11] = 16'h1D83;   // ADD   R6, R6, R3
	assign mem_init[12] = 16'h0C0D;   // BRnz  #13
	assign mem_init[13] = 16'h9C3F;   // NOT   R6, R0
	assign mem_init[14] = 16'h1DA1;   // ADD   R6, R6, #1
	assign mem_init[15] = 16'h1D84;   // ADD   R6, R6, R4
	assign mem_init[16] = 16'h0C09;   // BRnz  #9
	assign mem_init[17] = 16'h9C7F;   // NOT   R6, R1
	assign mem_init[18] = 16'h1DA1;   // ADD   R6, R6, #1
	assign mem_init[19] = 16'h1D85;   // ADD   R6, R6, R5
	assign mem_init[20] = 16'h0C05;   // BRnz  #5
	assign mem_init[21] = 16'h5020;   // AND   R0, R0, #0
	assign mem_init[22] = 16'h1021;   // ADD   R0, R0, #1
	assign mem_init[23] = 16'h3026;   // ST    R0, #38
	assign mem_init[24] = 16'hE004;   // LEA   R0, #4
	assign mem_init[25] = 16'hC000;   // JMP   R0
	assign mem_init[26] = 16'h5020;   // AND   R0, R0, #0
	assign mem_init[27] = 16'h103F;   // ADD   R0, R0, #-1
	assign mem_init[28] = 16'h3021;   // ST    R0, #33
	assign mem_init[29] = 16'h56E0;   // AND   R3, R3, #0
	assign mem_init[30] = 16'h5920;   // AND   R4, R4, #0
	assign mem_init[31] = 16'h5B60;   // AND   R5, R5, #0
	assign mem_init[32] = 16'hE622;   // LEA   R3, #34
	assign mem_init[33] = 16'h60C0;   // LDR   R0, R3, #0
	assign mem_init[34] = 16'h0C17;   // BRnz  #23
	assign mem_init[35] = 16'h62C1;   // LDR   R1, R3, #1
	assign mem_init[36] = 16'h0C15;   // BRnz  #21
	assign mem_init[37] = 16'h64C2;   // LDR   R2, R3, #2
	assign mem_init[38] = 16'h0C13;   // BRnz  #19
	assign mem_init[39] = 16'h1601;   // ADD   R3, R0, R1
	assign mem_init[40] = 16'h1842;   // ADD   R4, R1, R2
	assign mem_init[41] = 16'h1A02;   // ADD   R5, R0, R2
	assign mem_init[42] = 16'h9CBF;   // NOT   R6, R2
	assign mem_init[43] = 16'h1DA1;   // ADD   R6, R6, #1
	assign mem_init[44] = 16'h1D83;   // ADD   R6, R6, R3
	assign mem_init[45] = 16'h0C0C;   // BRnz  #12
	assign mem_init[46] = 16'h9C3F;   // NOT   R6, R0
	assign mem_init[47] = 16'h1DA1;   // ADD   R6, R6, #1
	assign mem_init[48] = 16'h1D84;   // ADD   R6, R6, R4
	assign mem_init[49] = 16'h0C08;   // BRnz  #8
	assign mem_init[50] = 16'h9C7F;   // NOT   R6, R1
	assign mem_init[51] = 16'h1DA1;   // ADD   R6, R6, #1
	assign mem_init[52] = 16'h1D85;   // ADD   R6, R6, R5
	assign mem_init[53] = 16'h0C04;   // BRnz  #4
	assign mem_init[54] = 16'h5020;   // AND   R0, R0, #0
	assign mem_init[55] = 16'h1021;   // ADD   R0, R0, #1
	assign mem_init[56] = 16'h3006;   // ST    R0, #6
	assign mem_init[57] = 16'hF000;   // HALT
	assign mem_init[58] = 16'h5020;   // AND   R0, R0, #0
	assign mem_init[59] = 16'h103F;   // ADD   R0, R0, #-1
	assign mem_init[60] = 16'h3002;   // ST    R0, #2
	assign mem_init[61] = 16'hF000;   // HALT
	assign mem_init[62] = 16'h0000;   // 0000
	assign mem_init[63] = 16'h0000;   // 0000
	assign mem_init[64] = 16'h0003;   // 0003
	assign mem_init[65] = 16'h0004;   // 0004
	assign mem_init[66] = 16'h0001;   // 0001
	assign mem_init[67] = 16'h0005;   // 0005
	assign mem_init[68] = 16'h0008;   // 0008
	assign mem_init[69] = 16'h000C;   // 000C

	//---------------------------------------------------------------------------
	// END MEMORY INITIALIZATION BLOCK
	//---------------------------------------------------------------------------

	// Continuous Read
	assign r_data_0 = mem[r_addr_0];
	assign r_data_1 = mem[r_addr_1];

	// Synchronous Reset + Write
	genvar i;
	generate
		for (i = 0; i < N_ELEMENTS; i = i + 1) begin : wport
			always @(posedge clk) begin
				if (rst) begin
					if (i < PROGRAM_LENGTH) begin
						`ifndef SIM
							mem[i] <= mem_init[i];
						`endif
					end
					else begin
						`ifndef SIM
							mem[i] <= 0;
						`endif
					end
				end
				else if (w_en && w_addr == i) begin
					mem[i] <= w_data;
				end
			end
		end
	endgenerate

endmodule
