`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2020 08:20:40 PM
// Design Name: 
// Module Name: funct
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


module funct(
    input [3:0] a,b,
    output [4:0] c
    );
    function [4:0] addition (input [3:0]i1,input [3:0] i2);
    addition=i1+i2;
    endfunction
    
    assign c=addition(a,b);
endmodule
