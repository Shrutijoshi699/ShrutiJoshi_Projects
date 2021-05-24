`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2020 07:38:22 PM
// Design Name: 
// Module Name: FA_structural
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


module FA_structural(
input x,y,cin,
output s,c
    );
    wire s1,c1,c2;
    
    HA_structural ha1(x,y,s1,c1);
    HA_structural ha2(s1,cin,s,c2);
    assign c=c1|c2;
endmodule
