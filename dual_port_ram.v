`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:22:16 12/22/2017 
// Design Name: 
// Module Name:    dual_port_ram 
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
//
//////////////////////////////////////////////////////////////////////////////////
module dual_port_ram(
    input clk,
    input rst,
    input [WIDTH-1:0] write_addr,
    input [WIDTH-1:0] read_addr,
    input [LENGTH-1:0] din,
    output [LENGTH-1:0] dout
);

    // LENGTH: word length
    // WIDTH: addr width
    parameter WIDTH = 4;
    parameter LENGTH = 8;

    // regs as ram
    reg [LENGTH-1:0] ram [2**WIDTH-1:0];

    // reset
    integer i;
    always @(posedge rst)begin
        for(i=0;i<=2**(WIDTH)-1;i=i+1)begin
            ram[i] = 0;
        end
    end

    // ram write
    always @(posedge clk) begin
        ram[write_addr] <= din;
    end
    // ram read
    assign dout = ram[read_addr];

endmodule 

