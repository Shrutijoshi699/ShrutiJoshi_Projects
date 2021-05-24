module andt(
input [7:0]a,b,
output[7:0]y);
assign y=a&b;
endmodule

class transaction;
randc bit[7:0]a;
randc bit[7:0]b;
bit[7:0]y;
endclass

class generator;
transaction t;
mailbox mbx;
event done;
integer i;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
for(i=0;i<20;i++) begin
t.randomize();
mbx.put(t);
$display("[GEN] : data sent to driver");
@(done);
#10;
end
endtask
endclass

interface andt_intf();
logic[7:0]a;
logic[7:0]b;
logic[7:0]y;
endinterface

class driver;
transaction t;
mailbox mbx;
event done;
virtual andt_intf vif;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
vif.a=t.a;
vif.b=t.b;
$display("[DRV] : Trigger interface");
->done;
#10;
end
endtask
endclass

class monitor;
virtual andt_intf vif;
mailbox mbx;
transaction t;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
t.a=vif.a;
t.b=vif.b;
t.y=vif.y;
mbx.put(t);
$display("[MON] : data sent to scoreboard");
#10;
end
endtask
endclass

class scoreboard;
mailbox mbx;
transaction t;
bit[7:0] temp;
function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
temp=t.a&t.b;
if(t.y==temp)
$display("[SCO] : Test passed");
else
$display("[SCO] : Test failed");
end
#10;
endtask

endclass

class environment;
generator g;
driver d;
monitor m;
scoreboard s;
mailbox gdmbx;
mailbox msmbx;
event gddone;
virtual andt_intf vif;
function new(mailbox gdmbx,mailbox msmbx);
this.gdmbx=gdmbx;
this.msmbx=msmbx;
g=new(gdmbx);
d=new(gdmbx);
m=new(msmbx);
s=new(msmbx);
endfunction

task run();
g.done=gddone;
d.done=gddone;
d.vif=vif;
m.vif=vif;

fork
g.run();
d.run();
m.run();
s.run();
join_any

endtask
endclass

module tb();
environment env;
mailbox gdmbx,msmbx;
andt_intf vif();
andt dut(vif.a,vif.b,vif.y);
initial begin
gdmbx=new();
msmbx=new();
env=new(gdmbx,msmbx);
env.vif=vif;
env.run();
#200;
$finish;
end

initial begin
$dumpvars;
$dumpfile("dump.vcd");
end
endmodule