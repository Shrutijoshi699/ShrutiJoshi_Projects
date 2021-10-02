`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
bit [7:0] din = 8'h11;
`uvm_object_utils_begin(transaction)
`uvm_field_int(din,UVM_DEFAULT)
`uvm_object_utils_end
function new(input string name="TRANS");
super.new(name);
endfunction
endclass

class componentA extends uvm_component;
transaction t;
`uvm_component_utils(componentA)
uvm_blocking_put_port #(transaction) send;
function new(string name="COMPA",uvm_component c);
super.new(name,c);
send=new("PUT",this);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
endfunction
virtual task run();
t.randomize();
t.print();
send.put(t);
endtask
endclass

class componentB extends uvm_component;
`uvm_component_utils(componentB)
uvm_blocking_put_imp #(transaction,componentB) recv;
function new(string name="COMPB",uvm_component c);
super.new(name,c);
recv=new("RECV",this);
endfunction

virtual task put(transaction t);
t.print();
endtask
endclass

class env extends uvm_env;
`uvm_component_utils(env)
componentA ca;
componentB cb;
function new(string name="ENV",uvm_component c);
super.new(name,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
ca=componentA::type_id::create("COMPA",this);
cb=componentB::type_id::create("COMPB",this);
endfunction
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
ca.send.connect(cb.recv);
endfunction
endclass
class test extends uvm_test;
`uvm_component_utils(test)
env e;
function new(string name="TEST",uvm_component c);
super.new(name,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e=env::type_id::create("ENV",this);
endfunction
virtual task run_phase(uvm_phase phase);
#100;
global_stop_request();
endtask
endclass

module tb;
test t;
initial begin
t=new("TEST",null);
run_test();
end
endmodule