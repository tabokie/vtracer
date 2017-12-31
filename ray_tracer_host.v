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
`define MAX_LATENCY 5
`define MAX_WIDTH 3
`define TOTAL_LATENCY 7
`define TOTAL_WIDTH 4
// canvas size
`define COL_MAX 80
`define ROW_MAX 60

module ray_tracer_host(
    input clk,
    input rst,
    input [127:0] in_bus,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    output reg [3:0] collision_sig
    // test
    // ,
    // output [6:0] col_before,
    // output [5:0] row_before,
    // output [30:0] direction,
    // output [11:0] dbuffer,
    // output [`MAX_WIDTH-1:0] i_show,
    // output [`TOTAL_WIDTH-1:0] j_show
);
    // function: visit one pixel at a time, then trace and shade


    // Task Dispatcher
    reg [`MAX_WIDTH-1:0] i;
        // assign i_show = i;
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;
        // assign col_before = col_cnt;
        // assign row_before = row_cnt;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            col_cnt <= 0;
            row_cnt <= 0;
            i <= 0;
        end
        else begin
            if(i>`MAX_LATENCY+1)begin
                i <= 0;
                col_cnt <= (col_cnt == `COL_MAX) ? 0 : (col_cnt + 1);
                if(col_cnt == `COL_MAX)begin
                    row_cnt <= (row_cnt == `ROW_MAX) ? 0 : (row_cnt + 1); 
                end
            end
            else begin
                i <= i+1;
            end
        end
    end

    // pipeline A
    // View Ray Solver
    wire [30:0] view_ray_out;
        // assign direction = view_ray_out;
    view_ray view_ray_module(
        .clk(clk),.rst(rst),
        .view_normal(in_bus[58:28]),.view_dist(in_bus[66:59]),.view_loc({col_cnt,row_cnt}),
        .view_out(view_ray_out)
    );

    // pipeline B
    // Ray Tracer (shader included)
    wire [11:0] pixel_color_out;
    wire pixel_collision_out;
        // assign dbuffer = pixel_color_out;
    ray_tracer ray_tracer_module(
        .clk(clk),.rst(rst),
        .in_bus(in_bus),.init(in_bus[27:0]),.dir(view_ray_out),
        .dout(pixel_color_out),.collision_ret(pixel_collision_out)
    );


   // Data Dispatcher
    reg [`TOTAL_WIDTH-1:0] j;
        // assign j_show = j;
    reg first_latency;
    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            j <= 0;
            first_latency <= 1;
            col_addr <= 0;
            row_addr <= 0;
            dout <= 0;
        end
        else begin
            if(first_latency == 1)begin
                if(j>`TOTAL_LATENCY)begin
                    first_latency <= 0;
                    j <= 0;
                    col_addr <= 0;
                    row_addr <= 0;
                    dout <= pixel_color_out;
                end
                else begin
                    j <= j+1;
                end
            end
            else begin
                if(j > `MAX_LATENCY + 1)begin
                    j <= 0;
                    col_addr <= (col_addr == `COL_MAX) ? 0 : (col_addr + 1);
                    if(col_addr == `COL_MAX)begin
                        row_addr <= (row_addr == `ROW_MAX) ? 0 : (row_addr + 1);
                    end
                    dout <= pixel_color_out;                    
                end
                else begin
                    j <= j+1;
                end
            end
        end
    end
    // Collision Dispatcher
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            collision_sig <= -1;
        end
        else begin
            if(col_addr==`COL_MAX && row_addr == `ROW_MAX)begin
                collision_sig <= -1;
            end
            else begin
                case(col_addr)
                0:begin
                    collision_sig[3] <= pixel_collision_out; 
                end
                `COL_MAX:begin
                    collision_sig[2] <= pixel_collision_out;
                end
                endcase  
                if(pixel_collision_out)begin
                    collision_sig[1] <= 1;
                end
            end
        end
    end


endmodule