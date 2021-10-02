// // module mul
// // (
// // input [15:0] a,
// // input [15:0] b,
// // input ctrl,
// // output [31:0] y
// // );
// // endmodule

class mul;
  rand bit [15:0] a;
  rand bit [15:0] b;
  rand bit cntrl;
  bit [31:0] y;
  
  task mul_16bit(input bit [15:0] a,input bit [15:0] b,input bit cntrl);
    this.a=a;
    this.b=b;
    this.cntrl=cntrl;
    if(this.cntrl)
      y=this.a*this.b;
    else
      y=0;
    $display("The value of a=%d,b=%d,cntrl=%d and result= %d",this.a,this.b,this.cntrl,this.y);
  endtask
endclass

module tb;
  mul t;
reg r=0;
  integer i;
  initial begin
    t=new();
    
    for(i=0;i<5;i++) begin
    r=t.randomize();
      t.mul_16bit(t.a,t.b,t.cntrl);
      #10;
    end
  end
endmodule

