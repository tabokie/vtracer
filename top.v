`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:23 12/20/2017 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vga_scan_param_h.v"
module top(
    input clk,
    input rst,// posedge as reset
    input PS2C,
    input PS2D,

    output hs,
    output vs,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
);
    // clkdiv
    reg [31:0] clkdiv = 0;
    always@( posedge clk) begin
        clkdiv <= clkdiv + 1'b1;
    end

    // vga read >
    // read data
    wire [11:0] vga_din;
    // read addr
    wire [`ROW_WIDTH-1:0] read_row_addr;// 64 8*8 pixel block
    wire [`COL_WIDTH-1:0] read_col_addr;// 128 8*8 pixel block
    // link to vga
    vga vga0(
        .vga_clk(clkdiv[1]),
        .clr(rst),
        .din(vga_din),
        .col_addr(read_col_addr),
        .row_addr(read_row_addr),
        //.read_en(rdn),
        .hs(hs),.vs(vs),
        .r(r),.g(g),.b(b)
    );

    // ray tracer >
    // pixel data out
    wire [11:0] tracer_dout;
    // write addr
    wire [`ROW_WIDTH-1:0] write_row_addr;
    wire [`COL_WIDTH-1:0] write_col_addr;
    // link to tracer
    ray_tracer_host ray_tracer_host0(
        .tracer_clk(clkdiv[0]),
        .rst(rst),
        .in_bus(object_ram_bus),
        .col_addr(write_col_addr),
        .row_addr(write_row_addr),
        .dout(tracer_dout),
        .collision_sig(collision)
    );

    // pixel color ram >
    // write: tracer
    wire [`ROW_WIDTH+`COL_WIDTH-1:0] tracer_write_addr;
    // read: vga
    wire [`ROW_WIDTH+`COL_WIDTH-1:0] vga_read_addr;
    // composite
    assign tracer_write_addr = {write_col_addr,write_row_addr};
    assign vga_read_addr = {read_col_addr,read_row_addr};
    // link to ram
    dual_port_ram #(.WIDTH(`ROW_WIDTH+`COL_WIDTH),.LENGTH(12)) pixelRAM(
        // .enable(en_ram),
        .clk(clkdiv[0]),
        .rst(rst),
        .write_addr(tracer_write_addr),
        .read_addr(vga_read_addr),
        .din(tracer_dout),
        .dout(vga_din)
    );

    // object info ram >
    // object out bus
    wire [127:0] object_ram_bus;
    // player movement signal
    wire [1:0] rotate_sig;
    wire [1:0] move_sig;
    object_host object_host0(
        .clk(clkdiv[0]),
        .rotate(rotate_sig),
        .move(move_sig),
        .out_bus(object_ram_bus)
    );

    // player control >
    // keyboard signal
    wire [7:0] ascii;
    // collision signal
    wire [3:0] collision;
    control_host control_host0(
        .key(ascii),
        .en_left(collision[3]),
        .en_right(collision[2]),
        .en_forward(collision[1]),
        .en_backward(collision[0]),
        .rotate_sig(rotate_sig),
        .move_sig(move_sig)
    );

    // keyboard routine >
    keyboard kbd0(
        .clk(clkdiv[1]),.PS2C(PS2C),.PS2D(PS2D),.ascii(ascii)
    );  

endmodule


