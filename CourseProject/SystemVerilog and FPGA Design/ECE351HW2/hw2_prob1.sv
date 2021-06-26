////////////////////////////////////////////////////////////////////////////////
// hw2_prob1.sv - Random Combinational Logic
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/10/2021
//
// Description: This module models combinational logic following the logic 
// in problem one of homework 2. Must use continuous assign statements.
////////////////////////////////////////////////////////////////////////////////
module hw2_prob1 (
  input logic A, B, C, D,  // Inputs for the combinational logic circuit
  output logic Y           // Output for the combinational logic circuit
);

timeunit 1ns/1ns;          // Specify time unit and time precision

logic n1, n2, n3, n4;      // Internal variables and connections

assign n1 = A | D;         // OR gate OR'ing inputs A and D
assign n2 = ~n1;           // Inverter inverting n1
assign n3 = ~D;            // Inverter inverting input D
assign n4 = B & C & n3;    // AND gate AND'ing inputs B, C, and n3
assign Y = n2 & n4;        // AND gate AND'ing n2 and n4 forming the final output

endmodule : hw2_prob1