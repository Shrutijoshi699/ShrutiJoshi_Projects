`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2020 07:20:05 PM
// Design Name: 
// Module Name: counter_4_bit
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


module counter_4_bit(
    input clk,ld,ce,
    input [3:0] loadin,
    output [3:0] dout
    );
    
    reg[3:0] dout_temp=4'd0;
    
    always@(posedge clk) begin
    if(ld==1'b1)
    dout_temp<=loadin;
    else
    dout_temp<=dout_temp+1;
    end
    
    assign dout=(ce==1'b1)?dout_temp:4'bzzzz;
    
endmodule
