`timescale 1ns / 1ps

// today's progress:
// implement basic structure
// todo:
// from double ram to single dual port ram <-
// implement object ram and their correponding decoder and first-level sdf <- multi-facet? wall?
// add full set ray tracing <- light management ? three light: myLight, lampLight, highLight
// add scene <- // coords and boundary
// about control ==> collision judgement and random enemies <- complicated, maybe state machine?

module top(
    input clk,
    input rst,

    output hs,
    output vs,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b 

);
    
    reg [31:0] clkdiv;
    always@( posedge clk) begin
        clkdiv <= clkdiv + 1'b1
    end

    // vga read //
    reg [11:0] vga_din;
    wire [5:0] read_row_addr;// 64 8*8 pixel block
    wire [6:0] read_col_addr;// 128 8*8 pixel block
    wire rdn;

    // send to vga
    vga #(
        .vga_clk(clkdiv[1]),
        .din(vga_din),
        .col_addr(read_col_addr),
        .row_addr(read_row_addr),
        .read_en(rdn),
        .hs(hs),.vs(vs),
        .r(r),.g(g),.b(b),
    );
    wire [127:0] object_ram_bus;
    reg [11:0] tracer_dout;
    wire [5:0] write_row_addr;
    wire [6:0] write_col_addr;
    wire [3:0] collision;
    ray_tracer_host #(
        .tracer_clk(clkdiv[0]),
        .rst(rst).
        .in_bus(object_ram_bus),
        .col_addr(write_col_addr),
        .row_addr(write_row_addr),
        .dout(tracer_dout),
        .collision_sig(collision)
    )

    wire tracer_write_addr;
    wire vga_read_addr;
    assign tracer_write_addr = {write_col_addr,write_row_addr};
    assign vga_read_addr = {read_col_addr,read_row_addr};
    dual_port_ram #(.WIDTH(13),.LENGTH(12)) pixelRAM(
        // .enable(en_ram),
        .clk(clkdiv[0]),
        .write_addr(tracer_write_addr),
        .read_addr(vga_read_addr),
        .din(tracer_dout),
        .dout(vga_din)
    )

    control_host #(
        .key(key_sig),
        .en_left(collision[3]),
        .en_right(collision[2]),
        .en_forward(collision[1]),
        .en_backward(collision[0]),
        .rotate_sig(rotate_sig),
        .move_sig(move_sig)
    )

    object_host #(
        .clk(clkdiv[0]),
        .rotate(rotate_sig),
        .move(move_sig),
        .out_bus(object_ram_bus)
    )

endmodule

