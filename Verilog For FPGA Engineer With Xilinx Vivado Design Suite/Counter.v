`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 07:43:21 PM
// Design Name: 
// Module Name: Counter
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


module Counter(
input clk,
output led0,led1
    );
    reg temp0=0,temp1=0;
    reg state=0;
    always@(posedge clk) begin
    case(state)
    0:begin
    temp0<=1'b1;
    temp1<=1'b0;
    end
     1:begin
       temp0<=1'b0;
       temp1<=1'b1;
       end
       default:begin
       temp0<=1'bx;
              temp1<=1'bx;
       end
       endcase
    end
    
    assign led0=temp0;
    assign led1=temp1;
endmodule
