`include "ULA.v"

module test_banch();

	reg [3:0] a,b;
	reg [1:0] op;
	wire [3:0] result;

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result(result)
	);	
	
	initial begin	
		a <= 0;
		b <= 2;
		op <= 0; // Soma	
		$dumpfile("wave.vcd"); // Especifica o arquivo 
		$dumpvars; // Especifica pra colocar todos os sinais 
		#500;
		op <= 1;
		#500;
		op <= 2;
		#500;
		op <= 3;
		#1000  $finish; 
	end

	always begin		
		if(a < 15) a <= a + 1;
		else a <= 0;
		#10;		
	end
	
endmodule
