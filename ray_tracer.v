`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:55:41 12/23/2017 
// Design Name: 
// Module Name:    ray_tracer 
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
`include "scene_ram_h.v"
`define collision_bound 2
`define tracing_bound 200
`define BLACK 12'b0
`define WHITE 12'b111111111111

module ray_tracer(
    input clk,
    input [127:0] in_bus,
    input [27:0] init,
    input [30:0] dir,
    output reg [11:0] dout,
    output reg tracer_ret,
    output reg collision_sig
);
    // trace each object
    // set 8 objects with 10-bit output t
    reg [79:0] t;
    // object 0: sphere
    wire [47:0] object0;
    wire [9:0] t0;
    assign t0 = t[9:0];
    assign object0 = in_bus[115 : 68];
    ray_tracer_sphere sphere_tracer0(.clk(clk),.init(init),.dir(dir),.object_in(object0),.t_out(t0));

    // solve minimum intersection
    reg [2:0] min_id;
    min #(.WIDTH(3),.LENGTH(10)) in8_len10_min(.in_bus(t),.out(min_id));

    always @(min_id)begin
        // collision check
        if(t[min_id] <= `collision_bound)collision_sig = 1;
        // shading test
        if(t[min_id] > `tracing_bound)dout = `BLACK;
        else dout = `WHITE;
    end

    // set return
    always @(dout) begin
        tracer_ret <= 1'b1;
    end

endmodule


