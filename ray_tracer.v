
module ray_tracer_host(
    input tracer_clk,
    input rst,
    input [127:0] in_bus,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    output reg [3:0] collosion_sig,
)
    wire tracer_sig;
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;

    ray_tracer #(
        .col_coord(col_cnt), .row_coord(row_cnt), 
        .ret_sig(tracer_sig), .dout(dout)
    );
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

endmodule

module ray_tracer(
    input [6:0] col_coord,
    input [5:0] row_coord,
    input [127:0] in_bus,
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

module view_ray

module light_tracer

module trace_sphere

