`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2021 07:56:10 PM
// Design Name: 
// Module Name: Mealy_with_2_process_meth
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


module Mealy_with_2_process_meth(
input clk,din,reset,
output dout
    );
    reg temp;
    reg state=0;
    reg nextstate=0;
    parameter s0=0,s1=1;
    
    always@(posedge clk or posedge reset)
    begin 
    if(reset==1'b1)
    state<=s0;
    else
    state<=nextstate;
    end
    
    always@(state or din)
    begin
    case(state)
    s0:begin
       if(din==1'b0)
       begin
       nextstate<=s0;temp<=0;
       end
       else
        begin
       nextstate<=s1;temp<=1;
       end
       end
    s1:begin
       if(din==1'b0)
       begin
       nextstate<=s0;temp<=1; end
       else
       begin
       nextstate<=s0;temp<=0;end
       end
    endcase
    end
    
   assign dout=temp;
endmodule
