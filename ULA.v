module ULA(input a,b,op,clock,
	  			 output result);

	wire [8:0] a,b;
	reg [8:0] result;
	wire [3:0] op;

	parameter sum=0,sub=1,mult=2,div=3;	
	
	always @ (posedge clock) begin
		case(op) 
			sum: result <= a + b;
			sub: result <= a - b;
			mult: result <= a * b;
			div: result <= a/b;
			default: result <= 0;
		endcase
	end
endmodule
