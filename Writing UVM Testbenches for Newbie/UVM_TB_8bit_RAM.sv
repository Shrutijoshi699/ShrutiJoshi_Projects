module ram(
input clk,wr,
input [7:0] din,
output reg[7:0] dout,
input[3:0]addr);
reg [7:0]mem[15:0];
integer i;
initial begin
for(i=0;i<16;i++) begin
mem[i]=0;
end
end

always@(posedge clk)begin
if(wr)
mem[addr]<=din;
else
dout<=mem[addr];
end
endmodule

interface ram_if();
logic clk;
logic wr;
logic [7:0] din;
logic [7:0] dout;
logic[3:0]addr;
endinterface

`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
rand bit wr;
rand bit [7:0] din;
bit [7:0] dout;
rand bit[3:0]addr;
constraint addr_c{addr>2;addr<8;};
`uvm_object_utils_begin(transaction)
`uvm_field_int(wr,UVM_DEFAULT);
`uvm_field_int(din,UVM_DEFAULT);
`uvm_field_int(dout,UVM_DEFAULT);
`uvm_field_int(addr,UVM_DEFAULT);
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
for(i=0;i<50;i++) begin
start_item(t);
t.randomize();
`uvm_info("GEN","Data sent to driver",UVM_NONE);
t.print(uvm_default_line_printer);
finish_item(t);
#20;
end
endtask
endclass

class driver extends uvm_driver #(transaction);
`uvm_component_utils(driver)
transaction t;
virtual ram_if vif;
function new(input string inst="DRV",uvm_component c);
super.new(inst,c);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS");
if(!uvm_config_db #(virtual ram_if)::get(this,"","vif",vif))
`uvm_info("DRV","Unable to read data",UVM_NONE);
endfunction
virtual task run_phase(uvm_phase phase);
forever begin
seq_item_port.get_next_item(t);
vif.wr=t.wr;
vif.din=t.din;
vif.addr=t.addr;
`uvm_info("DRV","Trigger DUT",UVM_NONE);
t.print(uvm_default_line_printer);
seq_item_port.item_done(t);
@(posedge vif.clk);
if(t.wr==1'b0)
@(posedge vif.clk);
end 
endtask
endclass

class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
uvm_analysis_port #(transaction) send;
transaction t;
virtual ram_if vif;
function new(input string inst="MON",uvm_component c);
super.new(inst,c);
send=new("WRITE",this);
endfunction
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS");
if(!uvm_config_db #(virtual ram_if)::get(this,"","vif",vif))
`uvm_info("MON","Unable to read data",UVM_NONE);
endfunction
virtual task run_phase(uvm_phase phase);
forever begin
@(posedge vif.clk);
t.wr=vif.wr;
t.din=vif.din;
t.addr=vif.addr;
if(vif.wr==1'b0)begin
@(posedge vif.clk);
t.dout=vif.dout;
end
`uvm_info("MON","Data sent to scoreboard",UVM_NONE);
send.write(t);
end
endtask
endclass

class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

reg[7:0] tarr[20]='{default:0};
uvm_analysis_imp #(transaction,scoreboard) recv;
function new(input string inst="SCO",uvm_component c);
super.new(inst,c);
recv=new("READ",this);
endfunction
/*virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
t=transaction::type_id::create("TRANS",this);
endfunction*/
virtual function void write(input transaction data);
`uvm_info("SCO","Data received from monitor",UVM_NONE);
data.print(uvm_default_line_printer);
if(data.wr==1'b1)begin
tarr[data.addr]=data.din;
`uvm_info("SCO",$sformatf("Data write : din : %0h and tarr[addr] :%0h",data.din,tarr[data.addr]),UVM_NONE);
end
if(data.wr==0)begin
`uvm_info("SCO",$sformatf("Data read : dout : %0h and tarr[addr] : %0h",data.dout,tarr[data.addr]),UVM_NONE);
if(data.dout==tarr[data.addr])begin
`uvm_info("SCO","Test Passed",UVM_NONE);end
else begin
`uvm_error("SCO","Test Failed");
`uvm_info("SCO",$sformatf("Data read : dout : %0h and tarr[addr] : %0h",data.dout,tarr[data.addr]),UVM_NONE);end
end
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
phase.raise_objection(this);
g.start(e.a.sequencer);
phase.drop_objection(this);
endtask
endclass

module tb;
test t;
ram_if vif();
ram uut(.clk(vif.clk),.wr(vif.wr),.din(vif.din),.dout(vif.dout),.addr(vif.addr));
initial begin
vif.clk=0;
end
always#10 vif.clk=~vif.clk;
initial begin
t=new("TEST",null);
uvm_config_db #(virtual ram_if)::set(null,"*","vif",vif);
run_test();
end

endmodule