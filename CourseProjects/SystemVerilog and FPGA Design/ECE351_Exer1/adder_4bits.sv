/////////////////////////////////////////////
// adder_4bits.sv - 4 bit adder 
//
// Author:  <Ryan Nand> (<nand@pdx.edu>)
/////////////////////////////////////////////
module adder_4bits (
	input logic [3:0] A, B,
	input logic C0,
	output logic [3:0] S,
	output logic C4
);

timeunit 1ns/1ns;

// internal variables
wire C1, C2, C3;

// instantiate and connect four FA's
fa FA0(.A(A[0]), .B(B[0]), .Cin(C0), .S(S[0]), .Cout(C1));
fa FA1(.A(A[1]), .B(B[1]), .Cin(C1), .S(S[1]), .Cout(C2));
fa FA2(.A(A[2]), .B(B[2]), .Cin(C2), .S(S[2]), .Cout(C3));
fa FA3(.A(A[3]), .B(B[3]), .Cin(C3), .S(S[3]), .Cout(C4));

endmodule: adder_4bits