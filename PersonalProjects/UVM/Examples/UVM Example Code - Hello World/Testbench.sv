// Notes: 
  // This example shows the absolute basics of how to create a UVM verification environment
  // UVM utilizes SystemVerilog OOP (Object-Oriented Programming) instead of SystemVerilog POP (Procedural-Oriented Programming)
  // SystemVerilog POP is what we use for RTL
  // Don't confuse UVM objects with objects of OOP; from henceforth UVM objects will be referred to as objects unless explicitly stated otherwise (Ex. OOP object)
  // Methods is an umbrella term for tasks and functions

// Include the definitions for the UVM macros
`include "uvm_macros.svh"

// Create a package for easy import of all UVM components and/or objects
package my_pkg;

  // Import in the UVM base class library
    // Wildcard importing imports only the used elements
	  // For this reason we cannot "export" this package and do package chaining 
  import uvm_pkg::*;

  // Create our own UVM environment component/class
    // To do this we must inherit the UVM virtual base environment component/class "uvm_env"
	// In SystemVerilog, a "virtual" class is a class that must be extended in order to be functional
	  // Virtual classes cannot be constructed or instantiated
	  // The purpose of virtual classes is to serve as a template or prototype for extended classes
	// Most all UVM classes are virtual classes except for the sequencer and driver
	  // The sequencer for good reason, the driver not so much
    // In SystemVerilog, "extends" is a keyword allows the inheritance of another class
  class my_env extends uvm_env;

    // Register the UVM environment class with the UVM factory
	  // The factory allows the user to override the default components and/or objects with their own
	    // The factory automation makes utilizing UVM much easier, flexible, and reusable
	  // "'uvm_component_utils(...)" is a UVM defined macro that allows component registery with the factory
	  // Pass in the class type name
    `uvm_component_utils(my_env)
    
	// Override the constructor to create an OOP object and establish this class as the parent UVM environment component
	  // In SystemVerilog, "new(...)" is a mandatory function (aka constructor) in every class that is automatically executed during instantiation
	    // Constructors is native to OOP
	  // Pass in the desired component name and a variable to reference this particular class as the parent component
	  // "uvm_component" is a UVM base class that defines everything (hierarchy, phasing, etc.) about UVM components
	    // We are declaring a variable of this type to inform UVM that this particular class will be a parent component
    function new(string name, uvm_component parent);
	  // Use the UVM base class constructor to create the OOP object and establish this class as the parent UVM environment component
	    // Passing in the same two arguments passed in the constructor above will reference this particular class as the parent component
		// In SystemVerilog, "super" is a pre-defined class variable that references the super of a sub-class
	      // "super" is used when the sub-class overrides properties/methods of the base class, but you need to use the original property/method instead
		// In this case, we overrode the constructor within this sub-class but we need the base class constructor instead
		// In other words, this is just a chain of constructors to automatically point to the original constructor which actually creates the OOP object
      super.new(name, parent);
    endfunction
 
  endclass: my_env
  
  // Create our own UVM test component/class
    // To do this we must inherit the UVM virtual base test component/class "uvm_test"
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
	  // The build phase is the first phase within the UVM that signifies the building of the UVM components
	  // "build_phase(...)" is a virtual function within the UVM component base class that creates and configures the testbench structure
	  // "uvm_phase" is a UVM base class that defines everything (behavior, state, and context) about a phase
	    // We are declaring a variable of this type to inform UVM the identity (behavior, state, and context) of the phase
    function void build_phase(uvm_phase phase);
	  // Create the UVM environment component by instantiation
	    // "...type_id::create(...)" is a static method within the UVM default factory class that creates the component or object
		// Must pass the desired component name and a reference to the component/class
		// In SystemVerilog, "this" is a pre-defined class variable that references the instance/class in which it is invoked
		// In SystemVerilog, "::" is the scope resolution operator
		  // Used to traverse scopes
		// "my_env::type_id::create(...)" is within the scope of the UVM environment class we created thanks to the UVM factory
		  // Translates to: use the "create(...)" within the scope of "type_id" which is within the scope of class "my_env"
		// In other words, we are referencing the UVM environment class to create the UVM environment component
      m_env = my_env::type_id::create("m_env", this);
    endfunction
    
	// Override the run phase to run the simulation we desire
	  // The run phase is the fifth phase within the UVM that signifies the running of the simulation
	  // "run_phase(...)" is a UVM base class task to actually execute the simulation
	    // Of the phases within UVM the run phase is the only SystemVerilog task; the rest are SystemVerilog functions
	  // In SystemVerilog, "task" and "function" both make it possible to partition complex functionality into smaller, reusable blocks of code
	    // A "function" is required to run in zero simulation time and a "task" can have simulation delays
		// Primarily, only functions are used in RTL while both tasks and functions are used in verification
      // Therefore the run phase is the only UVM phase that consumes time
    task run_phase(uvm_phase phase);
	  // Initiate the end-of-test mechanism
	    // "raise_objection(...)" is a virtual function within the UVM objection class that raises an objection
		// An objection must be raised in order to tell the UVM environment to run the simulation
		// If the objection is never raised the simulation will be skipped over as if it was already executed
      phase.raise_objection(this);
	  // Insert arbitrary code to perform the simulation
	  // Delay for 10 timeunits
      #10;
	  // Print Hello World info report
	    // "'uvm_info" is a UVM report macro used for reporting messages to the user
		  // There are four report macros with different severity levels
		    // From low to high severity: "'uvm_info", "'uvm_warning", "'uvm_error", "'uvm_fatal"
	      // The arguments from left to right are string ID, string, and verbosity
		    // In SystemVerilog, "" is an empty string; so the string ID is blank
	    // "UVM_MEDIUM" is a UVM enumerated value to establish the verbosity level
		  // There are six UVM enumerated values with different verbosity levels 
		    // From low to high verbosity: "UVM_NONE", "UVM_LOW", "UVM_MEDIUM", "UVM_HIGH", "UVM_FULL", "UVM_DEBUG"
	    // Filtering of report messages can be done by setting severity and verbosity levels 
      `uvm_info("", "Hello World", UVM_MEDIUM)
	  // End the end-of-test mechanism
	    // "drop_objection(...)" is a virtual function within the UVM objection class that drops a previously raised objection
		// Once the objection is dropped the UVM environment knows to stop the simulation
		// If the objection is never dropped the simulation will run endlessly
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
    // Note that the DUT module instance has the interface instance name in the port list
	  // This connects the interface to the DUT
  dut_if dut_if1();
  dut    dut1(.dif(dut_if1));

  // Create a procedural block for UVM execution
  initial begin
    // Execute the UVM test
	  // "run_test(...)" is a global task within the UVM root class that phases all components through all registered phases
	  // Pass in the test class type name
    run_test("my_test");
  end

endmodule: top
