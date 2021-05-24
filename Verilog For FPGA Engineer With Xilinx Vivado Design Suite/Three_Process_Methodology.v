`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2021 07:57:35 PM
// Design Name: 
// Module Name: Three_Process_Methodology
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


module Three_Process_Methodology(
input clk,reset,
output dout
    );
    reg dout_temp;
    reg state=0;
    reg nextstate=0;
    parameter s0=0,s1=1;
    
    always@(posedge clk or posedge reset)
    begin
    if(reset)
    state<=s0;
    else
    state<=nextstate;
    end
    
    always@(state)
    begin
    case(state)
    s0:nextstate<=s1;
    s1:nextstate<=s0;
    endcase
    end
    
    always@(state)
    begin
    case(state)
    s0:dout_temp=1'b0;
    s1:dout_temp=1'b1;
    endcase
    end
    
    assign dout=dout_temp;
    
endmodule
