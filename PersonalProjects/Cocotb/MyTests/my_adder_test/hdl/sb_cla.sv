////////////////////////////////////////////////////////////////////////////////
// cla_sb.sv - Single bit CLA (carry look-ahead adder)
//
// Author:  Ryan Nand
// Date: 04/26/2021
//
// Description: This module is a single bit adder module for the CLA.
////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module cla_sb (
	input A, B, Cin,
	output reg S, Cout 
);

reg n1, n2;

always @* begin
    n1   = A ^ B;
    S    = n1 ^ Cin;
    n2   = A & B;
    Cout = Cin & n1 | n2;
end
endmodule
