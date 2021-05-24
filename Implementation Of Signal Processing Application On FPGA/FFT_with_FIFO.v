//Implementation to connect 2 FIFO IPs to a FFT IP

`timescale 1ns / 1ps
module fft#(
 parameter A = 2'd0,
           parameter B = 2'd1,
           parameter C = 2'd2)
(input wire clk,
                input wire srst,
                input wire [31 : 0] din,
                input wire wr_en,
                input wire rd_en1,
               output wire full,
                output wire empty,
                output wire [31:0] dout1,
                output wire full1,
                output wire empty1,
                output wire valid1,
                output wire m_axis_data_tlast
               );
    
   reg rd_en;
   wire [31:0] dout;
   wire valid;
   reg [7 : 0] s_axis_config_tdata;
       reg s_axis_config_tvalid;
       wire s_axis_config_tready;
       reg [31 : 0] s_axis_data_tdata;
       reg s_axis_data_tvalid;
       wire s_axis_data_tready;
      wire s_axis_data_tlast;
       wire [31 : 0] m_axis_data_tdata;
       wire m_axis_data_tvalid;
       
       wire event_frame_started;
       wire event_tlast_unexpected;
       wire event_tlast_missing;
       wire event_data_in_channel_halt;
       
       reg [2:0] cnt;
   /*
      reg cnt;
      reg new_clk;
 reg [1:0] state;
 
      
    initial
    begin
       cnt<=1'b1;
    end
     
    always@(posedge clk)
    begin
        cnt<=cnt-1;
    end    
     
     always@(*)
     begin
        new_clk<=~cnt;
     end
     */
     wire value_read;
     reg valid_d1;
     parameter FIRST=2'b00;
     parameter SECOND=2'b01;
     parameter THIRD=2'b10;
     reg [1:0]st;
      
      reg [31:0] dout_d1;
      
        
    always@(posedge clk)
    begin
    if(srst)
    begin
    st <= FIRST;
        rd_en<=1'b0;
    end
    else
    begin
    case(st)
    FIRST: begin
            if(empty==1'b0)
            st <= SECOND;
            else
              st <= FIRST;
              end
    SECOND: begin
            if (valid_d1==1'b1 && s_axis_data_tready==1'b1 && empty==1'b0)
            
                st <= THIRD;
                else if(valid_d1==1'b1 && s_axis_data_tready==1'b1 && empty==1'b1)
                st <= FIRST;
                else
                st <= SECOND;
                   end
       THIRD: st <= SECOND;
             
      endcase
      end
      end
            
 always@(posedge clk)
         begin
         if(srst)
         begin
         rd_en<=1'b0;
         valid_d1 <= 1'b0;
         dout_d1 <= 32'd0;
       end
       else
       begin
          if((st==FIRST && empty==1'b0) || (valid_d1==1'b1 && s_axis_data_tready==1'b1 && empty==1'b0 &&st==SECOND))
                rd_en<=1'b1;
                else  
                rd_en <=1'b0;
            if(valid==1'b1)
             dout_d1 <= dout;
             else
             dout_d1 <= dout;
            
           
           if(valid==1'b1)
           valid_d1 <= 1'b1;
           else if(valid_d1==1'b1 && s_axis_data_tready==1'b1)
            valid_d1 <= 1'b0;
            else
            valid_d1 <= valid_d1;
       end
     end
    
   
   
   
   assign value_read = (valid_d1==1'b1 && s_axis_data_tready==1'b1) ? 1'b1: 1'b0;
   
   
   
    fifo_generator_0  fifo_generator_0 (
      .clk(clk),      // input wire clk
      .srst(srst),    // input wire srst
      .din(din),      // input wire [31 : 0] din
      .wr_en(wr_en),  // input wire wr_en
      .rd_en(rd_en),  // input wire rd_en
      .dout(dout),    // output wire [31 : 0] dout
      .full(full),    // output wire full
      .empty(empty),  // output wire empty
      .valid(valid)  // output wire valid
    );
   
   
 
    
    
     always@(posedge clk)
     begin
     if(srst)
     begin  
        s_axis_config_tvalid<=1'b0;
        s_axis_config_tdata<=8'd0;
     end
     else
     begin
        s_axis_config_tvalid<=1'b1;
        s_axis_config_tdata<=8'b00000001;
        
     end
     end
  
      always@(posedge clk )
      begin
      if(srst)
      begin
        cnt <= 3'b000;
      end
      else
      begin
      if(valid== 1'b1)
           cnt <= cnt+1;
      else if(cnt==3'b111 && valid_d1==1'b1)
            cnt <=3'b000;
            else
           cnt <= cnt;
       end 
       end
          
       assign s_axis_data_tlast =(cnt==3'b111 && valid_d1==1'b1)? 1'b1: 1'b0;
                
  
       xfft_0  xfft_0 (
         .aclk(clk),                                              // input wire aclk
         .s_axis_config_tdata(s_axis_config_tdata),                // input wire [7 : 0] s_axis_config_tdata
         .s_axis_config_tvalid(s_axis_config_tvalid),              // input wire s_axis_config_tvalid
         .s_axis_config_tready(s_axis_config_tready),              // output wire s_axis_config_tready
         .s_axis_data_tdata(dout_d1),                    // input wire [31 : 0] s_axis_data_tdata
         .s_axis_data_tvalid(valid_d1),                  // input wire s_axis_data_tvalid
         .s_axis_data_tready(s_axis_data_tready),                  // output wire s_axis_data_tready
         .s_axis_data_tlast(s_axis_data_tlast),                    // input wire s_axis_data_tlast
         .m_axis_data_tdata(m_axis_data_tdata),                    // output wire [31 : 0] m_axis_data_tdata
         .m_axis_data_tvalid(m_axis_data_tvalid),                  // output wire m_axis_data_tvalid
         .m_axis_data_tlast(m_axis_data_tlast),                    // output wire m_axis_data_tlast
         .event_frame_started(event_frame_started),                // output wire event_frame_started
         .event_tlast_unexpected(event_tlast_unexpected),          // output wire event_tlast_unexpected
         .event_tlast_missing(event_tlast_missing),                // output wire event_tlast_missing
         .event_data_in_channel_halt(event_data_in_channel_halt)  // output wire event_data_in_channel_halt
       );
       
   
reg [31 : 0] din1;
reg wr_en1;


 
 always@(posedge clk)
 begin
 if(srst)
 begin
    wr_en1<=1'b0;
    din1<=32'd0;
 end
 else
 begin
    if(m_axis_data_tvalid)
    begin
        wr_en1<=1'b1;
        din1<=m_axis_data_tdata;
    end
    else
    begin
        wr_en1<=1'b0;
        din1<=32'd0;
    end
  end
 end   
     
     
fifo_generator_1 fifo_generator_1 (
         .clk(clk),      // input wire clk
         .srst(srst),    // input wire srst
         .din(din1),      // input wire [31 : 0] din1
         .wr_en(wr_en1),  // input wire wr_en1
         .rd_en(rd_en1),  // input wire rd_en1
         .dout(dout1),    // output wire [31 : 0] dout1
         .full(full1),    // output wire full1
         .empty(empty1),  // output wire empty1
         .valid(valid1)  // output wire valid1
       );       

endmodule
