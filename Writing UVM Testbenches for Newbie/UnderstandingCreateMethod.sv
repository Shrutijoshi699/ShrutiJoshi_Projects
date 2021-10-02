
`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_object;

//data members
rand bit[3:0] a;
rand bit [3:0] b[4];//array of 4 elements
string inst;
//constructor
function new(input string inst="INST");
super.new(inst);
this.inst=inst;
endfunction
/*
virtual function void do_print(uvm_printer printer);
super.do_print(printer);
printer.print_field_int("a",a,$bits(a),UVM_DEC);
printer.print_string("Inst",inst);
endfunction
*/
//registering data members to the factory using macro

`uvm_object_utils_begin(simple)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_sarray_int(b,UVM_DEFAULT)
`uvm_field_string(inst,UVM_DEFAULT)
`uvm_object_utils_end


endclass

class test extends uvm_test;

`uvm_component_utils(test)

function new(input string name,uvm_component c);
super.new(name,c);
endfunction

function void build_phase(uvm_phase phase);
reg r;
simple s=simple::type_id::create("INST");
r=s.randomize();
s.print();
endfunction

endclass

module tb;
test t;
initial begin
t=new("Test",null);
run_test();
end
endmodule

 
