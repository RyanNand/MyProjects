/////////////////////////////////////////////
// num_ones.sv - number of ones calculator for ECE 351 exercise #2
//
// Author:  Ryan Nand (nand@pdx.edu)
//
// NOTE:  Makes use of a for loop to that it still works even if the number of BITS changes. 
// This module can be modeled like the leading_one module
/////////////////////////////////////////////
module num_ones
import definitions_pkg::*;
#(
    parameter BITS      = 16
)
(
   input wire   [BITS-1:0]          SW,
   output logic [$clog2(BITS):0]    LED
);

always_comb 
  begin : numb_ones
    // ADD YOUR CODE HERE
    LED = '0;                                          // Reset LED to zero
    for (int i = $low(SW); i <= $high(SW); i++) begin  // Start for loop to look at each data location in SW
      if(SW[i]) begin                                  // If data location is high or 1
        LED += 1;                                      // Increment LED and store it back into LED
      end
    end
  end : numb_ones

endmodule: num_ones
