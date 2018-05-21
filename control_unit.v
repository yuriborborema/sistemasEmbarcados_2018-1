`include "ULA.v"
`include "display.v"

module control_unit(HEX0,HEX1,HEX2,HEX3,CLOCK_50,KEY); // a,b,op,result
	
	output [7:0] HEX0,HEX1,HEX2,HEX3;
	input [3:0] KEY;
	reg [7:0] a,b;
	reg [3:0] op = 0;
	wire result;	

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result(result),
		.clock(CLOCK_50)
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

	// Botão que determina a operação
	always @ (posedge KEY[0]) begin 
		if(op < 4) op <= op + 1 ;
		else op <= 0;
	end
	
	// Botão que determina primeiro valor
	always @ (posedge KEY[1]) begin 
		if(op < 10) a <= a + 1 ;
		else a <= 0;
	end 

	// Botão que determina segundo valor 
	always @ (posedge KEY[2]) begin 
		if(b < 10) b <= b + 1 ;
		else b <= 0;
	end

endmodule	
