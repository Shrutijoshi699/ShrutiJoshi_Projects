module ram(
input clk,rst,wr,
input [7:0] din,
input[5:0]addr,
output reg[7:0]dout);

reg[7:0] mem[64];
integer i;
always@(posedge clk) begin
if(rst) begin
	for(i=0;i<64;i++) begin
	mem[i]=0;
	end
end
else begin
  if(wr==1'b1) 
	mem[addr]<=din;
	else
	dout<=mem[addr];
end
end
endmodule

class transaction;
rand bit [7:0] din;
rand bit[5:0]addr;
bit[7:0]dout;
bit wr;
endclass

class generator;
mailbox mbx;
transaction t;
event done;
integer i;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
for(i=0;i<50;i++) begin
t.randomize();
mbx.put(t);
$display("[GEN] : data sent to driver");
@(done);
end
endtask
endclass

interface ram_intf();
logic clk,rst,wr;
  logic [7:0] din;
  logic[5:0]addr;
  logic[7:0]dout;
endinterface

class driver;
transaction t;
mailbox mbx;
event done;
virtual ram_intf vif;
function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
mbx.get(t);
vif.din=t.din;
vif.addr=t.addr;
$display("[DRV] : interface triggered");
->done;
@(posedge vif.clk);
end
endtask
endclass

class monitor;
mailbox mbx;
transaction t;
virtual ram_intf vif;

function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
t=new();
forever begin
t.wr=vif.wr;
t.din=vif.din;
t.addr=vif.addr;
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
transaction taddr[64];
function new(mailbox mbx);
this.mbx=mbx;
endfunction

task run();
  t=new();
forever begin
mbx.get(t);
  if(t.wr==1'b1) begin
if(taddr[t.addr]==null) begin
taddr[t.addr]=new();
taddr[t.addr]=t;
$display("[SCO] : data stored");
end
end
else begin
if(taddr[t.addr]==null) 
  begin
	if(t.dout==0)
	$display("[SCO] : data read test passed");
	else
	$display("[SCO] : data read test failed ");
end
else begin
	if(t.dout==taddr[t.addr].din)
	$display("[SCO] : data read test passed");
	else
	$display("[SCO] : data read test failed ");
end
end
end
endtask
endclass

class environment;
generator g;
driver d;
monitor m;
scoreboard s;
mailbox gdmbx,msmbx;
virtual ram_intf vif;
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

module ram_tb_with_sv();
environment e;
ram_intf vif();
mailbox gdmbx,msmbx;

ram dut(vif.clk,vif.rst,vif.wr,vif.din,vif.addr,vif.dout);
always #5 vif.clk=~vif.clk;
initial begin
vif.rst=1;
vif.clk=0;
vif.wr=1;
#30;
vif.rst=0;
#300;
vif.wr=0;
#200;
vif.rst=1;
end
initial begin
gdmbx=new();
msmbx=new();
e=new(gdmbx,msmbx);
  e.vif=vif;
e.run();
#600;
$finish;
end
initial begin
$dumpvars;
$dumpfile("dump.vcd");
end
endmodule
