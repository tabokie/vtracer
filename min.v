module min(
    input [2**WIDTH*LENGTH-1:0] in_bus,
    output [WIDTH-1:0] out
)

    parameter WIDTH = 4;// 8 object
    parameter LENGTH = 10;

    generate 
    if(WIDTH==1)begin
        if(in_bus[2*LENGTH-1:LENGTH]>in_bus[LENGTH-1:0])begin
            assign out = 1'b0;
        end
        else assign out = 1'b1;
    end
    else begin
        wire [WIDTH/2-1:0]min_0;
        wire [WIDTH/2-1:0]min_1;
        min #(WIDTH = WIDTH/2) sub_module(.in_bus[2*LENGTH-1:LENGTH],.out(min_1));
        min #(WIDTH = WIDTH/2) sub_module(.in_bus[LENGTH-1:0],.out(min_0));
        if(in_bus[min_0]>in_bus[min_1+2**(WIDTH-1)])begin
            assign out = min_1 + 2**(WIDTH-1);
        end
        else assign out = min_0;
    end
    endgenerate
endmodule