`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
 bit[1:0] a = 2'b11;
 bit [3:0] b = 4'b0100;
 bit c = 1'b1;
`uvm_object_utils_begin(transaction)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_int(b,UVM_DEFAULT)
`uvm_field_int(c,UVM_DEFAULT)
`uvm_object_utils_end
function new(input string inst="TRANS");
super.new(inst);
endfunction
endclass

class producer extends uvm_component;
`uvm_component_utils(producer)
uvm_analysis_port #(transaction) send;
transaction t;
integer i;
function new(input string inst="PROD",uvm_component c);
super.new(inst,c);
send=new("WRITE",this);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
for(i=0;i<10;i++) begin
`uvm_info("PROD","Data sent",UVM_NONE);
t.randomize();
t.print(uvm_default_line_printer);
send.write(t);
end
phase.drop_objection(phase);
endtask
endclass

class subscriber1 extends uvm_component;
`uvm_component_utils(subscriber1)
uvm_analysis_imp #(transaction,subscriber1) recv;
function new(input string inst="SUB1",uvm_component c);
super.new(inst,c);
recv=new("READ",this);
endfunction
virtual function void write(transaction t);
`uvm_info("SUB1","Data recv",UVM_NONE);
t.print(uvm_default_line_printer);
endfunction
endclass

class subscriber2 extends uvm_component;
`uvm_component_utils(subscriber2)
uvm_analysis_imp #(transaction,subscriber2) recv;
function new(input string inst="SUB2",uvm_component c);
super.new(inst,c);
recv=new("READ",this);
endfunction
virtual function void write(transaction t);
`uvm_info("SUB2","Data recv",UVM_NONE);
t.print(uvm_default_line_printer);
endfunction
endclass

class subscriber3 extends uvm_component;
`uvm_component_utils(subscriber3)
uvm_analysis_imp #(transaction,subscriber3) recv;
function new(input string inst="SUB1",uvm_component c);
super.new(inst,c);
recv=new("READ",this);
endfunction
virtual function void write(transaction t);
`uvm_info("SUB3","Data recv",UVM_NONE);
t.print(uvm_default_line_printer);
endfunction
endclass

class env extends uvm_env;
`uvm_component_utils(env)
producer p;
subscriber1 s1;
subscriber2 s2;
subscriber3 s3;
function new(input string inst="ENV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
p=producer::type_id::create("PROD",this);
s1=subscriber1::type_id::create("SUB1",this);
s2=subscriber2::type_id::create("SUB2",this);
s3=subscriber3::type_id::create("SUB3",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
p.send.connect(s1.recv);
p.send.connect(s2.recv);
p.send.connect(s3.recv);
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
test t;
initial begin
t=new("TEST",null);
run_test();
end
endmodule