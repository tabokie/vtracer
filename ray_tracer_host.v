module ray_tracer_host(
    input tracer_clk,
    input rst,
    input [127:0] in_bus,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    output reg [3:0] collosion_sig
);
    // function: visit each pixel at one time, trace and shade


    // generate visit pixel
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;
    wire clear;
    assign clear = 1;
    always @(posedge tracer_sig) begin
        if(!clear)begin
            col_cnt <= 7'd0;
        end
        else if(col_cn == 7'd127) begin
            col_cnt <= 7'd0;
        end
        else begin
            col_cnt <= col_cnt + 7'd1;
        end
    end

    always @(posedge tracer_sig) begin
        if(!clear) begin
            row_cnt <= 6'd0;
        end
        else if(col_cnt == 7'd127) begin
            if(row_cnt == 6'd63) begin
                row_cnt <= 6'd0;
            end
            else begin
                row_cnt <= row_cnt + 6'd1;
            end
        end
    end

    // generate view tracing ray
    reg [27:0] init;
    assign init = in_bus[27:0];
    reg [27:0] directon;
    view_ray(.view_normal(in_bus[55:28]),.view_dist(in_bus[65:56]), .view_loc({col_cnt,row_cnt}),
        .view_out(direction));

    // trace ray
    wire tracer_sig;
    wire pixel_collision_sig;
    ray_tracer(.in_bus(in_bus), .init(init), .dir(direction), 
        .dout(dout), .tracer_ret(tracer_sig), collision_sig(pixel_collision_sig));

    // pass color data
    always @(posedge tracer_sig) begin
        col_addr <= col_cnt;
        row_addr <= row_cnt;
    end

    // process collision
    reg [3:0] collision_reg; // l_r_f_b
    always @(posedge tracer_sig) begin
        if(!clear)begin
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

endmodule