`timescale 1ps/1ps

module dff (
	input D, clk, rstN,
	output reg Q
);

always @(posedge clk or negedge rstN) begin
	if(!rstN)
		Q <= 0;
	else
		Q <= D;
end

// Snippet of non-synthesizable code needed to create VCD waveform file (aka GTKWave waveform)
initial begin
  $dumpfile ("dff.vcd");  // The arugment to the system task is the desired filename to dump the variables into
  $dumpvars (0, dff);     // Include all variables (first argument "0") and which module (module name "dff") has the variables to dump
end

endmodule
