`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2020 07:27:44 PM
// Design Name: 
// Module Name: Inverter_switch_model
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


module Inverter_switch_model(
input[3:0] a,
output[3:0] y
);
supply1 vdd;
supply0 gnd;

pmos p1 [3:0](y,vdd,a);
nmos n1 [3:0](y,gnd,a);

endmodule
