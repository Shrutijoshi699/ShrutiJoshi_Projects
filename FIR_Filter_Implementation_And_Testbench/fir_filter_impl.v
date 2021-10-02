
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Shruti Joshi
// 
// Create Date: 09/22/2021 03:12:01 PM
// Design Name: FIR_Filter
// Module Name: FIR_Filter_Impl
// Project Name: FIR_Filter_With_Pregeneraged_Coefficients
// Description: This project is designed for implementation of FIR filter on a FPGA.
// The FIR filter consists of three components, ie. circular buffer, multiplier and accumulator

//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module FIR_Filter_Impl#(parameter NO_OF_TAPS = 15)
   (input clk,
   input reset,
   input signed [NO_OF_TAPS:0] s_axis_fir_tdata, 
   input s_axis_fir_tvalid,
   input m_axis_fir_tready,
   output reg m_axis_fir_tvalid,
   output reg s_axis_fir_tready,
   output signed [2*NO_OF_TAPS + 1:0] m_axis_fir_tdata
   );
   //Parameter to be used to declare the size of circular buffer counter
    parameter BUFFER_COUNT=$clog2(NO_OF_TAPS) - 1;
    
    
    integer i=0; //variable used for counting 
    integer file; //variable used for reading the file that holds predefined coefficients
    
    //memory and variable declaration for buffer,tap and accumulator and related functionality
    reg signed [NO_OF_TAPS:0] buff[NO_OF_TAPS - 1:0];
    reg signed [NO_OF_TAPS:0] tap[NO_OF_TAPS - 1:0];
    reg signed [2*NO_OF_TAPS + 1:0] acc[NO_OF_TAPS - 1:0];
    reg enable_fir, enable_buff;
    reg [BUFFER_COUNT:0] buff_cnt;
    reg signed [NO_OF_TAPS:0] in_sample; 
    reg [2*NO_OF_TAPS + 1:0] acc_tmp [NO_OF_TAPS - 1:0];
    reg [2*NO_OF_TAPS + 1:0] sum [NO_OF_TAPS - 1:0];
    
    initial begin
        s_axis_fir_tready=0;
        m_axis_fir_tvalid=0;
    end
    
     /* Taps for LPF running @ 1MSps with a cutoff freq of 400kHz
     *This initial block read the coefficients from CoeffRead.coe file and stores the values.
     */
    initial begin
        file = $fopen("D:/UdemyCourse/Questasim_projects/FPGA_Consultation_Projects/tap.txt", "r");
            $readmemh("D:/UdemyCourse/Questasim_projects/FPGA_Consultation_Projects/tap.txt", tap);
        $fclose(file);
    end
      
   /* This loop sets the tvalid flag on the output of the FIR high once 
    * the circular buffer has been filled with input samples for the 
    * first time after a reset condition. */
   always @ (posedge clk or negedge reset)begin
    if (reset == 1'b0)begin
        buff_cnt <= 4'd0;
        enable_fir <= 1'b0;
        in_sample <= 8'd0;
    end
    else if (m_axis_fir_tready == 1'b0 || s_axis_fir_tvalid == 1'b0)begin
        enable_fir <= 1'b0;
        buff_cnt <= NO_OF_TAPS;
        in_sample <= in_sample;
    end
    else if (buff_cnt == NO_OF_TAPS)begin
        buff_cnt <= 4'd0;
        enable_fir <= 1'b1;
        in_sample <= s_axis_fir_tdata;
    end
    else begin
        buff_cnt <= buff_cnt + 1;
        in_sample <= s_axis_fir_tdata;
     end
    end   

   /*This loop sets the tready of slave ,tvalid of master and 
   *the buffer flag based on the values of reset, tready of 
   *master and tvalid of the slave.*/
   always @ (posedge clk)begin
    if(reset == 1'b0 || m_axis_fir_tready == 1'b0 || s_axis_fir_tvalid == 1'b0)begin
        s_axis_fir_tready <= 1'b0;
        m_axis_fir_tvalid <= 1'b0;
        enable_buff <= 1'b0;
     end
     else begin
        s_axis_fir_tready <= 1'b1;
        m_axis_fir_tvalid <= 1'b1;
        enable_buff <= 1'b1;
     end
    end
   
   /* Circular buffer brings in a serial input sample stream that 
    * creates an array of input samples based on the NO_OF_TAPS of the filter. */
   always @ (posedge clk)begin
    if(enable_buff == 1'b1)begin
        buff[0] <= in_sample;
        if(i+1<=NO_OF_TAPS - 1 && i<=NO_OF_TAPS - 2)begin
            buff[i+1] <= buff[i]; 
            i<=i+1;
         end 
         else
            i<=0;     
         end
     else begin
        if(i<=NO_OF_TAPS - 1)begin
            buff[i+1] <= buff[i]; 
            i<=i+1;
        end
        else
            i<=0;
     end
   end

   /* Multiply stage of FIR */
   always @ (posedge clk)begin
    if (enable_fir == 1'b1)begin
        if(i<=NO_OF_TAPS - 1) begin
            acc[i] <= tap[i] * buff[i];
            i<=i+1;
         end
         else begin
            i<=0;
         end
         acc_tmp[i]=acc[i];
     end
   end  
     
    /* Accumulate stage of FIR */ 
    always @* begin
     for (i=1; i<NO_OF_TAPS; i=i+1) begin
        if (i == 1) begin
            sum[i] = acc_tmp[i] + acc_tmp[i-1];
        end
        else begin
            sum[i] = sum[i-1] + acc_tmp[i];
        end
     end
    end
    
    //Feeding the output value to the output of the module if fir is enabled
    assign m_axis_fir_tdata=(enable_fir)?sum[NO_OF_TAPS - 1]:0;
    
endmodule
