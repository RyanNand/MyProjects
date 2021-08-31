/////////////////////////////////////////////////////////////////////////////////////////////////////////
// uart_tx.sv - UART Transmitter (starter code)
//
// Author:	Ryan Nand (nand@pdx.edu) 
// Date:	5/29/2021
//
// Description:
// ------------
// Serializes a data packet, adds the start and stop bits and transmits the
// data packed on bit at a time on the tx signal.
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_tx
(
  input  logic clk, reset,            // system clock and reset (reset asserted high)
  input  logic tx_start, s_tick,      // tx_start tells the transmitter to transmit a serial data packet
  input  logic [7:0] din,             // parallel data in
  output logic tx_done_tick,          // packet transmission done pulse
  output logic tx,                    // serial transmit line
  output logic xmit_tick              // debug signal for when bit is transmitt3ed
);

// ADD YOUR CODE HERE

// UART transmitter FSM declarations
typedef enum logic [3:0] {IDLE, START, DB_[1:8], STOP, DONE} FSM_STATE_t;
FSM_STATE_t state_reg, state_next;

// Sample bit counter
logic [3:0] sbc_counter;                     // Sample tick counter for each of the rx bits
logic sbc_clr, sbc_inc;                      // Sample tick counter control signals
logic sbc_tick08, sbc_tick16;                // Sample tick status signals

always_ff @(posedge clk) begin: sbc_logic    // Counter procedural block
  if(reset)                                  // If reset
    sbc_counter <= '0;                       // Set counter to zero
  else if(sbc_clr)                           // If clear
    sbc_counter <= '0;                       // Set counter to zero
  else if(sbc_inc)                           // If increment
    sbc_counter <= sbc_counter + 1;          // Increment counter
  else                                       // Else
    sbc_counter <= sbc_counter;              // Retain the original value
end: sbc_logic

assign sbc_tick08 = sbc_counter == 4'b0111;  // If counter equal to 7 set sbc_tick08 to 1 or true 
assign sbc_tick16 = sbc_counter == 4'b1111;  // If counter equal to 15 set sbc_tick16 to 1 or true

// UART Transfer Data Register
logic [7:0]  tx_data_reg;                    // UART transfer shift register
logic tx_data_reg_load, tx_data_reg_shift;   // UART transfer shift register control

always_ff @(posedge clk) begin: uart_transfer_data_register  // Tx data tranfer procedural block
  if(reset)                                  // If reset
    tx_data_reg <= '0;                       // Set data reg to zero
  else if(tx_data_reg_load)                  // If load
    tx_data_reg <= din;                      // Load din (data in) into reg
  else if(tx_data_reg_shift)                 // If shift
    tx_data_reg <= tx_data_reg >> 1;         // Shift reg one bit to the right
  else                                       // Else
    tx_data_reg <= tx_data_reg;              // Retain the original value
end: uart_transfer_data_register

// UART Transmitter FSM
always_ff @(posedge clk) begin: uart_tcvr_seq_block  // FSM procedural block
  if(reset)                                  // If reset
    state_reg <= IDLE;                       // Set state to IDLE
  else                                       // Else
    state_reg <= state_next;                 // Proceed to next state
end: uart_tcvr_seq_block

always_comb begin: uart_tcvr_comb_block           // FSM combinational logic
  {sbc_clr, sbc_inc} = 2'b00;                     // Pre-case assignment initialization to zero
  {tx_data_reg_load, tx_data_reg_shift} = 2'b00;  // Pre-case assignment initialization to zero
  {tx_done_tick, xmit_tick} = 2'b00;              // Pre-case assignment initialization to zero
  case(state_reg)                                 // Identify state with state_reg
    IDLE:  begin
      if(tx_start) begin                          // If start 
        state_next = START;                       // Go to START state
        end
      else                                        // Else 
        state_next = IDLE;                        // Stay in IDLE state
      end              
    START:  begin                               // Start state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_load = 1'b1;                // Load register with data
          state_next = DB_1;                      // Point to next state DB_1
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else 
          sbc_inc = 1'b1;                         // Increment counter
          state_next = START;                     // Stay in START state
          end
    end                
    DB_1:  begin                                // DB_1 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_2;                      // Point to next state DB_2
          xmit_tick = 1'b1;                       // Transmit debug signal
        end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_1;                      // Stay in DB_1 state
          end
    end
    DB_2:  begin                                // DB_2 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_3;                      // Point to next state DB_3
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_2;                      // Stay in DB_2 state
          end
    end
    DB_3:  begin                                // DB_3 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_4;                      // Point to next state DB_4
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_3;                      // Stay in DB_3 state
          end
    end
    DB_4:  begin                                // DB_4 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_5;                      // Point to next state DB_5
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_4;                      // Stay in DB_4 state
          end
    end
    DB_5:  begin                                // DB_5 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_6;                      // Point to next state DB_6
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_5;                      // Stay in DB_5 state
          end
    end
    DB_6:  begin                                // DB_6 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_7;                      // Point to next state DB_7
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_6;                      // Stay in DB_6 state
          end
    end
    DB_7:  begin                                // DB_7 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = DB_8;                      // Point to next state DB_8
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_7;                      // Stay in DB_7 state
          end
    end
    DB_8:  begin                                // DB_8 state
      if(s_tick)                                  // If system tick
        if(sbc_tick16) begin                      // If counter reaches 16 ticks
          sbc_clr = 1'b1;                         // Clear counter
          tx_data_reg_shift = 1'b1;               // Shift data register
          state_next = STOP;                      // Point to next state STOP
          xmit_tick = 1'b1;                       // Transmit debug signal
          end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = DB_8;                      // Stay in DB_8 state
          end
    end
    STOP:  begin                                // STOP state
      if(s_tick)                                  // If system tick
        if(sbc_tick08) begin                      // If counter reaches 8 ticks
          sbc_clr = 1'b1;                         // Clear counter
          state_next = DONE;                      // Point to next state DONE
          xmit_tick = 1'b1;                       // Transmit debug signal
         end 
        else begin                                // Else
          sbc_inc = 1'b1;                         // Increment counter
          state_next = STOP;                      // Stay in STOP state
          end
    end
    DONE: begin                                 // Done state
      tx_done_tick = 1'b1;                        // Generate done tick
      state_next = IDLE;                          // Point to next state IDLE
      end
  endcase
end: uart_tcvr_comb_block

// assign the outputs
always_ff @(posedge clk) begin : tx_ff            // Output flip-flop
  tx <= tx_data_reg[0];                           // Set tx to bit 0 of the tx data register
end : tx_ff

endmodule: uart_tx
