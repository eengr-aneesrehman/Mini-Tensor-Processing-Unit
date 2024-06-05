module activation_unit 
#(
    parameter bit_width = 8
)
(
    input  logic [bit_width-1:0] in1,in2,in3,in4, 
    output logic [bit_width-1:0] out1,out2,out3,out4 
);
    always_comb begin
        if (in1<8'h0A) 
        begin
            out1 = 8'h00;
        end 
        else 
        begin
            out1 = in1; 
        end
    
        if (in2<8'h0A) 
        begin
            out2 = 8'h00;
        end 
        else 
        begin
            out2 = in2; 
        end
    
        if (in3<8'h0A) 
        begin
            out3 = 8'h00;
        end 
        else 
        begin
            out3 = in3; 
        end

        if (in4<8'h0A) 
        begin
            out4 = 8'h00;
        end 
        else 
        begin
            out4 = in4; 
        end
    end
    // Dump waves
    initial 
    begin
    $dumpfile("dump.vcd");   // Specifies the name of the dump file
    $dumpvars(1, activation_unit);     // Dumps the variables of the adder module
    end
endmodule