`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
`uvm_component_utils(producer)
reg [7:0] a=8'h12;
reg [15:0] b=16'hffff;
reg [3:0] c=4'hf;
//adding blocking port
uvm_blocking_put_port #(reg[7:0]) send1;
uvm_blocking_put_port #(reg[15:0]) send2;
uvm_blocking_put_port #(reg[3:0]) send3;
function new(string name="PROD",uvm_component c);
super.new(name,c);
send1=new("SEND1",this);
send2=new("SEND2",this);
send3=new("SEND3",this);
endfunction


task run();
`uvm_info("PROD",$sformatf("Data send a : %0x, b : %0x and c : %0x",a,b,c),UVM_NONE);
send1.put(a);
send2.put(b);
send3.put(c);
endtask

endclass

class consumer extends uvm_component;
 
 
`uvm_component_utils(consumer)
`uvm_blocking_put_imp_decl(_1)
`uvm_blocking_put_imp_decl(_2)
`uvm_blocking_put_imp_decl(_3)
 
 
 
  uvm_blocking_put_imp_1 #(reg[7:0],consumer) recv1;
  uvm_blocking_put_imp_2 #(reg[15:0],consumer) recv2;
  uvm_blocking_put_imp_3 #(reg[3:0],consumer) recv3;
 
  
function new(input string inst="CONS",uvm_component c);
super.new(inst,c);
    recv1=new("RECV1",this);
    recv2=new("RECV2",this);
    recv3=new("RECV3",this);
endfunction
 
 
virtual task put_1(input reg[7:0] x );
    `uvm_info("CONS:RECV1",$sformatf("the data is received  : %0d ",x),UVM_NONE)
endtask
 
 
  virtual task put_2(input reg[15:0] y);
    `uvm_info("CONS:RECV2",$sformatf("the data is received : %0X",y),UVM_NONE)
endtask
 
  virtual task put_3(input reg[3:0] z);
    `uvm_info("CONS:RECV3",$sformatf("the data is received : %0X",z),UVM_NONE)
endtask
 
endclass
 
 
 
 
 
 
 
class test extends uvm_test;
`uvm_component_utils(test)
 
producer p;
consumer c;
 
function new(input string inst="TEST",uvm_component c);
super.new(inst,c);
endfunction
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  p=producer::type_id::create("PROD",this);
  c=consumer::type_id::create("CONS",this);
endfunction
 
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
  p.send1.connect(c.recv1);
  p.send2.connect(c.recv2);
  p.send3.connect(c.recv3);
endfunction
 
 
virtual task run_phase(uvm_phase phase);
#100;
global_stop_request();
endtask
 
endclass
 
 
 
 
 
 
 
module top_correct;
test t;
  
initial begin
t=new("TEST",null);
run_test();
end
 
 
endmodule
