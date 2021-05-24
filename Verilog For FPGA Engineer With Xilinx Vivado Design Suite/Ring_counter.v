`timescale 1ns / 1ps

module Ring_counter(
    input clk,reset,
    output [3:0] q_out
    );
    
    reg[3:0]q_temp;
    integer i;
    always@(posedge clk) begin
    if(reset==1'b0) begin
    q_temp[3]<=q_temp[0];

    for(i=3;i>=0;i=i-1) begin
    q_temp[i-1]<=q_temp[i];
   end
    end
    else 
    q_temp<=4'b1000;
   
    end
    
    assign q_out=q_temp;
    
endmodule
