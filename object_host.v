module object_host(
    input clk,
    input [1:0] rotate,
    input [1:0] move,
    output [127:0] out_bus
);
    // uint: 10-bit / 8-bit
    // min_dist: 8-bit (<256)
    // max_dist: 11-bit
    // int: 11-bit / 9-bit
    // point: 10-bit * 10-bit * 8-bit(height) = 28([27:0])
    // vector: 11-bit * 11-bit * 9-bit = 31([30:0])

    // player: 28+31+8+1 = 68
    reg [27:0] view_init; // x10_y10_z8
    reg [30:0] view_normal;
    reg [7:0] view_dist;
    reg view_light_en;
    assign out_bus[67:0] = {view_light_en,view_dist,view_normal,view_init};

    // sphere: 28+8+12 = 48
    reg [27:0] sphere0_center;
    reg [7:0] sphere0_radius;
    reg [11:0] sphere0_color;
    assign out_bus[115:67] = {sphere0_color,sphere0_radius,sphere0_center};

    reg [9:0] dx;
    reg [9:0] dy;

    always @(posedge clk)begin
        case(rotate)
            2'b01:view_normal
            2'b10:
        endcase
        case(move)
            2'b01:view_init[] <= player - view_normal*move_speed;
            2'b10:player <= player + view_normal*move_speed;
        endcase
    end


endmodule