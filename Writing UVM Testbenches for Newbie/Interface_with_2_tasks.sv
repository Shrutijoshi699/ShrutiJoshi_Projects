//interface for RAM
interface Bus(input clk);
logic[7:0] addr,data;
logic RWn;
$info("Interface used");

task MasterWrite(input logic[7:0] waddr,input logic[7:0] wdata);
addr=waddr;
data=wdata;
RWn=0;
#10; RWn=1;
data='z;
endtask

task MasterRead(input logic[7:0] raddr,output logic[7:0] rdata);
addr=raddr;
RWn=1;
#10;rdata=data;
endtask

endinterface

module RAM(Bus MemBus);
logic[7:0]mem[0:255];
$info("module used");
always@*
if(MemBus.RWn)begin
MemBus.data=mem[MemBus.addr];
$info("write enabled");
  end
else begin
mem[MemBus.addr]=MemBus.data;
$info("read enabled");
end
endmodule

module TestRAM;
logic clk;
logic[7:0]data;
Bus TheBus(.clk(clk));

RAM TheRAM(.MemBus(TheBus));
initial begin

for(int i=0;i<256;i++)
	$info("write task called");
	TheBus.addr=TheBus.addr+1;
TheBus.RWn=1;
TheBus.data=mem[0];

end
endmodule
