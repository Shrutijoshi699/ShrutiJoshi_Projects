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
      
      module tb;
        add t;
        
        initial begin
          t=new();//to initialize all memebers to default values
          
          t.add_two(4'b0101,4'b0011);
        end
      endmodule
