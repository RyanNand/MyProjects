/////////////////////////////////////////////
// mult.sv - multiplier for ECE 351 exercise #2
//
// Author:  Ryan Nand (nand@pdx.edu)
//
// Does a signed multiply of a_in * b_in
/////////////////////////////////////////////
module mult
import definitions_pkg::*;
#(
    parameter BITS      = 16
 )
(
    input  wire         [BITS-1:0]        SW,
    output logic signed [BITS-1:0]        LED
);

logic signed [BITS/2-1:0]       a_in;
logic signed [BITS/2-1:0]       b_in;

always_comb 
  begin : mult1
    LED = '0;                     // Reset LED to zero
    // ADD YOUR CODE HERE
    a_in = SW[BITS-1-:BITS/2];    // Part select higher bits
    b_in = SW[BITS/2-1-:BITS/2];  // Part select lower bits
    LED = a_in * b_in;            // Do the multiplication and store in LED
end : mult1

endmodule: mult
