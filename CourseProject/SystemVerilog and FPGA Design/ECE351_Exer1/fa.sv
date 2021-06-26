/////////////////////////////////////////////
// fa.sv - Single bit full adder 
//
// Author:  <Ryan Nand> (<nand@pdx.edu>)
/////////////////////////////////////////////
module fa (
	input logic A, B, Cin,	// a, b, and carry_in inputs
	output logic S, Cout	// sum and carry out outputs 
);

timeunit 1ns/1ns;

// ADD YOUR CODE HERE
// Internal variables
wire n1, n2, n3;
// Single bit adder logic
xor g1(n1, A, B); 
xor g2(S, n1, Cin);
and g3(n2, n1, Cin);
and g4(n3, A, B);
or  g5(Cout, n2, n3);

endmodule : fa

