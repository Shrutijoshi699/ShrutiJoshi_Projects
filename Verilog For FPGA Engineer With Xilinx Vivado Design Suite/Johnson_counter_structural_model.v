`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2020 08:01:41 PM
// Design Name: 
// Module Name: Johnson_counter_structural_model
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


module Johnson_counter_structural_model(
input clk,reset,
output [3:0]q
    );
    
   wire d0,d1,d2,d3,q0_tmp,q1_tmp,q2_tmp,q3_tmp,q0_bar,q1_bar,q2_bar,q3_bar;
    reg sel,d1_reg,d2_reg,d3_reg;
    
    always@(posedge clk)
    begin
    if(reset)
    sel=1'b0;
    else
    sel=1'b1;
    end
    
    assign d0=(sel==0)?0:q3_bar;
   
   always@(posedge clk)
   begin
   d1_reg=q0_tmp;
   d2_reg=q1_tmp;
   d3_reg=q3_tmp;
   end
   
   assign d1=d1_reg;
   assign d2=d2_reg;
   assign d3=d3_reg;
    
    DFF dff0(clk,reset,d0,q0_tmp,q0_bar);
    DFF dff1(clk,reset,d1,q1_tmp,q1_bar);
    DFF dff2(clk,reset,d2,q2_tmp,q2_bar);
    DFF dff3(clk,reset,d3,q3_tmp,q3_bar);
    
    assign q={q0_tmp,q1_tmp,q2_tmp,q3_tmp};
    
endmodule
