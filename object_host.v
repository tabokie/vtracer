module object_host(
    input clk,
    input [1:0] rotate,
    input [1:0] move,
    output [127:0] out_bus
);
    // int: 10-bit
    // point: 10-bit * 10-bit * 8-bit(height)
    // vector: same as point

    reg [27:0] view_init;
    reg [27:0] view_normal;
    reg [9:0] view_dist;
    reg view_light_en;

    reg [27:0] sphere0_center;
    reg [9:0] sphere0_radius;
    reg [11:0] sphere0_color;

    always @(posedge clk)begin
        case(rotate)
            2'b01:view_normal
            2'b10:
        endcase
        case(move)
            2'b01:player <= player - view_normal*move_speed;
            2'b10:player <= player + view_normal*move_speed;
        endcase
    end

    assign outbus[66:0] = {view_normal, player};

endmodule