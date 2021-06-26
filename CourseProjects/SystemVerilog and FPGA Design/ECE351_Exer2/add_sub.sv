/////////////////////////////////////////////
// add_sub.sv - Adder/subtractor for ECE 351 exercise #2
//
// Author:  Ryan Nand (nand@pdx.edu)
//
// Single adder/subtractor.  Use SELECTOR parameter to determine
// whether to add or subtract
/////////////////////////////////////////////
module add_sub
import definitions_pkg::*;
#(
    parameter add_sub_options_t SELECTOR,
    parameter BITS = 16
)
(
    input  wire         [BITS-1:0]     SW,
    output logic signed [BITS-1:0]     LED
);
   
logic signed [BITS/2-1:0]       a_in;
logic signed [BITS/2-1:0]       b_in;

always_comb 
  begin : addsub
    LED = '0;                      // Reset LED to zero
    // ADD YOUR CODE HERE
    a_in = SW[BITS-1-:BITS/2];     // Part select higher bits
    b_in = SW[BITS/2-1-:BITS/2];   // Part select lower bits
    case (SELECTOR)                // Case statement looking at typedef selector
      ALU_SUB: LED = a_in - b_in;  // Subtract and store in LED
      ALU_ADD: LED = a_in + b_in;  // Add and store in LED
    endcase
end : addsub

endmodule: add_sub
