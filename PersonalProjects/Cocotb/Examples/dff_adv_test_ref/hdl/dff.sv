`timescale 1ns/1ps

module dff (c,d,q);
   input wire c, d;
   output reg q = 1'b0;

   always @(posedge c)
     begin
	// It is also possible to add an delay of less than one clock period
	// here.
	q <= d;
     end

endmodule // dff
