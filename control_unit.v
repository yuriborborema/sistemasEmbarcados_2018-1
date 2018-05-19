`include "ULA.V"
`include "display.v"

module control_unit(SW,HEX0,HEX1,HEX2,HEX3,CLOCK_50); // chaves,a,b,op,result 

	reg [8:0] a,b;
	reg [3:0] op = 0;
	reg [7:0] seg;
	wire result;	

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result(result),
		.clock(CLOCK_50)
	);	

	display display(
		.number(result),
		.seg(seg)
	);

	// Botão que determina a operação
	always @ (BUTTON1) begin 
		if(op < 4) op <= op + 1 ;
		else op <= 0;
		seg <= SW[0];
		number <= op; 
	end
	
	// Botão que determina primeiro valor
	always @ (BUTTON2) begin 
		if(op < 10) a <= a + 1 ;
		else a <= 0;
		seg <= SW[1];
		number <= a;
	end 

	// Botão que determina segundo valor 
	always @ (BUTTON3) begin 
		if(b < 10) b <= b + 1 ;
		else b <= 0;
		seg <= SW[2];
		number <= b;
	end

	// Mostra o resultado 
	always @ (*) begin
		seg <= SW[3];
		number <= resultado;
	end
	
endmodule
	
