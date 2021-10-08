// Include the definitions for the UVM macros
`include "uvm_macros.svh"

// Create the interface that will communicate with the DUT
interface dut_if;
  
  // Create ports that the DUT will utilize
  logic clock, reset;
  logic cmd;
  logic [7:0] addr;
  logic [7:0] data;

endinterface

// Create the DUT or the device to be tested
module dut(dut_if dif);

  // Import in the UVM base class library
  import uvm_pkg::*;

  // Create a procedural block for reporting and your arbitrary design
  always @(posedge dif.clock) begin
    // Report the values received from the interface
    `uvm_info("", $sformatf("DUT received cmd=%b, addr=%d, data=%d",
                            dif.cmd, dif.addr, dif.data), UVM_MEDIUM)
  end
  
endmodule
