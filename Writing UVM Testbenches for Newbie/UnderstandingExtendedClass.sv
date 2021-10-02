class add;
  bit[3:0] a;
  bit[3:0] b;
  bit[4:0] c;
      
  task add_two(input bit [3:0] a,input bit [3:0] b);
    this.a=a;
    this.b=b;
        c=this.a+this.b;
        $display("the result = %0d",c);
      endtask
 endclass
 
class mul extends add;
bit [7:0] y=0;
integer i;
task mult(input bit [3:0] a,input bit [3:0] b);
for(i=0;i<a;i++) begin
y=y+b;
end
$display("Value of a=%0d,b=%0d and y=%0d",a,b,y);
endtask
endclass
 
      module tb;
        mul t;
        
        initial begin
          t=new();//to initialize all memebers to default values
          
          t.mult(4'b0101,4'b0011);
        end
      endmodule
