`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:00:10 12/22/2017 
// Design Name: 
// Module Name:    min 
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
// Recursicve Method
//////////////////////////////////////////////////////////////////////////////////
module min(
    input [2**WIDTH*LENGTH-1:0] in_bus,
    output reg[WIDTH-1:0] out
);
    parameter WIDTH = 3;// 8 object
    parameter LENGTH = 10;

    generate 
    if(WIDTH==1)begin
        always @(*) begin
            if(in_bus[2*LENGTH-1:LENGTH]>=in_bus[LENGTH-1:0])
                out = 1'b0;
            else out = 1'b1; 
        end
    end
    else begin
        wire [WIDTH-2:0] min_0;
        wire [WIDTH-2:0] min_1;
        min #(.WIDTH(WIDTH-1),.LENGTH(LENGTH)) sub_module_1(.in_bus(in_bus[2**(WIDTH)*LENGTH-1:2**(WIDTH-1)*LENGTH]),.out(min_1));
        min #(.WIDTH(WIDTH-1),.LENGTH(LENGTH)) sub_module_0(.in_bus(in_bus[2**(WIDTH-1)*LENGTH-1:0]),.out(min_0));
        always @(*) begin
            if(in_bus[min_0*LENGTH+LENGTH-1 -: LENGTH] > in_bus[(min_1+2**(WIDTH-1))*LENGTH+LENGTH-1 -: LENGTH])
                out = min_1 + 2**(WIDTH-1);
            else out = min_0;    
        end
    end
    endgenerate
     
endmodule

