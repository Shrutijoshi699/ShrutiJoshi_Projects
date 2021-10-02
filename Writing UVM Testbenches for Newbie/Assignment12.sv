`include "uvm_macros.svh"
import uvm_pkg::*;

module top
(
input [7:0] a,
input [7:0] b,
input [7:0] c,
output [7:0] y
);
 
assign y =  (a & b) | c;
 
endmodule

interface top_if();
logic [7:0] a;
logic [7:0] b;
logic [7:0] c;
logic [7:0] y;
endinterface

class transaction extends uvm_sequence_item;
rand bit [7:0] a;
rand bit [7:0] b;
rand bit [7:0] c;
rand bit [7:0] y;
`uvm_object_utils_begin(transaction)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_int(b,UVM_DEFAULT)
`uvm_field_int(c,UVM_DEFAULT)
`uvm_field_int(y,UVM_DEFAULT)
`uvm_object_utils_end
function new(input string inst="TRANS");
super.new(inst);
endfunction
endclass

class driver extends uvm_driver;
`uvm_component_utils(driver)
virtual top_if vif;
transaction t;
function new(input string inst="DRV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
if(!uvm_config_db #(virtual top_if)::get(this,"","vif",vif))
`uvm_info("DRV","Unable to read data",UVM_NONE);
endfunction
virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
t.randomize();
t.print();
vif.a=t.a;
vif.b=t.b;
vif.c=t.c;
phase.drop_objection(phase);
endtask
endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
uvm_analysis_port #(transaction) send;
virtual top_if vif;
transaction tr;
function new(input string inst="MON",uvm_component c);
super.new(inst,c);
send=new("WRITE",this);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
tr=transaction::type_id::create("TRANS",this);
if(!uvm_config_db #(virtual top_if)::get(this,"","vif",vif))
`uvm_info("MON","Unable to read data",UVM_NONE);
endfunction
virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
#10;
tr.a=vif.a;
tr.b=vif.b;
tr.c=vif.c;
tr.y=vif.y;
tr.print();
phase.drop_objection(phase);
endtask
endclass

class env extends uvm_env;
`uvm_component_utils(env)
driver d;
monitor m;
function new(input string inst="ENV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d=driver::type_id::create("DRV",this);
m=monitor::type_id::create("MON",this);
endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)
env e;
function new(input string inst="TEST",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e=env::type_id::create("ENV",this);
endfunction
endclass

module tb;
top_if vif();
top uut(.a(vif.a),.b(vif.b),.c(vif.c),.y(vif.y));
test t;
initial begin
t=new("TEST",null);
uvm_config_db #(virtual top_if)::set(null,"*","vif",vif);
run_test();
end
endmodule