`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 07:51:23 PM
// Design Name: 
// Module Name: Mux_With_Case
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


module Mux_With_Case(
input clk,a,b,c,d,
input [1:0] sel,
output y
    );
    reg y_temp=0;
    always@(posedge clk) begin
    case(sel)
    2'd0:y_temp=a;
    2'd1:y_temp=b;
    2'd2:y_temp=c;
    2'd3:y_temp=d;
    default:y_temp=1'bx;
    endcase
    end
    assign y = y_temp;
endmodule
