`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2021 08:02:36 PM
// Design Name: 
// Module Name: Moore_Sequence_Detetctor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Moore_Sequence_Detetctor(
input clk,din,
output dout
    );
    parameter s0=0,s1=1,s2=2,s3=3;
    reg temp=0;
    reg [1:0]state=0;
    reg [1:0]nextstate=0;
    
    
    always@(posedge clk)
    begin
    state<=nextstate;
    end
    
    always@(state)
    begin
    case(state)
    s0:begin
       if(din==1'b0)
       begin
            nextstate<=s0;
            temp<=0;
       end
       else
       begin
            nextstate<=s1;
            temp<=0;
       end
       end
     s1:begin
        if(din==1'b0)
        begin
            nextstate<=s2;
            temp<=0;
        end
        else
        begin
            nextstate<=s1;
            temp<=0;
        end
        end
      s2:begin
         if(din==1'b0)
         begin
            nextstate<=s0;
            temp<=0;
         end
         else
         begin
            nextstate<=s3;
            temp<=1;
         end
         end
        s3:begin
           if(din==1'b0)
           begin
             nextstate<=s2;
             temp<=0;
           end
           else
           begin
              nextstate<=s1;
              temp<=0;
           end
           end
    endcase
    end
    
    assign dout=temp;
    
endmodule
