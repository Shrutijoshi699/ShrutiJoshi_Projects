
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shruti Joshi
// 
// Create Date: 09/22/2021 03:12:01 PM
// Design Name: FIR_Filter
// Module Name: FIR_Filter_Impl_Tb
// Project Name: FIR_Filter_With_Pregeneraged_Coefficients
// Description: This project is designed for implementation of FIR filter on a FPGA.
// The FIR filter consists of three components, ie. circular buffer, multiplier and accumulator

//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module FIR_Filter_Impl_Tb();

//Set the value of NO_OF_TAPS according to the requirement
parameter NO_OF_TAPS = 15;
reg clk,reset;
reg s_axis_fir_tvalid;
reg [NO_OF_TAPS:0] s_axis_fir_tdata;
reg m_axis_fir_tready;
wire m_axis_fir_tvalid;
wire s_axis_fir_tready;
wire [2 * NO_OF_TAPS + 1:0] m_axis_fir_tdata;
reg[NO_OF_TAPS:0]square[2 * NO_OF_TAPS - 1:0];
integer file;
integer i=0;

  FIR_Filter_Impl #(.NO_OF_TAPS(NO_OF_TAPS))
  uut(.clk(clk),
   .reset(reset),
   .s_axis_fir_tdata(s_axis_fir_tdata), 
   .s_axis_fir_tvalid(s_axis_fir_tvalid),
   .m_axis_fir_tready(m_axis_fir_tready),
   .m_axis_fir_tvalid(m_axis_fir_tvalid),
   .s_axis_fir_tready(s_axis_fir_tready),
   .m_axis_fir_tdata(m_axis_fir_tdata)
   );
   
   //This block initializes clock and input data to 0
  initial begin
    clk=0;
    s_axis_fir_tdata<=0;
  end

  //This block sets or resets the module 
  always begin
        reset = 1; #20;
        reset = 0; #50;
        reset = 1; #1000000;
    end
   
   //This block sets or resets tvalid signal 
   always begin
       s_axis_fir_tvalid = 0; #100;
       s_axis_fir_tvalid = 1; #1000;
       s_axis_fir_tvalid = 0; #50;
       s_axis_fir_tvalid = 1; #998920;
   end
   
   //This block sets or resets tready signal
   always begin
       m_axis_fir_tready = 1; #1500;
       m_axis_fir_tready = 0; #100;
       m_axis_fir_tready = 1; #998400;
   end
   
   //This block runs the clock with period of 10 clock sycles and 50% duty cycle
   always #5 clk<=~clk;

  //The below block is used for reading the square wave input values from a text file
  initial begin
    file = $fopen("D:/vivado_projects/FIR_filter_with_pregenerated_coefficients/FIR_filter_with_pregenerated_coefficients.srcs/sim_1/imports/behav/SquareWaveValues.txt", "r");
        $readmemh("D:/vivado_projects/FIR_filter_with_pregenerated_coefficients/FIR_filter_with_pregenerated_coefficients.srcs/sim_1/imports/behav/SquareWaveValues.txt", square);
    $fclose(file);
  end

  //This block provides the square wave to the input signal 
  always@(posedge clk) begin
    s_axis_fir_tdata = square[i];
    i = i+ 1;
    if(i == 2 * NO_OF_TAPS - 1)
        i = 0;
    end

endmodule
