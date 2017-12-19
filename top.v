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

    reg [11:0] tracer_dout;
    wire [5:0] write_row_addr;
    wire [6:0] write_col_addr;
    wire [3:0] collision;
    ray_tracer_host #(
        .tracer_clk(clkdiv[0]),
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

    )

endmodule

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
    input  
    output [1024:0] out_bus
)

endmodule

module ray_tracer_host(
    input tracer_clk,
    input rst,
    input [1024:0] in_bus,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    // output sinc_ret
)
    wire tracer_sig;
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;

    view_ray #()

    ray_tracer #(
        .col_coord(col_cnt), .row_coord(row_cnt), 
        .ret_sig(tracer_sig), .dout(dout)
    );
    always @(tracer_sig and posedge tracer_clk) begin
        
    end

endmodule

module ray_tracer(
    input [6:0] col_coord,
    input [5:0] row_coord,
    input [1024:0] in_bus,
    output ret_sig,
    output [11:0] dout
)

    reg [NUM_OBJ : 0] tracer_sig;
    generate
        genvar i;
        for(i = 0; i < NUM_OBJ; i = i+1) begin : tracer_instance
            reg [2:0] obj_type;
            reg [3:0] obj_id;

            ray_tracer #(.ret_sig(tracer_sig[i]));

        end
    endgenerate

endmodule

module light_tracer

module trace_sphere

