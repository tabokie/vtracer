`timescale 1ns / 1ps

// today's progress:
// implement basic structure
// todo:
// from double ram to single dual port ram <-
// implement object ram and their correponding decoder and first-level sdf <- multi-facet? wall?
// add full set ray tracing <- light management ? three light: myLight, lampLight, highLight
// add scene <- // coords and boundary
// about control ==> collision judgement and random enemies <- complicated, maybe state machine?

module top(
    input clk,
    input rst,

    output hs,
    output vs,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b 

)
    
    reg [31:0] clkdiv;
    always@( posedge clk) begin
        clkdiv <= clkdiv + 1'b1
    end

    // vga read //
    reg [11:0] vga_din;
    wire [5:0] read_row_addr;// 64 8*8 pixel block
    wire [6:0] read_col_addr;// 128 8*8 pixel block
    wire rdn;

    // send to vga
    vga #(
        .vga_clk(clkdiv[1]),
        .din(vga_din),
        .col_addr(read_col_addr),
        .row_addr(read_row_addr),
        .read_en(rdn),
        .hs(hs),.vs(vs),
        .r(r),.g(g),.b(b),
    );

    wire en_ram;
    reg [11:0] tracer_dout;
    wire [5:0] write_row_addr;
    wire [6:0] write_col_addr;
    ray_tracer_host #(
        .tracer_clk(clkdiv[0]),
        .col_addr(write_col_addr),
        .row_addr(write_row_addr),
        .dout(tracer_dout),
        .sinc_ret(en_ram)
    )

    // connect double ram
    double_ram #(
        .enable(en_ram),
        .write_col(write_col_addr),
        .write_row(write_row_addr),
        .read_col(read_col_addr),
        .read_row(read_row_addr),
        .din(tracer_dout),
        .dout(vga_din)
    )

endmodule

module vga(
    input vga_clk,
    input [11:0] din,
    output reg [6:0] col_addr,
    output reg [6:0] row_addr,
    output reg hs,
    output reg vs,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b 
)

    // h_count: VGA horizontal counter (0-799)
    reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
    always @ (posedge vga_clk) begin
        if (!clrn) begin
            h_count <= 10'h0;
        end else if (h_count == 10'd799) begin
            h_count <= 10'h0;
        end else begin 
            h_count <= h_count + 10'h1;
        end
    end
    // v_count: VGA vertical counter (0-524)
    reg [9:0] v_count; // VGA vertical   counter (0-524): lines
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn) begin
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
    wire        read   = (h_count > 10'd142) && // 143 -> 782
                        (h_count < 10'd783) && //        640 pixels
                        (v_count > 10'd34)  && //  35 -> 514
                        (v_count < 10'd515);   //        480 lines
    // vga signals
    always @ (posedge vga_clk) begin
        row_addr <=  (row[8:0]) / 9'd8; // pixel ram row address
        col_addr <=  col % 9'd8 ;      // pixel ram col address
        rdn      <= ~read;     // read pixel (active low)
        hs       <=  h_sync;   // horizontal synchronization
        vs       <=  v_sync;   // vertical   synchronization
        r        <=  rdn ? 4'h0 : d_in[3:0]; // 3-bit red
        g        <=  rdn ? 4'h0 : d_in[7:4]; // 3-bit green
        b        <=  rdn ? 4'h0 : d_in[11:8]; // 2-bit blue
    end

endmodule

module ray_tracer_host(
    input tracer_clk,
    input rst,
    output reg [6:0] col_addr,
    output reg [5:0] row_addr,
    output reg [11:0] dout,
    output sinc_ret
)
    wire tracer_sig;
    reg [6:0] col_cnt;
    reg [5:0] row_cnt;

    ray_tracer #(
        .col_coord(col_cnt), .row_coord(row_cnt), 
        .ret_sig(tracer_sig), .dout(dout)
    );
    always @(tracer_sig and posedge tracer_clk) begin
        
    end

endmodule

module ray_tracer(
    input [6:0] col_coord,
    input [5:0] row_coord,
    output ret_sig,
    output [11:0] dout
)

    reg [NUM_OBJ : 0] tracer_sig;
    generate
        genvar i;
        for(i = 0; i < NUM_OBJ; i = i+1) begin : tracer_instance
            reg [2:0] obj_type;
            reg [3:0] obj_id;

            ray_tracer #(.ret_sig(tracer_sig[i]));

        end
    endgenerate

endmodule


// need clk sinc ??
module double_ram(
    input enable,
    input [6:0] write_col,
    input [5:0] write_row,
    input [6:0] read_col,
    input [6:0] read_row,
    input [11:0] din,
    output [11:0] dout
)
    // 64 * 128 = 8192
    reg [11:0] ram_0 [0:8191];
    reg [11:0] ram_1 [0:8191];
    reg [12:0] write_addr = {write_col,write_row};
    reg [12:0] read_addr = {read_col, read_row};
    case (enable)
        1'b0:
            ram_1[write_addr] = din;
            dout = ram_0[read_addr];
        1'b1:
            ram_0[write_addr] = din;
            dout = ram_1[read_addr];
    endcase
endmodule