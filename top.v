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

)
    
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

// move: a_b a forward, b backward
// rotate: a_b a left, b right
module control_host(
    input key,
    input en_left,
    input en_right,
    input en_forward,
    input en_backward,
    output [1:0] rotate_sig,
    output [1:0] move_sig
)
    reg [1:0] rotate;
    reg [1:0] move;
    case(key)begin
        
    endcase

    always@* begin
        if(en_left)rotate_sig[1] <= rotate[1];
        if(en_right)rotate_sig[0] <= rotate[0];
        if(en_forward)move_sig[1] <= move[1];
        if(en_backward)move_sig[0] <= move[0];
    end

endmodule

// connected with bus
// divided into 
// player
// light
// objects

// transfer view_ray and one object and lights to trace_obj
// get t
// calc normal
// transfer light_ray and lights to trace_light

module object_host(
    input clk,
    input [1:0] rotate,
    input [1:0] move,
    output [127:0] out_bus
)
    // int: 12-bit
    // point: 12-bit * 12-bit * 8-bit(height)
    // vector: same as point


    // x,y:24-bit; z: 8-bit; add up to 32-bit
    reg [31:0] player;
    reg [31:0] view_normal;

    reg [31:0] sphere0_center;
    reg [11:0] sphere0_radius;

    always @(posedge clk)begin
        case(rotate)
            2'b01:view_normal <= 
            2'b10:
        endcase
        case(move)
            2'b01:player <= player - view_normal*move_speed;
            2'b10:player <= player + view_normal*move_speed;
        endcase
    end

    assign outbus[63:0] = {view_normal, player};
    assign outbus[107:64] = {sphere0_radius,sphere0_center}; 

endmodule
