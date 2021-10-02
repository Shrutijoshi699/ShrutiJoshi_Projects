import uvm_pkg::*;
`include "uvm_macros.svh"

class transaction extends uvm_sequence_item;
  rand bit [3:0] a;
  rand bit [4:0] b;
  rand bit [7:0] c;
  
  function new(input string inst="TRANS");
  super.new(inst);//call to constructor of uvm_sequence_item
  endfunction
  `uvm_object_utils_begin(transaction)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_int(b,UVM_DEFAULT)
`uvm_field_int(c,UVM_DEFAULT)
`uvm_object_utils_end
endclass

module tb;
transaction t;
reg w=0;
initial begin
  t=new("TRANS");
  w=t.randomize();
  t.print();
  t.print(uvm_default_line_printer);
end
endmodule
