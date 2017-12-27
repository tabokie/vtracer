// specially for vector (x,y,0)
module two_d_normalize(
    input [7:0] d,
    input [21:0] dir,
    output [10:0] normalized_x,
    output [10:0] normalized_y
);
    wire [19:0] nmold;
    wire [19:0] nx;
    signed_to_20b_signed #(.LENGTH(11)) int0(.in(dir[21:11]),.out(nx));
    wire [19:0] ny;
    signed_to_20b_signed #(.LENGTH(11)) int1(.in(dir[10:0]),.out(ny));
    mold mold0(.clk(),.x(nx),.y(ny),.z(20'b0),.mold(nmold));

    wire [19:0] norx;
    assign norx = nx*d/nmold;
    wire [19:0] nory;
    assign nory = ny*d/nmold;

    assign normalized_x[9:0] = nx[9:0];
    assign normalized_x[10] = norx[19]==1'b1 ? 1'b1 : 1'b0;
    assign normalized_y[9:0] = ny[9:0];
    assign normalized_x[10] = nory[19]==1'b1 ? 1'b1 : 1'b0;

endmodule