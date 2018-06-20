module testeLCD (CLOCK_50, SW, LCD_ON,	LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA);
	input CLOCK_50;
	input [1:0] SW;
	output LCD_ON,	LCD_BLON, LCD_RW, LCD_RS; 
	output reg LCD_EN;
   output reg [7:0] LCD_DATA;
	
	reg [3:0] estado;
	reg [3:0] cont;
	
		assign    LCD_ON   = 1'b1;
	assign    LCD_BLON = 1'b1;

	assign	LCD_RW		=	1'b0;
	assign	LCD_RS		=	1;
	
	always @(posedge SW[0])begin
	estado<=0;
	LCD_DATA	=	8'h41;
	case(estado)
		0: begin LCD_EN<=1;
					estado<=1;
				end
		1: begin LCD_EN <=0;
					estado<=2;
				end
		/*2: begin 
					LCD_DATA <=8'h0E;
					LCD_EN<=1;
				end
		3: LCD_EN<=0;*/
	endcase
	//LCD_DATA<= 8'h01;
	/*estado<=0;
		case(estado)
		0: begin LCD_EN<=1;
					estado<=1;
				end
		1: begin LCD_EN <=0;
					estado<=2;
				end
		2: begin 
					LCD_DATA <=8'h0E;
					LCD_EN<=1;
				end
		3: LCD_EN<=0;
	endcase*/
	
	end
	
endmodule
