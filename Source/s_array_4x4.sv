module s_array_4x4 
#(
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
    output  logic  [(bit_width*3)-1:0]    psum_out_1,psum_out_2,psum_out_3,psum_out_4
);
    logic [bit_width-1:0]       a_out_1x1    ,a_out_2x1    ,a_out_3x1     ,a_out_4x1;
    logic [(bit_width*3)-1:0]   psum_out_1x1 ,psum_out_2x1 ,psum_out_3x1;

    logic [bit_width-1:0]       a_out_1x2    ,a_out_2x2    ,a_out_3x2     ,a_out_4x2;
    logic [(bit_width*3)-1:0]   psum_out_1x2 ,psum_out_2x2 ,psum_out_3x2;

    logic [bit_width-1:0]       a_out_1x3    ,a_out_2x3    ,a_out_3x3     ,a_out_4x3;
    logic [(bit_width*3)-1:0]   psum_out_1x3 ,psum_out_2x3 ,psum_out_3x3;

    logic [(bit_width*3)-1:0]   psum_out_1x4 ,psum_out_2x4 ,psum_out_3x4;

    logic [3:0] ld_w_decoded;
    decoder_2x4 decoder_unit (.en(ld_w_en),.in(ld_w_id[1:0]),.out(ld_w_decoded));  

    //Column 1 of Systolic Array
    MAC unit_1x1 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[0]), .a_in(a_in_1),  .w_in(w_in_1),  .psum_in(psum_in_1),    .a_out(a_out_1x1),   .psum_out(psum_out_1x1));
    MAC unit_2x1 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[1]), .a_in(a_in_2),  .w_in(w_in_1),  .psum_in(psum_out_1x1), .a_out(a_out_2x1),   .psum_out(psum_out_2x1));
    MAC unit_3x1 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[2]), .a_in(a_in_3),  .w_in(w_in_1),  .psum_in(psum_out_2x1), .a_out(a_out_3x1),   .psum_out(psum_out_3x1));
    MAC unit_4x1 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[3]), .a_in(a_in_4),  .w_in(w_in_1),  .psum_in(psum_out_3x1), .a_out(a_out_4x1),   .psum_out(psum_out_1));

    //Column 2 of Systolic Array
    MAC unit_1x2 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[0]), .a_in(a_out_1x1),  .w_in(w_in_2),  .psum_in(psum_in_2),    .a_out(a_out_1x2),   .psum_out(psum_out_1x2));
    MAC unit_2x2 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[1]), .a_in(a_out_2x1),  .w_in(w_in_2),  .psum_in(psum_out_1x2), .a_out(a_out_2x2),   .psum_out(psum_out_2x2));
    MAC unit_3x2 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[2]), .a_in(a_out_3x1),  .w_in(w_in_2),  .psum_in(psum_out_2x2), .a_out(a_out_3x2),   .psum_out(psum_out_3x2));
    MAC unit_4x2 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[3]), .a_in(a_out_4x1),  .w_in(w_in_2),  .psum_in(psum_out_3x2), .a_out(a_out_4x2),   .psum_out(psum_out_2));

    //Column 3 of Systolic Array
    MAC unit_1x3 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[0]), .a_in(a_out_1x2),  .w_in(w_in_3),  .psum_in(psum_in_3),    .a_out(a_out_1x3),   .psum_out(psum_out_1x3));
    MAC unit_2x3 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[1]), .a_in(a_out_2x2),  .w_in(w_in_3),  .psum_in(psum_out_1x3), .a_out(a_out_2x3),   .psum_out(psum_out_2x3));
    MAC unit_3x3 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[2]), .a_in(a_out_3x2),  .w_in(w_in_3),  .psum_in(psum_out_2x3), .a_out(a_out_3x3),   .psum_out(psum_out_3x3));
    MAC unit_4x3 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[3]), .a_in(a_out_4x2),  .w_in(w_in_3),  .psum_in(psum_out_3x3), .a_out(a_out_4x3),   .psum_out(psum_out_3));

    //Column 4 of Systolic Array
    MAC unit_1x4 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[0]), .a_in(a_out_1x3),  .w_in(w_in_4),  .psum_in(psum_in_4),    .a_out(),   .psum_out(psum_out_1x4));
    MAC unit_2x4 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[1]), .a_in(a_out_2x3),  .w_in(w_in_4),  .psum_in(psum_out_1x4), .a_out(),   .psum_out(psum_out_2x4));
    MAC unit_3x4 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[2]), .a_in(a_out_3x3),  .w_in(w_in_4),  .psum_in(psum_out_2x4), .a_out(),   .psum_out(psum_out_3x4));
    MAC unit_4x4 (.clk(clk),    .rst(rst),  .ld_w(ld_w_decoded[3]), .a_in(a_out_4x3),  .w_in(w_in_4),  .psum_in(psum_out_3x4), .a_out(),   .psum_out(psum_out_4));
    
    // Dump waves
    initial 
    begin
    $dumpfile("dump.vcd");   // Specifies the name of the dump file
    $dumpvars(1, s_array_4x4);     // Dumps the variables of the adder module
    end
endmodule: s_array_4x4