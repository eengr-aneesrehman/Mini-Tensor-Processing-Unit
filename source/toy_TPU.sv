module toy_TPU#(
    parameter bit_width = 8
)(
    //clk and rst
    input logic clk,
    input logic rst,
    // ld weights
    input logic [1:0]ld_w_id,
    input logic ld_w_en,
    // data-in
    input   logic  [bit_width-1:0]        a_in_1,a_in_2,a_in_3,a_in_4,
    input   logic  [bit_width-1:0]        w_in_1,w_in_2,w_in_3,w_in_4,
    input   logic  [(bit_width*3)-1:0]    psum_in_1,psum_in_2,psum_in_3,psum_in_4,
    // data-out
    output  logic  [bit_width-1:0]    out_1,out_2,out_3,out_4
);

logic   [(bit_width*3)-1:0] psum_out_1,psum_out_2,psum_out_3,psum_out_4;
logic   [bit_width-1:0]     q_out_1,q_out_2,q_out_3,q_out_4;


s_array_4x4 #(.bit_width(bit_width)) array (
    .clk(clk),
    .rst(rst),
    .ld_w_id(ld_w_id),
    .ld_w_en(ld_w_en),
    .a_in_1(a_in_1),.a_in_2(a_in_2),.a_in_3(a_in_3),.a_in_4(a_in_4),
    .w_in_1(w_in_1),.w_in_2(w_in_2),.w_in_3(w_in_3),.w_in_4(w_in_4),
    .psum_in_1(psum_in_1),.psum_in_2(psum_in_2),.psum_in_3(psum_in_3),.psum_in_4(psum_in_4),
    .psum_out_1(psum_out_1),.psum_out_2(psum_out_2),.psum_out_3(psum_out_3),.psum_out_4(psum_out_4)
    );

quantizer_unit #(.bit_width(bit_width)) q_unit (
    .in1(psum_out_1),.in2(psum_out_2),.in3(psum_out_3),.in4(psum_out_4), 
    .out1(q_out_1),.out2(q_out_2),.out3(q_out_3),.out4(q_out_4) 
    );   

activation_unit #(.bit_width(bit_width)) a_unit (
    .in1(q_out_1),.in2(q_out_2),.in3(q_out_3),.in4(q_out_4), 
    .out1(out_1),.out2(out_2),.out3(out_3),.out4(out_4) 
    ); 

// Dump waves
initial 
begin
$dumpfile("dump.vcd");   // Specifies the name of the dump file
$dumpvars(1, toy_TPU);     // Dumps the variables of the adder module
end
endmodule