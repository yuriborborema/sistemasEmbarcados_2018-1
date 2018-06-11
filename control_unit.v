module control_unit(HEX0,HEX1,HEX2,HEX4,HEX5,KEY,SW,CLOCK_50,LEDR, LCD_DATA, LCD_RS, LCD_RW, LCD_EN);
	input [17:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	input [7:0]LCD_DATA; 
	input LCD_RS, LCD_RW, LCD_EN;
	reg [3:0] a,b;
	reg [1:0] op;
	wire [3:0] result1,result2;
	output [7:0] HEX0,HEX1,HEX2,HEX4,HEX5;
	output [17:0] LEDR;
	
	
	reg [7:0] dataAux = 8'h61;

	

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result1(result1),
		.result2(result2)
	);		
	
	dance dance(
		.led(LEDR),
		.SW(SW),
		.Clock(CLOCK_50)
	);

	display displayA(
		.number(a),
		.seg(HEX2)
	);

	display displayB(
		.number(b),
		.seg(HEX1)
	);

	
	display displayOp(
		.number(op),
		.seg(HEX0)
	);

	display displayResult(
		.number(result1),
		.seg(HEX4)
	);

	display displayC(
		.number(result2),
		.seg(HEX5)
	);
	
	lcd lcd(
		.clk(CLOCK_50), 
		.LCD_data_in(dataAux),
		.LCD_DATA(LCD_DATA),
		.LCD_RS(LCD_RS),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN)
	);

	// Botão que determina a operação
	always @ (posedge KEY[0]) begin 
		op <= op + 1 ;
	end
	
	// Botão que determina primeiro valor
	always @ (posedge KEY[2]) begin 
		if(a < 9) a <= a + 1 ;
		else a <= 0;
	end 

	// Botão que determina segundo valor 
	always @ (posedge KEY[1]) begin 
		if(b < 9) b <= b + 1 ;
		else b <= 0;
	end
	
	
	// Botão que alterna as letras
	//always @ (posedge KEY[3]) begin 
	//	LCD_RS_in <= 1;
	//	if(LCD_data_in == 8h'7A) LCD_data_in <= 8'h61;
	//	else LCD_data_in <= LCD_data_in+8'h01;
	//end
	
	// Botão que avanca o curso
	//always @ (posedge SW[4]) begin 
	//	LCD_RS_in <= 0;
	//	if(LCD_data_in==8'h0B) LCD_data_in <=8'h40;
	//	else if(LCD_data_in==8'h40) LCD_data_in <= LCD_data_in+1;
	//else LCD_data_in <= LCD_data_in+1;
	//end
	
	always @ (posedge CLOCK_50) begin
		dataAux <= dataAux+1;
	end
	

endmodule 
