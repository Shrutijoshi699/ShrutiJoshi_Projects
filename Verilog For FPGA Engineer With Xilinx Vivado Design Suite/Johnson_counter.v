`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2020 07:40:06 PM
// Design Name: 
// Module Name: Johnson_counter
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


module Johnson_counter(
    input clk,reset,
    output [3:0] q_out
    );
    
    reg[3:0]q_temp;
    integer i;
    always@(posedge clk) begin
    if(reset==1'b0) begin
    q_temp[0]<=~q_temp[3];
    for(i=0;i<=3;i=i+1) begin
    q_temp[i+1]<=q_temp[i];
   end
    end
    else 
    q_temp<=4'b0000;
   
    end
    
    assign q_out=q_temp;
    
endmodule
