`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2020 07:35:28 PM
// Design Name: 
// Module Name: PriorityEncoder
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


module PriorityEncoder(
    input clk, 
    input [7:0] y,
    output a,b,c,d
    );
    reg [3:0] abcd_temp=4'b0000;
    
    always@(posedge clk) begin
    case(y)
    8'b00000000:abcd_temp=4'b0000;
    8'b00000001:abcd_temp=4'b0001;
    8'b0000001x:abcd_temp=4'b0011;
    8'b000001xx:abcd_temp=4'b0101;
    8'b00001xxx:abcd_temp=4'b0111;
    8'b0001xxxx:abcd_temp=4'b1001;
    8'b001xxxxx:abcd_temp=4'b1011;
    8'b01xxxxxx:abcd_temp=4'b1101;
    8'b1xxxxxxx:abcd_temp=4'b1111;
    default:abcd_temp=4'b0000;
    endcase
   end
    
    assign a=abcd_temp[3];
    assign b=abcd_temp[2];
    assign c=abcd_temp[1];
    assign d=abcd_temp[0];
endmodule
