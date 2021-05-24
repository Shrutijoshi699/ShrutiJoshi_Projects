module add8bit(input[7:0]a,b,
output[8:0]y);
assign y=a+b;
endmodule

class transaction;
randc bit[7:0] a;
randc bit[7:0] b;
bit[8:0] y;
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

interface add8bit_intf();
logic[7:0]a;
logic[7:0]b;
logic[8:0]y;
endinterface

class driver;
transaction t;
mailbox mbx;
virtual add8bit_intf vif;
event done;
function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
vif.a=t.a;
vif.b=t.b;
$display("[DRV] : Triggered interface");
->done;
#10;
end
endtask
endclass

class monitor;
virtual add8bit_intf vif;
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
bit[8:0] temp;
function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
temp=t.a+t.b;
if(temp==t.y)
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
mailbox gdmbx,msmbx;
virtual add8bit_intf vif;
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
environment env;
mailbox gdmbx,msmbx;
add8bit_intf vif();

add8bit dut(vif.a,vif.b,vif.y);

initial begin
gdmbx=new();
msmbx=new();
env=new(gdmbx,msmbx);
env.vif=vif;
env.run();
#500;
$finish;
end
  
initial begin
$dumpvars;
$dumpfile("dump.vcd");
end 
endmodule