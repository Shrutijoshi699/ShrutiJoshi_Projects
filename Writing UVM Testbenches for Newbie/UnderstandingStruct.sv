typedef struct{
  bit[3:0] a;
  bit[3:0] b;
  bit[4:0] c; 
} add_struct;

module tb;
  add_struct t;
  initial begin
    t.a=4'b1010;
    t.b=4'b0001;
    
    t.c=t.a+t.b;//algorithm
    $display("value of addition : %0d",t.c);
    
  end
endmodule
