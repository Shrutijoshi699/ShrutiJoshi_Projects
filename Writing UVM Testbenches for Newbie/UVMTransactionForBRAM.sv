`include "uvm_macros.svh"
import uvm_pkg::*;

module bram(
input [7:0] din,
input [11:0] addr,
input wr,
input clk,
input rst,
output [7:0] dout);
endmodule

class transaction extends uvm_sequence_item;
rand bit [7:0] din;
rand bit [11:0] addr;
rand bit wr;
rand bit clk;
rand bit rst;
bit [7:0] dout;

`uvm_object_utils_begin(transaction)
`uvm_field_int(din,UVM_DEFAULT)
`uvm_field_int(addr,UVM_DEFAULT)
`uvm_field_int(wr,UVM_DEFAULT)
`uvm_field_int(clk,UVM_DEFAULT)
`uvm_field_int(rst,UVM_DEFAULT)
`uvm_field_int(dout,UVM_DEFAULT)
`uvm_object_utils_end

function new(string name="SEQ");
super.new(name);
endfunction
endclass

//uvm_test-->uvm_component
class test extends uvm_test;
`uvm_component_utils(test)

function new(string name="TEST",uvm_component p=null);
super.new(name,p);
endfunction

virtual task run();
transaction trans=new();
trans.randomize();
trans.print(uvm_default_line_printer);
endtask

endclass

module tb;
test t;
initial begin
t=new();
run_test();
end
endmodule
