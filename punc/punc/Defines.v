//==============================================================================
// Global Defines for PUnC LC3 Computer
//==============================================================================

// Add defines here that you'll use in both the datapath and the controller

//------------------------------------------------------------------------------
// Opcodes
//------------------------------------------------------------------------------
`define OC 15:12       // Used to select opcode bits from the IR

`define OC_ADD 4'b0001 // Instruction-specific opcodes
`define OC_AND 4'b0101
`define OC_BR  4'b0000
`define OC_JMP 4'b1100
`define OC_JSR 4'b0100
`define OC_LD  4'b0010
`define OC_LDI 4'b1010
`define OC_LDR 4'b0110
`define OC_LEA 4'b1110
`define OC_NOT 4'b1001
`define OC_ST  4'b0011
`define OC_STI 4'b1011
`define OC_STR 4'b0111
`define OC_HLT 4'b1111

`define IMM_BIT_NUM 5  // Bit for distinguishing ADDR/ADDI and ANDR/ANDI
`define IS_IMM 1'b1
`define JSR_BIT_NUM 11 // Bit for distinguishing JSR/JSRR
`define IS_JSR 1'b1

`define BR_N 11        // Location of special bits in BR instruction
`define BR_Z 10
`define BR_P 9

// ALU Modes
`define ALU_FN_ADD   3'b000
`define ALU_FN_ADD_I 3'b001
`define ALU_FN_NOT   3'b010
`define ALU_FN_AND   3'b011
`define ALU_FN_AND_I 3'b100
`define ALU_FN_PASS  3'b101

// Register File
`define RF_R0_ADDR_SEL_A    1'b0 // ir[8-6]
`define RF_R0_ADDR_SEL_B    1'b1 // ir[11-9]
`define RF_R1_ADDR_SEL_A    1'b0 // ir[2-0]
`define RF_R1_ADDR_SEL_B    1'b1 // ir[8-6]
`define REG_A               2:0 // macros for IR bits
`define REG_B               8:6
`define REG_C              11:9
`define R7                  3'b111
`define RF_W_DATA_SEL_ALU   2'b00 
`define RF_W_DATA_SEL_MEM   2'b01
`define RF_W_DATA_SEL_PC    2'b10
`define RF_W_DATA_SEL_A     2'b11 // pc + sext_9
`define RF_W_ADDR_SEL_A     1'b0  // ir[11-9]
`define RF_W_ADDR_SEL_B     1'b1  // 111 (R7)

// Memory Module
`define MEM_W_DATA_SEL_RF   1'b0 // write data selects
`define MEM_W_DATA_SEL_MEM  1'b1
`define MEM_W_ADDR_SEL_A    1'b0 // pc + sext_9
`define MEM_W_ADDR_SEL_B    1'b1 // rf_1_data + sext_6
`define MEM_R_ADDR_SEL_PC   2'b00  
`define MEM_R_ADDR_SEL_A    2'b01 // pc + sext_9
`define MEM_R_ADDR_SEL_B    2'b10 // rf_r0_data + sext_6

// Program Counter
`define PC_LD_DATA_SEL_A    2'b00 // pc + sext_9
`define PC_LD_DATA_SEL_B    2'b01 // rf_r0_data (BaseR)
`define PC_LD_DATA_SEL_C    2'b10 // pc + sext_11

// Condition Code registers
`define COND_LD_DATA_SEL_ALU  1'b0 // alu_out
`define COND_LD_DATA_SEL_RF   1'b1 // rf_w_data


