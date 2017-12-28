`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:02:07 12/23/2017 
// Design Name: 
// Module Name:    vga 
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
`include "vga_scan_param_h.v"
module vga(
    input vga_clk,
    input clr,
    input [11:0] din,
    output reg [`COL_WIDTH-1:0] col_addr,
    output reg [`ROW_WIDTH-1:0] row_addr,
    output reg hs,
    output reg vs,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b 
);

    // h_count: VGA horizontal counter (0-799)
    reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
    always @ (posedge vga_clk or posedge clr) begin
        if (clr) begin
            h_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            h_count <= 10'h0;
        end else begin 
            h_count <= h_count + 10'h1;
        end
    end
    // v_count: VGA vertical counter (0-524)
    reg [9:0] v_count; // VGA vertical   counter (0-524): lines
    always @ (posedge vga_clk or posedge clr) begin
        if (clr) begin
            v_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            if (v_count == 10'd524) begin
                v_count <= 10'h0;
            end else begin
                v_count <= v_count + 10'h1;
            end
        end
    end
    // signals, will be latched for outputs
    wire  [9:0] row    =  v_count - 10'd35;     // pixel ram row addr 
    wire  [9:0] col    =  h_count - 10'd143;    // pixel ram col addr 
    wire        h_sync = (h_count > 10'd95);    //  96 -> 799
    wire        v_sync = (v_count > 10'd1);     //   2 -> 524
    wire        read   = (h_count > 10'd142 + `COL_EDGE) && // 143 -> 782
                        (h_count < 10'd783 - `COL_EDGE) && //        640 pixels
                        (v_count > 10'd34 + `ROW_EDGE) && //  35 -> 514
                        (v_count < 10'd515 - `ROW_EDGE);   //        480 lines
    // vga signals
    always @ (posedge vga_clk) begin
        row_addr <=  row[8:`UNIT_WIDTH] ; // pixel ram row address = row / 8 and row[9] == 0
        col_addr <=  col[9:`UNIT_WIDTH] ;      // pixel ram col address = col / 8
        // rdn      <= ~read;     // read pixel (active low)
        hs       <=  h_sync;   // horizontal synchronization
        vs       <=  v_sync;   // vertical   synchronization
        r        <=  ~read ? 4'h0 : din[3:0]; // 4-bit red
        g        <=  ~read ? 4'h0 : din[7:4]; // 4-bit green
        b        <=  ~read ? 4'h0 : din[11:8]; // 4-bit blue
    end

endmodule