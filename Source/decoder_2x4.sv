module decoder_2x4 
(
    input  logic [1:0] in, 
    input  logic       en,    
    output logic [3:0] out 
);
    always_comb begin
        if (en) begin
            case (in)
                2'b00: out = 4'b0001; 
                2'b01: out = 4'b0010;
                2'b10: out = 4'b0100;
                2'b11: out = 4'b1000; 
                default: out = 4'b0000; 
            endcase
        end else begin
            out = 4'b0000; 
        end
    end
    // Dump waves
    initial 
    begin
    $dumpfile("dump.vcd");   // Specifies the name of the dump file
    $dumpvars(1, decoder_2x4);     // Dumps the variables of the adder module
    end
endmodule : decoder_2x4