module ULA(a,b,op,result);

	input [3:0] a,b;
	input [1:0] op;
	output reg [3:0] result1, result2;

	parameter sum=0,sub=1,mult=2,div=3;	
	
	always @ (*) begin
		case(op) 
			sum: 
			begin 
				result1 <= a + b;
				if((a+b) == 20) result2 <= 2;
				else if ((a+b) > 10) result2 <= 1;
				else result2 <= 0;
			end 
			sub: 
			begin
				if(a > b) result1 <= a - b;
				else begin 
					result1 <= b - a;
					result2 <= 15;
				end
			end
			mult: 
			begin
				result1 <= a * b;
				if((a+b) > 90) result2 <= 9;
				else if ((a*b) > 80) result2 <= 8;
				else if ((a*b) > 70) result2 <= 7;
				else if ((a*b) > 60) result2 <= 6;
				else if ((a*b) > 50) result2 <= 5;
				else if ((a*b) > 40) result2 <= 4;
				else if ((a*b) > 30) result2 <= 3;
				else if ((a*b) > 20) result2 <= 2;
				else if ((a*b) > 10) result2 <= 1;
				else result2 <= 0;				
			end
			div: result <= a/b;
			default: result <= 0;
		endcase
	end
endmodule
