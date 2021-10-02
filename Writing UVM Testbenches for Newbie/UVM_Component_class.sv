`include "uvm_macros.svh"
import uvm_pkg::*;

class simple extends uvm_component;
`uvm_component_utils(simple)

string name;

function new(input string name,uvm_component c);
super.new(name,c);
this.name=name;
endfunction

task run();
$display("An instance name %0s",this.name);
endtask
endclass

module tb;
simple s;
initial begin
s=new("COMPONENT",null);
s.run();
end
endmodule
