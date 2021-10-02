
`include "uvm_macros.svh"
import uvm_pkg::*;

class assignment4 extends uvm_component;
`uvm_component_utils(assignment4)

string name;
rand bit[3:0]a;
rand bit[3:0]b;
bit[4:0]c;

function new(input string name,uvm_component comp);
super.new(name,comp);
this.name=name;
endfunction

task add(input bit[3:0] a,b);
this.a=a;
this.b=b;
this.c=this.a+this.b;

$display("value of a=%0d,b=%0d and c=%0d",this.a,this.b,this.c);
endtask
endclass


module tb;
assignment4 a4;
reg r;
initial begin
a4=new("Component",null);
r=a4.randomize();
a4.add(a4.a,a4.b);
end
endmodule

