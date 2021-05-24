`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 08:23:39 PM
// Design Name: 
// Module Name: Single_port_RAM
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


module Single_port_RAM(
    input clk,cs,
    input[3:0]addr,
    input we,
    input [7:0]datain,
    output [7:0]dataout
    );
    reg[7:0] dataout_temp;
    reg [7:0] mem [7:0];
    always@(posedge clk) begin
    if(cs & we) 
    mem[addr]<=datain;
    end
    
    always@(posedge clk) begin
    if(cs & !we)
    dataout_temp<=mem[addr];
    end
    
    assign dataout=dataout_temp;
endmodule
