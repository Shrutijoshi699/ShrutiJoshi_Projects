`include "uvm_macros.svh"
import uvm_pkg::*;
class dis extends uvm_report_object;
rand bit[15:0] din;
  `uvm_object_utils_begin(dis)
`uvm_field_int(din,UVM_DEFAULT);
`uvm_object_utils_end
  
  function new(string name="DIS");
    super.new(name);
  endfunction
  
  task run();
    `uvm_info("DIS", $sformatf("Value of din : %0d",din), UVM_HIGH);   
  endtask
  
endclass
 
module tb;
  reg r;
  dis d;
integer level;
initial begin
    d = new("DIS");
d.set_report_verbosity_level(UVM_HIGH);
level=d.get_report_verbosity_level();
`uvm_info("INFO",$sformatf("Verbosity level=%0d",d.get_report_verbosity_level()),UVM_NONE);
    r=d.randomize();
    d.run();
  end
  
endmodule
 
 
