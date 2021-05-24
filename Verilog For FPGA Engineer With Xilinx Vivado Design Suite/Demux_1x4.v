`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2020 08:07:15 PM
// Design Name: 
// Module Name: Demux_1x4
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


module Demux_1x4(
    input i,
    input [1:0] sel,
    output [3:0] y
    );
    reg[3:0] y_temp;
    always@(*) begin
    case(sel)
    2'b00: begin 
            y_temp[3:1]=1'b0;
            y_temp[0]=i;
            end
     2'b01: begin 
            y_temp[3:2]=1'b0;
            y_temp[1]=i;
            y_temp[0]=1'b0;
            end
     2'b10: begin 
            y_temp[3]=1'b0;
            y_temp[2]=i;
            y_temp[1:0]=1'b0;
            end
     2'b11: begin 
            y_temp[3]=i;
            y_temp[2:0]=1'b0;
           end
     default:y_temp=4'b0000;
    endcase
    end
    assign y=y_temp;
endmodule
