`include "uvm_macros.svh"
import uvm_pkg::*;

class assignment3 extends uvm_object;

bit [3:0] a;
rand bit [7:0] b;
rand bit [15:0] c;
string inst;

function new(string inst="INST");
super.new(inst);
this.inst=inst;
endfunction

`uvm_object_utils_begin(assignment3)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_int(b,UVM_DEFAULT)
`uvm_field_int(c,UVM_DEFAULT)
`uvm_object_utils_end

endclass

module tb;
assignment3 a3;
reg r=0;
initial begin
a3=new("INST");
r=a3.randomize();
a3.print();
end 
endmodule
