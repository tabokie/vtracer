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
`define collision_bound 2
`define tracing_bound 10'd200
`define BLACK 12'h000
`define WHITE 12'hfff
`define SHADER_LATENCY 0
`define LATENCY_WIDTH 1

module ray_tracer(
    input clk,
    input rst,
    input [179:0] in_bus,
    input [27:0] init,
    input [30:0] dir,
    output reg [11:0] dout,
    output reg collision_ret
);

    // internal pipeline maneger for shader
    reg [5:0] i;
    reg shader_rst = 1'b0;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            i <= 6'b0;
        end
        else begin
            case(i)
            6'd52:begin
                shader_rst <= 1'b1;
            end
            default: i <= i+6'b1;
            endcase
        end
    end


    /*  52 clk  */
    // pipeline B.1 //
    // Intersection Solver //
    // trace each object >>
    // set 8 objects with 10-bit output t
    wire [79:0] t;
    // object 0: sphere
    wire [47:0] object0;
    wire [30:0] sphere0_normal;
    assign object0 = in_bus[115 : 68];
    ray_tracer_sphere sphere_tracer0(.clk(clk),.rst(rst),.init(init),.dir(dir),.object_in(object0),.t_out(t[9:0]),.normal(sphere0_normal));
        
    // object 1:
    wire [55:0] object1;
    wire [30:0] box0_normal;
    assign object1 = in_bus[171:116];
    ray_tracer_box box_tracer0(.clk(clk),.rst(rst),.init(init),.dir(dir),.object_in(object1),.t_out(t[19:10]),.normal(box0_normal));

    assign t[79:20] = -1;
    
    // pipeline B.2 //
    // Minimum Filter //
    // solve minimum intersection >>
    wire [2:0] min_id;
    min #(.WIDTH(3),.LENGTH(10)) in8_len10_min(.in_bus(t),.out(min_id));

    // collision check
    wire collision_sig;
    assign collision_sig = t[(min_id+1)*10-1 -: 10] < `collision_bound;

    //  34  clk //
    // pipeline B.3 //
    // Shader //
    wire [11:0] shading_color;

    reg [30:0] normal;
    reg [9:0] normal_mold;
    always @(*)begin
        case(min_id)
        3'b0:begin // sphere 0
            // n = (init+r) - c
            normal = sphere0_normal; 
            normal_mold = {2'b0,in_bus[103:96]};
        end
        3'b1:begin // box 1
            normal = box0_normal;
            normal_mold = 10'b1;
        end
        endcase
    end
    single_shader shader(.clk(clk),.rst(shader_rst),
        .light(28'b0),.init(in_bus[27:0]),.dir(dir),.t(t[(min_id+1)*10-1 -: 10]),.normal(normal),.normal_mold(normal_mold),
        .color(shading_color));

    // shader for test
    // assign shading_color = (t[(min_id+1)*10-1 -: 10] > `tracing_bound) ? `BLACK : `WHITE;
    
    /*   1 clk   */
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            dout <= `BLACK;
            collision_ret <= 1;
        end
        else begin
            dout <= shading_color;
            collision_ret <= collision_sig;
        end
    end


endmodule


