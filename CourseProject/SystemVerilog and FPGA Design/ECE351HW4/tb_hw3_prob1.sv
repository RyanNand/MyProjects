///////////////////////////////////////////////////////////////////////////////////
// tb_hw3_prob1.sv - Testbench for 4-Bit Serial-In Parallel-Out Shift Register
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/22/2021
//
// Description: This tests the 4-bit SIPO register 
//
///////////////////////////////////////////////////////////////////////////////////
module tb_hw3_prob1;

timeunit 1ns/1ns;

// make use of the SystemVerilog C programming interface
// https://stackoverflow.com/questions/33394999/how-can-i-know-my-current-path-in-system-verilog
import "DPI-C" function string getenv(input string env_name);

// Internal variables
logic serial_in, shift, clk, clr;
logic [3:0] Q;
logic [3:0] count;

// Instantiate modules
hw3_prob1 reg1(.*);

initial begin : clock_generator
  clk = 0;
  forever #5 clk = ~clk;
  end : clock_generator

initial begin : stimulus
  clr = 0;
  count = 0;
  $display("\n4-Bit SIPO Shift Register Test - Ryan Nand (nand@pdx.edu)");
  $display("Sources: %s\n", getenv("PWD")); 
  @(posedge clk); {serial_in, shift} = 2'b11;
  #100 if(Q == 15) begin
    $display("\nPast 1st test! Expected result: 4'b1111\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else 
    $display("\nFailed 1st test! Expected result: 4'b1111\t\tRegister output: 4'b%b", Q);
  @(posedge clk);
    clr = 1;
    {serial_in, shift} = 2'b00;
  @(posedge clk);
    clr = 0;
  #150 if(Q == 0) begin
    $display("Past 2nd test! Expected result: 4'b0000\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else 
    $display("Failed 2nd test! Expected result: 4'b0000\t\tRegister output: 4'b%b", Q);
  @(posedge clk); {serial_in, shift} = 2'b10;
  #220 if(Q == 0) begin
    $display("Past 3rd test! Expected result: 4'b0000\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else
    $display("Failed 3rd test! Expected result: 4'b0000\t\tRegister output: 4'b%b", Q);
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b00;
  #320 if(Q == 4'b1100) begin
    $display("Past 4th test! Expected result: 4'b1100\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else 
    $display("Failed 4th test! Expected result: 4'b1100\t\tRegister output: 4'b%b", Q);
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b01;
  @(posedge clk); {serial_in, shift} = 2'b01;
  @(posedge clk); {serial_in, shift} = 2'b00;
  #440 if(Q == 4'b0011) begin
    $display("Past 5th test! Expected result: 4'b0011\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else 
    $display("Failed 5th test! Expected result: 4'b0011\t\tRegister output: 4'b%b", Q);
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b01;
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b01;
  @(posedge clk); {serial_in, shift} = 2'b00;
  #460 if(Q == 4'b0101) begin
    $display("Past 6th test! Expected result: 4'b0101\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else 
    $display("Failed 6th test! Expected result: 4'b0101\t\tRegister output: 4'b%b", Q);
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b01;
  @(posedge clk); {serial_in, shift} = 2'b11;
  @(posedge clk); {serial_in, shift} = 2'b00;
  #580 if(Q == 4'b1010) begin
    $display("Past 7th test! Expected result: 4'b1010\t\tRegister output: 4'b%b", Q);
    count <= count + 1;
    end
  else 
    $display("Failed 7th test! Expected result: 4'b1010\t\tRegister output: 4'b%b", Q);
  #600 if(count == 7)
    $display("\n**All 7 tests have been passed!**\n");
  else
    $display("\n**There were failures!!**\n");
  $display("End 4-Bit SIPO Shift Register Test - Ryan Nand (nand@pdx.edu)\n");
  $stop;
  end : stimulus

endmodule : tb_hw3_prob1 
