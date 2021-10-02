//module adder
module top(
input [3:0] a,
input [3:0] b,
output[4:0] c);

assign c=a+b;

endmodule

//interface
interface top_if();
logic [3:0] a;
logic [3:0] b;
logic [4:0] c;
endinterface

module tb;
top_if tbif();
top uut(.a(tbif.a),.b(tbif.b),.c(tbif.c));

initial begin
tbif.a=5;
tbif.b=5;
#10;
$display("a and b adds up to %0d",tbif.c);
end

initial begin
$dumpvars;
$dumpfile("dump.vcd");
end
endmodule