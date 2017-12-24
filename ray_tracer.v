`include "scene_ram_h.v"
`define collision_bound 2
`define tracing_bound 200
`define BLACK 12'b0
`define WHITE 12'b111111111111

module ray_tracer(
    input [127:0] in_bus,
    input [27:0] init,
    input [27:0] dir,
    output reg [11:0] dout,
    output reg tracer_ret,
    output reg collision_sig
);
    // trace each object4
    // set 8 objects with 10-bit output t
    reg [9:0] t[7:0];
    // object 0: sphere
    wire [49:0] object0;
    wire [9:0] t0;
    assign t0 = t[0];
    assign object0 = in_bus[`object_end+49 : `object_end];
    ray_tracer_sphere(.init(init),.dir(dir),.object_in(object0),.t_out(t0));

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
