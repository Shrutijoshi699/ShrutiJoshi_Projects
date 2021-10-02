import uvm_pkg::*;
`include "uvm_macros.svh"

module tb;
  reg [3:0] a = 4'b1010;
  reg [15:0 ] b = 16'h1122;
  integer c = 12;
  reg d = 1;
  
  initial begin
    `uvm_info("MODULE",$sformatf("value of a : %0h,value of b : %0h,value of c : %0h and d : %0h",a,b,c,d),UVM_NONE);
   
  end 
endmodule
