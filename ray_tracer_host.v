`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:02:52 12/23/2017 
// Design Name: 
// Module Name:    ray_tracer_host 
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
// pipeline latency
`define MAX_LATENCY 37
`define MAX_WIDTH 7
// for no shader
// 54 + 34 + 2 = 90
// `define TOTAL_LATENCY 90
// for shader added
// 88 + 34 + 2 = 124
`define TOTAL_LATENCY 124
`define TOTAL_WIDTH 8
// canvas size
`define COL_INIT 7'd0
`define ROW_INIT 6'd0
`define COL_MAX 7'd79
`define ROW_MAX 6'd59


module ray_tracer_host(
    input clk,
    input rst,
    input [179:0] in_bus,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    output reg [3:0] collision_sig
);

    // function: visit one pixel at a time, then trace and shade

    // Task Dispatcher
    reg [`MAX_WIDTH-1:0] i;
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            col_cnt <= `COL_INIT;
            row_cnt <= `ROW_INIT;
            i <= 0;
        end
        else begin
            if(i==`MAX_LATENCY - 2)begin
                i <= i + 1;
                col_cnt <= (col_cnt == `COL_MAX) ? `COL_INIT : (col_cnt + 7'd1);
                if(col_cnt == `COL_MAX)begin
                    row_cnt <= (row_cnt == `ROW_MAX) ? `ROW_INIT : (row_cnt + 6'd1); 
                end
            end
            else if(i==`MAX_LATENCY - 1)begin
                i <= 0;
            end
            else begin
                i <= i + 1;
            end
        end
    end

    reg rt_rst = 1'b1;
    reg [5:0] k;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            k <= 6'b0;
            rt_rst <= 1'b0;
        end
        else begin
            if( k == 6'd34)begin
                rt_rst <= 1'b1;
            end
            else begin
                k <= k + 6'd1;
            end
        end
    end


    /*  34 clk  */
    // pipeline A
    // View Ray Solver
    wire [30:0] view_ray_out;
    view_ray view_ray_module(
        .clk(clk),.rst(rst),
        .view_normal(in_bus[58:28]),.view_dist(in_bus[66:59]),.view_loc({col_cnt,row_cnt}),
        .view_out(view_ray_out)
    );

    /*  52+2=54  */ /*  => 52+34+2 = 88  */
    // pipeline B
    // Ray Tracer (shader included)
    wire [11:0] pixel_color_out;
    wire pixel_collision_out;
    ray_tracer ray_tracer_module(
        .clk(clk),.rst(rt_rst),
        .in_bus(in_bus),.init(in_bus[27:0]),.dir(view_ray_out),
        .dout(pixel_color_out),.collision_ret(pixel_collision_out));

   // Data Dispatcher
    reg [`TOTAL_WIDTH-1:0] j;
    reg first_latency;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            j <= 0;
            first_latency <= 1'd1;
            col_addr <= `COL_INIT;
            row_addr <= `ROW_INIT;
            dout <= 12'hfff;
        end
        else begin
            if(first_latency == 1'd1)begin
                if(j==`TOTAL_LATENCY)begin
                    first_latency <= 1'd0;
                    j <= 0;
                    col_addr <= `COL_INIT;
                    row_addr <= `ROW_INIT;
                    dout <= pixel_color_out;
                end
                else begin
                    j <= j+1;
                end
            end
            else begin
                if(j == `MAX_LATENCY - 2)begin
                    j <= j + 1;
                    col_addr <= (col_addr == `COL_MAX) ? `COL_INIT : (col_addr + 7'd1);
                    if(col_addr == `COL_MAX)begin
                        row_addr <= (row_addr == `ROW_MAX) ? `ROW_INIT : (row_addr + 6'd1);
                    end
                    dout <= pixel_color_out;                    
                end
                else if(j == `MAX_LATENCY - 1)begin
                    j <= 0;
                end
                else begin
                    j <= j+1;
                end
            end
        end
    end
    // Collision Dispatcher //
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            collision_sig <= 4'hf;
        end
        else begin
            if(col_addr==`COL_MAX && row_addr == `ROW_MAX)begin
                collision_sig <= 4'hf;
            end
            else begin
                case(col_addr)
                7'd0:begin
                    collision_sig[3] <= pixel_collision_out; 
                end
                `COL_MAX:begin
                    collision_sig[2] <= pixel_collision_out;
                end
                endcase  
                if(pixel_collision_out)begin
                    collision_sig[1] <= 1'd1;
                end
            end
        end
    end


endmodule