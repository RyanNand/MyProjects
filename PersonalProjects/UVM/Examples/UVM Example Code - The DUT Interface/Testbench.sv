// Notes:
  // This example provides a DUT to actually test and does a good job on showing how to connect to the verification environment
  // The combination of the interface and the DUT is called the test harness
  // The test harness is never directly connected to the UVM environment
    // Cannot connect a modular design to a class-based verification environment
	  // UVM has a method of getting around this obstacle using a configuration database
      // The test harness will be connected to the UVM environment through a virtual interface referenced using the configuration database
	    // This promotes reusable verification environments

// Include the definitions for the UVM macros
`include "uvm_macros.svh"

// Create a package for easy import of all UVM components and/or objects
package my_pkg;

  // Import in the UVM base class library
  import uvm_pkg::*;

  // Create our own UVM driver component/class
    // To do this we must inherit the UVM driver base component/class "uvm_driver"
  class my_driver extends uvm_driver;

    // Register the UVM driver class with the UVM factory
    `uvm_component_utils(my_driver)

    // Declare a virtual interface variable
	  // The virtual interface connects the UVM environment to the actual interface
	    // In SystemVerilog, you cannot connect dynamic classes with static interfaces
		// Since the language doesn't allow it, we must use a virtual interface which will reference the actual interface
		// Even if the language did allow it, we wouldn't want to hardwire the UVM environment to the interface 
		  // It removes the reusability feature of UVM
    virtual dut_if dut_vi;

    // Override the constructor to create an OOP object and establish this class as the parent UVM driver component
    function new(string name, uvm_component parent);
	  // Use the UVM base class constructor to create the OOP object and establish this class as the parent UVM driver component
      super.new(name, parent);
    endfunction
    
	// Override the build phase to build the virtual interface
    function void build_phase(uvm_phase phase);
      // Get interface reference from the configuration database
	    // The UVM configuration database is a globally accessible database where type specific data can be stored and retrieved
        // We are storing the interface reference in the top module and retrieving it here
          // This connects the virtual interface with the actual interface
		// The parameter must contain the type of data (aka configuration type) being retrieved
		  // The parameter value identifies the configuration type as an int property
		    // I'm guessing this int property is an address
		// In SystemVerilog, the scope resolution operator "::" must be used to call "static" functions within a class that has no class type variable
		  // Remember that "static" functions are not recursive while "automatic" functions are
		    // "static" functions retain it's values from previous calls while "automatic" allocates new storage each time
		  // Primarily, automatic functions are for RTL while both automatic and static can be used for verification
		// "...::get(...)" is a static function within the UVM configuration database class that retrives data from the configuration database
		// Must pass the caller, path, name, and value
		  // The caller is a hierarchical component indicating the upper bound of where the data retrieved is applicable
		    // 99% of the time the caller is the current component, therefore we use "this"
		  // The path is a hierarchical lower bound that limits the applicability of the data
		    // The path is an empty string because similarly to the caller the configuration data applies to only this current instance
		  // If the caller and path were anything different the function would be retrieving data for another component
			// Legal, but not typically something we would want to do
		  // The name is the name of the configuration data we are retriving
		    // Using the same name as the configuration type is common
		  // The value is the variable we are storing the data or reference in
      if( !uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut_vi) )
	    // Report an error if retrival from the configuration database fails
		  // "uvm_config_db #(...)::get(...)" will return a 0 if an error occurs and a 1 if successful
        `uvm_error("", "uvm_config_db::get failed")
    endfunction 
   
    // Override the run phase to generate random stimulus
    task run_phase(uvm_phase phase);
      forever
      begin
        // Generate random stimulus
		  // Will trigger on the positive edge of clock provided through the virtual interface
        @(posedge dut_vi.clock);
		// Update the virtual interface ports with random stimulus
		// In SystemVerilog, "$urandom" is a system task that returns a unsigned 32-bit psudo-random number
		  // When the size is fewer bits than the value, the left-most bits of the value are truncated.
        dut_vi.cmd  <= $urandom;
        dut_vi.addr <= $urandom;
        dut_vi.data <= $urandom;
      end
    endtask

  endclass: my_driver
  
  // Create our own UVM environment component/class
  class my_env extends uvm_env;

    // Register the UVM environment class with the UVM factory
    `uvm_component_utils(my_env)
    
	// Declare the UVM driver class type variable
    my_driver m_driv;
    
	// Override the constructor to create an OOP object and establish this class as the parent UVM environment component
    function new(string name, uvm_component parent);
	  // Use the UVM base class constructor to create the OOP object and establish this class as the parent UVM environment component
      super.new(name, parent);
    endfunction
 
    // Override the build phase to build the components we desire
    function void build_phase(uvm_phase phase);
	  // Create the UVM driver component by instantiation
      m_driv = my_driver::type_id::create("m_driv", this);
    endfunction
    
  endclass: my_env
  
  // Create our own UVM test component/class
  class my_test extends uvm_test;

    // Register the UVM test class with the UVM factory  
    `uvm_component_utils(my_test)

	// Declare a UVM environment class type variable    
    my_env m_env;
    
	// Override the constructor to create an OOP object and establish this class as the parent UVM test component
    function new(string name, uvm_component parent);
	  // Use the UVM base class constructor to create the OOP object and establish this class as the parent UVM test component	
      super.new(name, parent);
    endfunction
 
	// Override the build phase to build the components we desire 
    function void build_phase(uvm_phase phase);
	  // Create the UVM environment component by instantiation	
      m_env = my_env::type_id::create("m_env", this);
    endfunction
    
	// Override the run phase to run the simulation we desire
    task run_phase(uvm_phase phase);
	  // Initiate the end-of-test mechanism
      phase.raise_objection(this);
	  // Insert arbitrary code to perform the simulation
	  // Delay 80 timeunits
      #80;
	  // End the end-of-test mechanism
      phase.drop_objection(this);
    endtask
     
  endclass: my_test
  
  
endpackage: my_pkg

// Create our top module
module top;

  // Import both the UVM base class library package and the package with our UVM components/objects
  import uvm_pkg::*;
  import my_pkg::*;
  
  // Instantiate our interface and DUT
  dut_if dut_if1 ();
  dut    dut1 (.dif(dut_if1));

  // Create the clock generator
    // Never create the generator in a class based verification environment, must be in a module or interface
  initial begin
    // Initialize the clock
    dut_if1.clock = 0;
	// Forever pulse the clock with a period of (2 * 5) = 10
	  // Within the run phase of the test class we have a delay of 80 timeunits
	    // Within the DUT we have a procedural block that triggers a report message on each positive edge clock
		  // This means that there should be (80 / 10) = 8 user-defined report messages
    forever #5 dut_if1.clock = ~dut_if1.clock;
  end

  initial begin
    // Set the interface reference into the configuration database
		// The parameter must contain the type of data (aka configuration type) being stored
		// "...::set(...)" is a static function within the UVM configuration database class that stores data into the configuration database
		// Must pass the caller, path, name, and value
		  // The top module is not a component, so we use "null"
		  // In SystemVerilog, "null" is a pointer to an invalid address (usually 0x0); there is no OOP object to reference
		  // The path is a wildcard "*" indicating all lower hierarchical components have access to the data stored
		  // The name is the name of the configuration data we are storing
		  // The value is the variable containing the data to be stored
    uvm_config_db #(virtual dut_if)::set(null, "*", "dut_if", dut_if1);
    // Set the variable to end all procedures after simulation
	  // If this was not set, the clock generator would still be running endlessly
	  // "uvm_top" is a UVM implicit top-level global component within the UVM root class to serve as a parent to all components
	  // "finish_on_completion" is a UVM variable within the UVM root class; if set, then "run_test(...)" will call "$finish" after all phases have been executed
	  // In SystemVerilog, "$finish" is a system task that tells the simulator to terminate the current simulation
    uvm_top.finish_on_completion = 1;
    // Execute the UVM test
    run_test("my_test");
  end

endmodule: top
