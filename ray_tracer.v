module ray_tracer(
    input [127:0] in_bus;
    input [27:0] init;
    input [27:0] dir;
    output [11:0] dout;
    output tracer_ret;
    output collision_sig;
)
    // trace each object
    // set 8 objects with 10-bit output t
    reg [9:0] t[7:0]
    // object 0: sphere
    wire [] object0;
    wire [9:0] t0;
    assign t0 = t[0];
    assign object0 = in_bus[];
    ray_tracer_sphere();

    // solve minimum intersection
    reg [2:0] min_id;
    min 8_in(.in_bus(t),.out(min_id));

    // check collision
    reg collision_sig;
    `define collision_bd ...
    if(t[min_id] < collision_bd)assign collision_sig = 1;

    // shading
    // simple test
    `define tracer_bd
    if(t[min_id] > bd)assign dout = BLACK;
    else assign dout = WHITE;

    // set return
    always @(dout) begin
        tracer_ret <= 1'b1;
    end

endmodule

