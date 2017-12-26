module vga(
    input vga_clk,
    input clrn,
    input [11:0] din,
    output reg [6:0] col_addr,
    output reg [6:0] row_addr,
    output reg hs,
    output reg vs,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b 
);

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
        //rdn      <= ~read;     // read pixel (active low)
        hs       <=  h_sync;   // horizontal synchronization
        vs       <=  v_sync;   // vertical   synchronization
        r        <=  ~read ? 4'h0 : din[3:0]; // 4-bit red
        g        <=  ~read ? 4'h0 : din[7:4]; // 4-bit green
        b        <=  ~read ? 4'h0 : din[11:8]; // 4-bit blue
    end

endmodule