`include "uvm_macros.svh"
import uvm_pkg::*;

class assignment5 extends uvm_component;
`uvm_component_utils(assignment5);
function new(string name,uvm_component parent);
super.new(name,parent);
endfunction
string s="SUCCESS";
task run();
`uvm_info("ASSIGNMENT5",$sformatf("This code is a %0s",s),UVM_DEBUG);
endtask
endclass

module tb;
assignment5 a5;
reg r;
initial begin
a5=new("ASSIGNMENT5",null);
a5.set_report_verbosity_level(UVM_DEBUG);
r=a5.randomize();
a5.run();
end
endmodule
