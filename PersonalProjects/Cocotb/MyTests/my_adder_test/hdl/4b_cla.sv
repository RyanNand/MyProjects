////////////////////////////////////////////////////////////////////////////////
// 4b_cla.sv - 4-bit CLA (carry look-ahead adder)
//
// Author:  Ryan Nand
// Date: 04/26/2021
//
// Description: This module takes the single bit adder from cla_sb.sv and 
// utilizies it to create a 4-bit CLA
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module cla_4b (
	input [3:0] A, B, 
	input Cin,
	output [3:0] Sum, 
	output Cout 
);


// Internal nets
wire n1, n2, n3;

cla_sb cla0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(Sum[0]), .Cout(n1));
cla_sb cla1(.A(A[1]), .B(B[1]), .Cin(n1), .S(Sum[1]), .Cout(n2));
cla_sb cla2(.A(A[2]), .B(B[2]), .Cin(n2), .S(Sum[2]), .Cout(n3));
cla_sb cla3(.A(A[3]), .B(B[3]), .Cin(n3), .S(Sum[3]), .Cout(Cout));

endmodule
