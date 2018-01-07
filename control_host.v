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
    input clk,
    input rst,
    input [3:0]key,
    input en_left,
    input en_right,
    input en_forward,
    input en_backward,
    output reg[1:0] rotate_sig,
    output reg[1:0] move_sig
);
    reg [1:0] rotate;
    reg [1:0] move;

    always @(key[3:2])begin
        case(key[3:2])
            // l
            2'b10: rotate[1] = 1;
            // r
            2'b01: rotate[0] = 1;
        endcase
    end

    always @(key[1:0])begin
        case(key[1:0])
            // b
            2'b01: move[0] = 1;
            // f
            2'b10: move[1] = 1;
        endcase
    end

    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            rotate_sig[1] <= 0;
        end
        else if(en_left)begin
            rotate_sig[1] <= rotate[1];
        end
        else begin
            rotate_sig[1] <= 0;
        end
    end

    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            rotate_sig[0] <= 0;
        end
        else if(en_right)begin
            rotate_sig[0] <= rotate[0];
        end
        else begin
            rotate_sig[0] <= 0;
        end
    end

    always @(posedge clk or negedge rst)begin
        if(!rst)begin
            move_sig[1] <= 0;
        end
        else if(en_forward)begin
            move_sig[1] <= move[1];
        end
        else begin
            move_sig[1] <= 0;
        end
    end

    always @(posedge clk or negedge rst)begin
       if(!rst)begin
            move_sig[0] <= 0;
        end
        else if(en_backward)begin
            move_sig[0] <= move[0];
        end
        else begin
            move_sig[0] <= 0;
        end
    end

endmodule