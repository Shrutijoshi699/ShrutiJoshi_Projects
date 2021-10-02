`include "uvm_macros.svh"
import uvm_pkg::*;


module counter
(
input [3:0] mode,
input rst,
input clk,
input [15:0] loaddata,
input loadin,
output [15 : 0] dout
);
endmodule

class transaction extends uvm_sequence_item;

rand bit [3:0] mode;
rand bit rst;
rand bit clk;
rand bit [15:0] loaddata;
rand bit loadin;
bit [15 : 0] dout;

`uvm_object_utils_begin(transaction)
`uvm_field_int(mode,UVM_DEFAULT)
`uvm_field_int(rst,UVM_DEFAULT)
`uvm_field_int(clk,UVM_DEFAULT)
`uvm_field_int(loaddata,UVM_DEFAULT)
`uvm_field_int(loadin,UVM_DEFAULT)
`uvm_field_int(dout,UVM_DEFAULT)
`uvm_object_utils_end

function new(string name="TRANS");
super.new(name);
endfunction

endclass

class test extends uvm_component;

`uvm_component_utils(test)

function new(string name="TEST",uvm_component p=null);
super.new(name,p);
endfunction

virtual task run();
transaction t=new();
t.randomize();
t.print();
endtask
endclass

module tb;
test t;
initial begin
t=new();
run_test();
end
endmodule
