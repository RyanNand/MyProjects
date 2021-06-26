////////////////////////////////////////////////////////////////////////////////
// hw2_prob3_dut.sv - ALU DUT 
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/10/2021
//
// Description: This module puts together the ALU and the register file to make
// the DUT.  
////////////////////////////////////////////////////////////////////////////////
module hw2_prob3_dut
import ALU_REGFILE_defs::*;
(

  // Register file interface
  input logic [REGFILE_ADDR_WIDTH-1:0]    Read_Addr_1, Read_Addr_2, // Read port addresses
  input logic [REGFILE_ADDR_WIDTH-1:0]    Write_Addr,               // Write port addresses
  input logic                             Write_enable,             // Write enable (1 to write)
  input logic [REGFILE_WIDTH-1:0]         Write_data,               // Data to write into the register file

  // ALU interface. Data to the ALU comes form the register file.
  input logic                             Carry_In,                 // Carry in
  input aluop_t                           Opcode,                   // Operation to perform
  output logic [ALU_OUTPUT_WIDTH-1:0]     ALU_Out,                  // ALU result

  // System-wide signal
  input logic                             Clock                     // System clock

);

// Internal variables
logic [15:0] data_out_1, data_out_2;

// Instantiate the ALU and register file
register_file rf1(.Data_Out_1(data_out_1), .Data_Out_2(data_out_2), .Data_In(Write_data), .*);
hw2_prob3_alu alu1(.A_In(data_out_1), .B_In(data_out_2), .*);

endmodule : hw2_prob3_dut