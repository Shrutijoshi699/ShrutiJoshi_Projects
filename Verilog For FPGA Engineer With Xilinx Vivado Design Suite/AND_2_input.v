`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2020 07:53:36 PM
// Design Name: 
// Module Name: AND_2_input
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


module AND_2_input(
input a,b,
output y
    );
    wire temp1,temp2;
    supply1 vdd;
    supply0 vss;
    pmos p1(temp1,vdd,a);
    pmos p2(temp1,vdd,b);
    nmos n1(temp1,temp2,a);
    nmos n2(temp2,vss,b);
    
    pmos p3(y,vdd,temp1);
    nmos n3(y,vss,temp1);
endmodule
