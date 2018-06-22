`include "ULA_tb.v"
`include "dance_tb.v"
`include "lcd_tb.v"

module test_banch();

	reg clock;	
	reg [7:0] a,b;
	reg [3:0] SW;
	reg [1:0] op;
	wire [7:0] result1,result2;
	wire [4:0] position;
	//wire [17:0] LEDR;	
	
	reg [7:0] iDATA;
	reg iRS;
	reg iStart;
	wire oDone;
	wire [7:0] LCD_DATA;
	wire LCD_RW;
    wire LCD_EN;
	wire LCD_RS;

	ULA ULA(
		.a(a),
		.b(b),
		.op(op),
		.result1(result1),
		.result2(result2)
	);

	dance dance(
		//.led(LEDR),
		.SW(SW),
		.Clock(clock),
		.position(position)
	);	
	
	lcd_tb lcd(
		.iDATA(iDATA),
		.iRS(iRS),
		.iStart(iStart),
		.iCLK(clock),
		.oDone(oDone),
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)
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
		#100 SW = 2; // Vai e volta
		
		iDATA = 8'h0F;
		iRS = 0;
		#100 iStart = 1;
		if(oDone==1)iStart=0;
		
		#500 iDATA = 8'h41;
		iRS = 1;
		#100 iStart = 1;
		if(oDone==1)iStart=0;
		
		
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