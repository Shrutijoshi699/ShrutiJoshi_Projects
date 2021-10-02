`timescale 1ns/1ps


module au
(
  input [1:0] mode,
  input [3:0] a,b,
  output reg [7:0] y
);
  
  always@(*)
    begin
      case(mode)
        2'b00: y = a + b;
        2'b01: y = a - b;
        2'b10: y = a * b;
        2'b11: y = a / b;
      endcase
    end
endmodule  

interface au_if();
logic [1:0] mode;
logic [3:0] a;
logic [3:0] b;
logic [7:0] y;
endinterface 

`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
rand bit [1:0] mode;
rand bit  [3:0] a;
rand bit  [3:0] b;
bit [7:0] y;
`uvm_object_utils_begin(transaction)
`uvm_field_int(mode,UVM_DEFAULT);
`uvm_field_int(a,UVM_DEFAULT);
`uvm_field_int(b,UVM_DEFAULT);
`uvm_field_int(y,UVM_DEFAULT);
`uvm_object_utils_end
function new(input string inst="TRANS");
super.new(inst);
endfunction
endclass

class generator extends uvm_sequence#(transaction);
`uvm_object_utils(generator)
transaction t;
integer i;
function new(input string inst="GEN");
super.new(inst);
endfunction
virtual task body();
t=transaction::type_id::create("TRANS");
for(i=0;i<10;i++) begin
start_item(t);
t.randomize();
`uvm_info("GEN","Data sent to driver",UVM_NONE);
t.print(uvm_default_line_printer);
#10;
finish_item(t);
end
endtask
endclass

class driver extends uvm_driver #(transaction);
`uvm_component_utils(driver)
transaction t;
virtual au_if vif;
function new(input string inst="DRV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
if(!uvm_config_db #(virtual au_if)::get(this,"","vif",vif))
`uvm_info("DRV","Unable to read data",UVM_NONE);
endfunction
virtual task run_phase(uvm_phase phase);
forever begin
seq_item_port.get_next_item(t);
vif.mode=t.mode;
vif.a=t.a;
vif.b=t.b;
`uvm_info("DRV","Trigger DUT",UVM_NONE);
t.print(uvm_default_line_printer);
seq_item_port.item_done();
end 
endtask
endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
uvm_analysis_port #(transaction) send;
transaction t;
virtual au_if vif;
function new(input string inst="MON",uvm_component c);
super.new(inst,c);
send=new("WRITE",this);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
if(!uvm_config_db #(virtual au_if)::get(this,"","vif",vif))
`uvm_info("DRV","Unable to read data",UVM_NONE);
endfunction
virtual task run_phase(uvm_phase phase);
forever begin
#10;
t.mode=vif.mode;
t.a=vif.a;
t.b=vif.b;
t.y=vif.y;
`uvm_info("MON","Data sent to scoreboard",UVM_NONE);
send.write(t);
end
endtask
endclass

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
transaction t;
uvm_analysis_imp #(transaction,scoreboard) recv;
function new(input string inst="SCO",uvm_component c);
super.new(inst,c);
recv=new("READ",this);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
endfunction
virtual function void write(input transaction t);
t.print(uvm_default_line_printer);
`uvm_info("SCO","Data received from monitor",UVM_NONE);
if(t.mode==2'b00 && t.y==t.a+t.b) begin
`uvm_info("SCO","Test Passed",UVM_NONE);end
else if(t.mode==2'b01 && t.y==t.a-t.b)begin
`uvm_info("SCO","Test Passed",UVM_NONE);end
else if(t.mode==2'b10 && t.y==t.a*t.b)begin
`uvm_info("SCO","Test Passed",UVM_NONE);end
else if(t.mode==2'b11 && t.y==t.a/t.b)begin
`uvm_info("SCO","Test Passed",UVM_NONE);end
else begin
`uvm_info("SCO","Test Failed",UVM_NONE);end
endfunction
endclass

class agent extends uvm_agent;
`uvm_component_utils(agent)
driver d;
monitor m;
uvm_sequencer #(transaction) sequencer;
function new(input string inst="AGENT",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d=driver::type_id::create("DRV",this);
m=monitor::type_id::create("MON",this);
sequencer=uvm_sequencer #(transaction)::type_id::create("SEQ",this);
endfunction
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(sequencer.seq_item_export);
endfunction
endclass

class env extends uvm_env;
`uvm_component_utils(env)
scoreboard s;
agent a;
function new(input string inst="ENV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
s=scoreboard::type_id::create("SCO",this);
a=agent::type_id::create("AGENT",this);
endfunction
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
a.m.send.connect(s.recv);
endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)
env e;
generator g;
function new(input string inst="TEST",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
e=env::type_id::create("ENV",this);
g=generator::type_id::create("GEN",this);
endfunction
virtual task run_phase(uvm_phase phase);
phase.raise_objection(phase);
#10;
g.start(e.a.sequencer);
phase.drop_objection(phase);
endtask
endclass

module tb;
test t;
au_if vif();
au uut(.mode(vif.mode),.a(vif.a),.b(vif.b),.y(vif.y));
initial begin
t=new("TEST",null);
uvm_config_db #(virtual au_if)::set(null,"*","vif",vif);
run_test();
end
endmodule