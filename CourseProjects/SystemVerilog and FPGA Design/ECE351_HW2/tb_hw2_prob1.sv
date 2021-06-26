////////////////////////////////////////////////////////////////////////////////
// tb_hw2_prob1.sv - The testbench for Random Combinational Logic
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/10/2021
//
// Description: This testbench tests the module for problem one from homework two. 
// 
////////////////////////////////////////////////////////////////////////////////
module tb_hw2_prob1;

localparam DELAY = 5;   // Create local parameter for delaying stimulus change

timeunit 1ns/1ns;       // Specify time unit and time precision

//stimulus
logic A, B, C, D;	// Inputs
logic Y;		// Output

// Instantiate the DUT
hw2_prob1 dut (.*);

// Setup moniter
initial begin : setup_monitor
  $monitor("At time %3d\t:\tInputs: A = %d,\tB = %d,\tC = %d,\tD = %d,\tOutput: Y = %d", $time, A, B, C, D, Y);
end : setup_monitor

// Generate stimulus
initial begin : stimulus

// Nested for loops to generate each stimulus combination
for(int i = 0; i < 2; i++) begin : for_a
  A = i;                                        // Assign input A zero or one
  for(int j = 0; j < 2; j++) begin : for_b
    B = j;                                      // Assign input B zero or one
    for(int k = 0; k < 2; k++) begin : for_c
      C = k;                                    // Assign input C zero or one
      for(int l = 0; l < 2; l++) begin : for_d
        D = l;                                  // Assign input D zero or one
        #DELAY;					// Delay input change by DELAY
      end : for_d
    end : for_c
  end : for_b
end : for_a
$stop;
end : stimulus
endmodule : tb_hw2_prob1