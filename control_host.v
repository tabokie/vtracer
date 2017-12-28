`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:03:29 12/23/2017 
// Design Name: 
// Module Name:    control_host 
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
module control_host(
    input [7:0]key,
    input en_left,
    input en_right,
    input en_forward,
    input en_backward,
    output reg[1:0] rotate_sig,
    output reg[1:0] move_sig
);
    reg [1:0] rotate;
    reg [1:0] move;

    always @(key)begin
        case(key)
            // a
            8'h61: rotate[1] = 1;
            // s
            8'h73: move[0] = 1;
            // d
            8'h64: rotate[0] = 1;
            // w
            8'h77: move[1] = 1;
        endcase
    end

    always @(en_left)begin
        if(en_left)begin
            rotate_sig[1] <= rotate[1];
        end
        else begin
            rotate_sig[1] <= 0;
        end
    end

    always @(en_right)begin
        if(en_right)begin
            rotate_sig[0] <= rotate[0];
        end
        else begin
            rotate_sig[0] <= 0;
        end
    end

    always @(en_forward)begin
        if(en_forward)begin
            move_sig[1] <= move[1];
        end
        else begin
            move_sig[1] <= 0;
        end
    end

    always @(en_backward)begin
        if(en_backward)begin
            move_sig[0] <= move[0];
        end
        else begin
            move_sig[1] <= 0;
        end
    end

endmodule