///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// carwash_fsm_test.sv - Testbench for the car wash FSM
//
// Author:	Ryan Nand (nand@pdx.edu) 
// Date:	5/29/2021
//
// Description:
// ------------
// Code to test the paths for the car wash FSM.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module top;

logic clk;                                // System clock
logic clr, TOKEN, START, T1DONE, T2DONE;  // Inputs to FSM
logic CLRT1, CLRT2, SOAP, SPRAY;          // Outputs from FSM

timeunit 1ns/1ns;                         // 1ns time unit and precision

// make use of the SystemVerilog C programming interface
// https://stackoverflow.com/questions/33394999/how-can-i-know-my-current-path-in-system-verilog
import "DPI-C" function string getenv(input string env_name);

// Instantiate any modules
carwash_fsm dut(.*);                      // Car wash FSM instantiation
tb_carwash tb(.*);                        // Test bench program instantiation

initial begin : print
  // Print statements to console for results
  $display("\nCar Wash FSM Path Test - Ryan Nand (nand@pdx.edu)");
  $display("Sources: %s\n", getenv("PWD")); 
  $monitor("Time: %3d Current state = %s\t||\t Inputs: clr = %d, Token = %d, Start = %d, T1Done = %d, T2Done = %d\t||\t Outputs: CLRT1 = %d, CLRT2 = %d, SOAP = %d, SPRAY = %d", 
           $time, dut.state.name, clr, dut.TOKEN, START, T1DONE, T2DONE, CLRT1, CLRT2, SOAP, SPRAY);
  clk = 0;                                // Initialize clock
  forever #5 clk = ~clk;                  // Generate system clock 
end : print

endmodule : top

// Testbench program
program tb_carwash (
  input logic clk,                                             // System clock input
  output logic clr, TOKEN, START, T1DONE, T2DONE               // Outputs of program (inputs to FSM module)
);

timeunit 1ns/1ns;                                              // 1ns time unit and precision

initial begin : implicit_FSM
  {clr, TOKEN, START, T1DONE, T2DONE} <= '0;                   // Initialize outputs to zero
  @(posedge clk);                                              // Initialize FSM state
  $display("\n**First see if clr works.**");                   // Path to check if clear works
    TOKEN <= 1;                                                // Insert token
  @(posedge clk);
    TOKEN <= 0;                                                // Clear token signal
    clr <= 1;                                                  // Set clear signal
  @(posedge clk);
    clr <= 0;                                                  // Clear the clear signal
  @(posedge clk);
  $display("\n**Insert token and try first path - cheap.**");  // Logic path to check cheap path
    TOKEN <= 1;                                                // Insert token
  @(posedge clk);
    TOKEN <= 0;                                                // Clear token signal
  $display("**Press start for cheap path.**");
    START <= 1;                                                // Press start button
  @(posedge clk);
    START <= 0;                                                // Clear start signal
    T1DONE <= 1;                                               // Set timer1 done signal
  @(posedge clk);
    T1DONE <= 0;                                               // Clear timer1 done signal
  @(posedge clk);
  $display("\n**Try second path - expensive.**");              // Logic path to check expensive path
  @(posedge clk);
    TOKEN <= 1;                                                // Insert token
  @(posedge clk);
    TOKEN <= 0;                                                // Clear token signal
  $display("**Insert another token for expensive path**");     
    TOKEN <= 1;                                                // Insert another token
  @(posedge clk);
    TOKEN <= 0;                                                // Clear token signal
    T1DONE <= 1;                                               // Set timer1 done signal
  @(posedge clk);
    T1DONE <= 0;                                               // Clear timer1 done signal
    T2DONE <= 1;                                               // Set timer2 done signal
  @(posedge clk);
    T2DONE <= 0;                                               // Clear timer2 done signal
    T1DONE <= 1;                                               // Set timer1 done signal
  @(posedge clk);
    T1DONE <= 0;                                               // Clear timer1 done signal
  @(posedge clk);
  $display("\n**All paths have been tested for!**");           // At this point all paths are validated
  $display("End Car Wash FSM Path Test - Ryan Nand (nand@pdx.edu)\n");
  $stop;
end : implicit_FSM
endprogram : tb_carwash