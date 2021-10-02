`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;

rand bit[3:0] a;
rand bit[7:0] b;

`uvm_object_utils_begin(transaction)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_int(b,UVM_DEFAULT)
`uvm_object_utils_end

function new(input string inst="TRAN");
super.new(inst);
endfunction
endclass

class producer extends uvm_component;
`uvm_component_utils(producer)
transaction t;
integer i;
//adding blocking port
uvm_blocking_put_port #(transaction) send;
function new(string name="PROD",uvm_component c);
super.new(name,c);
send=new("PUT",this);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
for(i=0;i<10;i++) begin
t.randomize();
`uvm_info("PROD","Sending data to consumer",UVM_NONE);
t.print(uvm_default_line_printer);
send.put(t);
end
phase.drop_objection(phase);
endtask
/*
task run();
t.randomize();
t.print();
send.put(t);
endtask
*/
endclass

class consumer extends uvm_component;
`uvm_component_utils(consumer)
uvm_blocking_put_imp #(transaction,consumer)  recv;
function new(string name="CONS",uvm_component c);
super.new(name,c);
recv=new("RECV",this);
endfunction

virtual task put(transaction t);
`uvm_info("CONS","Recvd data from producer",UVM_NONE);
t.print(uvm_default_line_printer);
endtask
endclass  

class env extends uvm_env;
`uvm_component_utils(env)
producer p;
consumer c;

function new(string name="ENV",uvm_component c);
super.new(name,c);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
p=producer::type_id::create("PROD",this);
c=consumer::type_id::create("CONS",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
p.send.connect(c.recv);
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
/*
virtual task run_phase(uvm_phase phase);
#100;
global_stop_request();
endtask
*/
endclass

module tb;
test t;
initial begin
t=new("TEST",null);
run_test();
end
endmodule