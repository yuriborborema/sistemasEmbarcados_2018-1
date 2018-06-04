module ULA(a,b,op,result1,result2);

	input [3:0] a,b;
	input [1:0] op;
	output reg [3:0] result1, result2;

	parameter sum=0,sub=1,mult=2,div=3;	
	
	always @ (*) begin
		case(op) 
			sum: 
			begin 
				if ((a+b) <= 9) begin 
					result1 <= a + b;
					result2 <= 0;				
				end else begin
					result1 <= a + b - 10;
					result2 <= 1;					
				end  
			end 
			sub: 
			begin
				if(a > b) begin
					result1 <= a - b;
					result2 <= 0;
				end
				else begin 
					result1 <= b - a;
					result2 <= 15;
				end
			end
			mult: 
			begin				
				if((a+b) >= 90) begin 
					result1 <= a * b - 90;
					result2 <= 9;
				end 
				else if ((a*b) >= 80) begin 
					result1 <= a * b - 80;
					result2 <= 8;
				end else if ((a*b) >= 70) begin 
					result1 <= a * b - 70;
					result2 <= 7;
				end 
				else if ((a*b) >= 60) begin 
					result1 <= a * b - 60;
					result2 <= 6;
				end 
				else if ((a*b) >= 50) begin 
					result1 <= a * b - 50;
					result2 <= 5;
				end 
				else if ((a*b) >= 40) begin 
					result1 <= a * b - 40;
					result2 <= 4;
				end 
				else if ((a*b) >= 30) begin 
					result1 <= a * b - 30;
					result2 <= 3;
				end 
				else if ((a*b) >= 20) begin 
					result1 <= a * b - 20;
					result2 <= 2;
				end 
				else if ((a*b) >= 10) begin 
					result1 <= a * b - 10;
					result2 <= 1;
				end 
				else result2 <= 0;				
			end
			div: begin 
				result1 <= a/b;
				result2 <= 0;
			end
			default: begin 
				result1 <= 0;
				result2 <= 0;
			end
		endcase
	end
endmodule
