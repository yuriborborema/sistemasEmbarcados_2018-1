module control_unit(HEX0,HEX1,HEX2,HEX4,HEX5,KEY,SW,CLOCK_50,LEDR);
	
	input [3:0] SW,KEY;
	input CLOCK_50;
	reg [3:0] a,b;
	reg [1:0] op;
	wire [3:0] result1,result2;
	output [7:0] HEX0,HEX1,HEX2,HEX4;
	output [17:0] LEDR;

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result1(result1)
		.result2(result2)
	);		
	
	dance dance(
		.led(LEDR),
		.key(SW),
		.Clock(CLOCK_50)
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
		.number(result1),
		.seg(HEX4)
	);

	display displayC(
		.number(result2),
		seg(HEX5)
	);

	// Botão que determina a operação
	always @ (posedge KEY[0]) begin 
		op <= op + 1 ;
		//else op <= 0;
	end
	
	// Botão que determina primeiro valor
	always @ (posedge KEY[1]) begin 
		if(a < 10) a <= a + 1 ;
		else a <= 0;
	end 

	// Botão que determina segundo valor 
	always @ (posedge KEY[2]) begin 
		if(b < 10) b <= b + 1 ;
		else b <= 0;
	end
	

endmodule 
