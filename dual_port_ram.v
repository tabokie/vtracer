module dual_port_ram(
    input clk,
    input [WIDTH-1:0] write_addr,
    input [WIDTH-1:0] read_addr,
    input [LENGTH-1:0] din,
    output [LENGTH-1:0] dout
)

    parameter WIDTH;
    parameter LENGTH;

    reg [LENGTH-1:0] ram [2**WIDTH-1:0];
    always @(posedge clk) begin
        ram[write_addr] <= din;
    end

    assign dout = ram[read_addr];

endmodule 




/*
// need clk sinc ??
module double_ram(
    // input enable,
    input clk,
    input [6:0] write_col,
    input [5:0] write_row,
    input [6:0] read_col,
    input [6:0] read_row,
    input [11:0] din,
    output [11:0] dout
)
    // 64 * 128 = 8192
    // reg [11:0] ram_0 [0:8191];
    // reg [11:0] ram_1 [0:8191];
    // reg [12:0] write_addr = {write_col,write_row};
    // reg [12:0] read_addr = {read_col, read_row};
    // case (enable)
    //     1'b0:
    //         ram_1[write_addr] = din;
    //         dout = ram_0[read_addr];
    //     1'b1:
    //         ram_0[write_addr] = din;
    //         dout = ram_1[read_addr];
    // endcase

    reg [11:0] ram [8191:0];
    wire write_addr = {write_col, write_row};
    wire read_addr = {read_col, read_row};
    always @(posedge clk) begin
        ram[write_addr] = din;
    end
    dout = ram[read_addr];

endmodule
*/
