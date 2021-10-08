// A good verilog reference: http://referencedesigner.com/tutorials/index.php
  // Used to find information on the system tasks below

`timescale 1ns/1ps

module adder #(
  parameter integer DATA_WIDTH = 4
) (
  input  logic unsigned [DATA_WIDTH-1:0] A,
  input  logic unsigned [DATA_WIDTH-1:0] B,
  output logic unsigned [DATA_WIDTH:0]   X
);

  assign X = A + B;

  // Code needed to create VCD waveform file (aka GTKWave waveform)
    // This code is to be in the top-level component
    // The following code makes this hdl non-synthesizable; since it has to use a "initial" procedural block
  initial begin
    // "$dumpfile" is a verilog system task that is used to dump the changes in the values of nets and registers in a file that is named as it's argument
      // The only argument is the desired filename to dump the signals into
    $dumpfile("dump.vcd");
    // "$dumpvars" is a verilog system task that is used to specify which variables are to be dumped (in the file mentioned by $dumpfile)
      //  The simplest way to use it is without any arguments
      //  The first argument determines which variables to dump into the file
        // 0 - Dump all variables; even the variables below this top-level component
        // 1 - Dump only the variables within this module
        // 2 - Dump only the variables within this module and only 1 level below (aka the instantiations within this module)
      // The second argument is the module name that contains the desired variables to dump
      // There can be a third argument; which is a module name (that contains desirable variables to dump) that isn't instantiated by the module in the second argument
    $dumpvars(1, adder);
  end

endmodule
