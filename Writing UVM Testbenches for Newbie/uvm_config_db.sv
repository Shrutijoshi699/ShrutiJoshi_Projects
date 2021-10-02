`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
int d=12;//data to be stored in the data base
test t;
initial begin
t=new("TEST",null);
uvm_config_db #(int)::set(null,"*","data",d);//this is how to store data in db
run_test();
end
endmodule

class test extends uvm_test;
`uvm_component_utils(test)
int data;
function new(input string inst="TEST",uvm_component c);
super.new(inst,c);
endfunction

//build phase has get method to retrieve te data
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!(uvm_config_db #(int)::get(this,"","data",data)))
`uvm_info("TEST","Unable to read db",UVM_NONE);
endfunction

virtual task run_phase(uvm_phase phase);
`uvm_info("TEST",$sformatf("Value read : %0d",data),UVM_NONE);
endtask
endclass
