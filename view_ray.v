module view_ray(
	input [27:0] view_normal,
	input [9:0] view_dist,
	input [12:0] view_loc,
	output [27:0] view_out
)

return 4*(|d0|/|d|*d + |x|/|d-1|*d-1 + (0,0,z))/4
    d-1 = (y,x,0)


endmodule