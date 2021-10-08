// Create the interface that will communicate with the DUT
interface dut_if;
  // For this example, there is no need for an interface
  // All we are doing is printing a log message "Hello World"
endinterface

// Create the DUT or the device to be tested
  // Note that the port list contains an interface type variable
    // The DUT will communicate with the UVM environment through the interface
module dut(dut_if dif);
  // For this example, there is no need for a DUT
  // All we are doing is printing a log message "Hello World"
endmodule
