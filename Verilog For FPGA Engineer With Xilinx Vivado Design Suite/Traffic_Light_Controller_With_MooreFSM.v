`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2021 07:38:27 PM
// Design Name: 
// Module Name: Traffic_Light_Controller_With_MooreFSM
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


module Traffic_Light_Controller_With_MooreFSM(
input clk,reset,
output r,y,g
    );
    reg tempr=0,tempy=0,tempg=0;
    reg [1:0] state=2'b00;
    reg [1:0] nextstate=0;
    parameter red=0,green=1,yellow=2,start=3;
//initial code without Mealy or Moore FSM   
//    integer count;
    
//    always@(posedge clk)
//    begin
//    case(state)
//    start:begin
//          if(reset==1'b1)
//          state<=red;
//          else
//          state<=start;
//          end
//     red:begin
//     if(count<5)
//     begin
//         tempr<=1'b1;
//         tempy<=1'b0;
//         tempg<=1'b0;
//         count<=count+1;
//         end
//        else
//        begin
//        count<=0;
//        state<=yellow;
//        end
//      end
//      yellow:begin
//           if(count<5)
//           begin
//               tempr<=1'b0;
//               tempy<=1'b1;
//               tempg<=1'b0;
//               count<=count+1;
//               end
//              else
//              begin
//              count<=0;
//              state<=green;
//              end
//            end
//      green:begin
//            if(count<5)
//            begin
//               tempr<=1'b0;
//               tempy<=1'b0;
//               tempg<=1'b1;
//               count<=count+1;
//            end
//            else
//            begin
//              count<=0;
//              state<=start;
//            end
//           end
//      default:state<=start;
//     endcase
//    end
    
//three process method
//    always@(posedge clk or posedge reset)
//    begin
//    if(reset==1'b1)
//        state<=start;
//    else
//        state<=nextstate;
//    end
    
//    always@(state)
//    begin
//    case(state)
//    start:nextstate<=red;
//    red:nextstate<=yellow;
//    yellow:nextstate<=green;
//    green:nextstate<=start;
//    endcase
//    end
    
//    always@(state)
//    begin
//    case(state)
//    start:begin
//            tempr=0;
//            tempy=0;
//            tempg=0;
//          end
//     red:begin
//           tempr=1'b1;
//           tempy=0;
//           tempg=0;           
//         end
//     yellow:begin
//              tempr=0;
//              tempy=1'b1;
//              tempg=0;           
//            end
//     green:begin
//             tempr=0;
//             tempy=0;
//             tempg=1'b1;           
//           end
//    endcase
//    end

//two process method
   always@(posedge clk or posedge reset)
    begin
    if(reset==1'b1)
        state<=start;
    else
        state<=nextstate;
    end
    
    always@(state)
    begin
    case(state)
    start:begin nextstate<=red;tempr=0;
                tempy=0;
                tempg=0;
          end
    red:begin nextstate<=yellow;tempr=1'b1;
                     tempy=0;
                     tempg=0;
         end
    yellow:begin nextstate<=green; tempr=0;
                      tempy=1'b1;
                      tempg=0; 
                      end
    green:begin nextstate<=start;tempr=0;
                                   tempy=0;
                                   tempg=1'b1;     
           end
    endcase
    end
    
    assign r=tempr;
    assign y=tempy;
    assign g=tempg;
endmodule
