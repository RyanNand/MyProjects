/////////////////////////////////////////////
// dut.sv - 8-bit Ripple Carry Adder
//
// Author:  <Ryan Nand> (<nand@pdx.edu>)
/////////////////////////////////////////////
module dut (
	input logic [7:0] ain, bin,
	input logic cin,
	output logic [7:0] sum,
	output logic cout
);

timeunit 1ns/1ns;

// ADD YOUR CODE HERE
// Internal variables
wire n1;
// 8 bit adder with carry logic
adder_4bits LSNibble(.A(ain[3:0]), .B(bin[3:0]), .C0(cin), .S(sum[3:0]), .C4(n1));
adder_4bits MSNibble(.A(ain[7:4]), .B(bin[7:4]), .C0(n1), .S(sum[7:4]), .C4(cout));


endmodule : dut