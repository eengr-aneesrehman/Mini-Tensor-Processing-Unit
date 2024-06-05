///////////////////////////////////////////////////////////////////////////////
// Project Name:  AI Accelerator
// Module Name:   MAC
// Designer:      Anees Rehman
// Description:   Multiply-Accumulate (MAC) unit for systolic array
///////////////////////////////////////////////////////////////////////////////

module MAC 
#(
    parameter bit_width = 8
)(
    //clk and rst
    input logic clk,
    input logic rst,
    // ld weights
    input logic ld_w,
    // data-in
    input logic  [bit_width-1:0] a_in,
    input logic  [bit_width-1:0] w_in,
    input logic  [(bit_width*3)-1:0] psum_in,
    // data-out
    output logic [bit_width-1:0] a_out,
    output logic [(bit_width*3)-1:0] psum_out
);
    logic [bit_width-1:0] w_reg;

    logic [bit_width-1:0] a_out_reg,a_out_next;
    logic [(bit_width*3)-1:0] psum_out_reg,psum_out_next;

    always@(posedge clk)
    begin
        if(rst) 
        begin
            w_reg <= 0;
        end
        else if(ld_w)
        begin
            w_reg <= w_in;
        end
    end

    always@(posedge clk)
    begin
        if(rst)
        begin
            a_out_reg    <= 0;
            psum_out_reg <= 0;
        end
        else
        begin
            a_out_reg    <= a_out_next;
            psum_out_reg <= psum_out_next;
        end
    end

    //next-state logic
    always_comb 
    begin
        a_out_next    = a_in;
        psum_out_next= (a_out_reg*w_reg)+psum_in;
    end

    // output logic
    always_comb 
    begin
        a_out    = a_out_reg;
        psum_out = psum_out_reg;
    end
    
    // Dump waves
    initial 
    begin
    $dumpfile("dump.vcd");   // Specifies the name of the dump file
    $dumpvars(1, MAC);     // Dumps the variables of the adder module
    end
endmodule: MAC