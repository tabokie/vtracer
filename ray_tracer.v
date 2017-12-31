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
`define SHADER_LATENCY 0
`define LATENCY_WIDTH 1

module ray_tracer(
    input clk,
    input rst,
    input [127:0] in_bus,
    input [27:0] init,
    input [30:0] dir,
    output reg [11:0] dout,
    output reg collision_ret
    // test
    ,
    output [79:0] t_show,
    output [2:0] min_show
);
    
    // pipeline B.1 //
    // Intersection Solver //
    // trace each object >>
    // set 8 objects with 10-bit output t
    wire [79:0] t;
    // object 0: sphere
    wire [47:0] object0;
    assign object0 = in_bus[115 : 68];
    ray_tracer_sphere sphere_tracer0(.clk(clk),.rst(rst),.init(init),.dir(dir),.object_in(object0),.t_out(t[9:0]));
    // object 1:
    assign t[79:10] = -1;
        assign t_show = t;

    // pipeline B.2 //
    // Minimum Filter //
    // solve minimum intersection >>
    wire [2:0] min_id;
    min #(.WIDTH(3),.LENGTH(10)) in8_len10_min(.in_bus(t),.out(min_id));
        assign min_show = min_id;

    // collision check
    wire collision_sig;
    assign collision_sig = t[(min_id+1)*10-1 -: 10] < `collision_bound;

    // pipeline B.3 //
    // Shader //
    // only test
    wire [11:0] shading_color;
    assign shading_color = (t[(min_id+1)*10-1 -: 10] > `tracing_bound) ? `BLACK : `WHITE; 


    // Dealing Latency
    reg [`LATENCY_WIDTH-1:0] i;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            i <= 0;
            dout <= `BLACK;
            collision_ret <= 1;
        end
        else begin
            if(i>`SHADER_LATENCY)begin
                i <= 0;
                dout <= shading_color;
                collision_ret <= collision_sig;
            end
            else begin
                i <= i+1;
            end
        end
    end

endmodule


