`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2020 07:22:59 PM
// Design Name: 
// Module Name: Half_adder_with_gate_level_modeling
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


module Half_adder_with_gate_level_modeling(
input a,b,
output sum,carry
    );
    xor xor_unit(sum,a,b);
    and and_unit(carry,a,b);
endmodule
