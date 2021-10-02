`include "uvm_macros.svh"
import uvm_pkg::*;
class dis extends uvm_component;
`uvm_component_utils(dis);//making class compatible to factory

function new(string name,uvm_component parent);
super.new(name,parent);
endfunction
rand bit[15:0] din;
task run();
`uvm_info("DIS",$sformatf("Value of din : %0d",din),UVM_NONE);
endtask
endclass

module tb;
dis d1;
  integer level;
  
  initial begin
    d1 = new("DIS", null);
    d1.set_report_verbosity_level(UVM_NONE);
    level = d1.get_report_verbosity_level;
    `uvm_info("INFO", $sformatf("Ver Level : %0d",level), UVM_NONE);
    d1.randomize;
    
    d1.run;
end
endmodule
