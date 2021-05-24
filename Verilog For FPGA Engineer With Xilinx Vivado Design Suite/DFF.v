`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2020 07:53:35 PM
// Design Name: 
// Module Name: DFF
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


module DFF(
input clk,reset,din,
output q,q_bar
    );
    reg q_temp,q_bar_temp;
    always@(posedge clk or negedge reset)
    begin
    if(reset)
    begin
       q_temp<=0;
       q_bar_temp<=0; 
    end
    else
    begin
        if(clk==1'b1)
            begin
            q_temp<=din;
            q_bar_temp<=~q_temp;
            end
         else
            begin
            q_temp<=1'b0;
            q_bar_temp<=~q_temp;
            end
    end
    end
    
    assign q=q_temp;
    assign q_bar=~q_temp;
endmodule
