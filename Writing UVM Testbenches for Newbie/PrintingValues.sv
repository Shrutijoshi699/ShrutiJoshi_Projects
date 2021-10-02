import uvm_pkg::*;
`include "uvm_macros.svh"

module tb;
  reg [4:0] a=5'b10110;
  integer i=12;
  
  initial begin
    `uvm_info("MODULE",$sformatf("value of a : %0b and i : %0d",a,i),UVM_NONE);
    `uvm_info("MODULE",$sformatf("decimal value of a :%0d and i :%0d",a,i),UVM_NONE);
  end 
endmodule