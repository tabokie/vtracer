// move: a_b a forward, b backward
// rotate: a_b a left, b right
module control_host(
    input key,
    input en_left,
    input en_right,
    input en_forward,
    input en_backward,
    output [1:0] rotate_sig,
    output [1:0] move_sig
)
    reg [1:0] rotate;
    reg [1:0] move;

    always@(*) begin
        if(en_left)rotate_sig[1] <= rotate[1];
        if(en_right)rotate_sig[0] <= rotate[0];
        if(en_forward)move_sig[1] <= move[1];
        if(en_backward)move_sig[0] <= move[0];
    end

endmodule
