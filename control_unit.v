module control_unit(HEX0,HEX1,HEX2,HEX3,KEY, SW); // a,b,op,result
	
	output [7:0] HEX0,HEX1,HEX2,HEX3;
	input [3:0] KEY, [7:0] SW;
	reg [3:0] a,b;
	reg [1:0] op;
	wire result;

	reg [7:0] LCD_data_in = 8'h61; // conferir esta instanciacao
	reg LCD_RS_in = 0;
		

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result(result)
	);	

	display displayA(
		.number(a),
		.seg(HEX1)
	);

	display displayB(
		.number(b),
		.seg(HEX2)
	);

	display displayOp(
		.number(op),
		.seg(HEX0)
	);

	display displayResult(
		.number(result),
		.seg(HEX3)
	);
	
	//PRECISO INSTANCIAR UM LCD SÓ PARA O CLK??

	// Botão que determina a operação
	always @ (posedge KEY[0]) begin 
		op <= op + 1 ;
		//else op <= 0;
	end
	
	// Botão que determina primeiro valor
	always @ (posedge KEY[1]) begin 
		if(a < 4'hf) a <= a + 1 ;
		else a <= 0;
	end 

	// Botão que determina segundo valor 
	always @ (posedge KEY[2]) begin 
		if(b < 4'hf) b <= b + 1 ;
		else b <= 0;
	end
	
	// Botão que alterna as letras
	always @ (posedge KEY[3]) begin 
		LCD_RS_in <= 1;
		if(LCD_data_in == 8h'7A) LCD_data_in <= 8'h61;
		else LCD_data_in <= LCD_data_in+8'h01;
	end
	
	// Botão que avanca o curso
		always @ (posedge SW[0]) begin 
		LCD_RS_in <= 0;
		if(LCD_data_in==8'h0B) LCD_data_in <=8'h40;
		else if(LCD_data_in==8'h40) LCD_data_in <= LCD_data_in+1;
		else LCD_data_in <= LCD_data_in+1;
	end

endmodule	
