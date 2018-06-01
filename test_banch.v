`include "ULA.v"
`include "dance.v"

module test_banch();

	reg clock;	
	reg [3:0] a,b,SW;
	reg [1:0] op;
	wire [3:0] result1,result2;
	wire [4:0] position;
	wire [17:0] LEDR;	

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
		.Clock(clock),
		.position(position)
	);	
	
	initial begin

		$dumpfile("wave.vcd");
		$dumpvars; 

		clock = 0;	
		a <= 0;
		b <= 2;		
		
		SW = 0; // Crescente		

		op = 0; // Soma
		#500 op = 1; // sub
		#500 op = 2; // mult
		#500 op = 3; // div		
	
		#100 SW = 1; // Decrescente
		
		

		#2000  $finish;		
	end
	
	// Clock
	always begin
		#10 clock <= ~clock;
	end

	// LEDs
	always @ (posedge clock) begin
		$display(position);
	end

	// ULA
	always begin		
		if(a < 15) a <= a + 1;
		else a <= 0;
		#10;		
	end
	
endmodule
