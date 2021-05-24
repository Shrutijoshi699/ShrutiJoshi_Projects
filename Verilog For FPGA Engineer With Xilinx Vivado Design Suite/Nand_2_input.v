`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2020 07:42:18 PM
// Design Name: 
// Module Name: Nand_2_input
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


module Nand_2_input(
input a,b,
output y
    );
    wire temp;
    supply1 vdd;
    supply0 vss;
    pmos p1(y,vdd,a);
    pmos p2(y,vdd,b);
    nmos n1(y,temp,a);
    nmos n2(temp,vss,b);
endmodule
