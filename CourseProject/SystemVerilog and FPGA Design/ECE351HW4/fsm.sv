//////////////////////////////////////////////////////////////////////////////////
// hw3_prob2.sv - Car Wash FSM
//
// Author:  Ryan Nand (nand@pdx.edu)
// Date: 05/22/2021
//
// Description: This module models a car wash finite state machine. The state 
// 		diagram can be found in the hw3 pdf.
//              
///////////////////////////////////////////////////////////////////////////////////
module carwash_fsm (
  input logic clk, clr,  // Input clock and clear/reset
  input logic TOKEN,     // Input for tokens inserted
  input logic START,     // Input for when customer presses start
  input logic T1DONE,    // Input for when spray time has expired
  input logic T2DONE,    // Input for rinse time (after soap) has expired
  output logic CLRT1,    // Output to clear the spray timer. Assert high
  output logic CLRT2,    // Output to clear the rinse timer. Assert high
  output logic SOAP,     // Output to apply soap. Assert high
  output logic SPRAY     // Output to turn on the spray. Assert high
);

timeunit 1ns/1ns;

// State encoding by enumerated type labels
typedef enum logic [3:0] {S0 = 0,            // State S0 explicit binary 3'b000
                          S1 = 1,            // State S1 explicit binary 3'b001
                          S2 = 2,            // State S2 explicit binary 3'b010
                          S3 = 3,            // State S3 explicit binary 3'b011
                          S4 = 4             // State S4 explicit binary 3'b100
                         }  state_binary_t;  // Typedef name

state_binary_t state, next_state;            // Declare state variables

// State sequencer
always_ff @(posedge clk)        // Trigger on positive edge clock
  if(clr)                       // If active high clear, reset
    state <= S0;                // Reset to state S0
  else                          // Else transition to next state
    state <= next_state;        // Equate to the pointer for the next state

// Next state decoder
always_comb begin               // Start FSM combinational logic
  case(state)                   // Case statement dependent on current FSM state
    S0:                         // State S0...
      if(TOKEN)                   // If active high TOKEN (customer puts in 1st token)
        next_state = S1;          // Next state will be S1
      else                        // Else (no token was put in) 
        next_state = S0;          // Don't move to next state
    S1:                         // State S1...
      if(START)                   // If active high START (customer presses start button)
        next_state = S4;          // Next state will be S4
      else if(TOKEN && !START)    // If active high TOKEN (customer puts second token)
        next_state = S2;          // Next state will be S2
      else                        // Else (no 2nd token inserted and no start button pressed)
        next_state = S1;          // Don't move to next state
    S2:                         // State S2...
      if(T1DONE)                  // If active high T1DONE (spray time expired)
        next_state = S3;          // Next state will be S3
      else                        // Else (timer still has time remaining)
        next_state = S2;          // Don't move to next state
    S3:                         // State S3
      if(T2DONE)                  // If active high T2DONE (rinse soap timer expired)
        next_state = S4;          // Next state will be S4
      else                        // Else (time remains on rinse after soap timer)
        next_state = S3;          // Don't move to next state
    S4:                         // State S4
      if(T1DONE)                  // If active high T1DONE (spray time expired)
        next_state = S0;          // Next state will be S0
      else                        // Else (time remaining on spray timer)
        next_state = S4;          // Don't move to next state
    default: next_state = S0;   // Default to state S0 (avoid unintentional latches)
  endcase
end

// FSM output decoder
always_comb begin
  {CLRT1, CLRT2, SOAP, SPRAY} = '0;             // Pre-case assignment (avoid unintential latches)
  case(state)                                   // Case statement dependent on current FSM state
    S0: {CLRT1, CLRT2, SOAP, SPRAY} = '0;       // State S0 has all outputs to zero
    S1: {CLRT1, CLRT2, SOAP, SPRAY} = 4'b1000;  // State S1 assert clear timer 1 output
    S2: {CLRT1, CLRT2, SOAP, SPRAY} = 4'b0101;  // State S2 assert clear timer 2 and spray output
    S3: {CLRT1, CLRT2, SOAP, SPRAY} = 4'b1010;  // State S3 assert clear timer 1 and soap output
    S4: {CLRT1, CLRT2, SOAP, SPRAY} = 4'b0001;  // State S4 assert spray output
    default: {CLRT1, CLRT2, SOAP, SPRAY} = '0;  // Default outputs to zero (avoid unintential latches)
  endcase
end
endmodule : carwash_fsm
