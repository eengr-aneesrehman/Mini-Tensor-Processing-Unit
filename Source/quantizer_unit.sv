module quantizer_unit 
#(
    parameter bit_width = 8
)
(
    input  logic [(bit_width*3)-1:0] in1,in2,in3,in4, 
    output logic [bit_width-1:0] out1,out2,out3,out4 
);
    always_comb begin
        if (in1<24'hFF) 
        begin
            out1 = in1;
        end 
        else 
        begin
            out1 = 8'hFF; 
        end

        if (in2<24'hFF) 
        begin
            out2 = in2;
        end 
        else 
        begin
            out2 = 8'hFF; 
        end

        if (in3<24'hFF) 
        begin
            out3 = in3;
        end 
        else 
        begin
            out3 = 8'hFF; 
        end
        if (in4<24'hFF) 
        begin
            out4 = in4;
        end 
        else 
        begin
            out4 = 8'hFF; 
        end
    end
    // Dump waves
    initial 
    begin
    $dumpfile("dump.vcd");   // Specifies the name of the dump file
    $dumpvars(1, quantizer_unit);     // Dumps the variables of the adder module
    end
endmodule