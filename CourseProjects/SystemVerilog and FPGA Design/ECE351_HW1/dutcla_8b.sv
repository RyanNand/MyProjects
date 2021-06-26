////////////////////////////////////////////////////////////////////////////////
// dutcla_8b.sv - 8-bit CLA (carry look-ahead adder)
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 04/26/2021
//
// Description: This module takes the 4-bit adder from dutcla_4b.sv and 
// utilizies it to create a 8-bit CLA
////////////////////////////////////////////////////////////////////////////////
module dutcla_8b (
	input logic [7:0] ain, bin, 
	input logic cin,	// a, b, and carry_in inputs
	output logic [7:0] sum, 
	output logic cout	// sum and carry out outputs 
);

timeunit 1ns/1ns;

// Internal nets
logic c0;

dutcla_4b cla_4b0(.ain(ain[3:0]), .bin(bin[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c0));
dutcla_4b cla_4b1(.ain(ain[7:4]), .bin(bin[7:4]), .cin(c0), .sum(sum[7:4]), .cout(cout));

endmodule : dutcla_8b