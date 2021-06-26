////////////////////////////////////////////////////////////////////////////////
// dutcla_4b.sv - 4-bit CLA (carry look-ahead adder)
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 04/26/2021
//
// Description: This module takes the single bit adder from cla_sb.sv and 
// utilizies it to create a 4-bit CLA
////////////////////////////////////////////////////////////////////////////////
module dutcla_4b (
	input logic [3:0] ain, bin, 
	input logic cin,	// a, b, and carry_in inputs
	output logic [3:0] sum, 
	output logic cout	// sum and carry out outputs 
);

timeunit 1ns/1ns;

// Internal nets
logic c1, c2, c3;

cla_sb cla0(.A(ain[0]), .B(bin[0]), .Cin(cin), .S(sum[0]), .Cout(c1));
cla_sb cla1(.A(ain[1]), .B(bin[1]), .Cin(c1), .S(sum[1]), .Cout(c2));
cla_sb cla2(.A(ain[2]), .B(bin[2]), .Cin(c2), .S(sum[2]), .Cout(c3));
cla_sb cla3(.A(ain[3]), .B(bin[3]), .Cin(c3), .S(sum[3]), .Cout(cout));

endmodule : dutcla_4b