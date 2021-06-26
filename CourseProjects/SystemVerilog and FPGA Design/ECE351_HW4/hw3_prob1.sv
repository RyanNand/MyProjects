///////////////////////////////////////////////////////////////////////////////////
// hw3_prob1.sv - 4-Bit Serial-In Parallel-Out Shift Register
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/22/2021
//
// Description: This module is a 4-bit shift register that takes in serial data
// 		and outputs in parallel with a universal clock and sync reset.
//              The value starts loading in the MSB shifting right toward the LSB.
//              The block diagram can be found in the hw3 pdf.
///////////////////////////////////////////////////////////////////////////////////
module hw3_prob1 (
  input logic serial_in, shift, clk, clr,  // Inputs
  output logic [3:0] Q                     // 4-bit parallel output
  );

always_ff @(posedge clk)
  if(clr) Q <= '0;      // If active high reset/clear
  else if(shift) begin  // If active high shift, then shift right
    Q[3] <= serial_in;  // Bring in new data bit from serial_in into Q3, the MSB
    Q[2] <= Q[3];       // Shift Q3 right to Q2
    Q[1] <= Q[2];       // Shift Q2 right to Q1
    Q[0] <= Q[1];       // Shift Q1 right to Q0, the LSB
  end
  else begin            // If neither above (!shift or !clr) retain all bits
    Q[3] <= Q[3];       // Don't shift
    Q[2] <= Q[2];       // Don't shift
    Q[1] <= Q[1];       // Don't shift
    Q[0] <= Q[0];       // Don't shift
  end
endmodule : hw3_prob1