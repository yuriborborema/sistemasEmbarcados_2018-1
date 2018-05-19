module ULA(input a,b,op,clock
					 output result);

	reg [8:0] a,b,result;
	reg [0:3] op;

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
