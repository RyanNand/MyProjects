///////////////////////////////////////////////////////////////////////////////////
// pmodSDD_Interface.sv - The PMODSSD interface module
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/22/2021
//
// Description: This module sets up the PMODSSD interface
//              
///////////////////////////////////////////////////////////////////////////////////
module pmodSSD_Interface 
#(
  // set to 1 for this project, else it will take 100's of thousand cycles of simulation time for each digit change.
  parameter SIMULATE = 1 
)
(
  input logic clk, reset,                                               // Clock and reset
  input logic[4:0] digit1, digit0,                                      // Digit character codes
  output logic SSD_AG, SSD_AF, SSD_AE, SSD_AD, SSD_AC, SSD_AB, SSD_AA,  // Anode segment drivers
  output logic SSD_C                                                    // Common cathode "digit enable"
);

timeunit 1ns/1ns;  // Time unit and precision

// A function to decode the character code into PMODSSD signals 
function automatic logic [6:0] CharToSig( input logic [4:0] char_code );
  case(char_code)  
    // hex digits 0-9
    5'b00000:  CharToSig = 7'b1111110;  // 0
    5'b00001:  CharToSig = 7'b0000110;  // 1
    5'b00010:  CharToSig = 7'b1101101;  // 2
    5'b00011:  CharToSig = 7'b1111001;  // 3
    5'b00100:  CharToSig = 7'b0110011;  // 4
    5'b00101:  CharToSig = 7'b1011011;  // 5 
    5'b00110:  CharToSig = 7'b1011111;  // 6
    5'b00111:  CharToSig = 7'b1110000;  // 7
    5'b01000:  CharToSig = 7'b1111111;  // 8
    5'b01001:  CharToSig = 7'b1111011;  // 9
			
    // hex digits A - F
    5'b01010:  CharToSig = 7'b1110111;  // A
    5'b01011:  CharToSig = 7'b0011111;  // B
    5'b01100:  CharToSig = 7'b1001110;  // C
    5'b01101:  CharToSig = 7'b0111101;  // D
    5'b01110:  CharToSig = 7'b1001111;  // E
    5'b01111:  CharToSig = 7'b1000111;  // F
			
    // individual segments       
    5'b10000:  CharToSig = 7'b1000000;  // segment a
    5'b10001:  CharToSig = 7'b0100000;  // segment b
    5'b10010:  CharToSig = 7'b0010000;  // segment c
    5'b10011:  CharToSig = 7'b0001000;  // segment d
    5'b10100:  CharToSig = 7'b0000100;  // segment e
    5'b10101:  CharToSig = 7'b0000010;  // segment f
    5'b10110:  CharToSig = 7'b0000001;  // segment g
			
    // Special characters         
    5'b11000:  CharToSig = 7'b0110111;  // upper case H
    5'b11001:  CharToSig = 7'b0001110; 	// upper case L       
    5'b11010:  CharToSig = 7'b1110111;  // upper case R
    5'b11011:  CharToSig = 7'b0000110;  // lower case L (l)
    5'b11100:  CharToSig = 7'b0000101; 	// lower case R (r)
			
    // The four remaining combinations are blanks
    default:   CharToSig = 7'b0000000;  // blank
  endcase
endfunction  // CharToSig

// Internal wire
wire tick_1kHz;  // Wire for clock

clk_divider #(.CLK_INPUT_FREQ_HZ(100_000_000), .TICK_OUT_FREQ_HZ(100_000), .SIMULATE(1)) 
              clock(.clk(clk), .reset(reset), .tick_out(tick_1kHz));

// Logic to perform 50% duty cycle of input clock tick
always_ff @(posedge clk) begin: digit_enable
  if (reset)           // If active high reset
    SSD_C <= 1'b0;     // Assign enable signal to zero
  else if (tick_1kHz)  // 2x the frequency for 50% on / 50% off
    SSD_C <= ~SSD_C;   // Invert enable signal on tick
  else
    SSD_C <= SSD_C;    // Else hold current value
end: digit_enable

always_comb begin
  {SSD_AA, SSD_AB, SSD_AC, SSD_AD, SSD_AE, SSD_AF, SSD_AG} = '0;                             // Pre-case assignment
  case(SSD_C)                                                                                // Case dependent on enable signal
    1'b0    : {SSD_AA, SSD_AB, SSD_AC, SSD_AD, SSD_AE, SSD_AF, SSD_AG} = CharToSig(digit0);  // Update outputs to character code for digit 0
    1'b1    : {SSD_AA, SSD_AB, SSD_AC, SSD_AD, SSD_AE, SSD_AF, SSD_AG} = CharToSig(digit1);  // Update outputs to character code for digit 1
    default : {SSD_AA, SSD_AB, SSD_AC, SSD_AD, SSD_AE, SSD_AF, SSD_AG} = CharToSig(digit0);  // Default outputs to character code for digit 0
  endcase
end
endmodule : pmodSSD_Interface