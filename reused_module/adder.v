module Adder(divisor,dividend,carry,difference); 
parameter divisorBITS=10; 
parameter dividendBITS=20;
parameter addBITS=divisorBITS+dividendBITS-1;
input [addBITS-1:0] divisor;
input [addBITS-1:0] dividend;
wire [addBITS-1:0] divisorinv;
output carry;
output [addBITS-1:0] difference;

assign divisorinv=~divisor; 
assign {carry,difference} = dividend+divisorinv+1'b1; 

endmodule 