////////////////////////////////////////////////////////////////////////////////
// hw2_prob3_alu.sv - ALU model 
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/10/2021
//
// Description: This module models the ALU from problem three of homework three.
// 
////////////////////////////////////////////////////////////////////////////////
module hw2_prob3_alu
import ALU_REGFILE_defs::*;                          // Import package
(

  input logic [ALU_INPUT_WIDTH-1:0] A_In, B_In,      // A and B operands
  input logic Carry_In,				     // Carry In
  input aluop_t Opcode,				     // Operation to perform
  output logic [ALU_OUTPUT_WIDTH-1:0] ALU_Out	     // ALU result (extended by 1 bit to preserve Carry_out from Sum/Diff)

);

always_comb begin : what_operation
  case(Opcode)                                       // Case statement for opcode indicating which expression to perform
    ADD_OP   :  ALU_Out = A_In + B_In + Carry_In;    // Add with carry
    SUB_OP   :  ALU_Out = A_In + ~B_In + Carry_In;   // Subtract with add carry
    SUBA_OP  :  ALU_Out = B_In + ~A_In + ~Carry_In;  // Subtract both operand and carry
    ORAB_OP  :  ALU_Out = {1'b0, A_In | B_In};       // OR inputs
    ANDAB_OP :  ALU_Out = {1'b0, A_In & B_In};       // AND inputs
    NOTAB_OP :  ALU_Out = {1'b0, (~A_In) & B_In};    // NOT inputs
    EXOR_OP  :  ALU_Out = {1'b0, A_In ^ B_In};       // EXOR inputs
    EXNOR_OP :  ALU_Out = {1'b0, A_In ~^ B_In};      // EXNOR inputs
  endcase
end : what_operation
endmodule