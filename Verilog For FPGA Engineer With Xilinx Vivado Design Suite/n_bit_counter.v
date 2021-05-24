`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2020 07:58:51 PM
// Design Name: 
// Module Name: n_bit_counter
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


module n_bit_counter
#(
parameter N=8
)

(
    input clk,start,
    output [N-1:0] q
    );
    
    reg [N-1:0] q_temp=0;
    
    always@(posedge clk)
    begin
    if(start==1'b1)
    q_temp<=q_temp+1;
    else
    q_temp<=0;
    end
    
    assign q=q_temp;
    
    
endmodule
