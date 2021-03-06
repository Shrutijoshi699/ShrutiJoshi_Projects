module counter(
input clk,rst,up,load,
input[7:0]loadin,
output reg [7:0]dout
);
always@(posedge clk) begin
if(rst)
dout<=8'd0;
else if(load)
dout<=load;
else begin
	if(up)
	dout<=dout+1;
	else
	dout<=dout-1;
	end
end
endmodule

class transaction;
randc bit[7:0]loadin;
bit[7:0]dout;
endclass

class generator;
transaction t;
mailbox mbx;
event done;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
t.randomize();
mbx.put(t);
$display("[GEN] : data sent to driver");
@(done);
endtask
endclass

interface counter_intf();
logic clk,rst,up,load;
  logic[7:0]loadin;
  logic [7:0]dout;
endinterface

class driver;
mailbox mbx;
event done;
transaction t;
virtual counter_intf vif;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
vif.loadin=t.loadin;
$display("[DRV] : interface triggered");
->done;
  @(posedge vif.clk);
end
endtask
endclass

class monitor;
mailbox mbx;
virtual counter_intf vif;
transaction t;

  function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
t.loadin=vif.loadin;
t.dout=vif.dout;
mbx.put(t);
$display("[MON] : data sent to scoreboard");
@(posedge vif.clk);
end
endtask
endclass

class scoreboard;
mailbox mbx;
transaction t;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
forever begin
mbx.get(t);
$display("[SCO] : data rcvd");
end
endtask
endclass

class environment;
generator g;
driver d;
monitor m;
scoreboard s;
mailbox gdmbx,msmbx;
virtual counter_intf vif;
event gddone;

function new(mailbox gdmbx,mailbox msmbx);
this.gdmbx=gdmbx;
this.msmbx=msmbx;

g=new(gdmbx);
d=new(gdmbx);

m=new(msmbx);
s=new(msmbx);
endfunction

task run();
d.vif=vif;
m.vif=vif;
g.done=gddone;
d.done=gddone;

fork
g.run();
d.run();
m.run();
s.run();
join_any
endtask
endclass

module tb();
environment e;
counter_intf vif();
mailbox gdmbx,msmbx;

  counter dut(vif.clk,vif.rst,vif.up,vif.load,vif.loadin,vif.dout);
always #5 vif.clk=~vif.clk;
initial begin
vif.clk=0;
vif.rst=0;
vif.load=0;
vif.up=0;
#30;
vif.rst=1;
#100;
vif.rst=0;
vif.up=1;
#100;
vif.load=1;
vif.up=0;
#100;
vif.load=0;
#100;
end
initial begin
gdmbx=new();
msmbx=new();
e=new(gdmbx,msmbx);
  e.vif=vif;
e.run();
#500;
$finish;
end
  initial begin
$dumpvars;
$dumpfile("dump.vcd");
end
endmodule