// Notes:
  // This example shows how to add a sequencer component that directs a sequence to generate transactions; these transactions contain constrained random stimulus

// Include the definitions for the UVM macros
`include "uvm_macros.svh"

// Create a package for easy import of all UVM components and/or objects
package my_pkg;

  // Import in the UVM base class library
  import uvm_pkg::*;

  // Create our own UVM transaction class/object
    // To do this we must inherit the UVM sequence item base component/class "uvm_sequence_item"
  class my_transaction extends uvm_sequence_item;
  
    // Register the UVM transaction class with the UVM factory
	  // "'uvm_object_utils(...)" is a UVM defined macro that allows UVM object registry with the factory
	    // A UVM transaction is a UVM object
	  // Pass in the class type name
    `uvm_object_utils(my_transaction)

    // Declare stimulus variables
	  // In SystemVerilog, "rand" is a type-modifier keyword used to declare a class variable as random
    rand bit cmd;
    rand int addr;
    rand int data;
    
	// Constraint the stimulus
	  // In SystemVerilog, "constraint" is a static data-type keyword used to declare constraints (aka constraint blocks) for variables declared as random
	    // Constraint blocks must each have a unique identifier or name
		// Constraint blocks must use curly braces
	  // In this case, we made constraints for the values within both "addr" and "data" to be in the range of 0-255
	    // Since we created these variables as 8 bit wide variables
    constraint c_addr { addr >= 0; addr < 256; }
    constraint c_data { data >= 0; data < 256; }
    
	// Override the constructor to create an OOP object
	  // Transactions are not components, so there is no parent
	  // Pass in a default string name
	    // Because UVM also builds transactions behind the scenes without giving them names
    function new (string name = "");
	  // Use the UVM base class constructor to create the OOP object
      super.new(name);
    endfunction
    
	// Override the convert to string method
	  // "convert2string" is a virtual function within the UVM object base class that allows the user to convert object data to a string
	  // In this case, we are converting transaction data to a string
    function string convert2string;
	  // Return a reformatted string of the transaction data
      return $sformatf("cmd=%b, addr=%0d, data=%0d", cmd, addr, data);
    endfunction

    // Override the copy method
	  // "do_copy(...)" is a virtual function within the UVM object base class that copies a specified object into another object
	  // In this case, we are copying the contents of an existing object into our transaction
	  // Pass in a UVM object class type variable
    function void do_copy(uvm_object rhs);
	  // Create a transaction class type variable
      my_transaction tx;
	  // Assign the superior UVM object class type variable to the subordinate transaction class type variable
	    // In SystemVerilog, "$cast" is a system task that assigns two different data type variables together when ordinary assignment is invalid
		  // This is called dynamic casting because it occurs during runtime and allows for error checking
		  // The system task will return a 1 if legal; otherwise, a 0 if it fails
		// In this case, we are basically doing "tx = rhs" which would normally be invalid
		  // Invalid because we cannot do child_class = parent_class; however, the opposite is valid
		  // "my_transaction" inherited "uvm_sequence_item" which inherited "uvm_transaction" which inherited "uvm_object"
      $cast(tx, rhs);
	  // Afterwards assign/copy the type casted objects to the class stimulus variables
      cmd  = tx.cmd;
      addr = tx.addr;
      data = tx.data;
    endfunction
    
	// Override the compare method
	  // "do_compare(...)" is a virtual function within the UVM object base class that compares members of this class with those of the object provided in the argument
	  // In this case, we are comparing the existing object with our current transaction
	  // Pass in a UVM object class type variable and a UVM comparer class type variable
	  // "uvm_comparer" is a UVM base class that provides a policy for doing comparisons
	    // We are not utilizing a policy in this example
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	  // Create a transaction class type variable
      my_transaction tx;
      // Declare and initialize a variable to determine if the comparisons match or mismatch
	    // This function has to return a 1 if all comparisons match; otherwise, a 0 for a comparison mismatch
      bit status = 1;
	  // Assign the superior UVM object class type variable to the subordinate transaction class type variable
      $cast(tx, rhs);
	  // Do comparisons for each stimulus variable
	    // If there is a mismatch, the status will update to a zero
		// In SystemVerilog, "&=" is an AND assignment operator that computes the bitwise AND between the left and right operands and assigns it to the left operand
		// In this case, the first comparison is equivalent to "status = status & (cmd == tx.cmd)"
      status &= (cmd  == tx.cmd);
      status &= (addr == tx.addr);
      status &= (data == tx.data);
	  // Return the result of the comparisons
      return status;
    endfunction

  endclass: my_transaction

  // Adopt the UVM sequencer component/class
    // In SystemVerilog, "typedef" is a keyword that allows users to define new data types
	// "uvm_sequencer" is a UVM class that builds the sequencer component
	  // Not a virtual class like the other components (except the driver) for this exact reason; so that we can create the very basic sequencer as is
	// We could create our own sequencer class/component by extending "uvm_sequencer"
      // But for this simple example that is not necessary, we will use the default UVM sequencer
	// Must pass in our transaction class type (aka UVM sequence item)
	  // The "uvm_sequencer" class has a "parameter type" in it's parameter list for the UVM sequence item
	// In SystemVerilog, "parameter type" is a keyword that has the same meaning as the "parameter" keyword but the purpose is to reassign a type instead of a value
	  // The "parameter" keyword is optional for both cases in the parameter list of a function or class definition
  typedef uvm_sequencer #(my_transaction) my_sequencer;

  // Create our UVM sequence class/object
    // To do this we must inherit the UVM virtual sequence component/class "uvm_sequence"
	// Must pass in our transaction class type (aka UVM sequence item)
	  // For both the "uvm_sequence" class and the "uvm_sequencer" class above the parameter list contains the following: "type REQ req = uvm_sequence_item"
	  // We are changing the type "REQ" to "my_transaction"; therefore, we now have "my_transaction req" where "req" is the variable name of our transaction class type
  class my_sequence extends uvm_sequence #(my_transaction);
  
    // Register the UVM sequence class with the UVM factory
    `uvm_object_utils(my_sequence)
    
	// Override the constructor to create an OOP object
    function new (string name = "");
	  // Use the superior UVM class constructor to create the OOP object
      super.new(name);
    endfunction

    // Define the behavior of the sequence
	  // Though not all sequences must generate a transaction, they must all have a task to define their behavior
    task body;
	  // Detect if the starting phase has been set
	    // "starting_phase" is a variable with the UVM sequence base class that reflects the current phase that this sequence was started in
		  // It looks like this method of detecting the phase is now obsolete; was replaced with "get_starting_phase" and "set_starting_phase"
		// The purpose of this detection is to make sure we are in the correct or desired phase to generate the transaction
		  // Remember that if the objection is never raised the transaction generation below will be skipped over
		  // If the objection is never dropped the transaction generation will keep generating endlessly
      if (starting_phase != null)
	    // Initiate the end-of-phase mechanism
		  // Typically, only the parent sequence needs the end-of-test mechanism
        starting_phase.raise_objection(this);

      // Generate transactions
	    // Looks like we are building 8 transactions
      repeat(8)
      begin
	    // Create the UVM transaction object by instantiation
          // Remember that "req" was defined by the inherited class
        req = my_transaction::type_id::create("req");
		// Initiate the operation of a sequence item
		  // "start_item" is a virtual task within the UVM sequence base class that is part of the process to intiate the operation of a sequence item
		    // Must be called with "finish_item" with no delay inbetween for UVM to properly operate the sequence item
		  // Pass in the transaction type variable
        start_item(req);
		// Randomize the stimulus within the transaction
		  // In SystemVerilog, "randomize(...)" is a pre-defined function that assigns random values to class variables
	        // This function behaves differently when called inside a class versus when called outside a class
		    // Inside: will randomize the class variable passed as an argument
		    // Outside (must use with a variable declared with the target class type): will randomize all variables declared as "rand" within the referenced class
	        // The function will return a zero if it fails to randomize; otherwise, a 1 is returned
        if( !req.randomize() )
		  // Report an error if the randomization fails
          `uvm_error("", "Randomize failed")
		// Finish initiating the operation of a sequence item
		  // Pass in the transaction type variable
        finish_item(req);
      end
      
	  // Detect if the starting phase has been set
      if (starting_phase != null)
	    // End the end-of-phase mechanism
        starting_phase.drop_objection(this);
    endtask: body
   
  endclass: my_sequence
  
  // Create our own UVM driver component/class
  class my_driver extends uvm_driver #(my_transaction);
  
    // Register the UVM driver class with the UVM factory
    `uvm_component_utils(my_driver)

    // Declare a virtual interface variable
    virtual dut_if dut_vi;

    // Override the constructor to create an OOP object and establish this class as the parent UVM driver component
    function new(string name, uvm_component parent);
	  // Use the UVM base class constructor to create the OOP object and establish this class as the parent UVM driver component
      super.new(name, parent);
    endfunction
    
	// Override the build phase to build the virtual interface
    function void build_phase(uvm_phase phase);
      // Get interface reference from the configuration database
      if( !uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut_vi) )
	    // Report an error if retrival from the configuration database fails
        `uvm_error("", "uvm_config_db::get failed")
    endfunction 
   
    // Override the run phase to generate random stimulus
    task run_phase(uvm_phase phase);
      forever
      begin
	    // Get the transaction from the sequencer
		  // "seq_item_port" is a port in the UVM driver base class that retrieves items from the sequencer
		  // "get_next_item(...)" is a virtual task from the UVM sequencer base class that retrieves the next available item from a sequence
		  // Must pass the transaction type variable
		  // This is also a method for handshaking with the sequencer
		    // A blocking method call; waits and only returns when item is retrieved
        seq_item_port.get_next_item(req);

        // Generate random stimulus
        @(posedge dut_vi.clock);
		// Update the virtual interface ports with random stimulus from the transaction
        dut_vi.cmd  = req.cmd;
        dut_vi.addr = req.addr;
        dut_vi.data = req.data;
        // Indicate that the handshaking with the sequencer is done
		  // "item_done()" is a virtual function from the UVM sequencer base class that indicates that the request is completed
        seq_item_port.item_done();
      end
    endtask

  endclass: my_driver
  
  // Create our own UVM environment component/class
  class my_env extends uvm_env;

    // Register the UVM environment class with the UVM factory
    `uvm_component_utils(my_env)
    
	// Declare the UVM driver class type variable and the UVM sequencer class type variable
    my_sequencer m_seqr;
    my_driver    m_driv;
    
	// Override the constructor to create an OOP object and establish this class as the parent UVM environment component
    function new(string name, uvm_component parent);
	  // Use the UVM base class constructor to create the OOP object and establish this class as the parent UVM environment component
      super.new(name, parent);
    endfunction
 
    // Override the build phase to build the components we desire
    function void build_phase(uvm_phase phase);
	  // Create the UVM sequencer component by instantiation
      m_seqr = my_sequencer::type_id::create("m_seqr", this);
	  // Create the UVM driver component by instantiation
      m_driv = my_driver   ::type_id::create("m_driv", this);
    endfunction
    
	// Override the connect phase to connect the components we desire
	  // "connect_phase(...)" is a virtual function within the UVM component base class that establishes cross-component connections
    function void connect_phase(uvm_phase phase);
	  // Connect the UVM sequencer component with the UVM driver component
	    // "connect(...)" is a virtual function of the UVM port component base class that connects two ports together
        // Must pass in the provider port
		  // In this case, it's the sequencer that is providing the transaction
        // "seq_item_export" is a port in the sequencer class that provides access to the sequencer
      m_driv.seq_item_port.connect(m_seqr.seq_item_export);
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
	  // Declare a UVM sequence class type variable
      my_sequence seq;
	  // Create the UVM sequence object by instantiation
      seq = my_sequence::type_id::create("seq");
	  // Randomize the sequence
	    // I believe this only applies if there are multiple sequences
		  // In this case, there is only one sequence
      if( !seq.randomize() ) 
	    // Report an error if the randomization fails
        `uvm_error("", "Randomize failed")
	  // Set the starting phase
	    // This is the same phase we used within the task body of the sequence
      seq.starting_phase = phase;
	  // Start the sequence
	    // "start(...)" is a virtual task within the UVM sequence base class that executes the sequence and returning when completed
		// Pass in the sequencer class type variable within the environment scope
		  // Because the sequencer is within the environment
      seq.start( m_env.m_seqr );
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
  initial
  begin
    // Initialize the clock
    dut_if1.clock = 0;
	// Forever pulse the clock with a period of (2 * 5) = 10
    forever #5 dut_if1.clock = ~dut_if1.clock;
  end

  initial
  begin
    // Set the interface reference into the configuration database
    uvm_config_db #(virtual dut_if)::set(null, "*", "dut_if", dut_if1);
    // Set the variable to end all procedures after simulation
    uvm_top.finish_on_completion = 1;
    // Execute the UVM test
    run_test("my_test");
  end

endmodule: top