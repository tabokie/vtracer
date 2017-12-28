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
module ray_tracer_host(
    input tracer_clk,
    input rst,
    input [127:0] in_bus,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    output reg [3:0] collision_sig
);
    // function: visit one pixel at a time, then trace and shade

    reg new_frame = 1'b0;
    // generate visit pixel
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;
    // sensitive to tracer_sig(done tracing cur pixel) and rst(reset)
    always @(posedge tracer_sig or posedge rst) begin
        if(rst)begin
            col_cnt <= 7'd0;
        end
        else if(col_cnt == 7'd127) begin
            col_cnt <= 7'd0;
        end
        else begin
            col_cnt <= col_cnt + 7'd1;
        end
    end
    always @(posedge tracer_sig or posedge rst) begin
        if(rst) begin
            row_cnt <= 6'd0;
        end
        else if(col_cnt == 7'd127) begin
            if(row_cnt == 6'd63) begin // new frame
                row_cnt <= 6'd0;
                new_frame <= 1'b1;
            end
            else begin
                row_cnt <= row_cnt + 6'd1;
            end
        end
    end

    // generate view tracing ray
    wire [27:0] init;
    assign init = in_bus[27:0];
    wire [30:0] direction;
    view_ray view_ray0(.clk(clk),
        .view_normal(in_bus[58:28]),.view_dist(in_bus[66:59]),.view_loc({col_cnt,row_cnt}),
        .view_out(direction));

    // trace ray
    wire [11:0] dbuffer;
    wire tracer_sig;
    wire pixel_collision_sig;
    ray_tracer ray_tracer0(.clk(tracer_clk),.in_bus(in_bus), .init(init), .dir(direction), 
        .dout(dbuffer), .tracer_ret(tracer_sig), .collision_sig(pixel_collision_sig));

    // pass color data
    always @(posedge tracer_sig) begin
        col_addr <= col_cnt;
        row_addr <= row_cnt;
        dout <= dbuffer;
    end

    // process collision
    reg [3:0] collision_reg; // l_r_f_b
    always @(posedge tracer_sig) begin
        if(rst)begin
            collision_reg <= 4'b0;
        end
        if(col_cnt==0 && pixel_collision_sig==1'b1)begin
            collision_reg[3] <= 1;
        end
        if(col_cnt==7'd127 && pixel_collision_sig==1'b1)begin
            collision_reg[2] <= 1;
        end
        if(pixel_collision_sig)begin
            collision_reg[1] <= 1;
        end
    end

    // trace backward

    // pass collision sig
    always @(new_frame)begin
        if(new_frame==1)begin
            new_frame <= 1'b0;
            collision_sig <= collision_reg;
        end
        else begin
            collision_sig <= 0;
        end
    end

endmodule