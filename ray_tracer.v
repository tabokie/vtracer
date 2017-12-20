module ray_tracer(
    input [127:0] in_bus;
    input [27:0] init;
    input [27:0] dir;
    output [11:0] dout;
    output tracer_ret;
    output collision_sig;
)
    // trace each object
    // object 0: sphere
    reg [10:0] t0;
    wire [] object0;
    assign object0 = in_bus[];
    ray_tracer_sphere();

    // solve minimum intersection
    reg [2:0] min_id;
    min_8in(.in0(t0),.in1,.out(min_id));

    // check collision
    reg collision_sig;
    `define err ...
    if(t[min_id] < err)assign collision_sig = 1;

    // shading
    // simple test
    if(t[min_id] > err)assign dout = BLACK;
    else assign dout = WHITE;

    // set return
    always @(dout) begin
        tracer_ret <= 1'b1;
    end

endmodule


    /*
    reg [NUM-1:0] object_sig;
    generate
        genvar i;
        for(i = 0; i < NUM_OBJ; i = i+1) begin : tracer_instance
            reg [2:0] obj_type;
            reg [3:0] obj_id;

            ray_tracer #(.ret_sig(object_sig[i]));

        end
    endgenerate
    reg [NUM-1:0] intersect_id;
    always @(object_sig)begin
        
    end
    */