`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/21/2020 07:46:06 PM
// Design Name: 
// Module Name: BRAM_top
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


module BRAM_top(
 input clk,cs,
   input[3:0]addr,
   input we,
   input [7:0]datain,
   output [7:0]dataout
    );
    blk_mem_gen_0 bram_dut (clk,cs,we,addr,datain,dataout);
endmodule
