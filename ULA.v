module ULA(a,b,op,result);

	input [3:0] a,b;
	input [1:0] op;
	output reg [3:0] result;

	parameter sum=0,sub=1,mult=2,div=3;	
	
	always @ (*) begin
		case(op) 
			sum: result <= a + b;
			sub: result <= a - b;
			mult: result <= a * b;
			div: result <= a/b;
			default: result <= 0;
		endcase
	end
endmodule
