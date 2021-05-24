`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2020 07:32:19 PM
// Design Name: 
// Module Name: Full_adder_with_gate_level_modeling
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


module Full_adder_with_gate_level_modeling(
input x,y,cin,
output s,cout
    );
    wire c1,c2,c3;
    
    xor xor_unit(s,x,y,cin);
    and and_unit1(c1,x,y);
    and and_unit2(c2,x,cin);
    and and_unit3(c3,y,cin);
    or or_unit(cout,c1,c2,c3);
    
endmodule
