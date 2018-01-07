`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:26 12/23/2017 
// Design Name: 
// Module Name:    object_host 
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
`define BLACK 12'b0
`define WHITE 12'b111111111111
module object_host(
    input clk,
    input rst,
    input [1:0] rotate,
    input [1:0] move,
    output [179:0] out_bus
);
    // uint: 10-bit / 8-bit
    // min_dist: 8-bit (<256)
    // max_dist: 11-bit
    // int: 11-bit / 9-bit
    // point: 10-bit * 10-bit * 8-bit(height) = 28([27:0]) x([27:18]), y([17:8]), z([7:0])
    // vector: 11-bit * 11-bit * 9-bit = 31([30:0]) x([30:20]), y([19:9]), z([8:0])

    // player: 28 + 31 + 8 + 1 = 68
    reg [27:0] view_init = 28'b0; // point: x10_y10_z8
    reg [30:0] view_normal = 31'b00000000000_00000000001_000000000; //31'b00111111111_00111111111_000000000; // vector: x11_y11_z9
    reg [7:0] view_dist = 8'b1111; // min_dist: 8
    reg view_light_en = 1'b0; // if also a light obj
    assign out_bus[67:0] = {view_light_en,view_dist,view_normal,view_init};

    // sphere: 28 + 8 + 12 = 48
    reg [27:0] sphere0_center = 28'b0000000000_0000100000_00010000; // point: x10_y10_z8
    reg [7:0] sphere0_radius = 8'b00010000; // min_dist: 8
    reg [11:0] sphere0_color = `WHITE; // color: 12
    assign out_bus[115:68] = {sphere0_color,sphere0_radius,sphere0_center};

    // box: 10*4+8*2 = 56
    reg [9:0] x_lo = 10'd16;
    reg [9:0] x_hi = 10'd32;
    reg [9:0] y_lo = 10'd20;
    reg [9:0] y_hi = 10'd36;
    reg [7:0] z_lo = 10'd0;
    reg [7:0] z_hi = 10'd30;
    assign out_bus[171:116] = {x_lo,x_hi,y_lo,y_hi,z_lo,z_hi};

    // rotate: normal(x,y,0) + delta_normal(y*4/|d|,x*4/|d|,0)
    reg [7:0] move_range = 8'b00000100;
    wire [10:0] mx;
    wire [10:0] my;
    two_d_normalize norm0(.clk(clk),.d(move_range),.dir(view_normal[30:9]),
        .normalized_x(mx),.normalized_y(my));

    reg [7:0] rotate_range = 8'b00000100;
    wire [10:0] rx;
    wire [10:0] ry;
    two_d_normalize norm1(.clk(clk),.d(rotate_range),.dir({view_normal[19:9],view_normal[30:20]}),
        .normalized_x(rx),.normalized_y(ry));

    // unused bit
    reg change;
    // l_r_f_b
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            view_init <= 28'b0;
            view_normal <= 31'b00000000000_00000000001_000000000;
        end
        else begin
            case(rotate)
                2'b01:begin
                    // right: x+=dy,y-=dx
                    view_normal[30:20] <= (view_normal[30:20] + rx);
                    view_normal[19:9] <= (view_normal[19:9] + ~ry + 11'b1);
                end
                2'b10:begin
                    // left: x-=dy,y+=dx
                    view_normal[30:20] <= (view_normal[30:20] + ~rx + 11'b1);
                    view_normal[19:9] <= (view_normal[19:9] + ry );
                end
            endcase
            case(move)
                2'b01:begin
                    // backward: x+=dx,y+=dy
                    {change,view_init[27:18]} <= ({1'b0,view_init[27:18]} + my);
                    {change,view_init[17:8]} <= ({1'b0,view_init[17:8]} + mx);
                end
                2'b10:begin
                    // forward: x-=dx,y-=dy
                    {change,view_init[27:18]} <= ({1'b0,view_init[27:18]} + ~my + 11'b1);
                    {change,view_init[17:8]} <= ({1'b0,view_init[17:8]} + ~mx + 11'b1);
                end
            endcase
        end
    end

endmodule



