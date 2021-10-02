module tb();
integer outfile0; //file descriptor
reg signed [15:0]A;
initial begin

    outfile0=$fopen("D:/vivado_projects/FIR_filter_with_pregenerated_coefficients/FIR_filter_with_pregenerated_coefficients.srcs/sim_1/imports/behav/SquareWaveValues.txt","r");   //"r" means reading and "w" means writing
    //read line by line.
    while (! $feof(outfile0)) begin //read until an "end of file" is reached.
        $fscanf(outfile0,"%h\n",A); //scan each line and get the value as an hexadecimal, use %b for binary and %d for decimal.
        #10; //wait some time as needed.
    end 
    //once reading and writing is finished, close the file.
    $fclose(outfile0);
end
endmodule
