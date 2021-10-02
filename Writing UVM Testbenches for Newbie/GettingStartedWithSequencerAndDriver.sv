`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
rand bit[3:0]a;
rand bit[7:0]b;
rand bit[7:0]c;
function new(input string inst="TRANS");
super.new(inst);
endfunction
//using macros to register the data
`uvm_object_utils_begin(transaction)
`uvm_field_int(a,UVM_DEFAULT);
`uvm_field_int(b,UVM_DEFAULT);
`uvm_field_int(c,UVM_DEFAULT);
`uvm_object_utils_end
endclass

class generator extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
transaction t;
function new(input string inst="GEN");
super.new(inst);
endfunction
virtual task body();
t=transaction::type_id::create("TRANS");
start_item(t);
t.randomize();
t.print();
finish_item(t);
`uvm_info("GEN","Data sent to driver",UVM_NONE);
endtask
endclass

class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
transaction t;
function new(input string inst="DRV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS");
endfunction
virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
seq_item_port.get_next_item(t);
`uvm_info("DRV","recvd data frm sequencer",UVM_NONE);
t.print();
seq_item_port.item_done();
phase.drop_objection(phase);
endtask
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)
driver d;
uvm_sequencer #(transaction) sequencer;
function new(input string inst="AGENT",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d=driver::type_id::create("DRV",this);
sequencer=uvm_sequencer #(transaction)::type_id::create("SEQ",this);
endfunction
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(sequencer.seq_item_export);
endfunction
endclass

class env extends uvm_env;
`uvm_component_utils(env)
agent a;
function new(input string inst="ENV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
a=agent::type_id::create("AGENT",this);
endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)
function new(input string inst="TEST",uvm_component c);
super.new(inst,c);
endfunction
generator g;
env e;
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e=env::type_id::create("ENV",this);
g=generator::type_id::create("GEN",this);
endfunction
virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
g.start(e.a.sequencer);
phase.drop_objection(phase);
endtask
endclass

module tb;
test t;
initial begin
t=new("TEST",null);
run_test();
end
endmodule