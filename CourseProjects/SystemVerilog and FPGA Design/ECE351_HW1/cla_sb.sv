////////////////////////////////////////////////////////////////////////////////
// cla_sb.sv - Single bit CLA (carry look-ahead adder)
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 04/26/2021
//
// Description: This module is a single bit adder module for the CLA.
////////////////////////////////////////////////////////////////////////////////
module cla_sb (
	input logic A, B, Cin,	// a, b, and carry_in inputs
	output logic S, Cout	// sum and carry out outputs 
);

timeunit 1ns/1ns;

always_comb
  begin : single_adder
    bit P, G;
    S = A ^ B ^ Cin;
    P = A ^ B;
    G = A & B;
    Cout = Cin & P | G;
  end : single_adder

endmodule : cla_sb

