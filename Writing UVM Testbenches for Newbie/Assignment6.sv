`include "uvm_macros.svh"
import uvm_pkg::*;

class assignment6 extends uvm_report_object;
string s="DOUBLE SUCCESS";
`uvm_object_utils_begin(assignment6)
`uvm_field_string(s,UVM_DEFAULT);
`uvm_object_utils_end
function new(string name="ASSIGNMENT6");
super.new(name);
endfunction

task run();
`uvm_info("ASSIGNMENT6",$sformatf("THIS CODE IS A %0s",s),UVM_DEBUG);
endtask
endclass

module tb;
assignment6 a6;
reg r;
integer level;
initial begin
a6=new("ASSIGNMENT6");
a6.set_report_verbosity_level(UVM_DEBUG);
level=a6.get_report_verbosity_level();
`uvm_info("INFO",$sformatf("Verbosity level = %0d",level),UVM_NONE);
r=a6.randomize();
a6.run();
end
endmodule
