////////////////////////////////////////////////////////////////////////////////
// hw2_prob2.sv - More Random Combinational Logic
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/10/2021
//
// Description: This module models the logic circuit in problem two of homework  
// two. Must use an always_comb procedural statement.
////////////////////////////////////////////////////////////////////////////////
module hw2_prob2 (

input logic in1, in2, in3, in4, in5, enableN,  // Inputs for combinational logic circuit
output logic tri_outN                          // The output for the combinational logic circuit

);

timeunit 1ns/1ns;                              // Specify the time unit and time precision

logic n3;                                      // Internal connections

always_comb
  begin : comb_logic
    logic n1, n2;                              // Internal connections
    n1 = in1 & in2;                            // AND gate AND'ing inputs in1 and in2
    n2 = in3 & in4 & in5;                      // AND gate AND'ing inputs in3, in4, and in5
    n3 = n1 ^ n2;                              // EXOR gate EXOR'ing n1 and n2
end : comb_logic

assign tri_outN = enableN ? 1'bz : ~n3;        // Tri-state buffer with active low enable at the output

endmodule : hw2_prob2