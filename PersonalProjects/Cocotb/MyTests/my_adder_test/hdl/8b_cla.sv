////////////////////////////////////////////////////////////////////////////////
// dutcla_8b.sv - 8-bit CLA (carry look-ahead adder)
//
// Author:  Ryan Nand
// Date: 04/26/2021
//
// Description: This module takes the 4-bit adder from dutcla_4b.sv and 
// utilizies it to create a 8-bit CLA
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module cla_8b (
	input [7:0] A, B, 
	input Cin,
	output [7:0] S,
	output Cout 
);


// Internal nets
wire n1;

cla_4b cla_4b0(.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .Sum(S[3:0]), .Cout(n1));
cla_4b cla_4b1(.A(A[7:4]), .B(B[7:4]), .Cin(n1), .Sum(S[7:4]), .Cout(Cout));

endmodule
