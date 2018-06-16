module control_unit(HEX0,HEX1,HEX2,HEX4,HEX5,KEY,SW,CLOCK_50,LEDR, LCD_ON,	LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA);
	
	input [17:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	reg [7:0] a,b;
	reg [1:0] op;
	wire [7:0] result1,result2;
	output [7:0] HEX0,HEX1,HEX2,HEX4,HEX5;
	output [17:0] LEDR;
	output LCD_ON,	LCD_BLON, LCD_RW, LCD_EN, LCD_RS;
   output [7:0] LCD_DATA;
		
	// reset delay gives some time for peripherals to initialize
	wire DLY_RST;
	Reset_Delay r0(	.iCLK(CLOCK_50),.oRESET(DLY_RST) );	
		
	//ligando lcd
	assign    LCD_ON   = 1'b1;
	assign    LCD_BLON = 1'b1;
	//regs auxiliares para lcd
	reg	[5:0]	LUT_INDEX;
	reg	[8:0]	LUT_DATA_TEXT;
	reg	[8:0]	LUT_DATA_INS;
	reg	[5:0]	mLCD_ST;
	reg	[17:0]	mDLY;
	reg		mLCD_Start;
	reg	[7:0]	mLCD_DATA;
	reg		mLCD_RS;
	wire		mLCD_Done;
	reg [15:0] LCD_LINEx;
	reg rs;
	//params auxiliares para lcd
	parameter	LCD_INTIAL	=	0;
	parameter	LCD_LINE1	=	5;
	parameter	LCD_CH_LINE	=	LCD_LINE1+16;
	parameter	LCD_LINE2	=	LCD_LINE1+16+1;
	parameter	LUT_SIZE	=	LCD_LINE1+32+1;
	
	
	
	
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
	
	
	////////////////////////lcd
	
	always @ (posedge KEY[3])begin
		rs=1;
		LUT_INDEX	<=	LUT_INDEX + 1'b1;
		case(LUT_INDEX)
	//	Initial
		0:	LUT_DATA_TEXT	<=	9'h00F;
		1:	LUT_DATA_TEXT	<=	9'h142;
		2:	LUT_DATA_TEXT	<=	9'h143;
		3:	LUT_DATA_TEXT	<=	9'h001;
		default:		LUT_DATA_TEXT	<=	9'h16C ;
	endcase
end
	
	always@(posedge CLOCK_50 or negedge DLY_RST)
begin
	if(!DLY_RST)
	begin
		//LUT_INDEX	<=	0;
		mLCD_ST		<=	0;
		mDLY		<=	0;
		mLCD_Start	<=	0;
		mLCD_DATA	<=	0;
		mLCD_RS		<=	0;
	end
	else
	begin
		if(LUT_INDEX<LUT_SIZE)
		begin
			case(mLCD_ST)
			0:	begin
					if(rs==1)begin
					mLCD_DATA	<=	LUT_DATA_INS[7:0];
					mLCD_RS		<=	0;
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
					end
					else begin
					mLCD_DATA	<=	LUT_DATA_TEXT[7:0];
					mLCD_RS		<=	1;
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
					end
				end
			1:	begin
					if(mLCD_Done)
					begin
						mLCD_Start	<=	0;
						mLCD_ST		<=	2;					
					end
				end
			2:	begin
					if(mDLY<18'h3FFFE)
					mDLY	<=	mDLY + 1'b1;
					else
					begin
						mDLY	<=	0;
						mLCD_ST	<=	0;
					end
				end
			/*3:	begin
					LUT_INDEX	<=	LUT_INDEX + 1'b1;
					mLCD_ST	<=	0;
				end*/
			endcase
		end
	end
end

/*always
begin
	case(LUT_INDEX)
	//	Initial

	//LCD_INTIAL+0:	LUT_DATA	<=	9'h038;
	//LCD_INTIAL+1:	LUT_DATA	<=	9'h00E;
	//LCD_INTIAL+2:	LUT_DATA	<=	9'h001;
	//LCD_INTIAL+3:	LUT_DATA	<=	9'h006;
	//LCD_INTIAL+4:	LUT_DATA	<=	9'h080;
	//	Line 1
	//LCD_LINE1+0:	LUT_DATA	<=	9'h141;	//	<Altera DE2 Kit>
	LCD_LINE1+1:	LUT_DATA	<=	9'h16C;
	LCD_LINE1+2:	LUT_DATA	<=	9'h174;
	LCD_LINE1+3:	LUT_DATA	<=	9'h165;
	LCD_LINE1+4:	LUT_DATA	<=	9'h172;
	LCD_LINE1+5:	LUT_DATA	<=	9'h161;
	LCD_LINE1+6:	LUT_DATA	<=	9'h120;
	LCD_LINE1+7:	LUT_DATA	<=	9'h144;
	LCD_LINE1+8:	LUT_DATA	<=	9'h145;
	LCD_LINE1+9:	LUT_DATA	<=	9'h132;
	LCD_LINE1+10:	LUT_DATA	<=	9'h120;
	LCD_LINE1+11:	LUT_DATA	<=	9'h142;
	LCD_LINE1+12:	LUT_DATA	<=	9'h16F;
	LCD_LINE1+13:	LUT_DATA	<=	9'h161;
	LCD_LINE1+14:	LUT_DATA	<=	9'h172;
	LCD_LINE1+15:	LUT_DATA	<=	9'h164;
	//	Change Line
	LCD_CH_LINE:	LUT_DATA	<=	9'h0C0;
	//	Line 2
	LCD_LINE2+0:	LUT_DATA	<=	9'h14E;	//	Nice To See You!
	LCD_LINE2+1:	LUT_DATA	<=	9'h169;
	LCD_LINE2+2:	LUT_DATA	<=	9'h163;
	LCD_LINE2+3:	LUT_DATA	<=	9'h165;
	LCD_LINE2+4:	LUT_DATA	<=	9'h120;
	LCD_LINE2+5:	LUT_DATA	<=	9'h154;
	LCD_LINE2+6:	LUT_DATA	<=	9'h16F;
	LCD_LINE2+7:	LUT_DATA	<=	9'h120;
	LCD_LINE2+8:	LUT_DATA	<=	9'h153;
	LCD_LINE2+9:	LUT_DATA	<=	9'h165;
	LCD_LINE2+10:	LUT_DATA	<=	9'h165;
	LCD_LINE2+11:	LUT_DATA	<=	9'h120;
	LCD_LINE2+12:	LUT_DATA	<=	9'h159;
	LCD_LINE2+13:	LUT_DATA	<=	9'h16F;
	LCD_LINE2+14:	LUT_DATA	<=	9'h175;
	LCD_LINE2+15:	LUT_DATA	<=	9'h121;
	default:		LUT_DATA	<=	9'h16C ;
	endcase
end*/

	lcd lcd(
		
		//    Host Side
		.iDATA(mLCD_DATA),
		.iRS(mLCD_RS),
		.iStart(mLCD_Start),
		.oDone(mLCD_Done),
		.iCLK(CLOCK_50),
		.iRST_N(DLY_RST),
		//    LCD Interface
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)    
	);

	
endmodule 
