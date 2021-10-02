//sequential circuit
module top(
input clk,
input [3:0]a,b,
output [7:0] c);
reg[7:0] temp;
always@(posedge clk) begin
temp<=a*b;
end
assign c=temp;
endmodule

//interface
interface top_if();
logic clk;
logic [3:0]a;
logic [3:0]b;
logic [7:0] c;
endinterface

module tb();
top_if tbif();

top uut(.clk(tbif.clk),.a(tbif.a),.b(tbif.b),.c(tbif.c));
initial begin
tbif.clk=0;
end

always #5 tbif.clk=~tbif.clk;
initial begin
#1000;
$finish;
end

initial begin
tbif.a=4'h5;
tbif.b=4'h5;
@(posedge tbif.clk);
$display("product of a and b is %0d",tbif.c);
end
initial begin
$dumpvars;
$dumpfile("dump.vcd");
end
endmodule
