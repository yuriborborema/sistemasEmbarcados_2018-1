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
	reg	[8:0]	LUT_DATA;
	reg	[5:0]	mLCD_ST;
	reg	[17:0]	mDLY;
	reg		mLCD_Start;
	reg	[7:0]	mLCD_DATA;
	reg		mLCD_RS;
	wire		mLCD_Done;
	reg [8:0] LUT_DATA_op;
	reg [8:0] LUT_DATA_a;
	reg [8:0] LUT_DATA_b;
	reg [8:0] LUT_DATA_res1;
	reg [8:0] LUT_DATA_res2;
	
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
	
	
	// BotÃ£o que determina a operaÃ§Ã£o
	always @ (posedge KEY[0]) begin 
		op <= op + 1 ;
		
		//passando op para asc2
		//sum=0,sub=1,mult=2,div=3
		case (op)
			1:LUT_DATA_op <= 9'h12B;
			1:LUT_DATA_op <= 9'h12D;
			1:LUT_DATA_op <= 9'h12A;
			1:LUT_DATA_op <= 9'h12F;
			endcase
	end
	
	// BotÃ£o que determina primeiro valor
	always @ (posedge KEY[2]) begin 
		if(a < 9) a <= a + 1 ;
		else a <= 0;
		
		//passando a para asc2
		case (a)
			0:LUT_DATA_a <= 9'h130;
			1:LUT_DATA_a <= 9'h131;
			2:LUT_DATA_a <= 9'h132;
			3:LUT_DATA_a <= 9'h133;
			4:LUT_DATA_a <= 9'h134;
			5:LUT_DATA_a <= 9'h135;
			6:LUT_DATA_a <= 9'h136;
			7:LUT_DATA_a <= 9'h137;
			8:LUT_DATA_a <= 9'h138;
			9:LUT_DATA_a <= 9'h139;
			endcase
		
	end 

	// BotÃ£o que determina segundo valor 
	always @ (posedge KEY[1]) begin 
		if(b < 9) b <= b + 1 ;
		else b <= 0;
		
		//passando b para asc2
		case (b)
			0:LUT_DATA_b <= 9'h130;
			1:LUT_DATA_b <= 9'h131;
			2:LUT_DATA_b <= 9'h132;
			3:LUT_DATA_b <= 9'h133;
			4:LUT_DATA_b <= 9'h134;
			5:LUT_DATA_b <= 9'h135;
			6:LUT_DATA_b <= 9'h136;
			7:LUT_DATA_b <= 9'h137;
			8:LUT_DATA_b <= 9'h138;
			9:LUT_DATA_b <= 9'h139;
			endcase
	end
	
	
	////////////////////////lcd
	  /// SW[17]: controla 'opÃ§Ã£o confirma', se
	  ///             = 1(SW[15] = 1 & SW[16] = 0); pressionar KEy[3] avanÃ§a o cursor
	  /// SW[16]: controla obter dados da ula, se
	  /// 			  = 1(SW[15] = 1 & SW[17] = 0); pressionar KEY[3] limpa a tela e apresenta resultados da ula
	  /// SW[15]: controla iniciar o display, ligar o cursor e escrever; se
	  ///             = 0(e demais SW = 0); inicia o display e liga cursor underline
	  /// 			  = 1(e demais SW = 0); preparado para escrever 
	  ///
	  /// caso contrario, qualquer outra combinaÃ§Ã£o, nÃ£o faz nada.
	  ///
	  /// mais info : http://www.dinceraydin.com/lcd/commands.htm
	  ///
	  /// obs thiago.: reg [5:0]lut_index;
	////////////////////////
	
	always @ (posedge KEY[3])begin
		
		//auxiliares para delay necessarios pra escrita no lcd
		mLCD_ST <=0;
		mDLY <=0;
		
		//// iniciando o display
		if (SW[17] == 0 && SW[16] == 0 && SW[15] == 0)begin
			LUT_DATA <= 9'h00E; 
			LUT_INDEX <= 0; 
			
			//bloco que escreve no lcd
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
					end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
		end
		
		//// escolhendo as letras
		if (SW[17] == 0 && SW[16] == 0 && SW[15] == 1)begin
			
			LUT_INDEX	<=	LUT_INDEX + 1'b1; 
			if(LUT_INDEX == 26) LUT_INDEX <= 0;
			else begin
				case(LUT_INDEX)
					//Initial
				1:	LUT_DATA	<=	9'h141;
				2:	LUT_DATA	<=	9'h142;
				3:	LUT_DATA	<=	9'h143;
				4:	LUT_DATA	<=	9'h144;
				5:	LUT_DATA	<=	9'h145;
				6:	LUT_DATA	<=	9'h146;
				7:	LUT_DATA	<=	9'h147;
				8:	LUT_DATA	<=	9'h148;
				9:	LUT_DATA	<=	9'h149;
				10:	LUT_DATA	<=	9'h14A;
				11:	LUT_DATA	<=	9'h14B;
				12:	LUT_DATA	<=	9'h14C;
				13:	LUT_DATA	<=	9'h14E;
				14:	LUT_DATA	<=	9'h14F;
				15:	LUT_DATA	<=	9'h150;
				16:	LUT_DATA	<=	9'h151;
				17:	LUT_DATA	<=	9'h152;
				18:	LUT_DATA	<=	9'h153;
				19:	LUT_DATA	<=	9'h154;
				20:	LUT_DATA	<=	9'h155;
				21:	LUT_DATA	<=	9'h156;
				22:	LUT_DATA	<=	9'h157;
				23:	LUT_DATA	<=	9'h158;
				24:	LUT_DATA	<=	9'h159;
				25:	LUT_DATA	<=	9'h15A;				
			endcase
			end
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
					end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//volta o cursor pra posiÃ§Ã£o anterior
			case(mLCD_ST)
				0:	begin			
					LUT_DATA <=	9'h010;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
		
		end
		
		if (SW[17] == 1 && SW[16] == 0 && SW[15] == 1)begin
			LUT_DATA <= 9'h014;
			
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
		end
		
		////mostrando valores da ula
		if (SW[17] == 0 && SW[16] == 1 && SW[15] == 1)begin
		
			//clear na tela
			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h001;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
		
			//escreve a
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA_a[7:0];
					mLCD_RS		<=	LUT_DATA_a[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//avanÃ§a
			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h014;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//escreve op
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA_op[7:0];
					mLCD_RS		<=	LUT_DATA_op[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//avanÃ§a
			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h014;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//escreve b
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA_b[7:0];
					mLCD_RS		<=	LUT_DATA_b[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//avanÃ§a
			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h014;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//escreve sinal de = 
			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h13D;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//avanÃ§a
			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h014;
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//escreve result2
					case (result2)
						0:LUT_DATA_res2 <= 9'h130;
						1:LUT_DATA_res2 <= 9'h131;
						2:LUT_DATA_res2 <= 9'h132;
						3:LUT_DATA_res2 <= 9'h133;
						4:LUT_DATA_res2 <= 9'h134;
						5:LUT_DATA_res2 <= 9'h135;
						6:LUT_DATA_res2 <= 9'h136;
						7:LUT_DATA_res2 <= 9'h137;
						8:LUT_DATA_res2 <= 9'h138;
						9:LUT_DATA_res2 <= 9'h139;
					endcase
			
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA_res2[7:0];
					mLCD_RS		<=	LUT_DATA_res2[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase
			
			mLCD_ST <=0;
			mDLY <=0;
			
			//escreve result1
			case (result1)
						0:LUT_DATA_res1 <= 9'h130;
						1:LUT_DATA_res1 <= 9'h131;
						2:LUT_DATA_res1 <= 9'h132;
						3:LUT_DATA_res1 <= 9'h133;
						4:LUT_DATA_res1 <= 9'h134;
						5:LUT_DATA_res1 <= 9'h135;
						6:LUT_DATA_res1 <= 9'h136;
						7:LUT_DATA_res1 <= 9'h137;
						8:LUT_DATA_res1 <= 9'h138;
						9:LUT_DATA_res1 <= 9'h139;
					endcase
			
			case(mLCD_ST)
				0:	begin
					mLCD_DATA	<=	LUT_DATA_res1[7:0];
					mLCD_RS		<=	LUT_DATA_res1[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	1;
				end
				1:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    2;                    
						end
					end
				2:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else mDLY    <=    0;
					end
			endcase

			
			
		
		end

end

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
