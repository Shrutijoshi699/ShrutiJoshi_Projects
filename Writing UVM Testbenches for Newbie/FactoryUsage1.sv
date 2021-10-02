`timescale 1ns/1ps

class drv;


int data1;int data2;
constraint data_c {data1>10;data2>12;};
function new(input int data1,input int data2);
this.data1=data1;
this.data2=data2;
endfunction

task run();
$display("Data1 = %0d and Data2 = %0d",this.data1,this.data2);
endtask
endclass

class env;
drv d;

task run();
d=new(12,14);
d.run();
endtask
endclass

module tb;
env e;

initial begin
e=new();
e.run();
end
endmodule