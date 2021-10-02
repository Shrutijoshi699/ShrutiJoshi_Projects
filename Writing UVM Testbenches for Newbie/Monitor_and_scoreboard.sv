`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
bit[3:0]a=4'b1010;
bit[3:0]b=4'b1000;
bit[4:0]y=5'b10010;
function new(input string inst="TRANS");
super.new(inst);
endfunction
`uvm_object_utils_begin(transaction)
`uvm_field_int(a,UVM_DEFAULT)
`uvm_field_int(b,UVM_DEFAULT)
`uvm_field_int(y,UVM_DEFAULT)
`uvm_object_utils_end
endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
transaction t;
uvm_analysis_port #(transaction) send;
function new(input string inst="MON",uvm_component c);
super.new(inst,c);
send=new("WRITE",this);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
endfunction

virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
send.write(t);
`uvm_info("MON","Data sent to scoreboard",UVM_NONE);
#10;
phase.drop_objection(phase);
endtask
endclass

class scoreboard extends uvm_component;
`uvm_component_utils(scoreboard)
transaction data;
uvm_analysis_imp #(transaction,scoreboard) recv;

function new(input string inst="SCO",uvm_component c);
super.new(inst,c);
recv=new("READ",this);//name given w.r.t the implementation of analysis port
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
data=transaction::type_id::create("TRANS",this);
endfunction
virtual function void write(input transaction t);
data=t;
endfunction
virtual task run_phase(uvm_phase phase);
forever begin
#10;
if(data.y==data.a+data.b) begin
`uvm_info("SCO","Test Passed",UVM_NONE);
end
else begin
`uvm_info("SCO","Test Failed",UVM_NONE);
end
end
endtask
endclass 

class env extends uvm_env;
`uvm_component_utils(env)
monitor m;
scoreboard s;

function new(string inst="ENV",uvm_component c);
super.new(inst,c);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
m=monitor::type_id::create("MON",this);
s=scoreboard::type_id::create("SCO",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
m.send.connect(s.recv);
endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)
env e;
function new(string inst="TEST",uvm_component c);
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