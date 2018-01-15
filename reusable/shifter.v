
module Shifter(divisor,shiftby,shiftedvalue);
parameter divisorBITS=10;
parameter dividendBITS=20;
parameter shiftBITS=divisorBITS+dividendBITS-1;
input [shiftBITS-1:0]divisor;
input [divisorBITS*2+dividendBITS-1:0]shiftby;
output [shiftBITS-1:0]shiftedvalue;

assign shiftedvalue=divisor<<shiftby; 

endmodule 