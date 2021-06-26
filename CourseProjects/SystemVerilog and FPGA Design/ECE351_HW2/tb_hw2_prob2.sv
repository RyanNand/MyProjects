////////////////////////////////////////////////////////////////////////////////
// tb_hw2_prob2.sv - The testbench for More Random Combinational Logic
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/10/2021
//
// Description: This testbench will test the logic circuit from problem two of 
// homework two. Testing all stimulus combinations. 
////////////////////////////////////////////////////////////////////////////////
module tb_hw2_prob2;

localparam DELAY = 5;   // Create local parameter for delaying stimulus change

timeunit 1ns/1ns;  // Specify time unit and time precision

// Input/output ports
logic in1, in2, in3, in4, in5, enableN;
logic tri_outN;

// Instantiate the DUT
hw2_prob2 dut(.*);

// Setup monitor 
initial begin : setup_monitor
  $monitor("At time %3d\t:\tInputs: EnableN = %d,\tin1 = %d,\tin2 = %d,\tin3 = %d,\tin4 = %d,\tin5 = %d,\tOutput: Y = %d", $time, enableN, in1, in2, in3, in4, in5, tri_outN);
end : setup_monitor

// Generate stimulus
initial begin : stimulus

// Nest for loops to generate each stimulus combination
for(int i = 0; i < 2; i++) begin : for_enableN
  enableN = i;                                          // Assign enableN high or low
  for(int j = 0; j < 2; j++) begin : for_in1
    in1 = j;                                            // Assign input in1 to high or low
    for(int k = 0; k < 2; k++) begin : for_in2
      in2 = k;                                          // Assign input in2 to high or low
      for(int l = 0; l < 2; l++) begin : for_in3
        in3 = l;                                        // Assign input in3 to high or low
        for(int m = 0; m < 2; m++) begin : for_in4
          in4 = m;                                      // Assign input in4 to high or low
          for(int  n= 0; n < 2; n++) begin : for_in5
            in5 = n;                                    // Assign input in5 to high or low
            #DELAY;					// Delay input change by DELAY local parameter
          end : for_in5
        end : for_in4
      end : for_in3
    end : for_in2
  end : for_in1
end : for_enableN
$stop;
end : stimulus
endmodule : tb_hw2_prob2