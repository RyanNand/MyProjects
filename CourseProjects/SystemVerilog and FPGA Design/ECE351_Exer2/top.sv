/////////////////////////////////////////////
// top.sv - top level (DUT) for ECE 351 exercise #2
//
// Author:  Ryan Nand (nand@pdx.edu)
//
// Instantiates the modules in the DUT (an ALU of sorts)
// and multiplexes the LED output based on the ALU function
/////////////////////////////////////////////
module top
import definitions_pkg::*;
#(
    parameter BITS = 16   
 )
(
    input test_selector_t       ALU_FUNC,   // Used to select which set of LEDs to return
    input logic [BITS-1:0]      SW,         // slide switches
    output logic [BITS-1:0]     LED         // LEDs
);

// internal variables for the LED values...remember all the hardware is running concurrently
logic [$clog2(BITS):0] LO_LED;      // leading ones LEDs
logic [$clog2(BITS):0] NO_LED;      // number of ones LEDs
logic [BITS-1:0]       ADD_LED;     // Adder LEDs
logic [BITS-1:0]       SUB_LED;     // Subtractor LEDS
logic [BITS-1:0]       MULT_LED;    // Multiplication LEDS

// instantiate the ALU functions
// You need 1 leading_ones, 1 num_ones, 1 mult, and 2 add_sub - one configured as an
// adder and the second configured as a subtractor

// ADD YOUR CODE HERE
leading_ones #(.SELECTOR(UP_FOR), .BITS(BITS)) lo_led(.SW(SW), .LED(LO_LED));     // Instantiate leading ones module
num_ones #(.BITS(BITS)) no_led(.SW(SW), .LED(NO_LED));                            // Instantiate number of ones module
add_sub #(.SELECTOR(ALU_ADD), .BITS(BITS)) add_led(.SW(SW), .LED(ADD_LED));       // Instantiate addition module
add_sub #(.SELECTOR(ALU_SUB), .BITS(BITS)) sub_led(.SW(SW), .LED(SUB_LED));       // Instantiate subtraction module
mult #(.BITS(BITS)) mult_led(.SW(SW), .LED(MULT_LED));                            // Instantiate mulitplication module

// LED multiplexer - selects one of the LED output from the the ALU functions
// based on  ALU_FUNC.  Use an always_comb block and either an if..else treee or a 
// case statement.  You can handle the case of an invalid ALU_FUNC by setting LED to 'x

// ADD YOUR CODE HERE
always_comb
  begin : select
    case (ALU_FUNC)                   // Case statement to update LED for a particular test case
      LEADING_ONES: LED = LO_LED;     // If case is leading_ones then update LED 
      NUM_ONES    : LED = NO_LED;     // If case is num_ones then update LED
      ADD         : LED = ADD_LED;    // If case is add then update LED
      SUB         : LED = SUB_LED;    // If case is sub then update LED
      MULT        : LED = MULT_LED;   // If case is mult_led then update LED
      default     : LED = 'x;         // Default to x
    endcase
end : select
endmodule: top