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
    // test
    // ,
    // output [9:0] t_show
    // output [2:0] min_show
    // integrate test
    // ,output [27:0] init_show,
    // output [30:0] dir_show,
    // output [47:0] object_show,
    // output [19:0] final_show
    // ,output [19:0] d_mold_show,
    // output [19:0] delta_show,
    // output [19:0] div_res,
    // output [19:0] final_show
);
    // assign t_show = t[9:0];

    /*  37 clk  */
    // pipeline B.1 //
    // Intersection Solver //
    // trace each object >>
    // set 8 objects with 10-bit output t
    wire [79:0] t;
    // object 0: sphere
    wire [47:0] object0;
    assign object0 = in_bus[115 : 68];
    ray_tracer_sphere sphere_tracer0(.clk(clk),.rst(rst),.init(init),.dir(dir),.object_in(object0),.t_out(t[9:0]));
        // ,.d_mold_show(d_mold_show)
        // ,.delta_show(delta_show)
        // ,.div_res_show(div_res)
        // ,.final_show(final_show) );
    // object 1:
    wire [55:0] object1;
    assign object1 = in_bus[171:116];
    ray_tracer_box box_tracer0(.clk(clk),.rst(rst),.init(init),.dir(dir),.object_in(object1),.t_out(t[19:10]));

    assign t[79:20] = -1;
    
    // pipeline B.2 //
    // Minimum Filter //
    // solve minimum intersection >>
    wire [2:0] min_id;
    min #(.WIDTH(3),.LENGTH(10)) in8_len10_min(.in_bus(t),.out(min_id));

    // collision check
    wire collision_sig;
    assign collision_sig = t[(min_id+1)*10-1 -: 10] < `collision_bound;

    // pipeline B.3 //
    // Shader //
    // only test
    // wire [30:0] init;
    // wire [30:0] ray;
    // wire [30:0] intersect;
    // wire [30:0] light;
    // assign init = in_bus[27:0];
    // assign ray = t[(min_id+1)*10-1 -: 10];

    // reg [19:0] normal_dir;
    // reg [19:0] orient_dir;
    // always @(posedge clk or negedge rst)begin
    //     if(!rst)begin
    //         normal_dir <= 0;
    //         orient_dir <= 0;
    //     end
    //     else begin
    //         case(min_id)
    //         3'b0:begin // sphere 0
    //             // n = (init+r) - c
    //             // o = light_init - (init+r)
    //             normal_dir[30:20] = 
    //         end
    //         endcase
    //     end
    // end
    wire [11:0] shading_color;
    assign shading_color = (t[(min_id+1)*10-1 -: 10] > `tracing_bound) ? `BLACK : `WHITE;
    
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


