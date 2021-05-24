`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2020 08:28:00 PM
// Design Name: 
// Module Name: Recursive_factorial
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


module Recursive_factorial(

    );
    
    function automatic [7:0] factorial(input [7:0] i);
    if(i==1)
    factorial=1;
    else
    factorial=i*factorial(i-1);
    endfunction
    
    initial
    begin
    $display("The value of factorial is %0d",factorial(3));
    end
endmodule
