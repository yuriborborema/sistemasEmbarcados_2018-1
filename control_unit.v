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
	
	reg [23:0] slow_count2;
	reg [7:0]x;
	
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
	
	
	// BotÃƒÂ£o que determina a operaÃƒÂ§ÃƒÂ£o
	always @ (posedge KEY[0]) begin 
		op <= op + 1 ;
		
		
	end
	
	// BotÃƒÂ£o que determina primeiro valor
	always @ (posedge KEY[2]) begin 
		if(a < 9) a <= a + 1 ;
		else a <= 0;
		
		
		
	end 

	// BotÃƒÂ£o que determina segundo valor 
	always @ (posedge KEY[1]) begin 
		if(b < 9) b <= b + 1 ;
		else b <= 0;
		
		
	end
	
	//Botão que alterna as letras mostradas no LCD.
		always @ (posedge KEY[3]) begin 
		if(x < 26) x <= x + 1 ;
		else x <= 0;
		
		
	end
	
	
	/////////////////////////////////////        LCD          /////////////////////////////////////////////  
	  /// Funcionamento: o display possuirá dois estados controlados pelos SW[16] e SW[15]
	  ///        Estado 1 (SW[16] == 0 e SW[15] == 1): Escreve as letras do alfabeto no visor inteiro, passando para
	  /// para a próxima letra de acordo com que o botâo KEY[3] é pressionado.
	  ///        Estado 2 (SW[16] == 1 e SW[15] == 1): Mostra no lcd os resultados da ULA em tempo real.
	  ///    Obs.: todas as demais combinações dos botôes SW não funcionarão.
	  ///
	  /// Variáveis: 
	  /// 		 DLY_RST: variavel utilizada para sincronizar a inicializacao de variaveis (mais info: module reset_Delay);
	  ///		 LUT_DATA: variável intermediária, usada para receber o valor de 9 bits que contempla os 8 bits do dado/inst mais 1 bit do valor de RS;
	  ///		 LUT_DATA_a: idem de LUT_DATA, entretanto utilizada para receber o valor a da ULA;
	  ///		 LUT_DATA_b: idem de LUT_DATA, entretanto utilizada para receber o valor b da ULA;
	  ///		 LUT_DATA_op: idem de LUT_DATA, entretanto utilizada para receber o valor da operação da ULA;
	  ///		 LUT_DATA_res1: idem de LUT_DATA, entretanto utilizada para receber o valor result1 da ULA;
	  ///		 LUT_DATA_res2: idem de LUT_DATA, entretanto utilizada para receber o valor result2 da ULA;
	  ///		 mDLY: variável que gera um delay após o dado ser mostrado no LCD para garantir que o hardware não falhará;
	  /// 		 mLCD_ST: variável intermediária responsável por controlar os estados (~= estado_atual);
	  /// 		 mLCD_Start: variável que informa ao module lcd que é para começar a escrita no LCD; 
	  ///		 mLCD_DATA: variavél interna da control_unit que recebe o valor de 8 bits (dado ou instrução) a ser enviado para o module lcd;
	  ///		 mLCD_RS: variavél interna da control_unit que recebe o valor de 1 bits do RS a ser enviado para o module lcd;
	  ///		 mLCD_Done: variável que é o module lcd informa a control_unit que o dado/inst foi escrito/realizado;
	  ///		 iDATA: variável do module lcd que recebe mLCD_DATA;
	  ///   	 iRS: variável do module lcd que recebe mLCD_RS;
	  ///		 iStart: variável do module lcd que recebe mLCD_Start;
	  /// 		 oDone: variável do module lcd que atribui o mLCD_Done;
	  ///		 iCLK: variável do module lcd que recebe CLOCK_50;
	  /// 		 iRST_N: variável do module lcd que recebe DLY_RST;
	  /// 		 x: variável que controla a passagem das letras no LCD através do botão KEY[3];
	  /// 
	  ///
	  /// Mais informações sobre o funcionamento do LCD:
	  /// 		 - http://www.dinceraydin.com/lcd/index.html (com simulador online).
	  /// Exemplos de funcionamento:
	  /// 		 - http://www.johnloomis.org/digitallab/ (exemplo base para este trabalho: lcdlab1).
	//////////////////////////////////////////////////////
	
	
	
	always @ (posedge CLOCK_50 or negedge DLY_RST)begin
		
		///// Inicializando variaveis auxiliares (mais info: module reset_Delay)
		if(!DLY_RST)
		begin		
		mLCD_ST <=0;
		mDLY <=0;
		mLCD_Start<=0;
		LUT_INDEX <= 0;
		end
		else begin	
		
		
		/////// JORDY: Daqui pra baixo, até a proxima indicação, por favor retire e teste para ver se realmente não precisa.
		///////   	   Caso não dê para você testar, apague estas linhas e deixe os demais comentários.  -->>>
		
		///// Rotina que mostra da clear (não finalizada):
		if (SW[17] == 1 && SW[16] == 1 && SW[15] == 1)begin

			case(mLCD_ST)
				0:	begin
					LUT_DATA <= 9'h00E;
					mLCD_ST		<=	1;
					end
				1:  begin 
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST <=2;
					end
				2:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    3;                    
						end
					end
				3:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else  begin mDLY    <=    0;
						mLCD_ST<=0;
						end
					end
				
			endcase
		end
		
		/////// JORDY: Daqui pra cima, por favor retire e teste para ver se realmente não precisa.
		///////   	   Caso não dê para você testar, apague estas linhas e deixe os demais comentários.  <<<--
		
		//// Rotina que mostra as letras no LCD:
		if (SW[17] == 0 && SW[16] == 0 && SW[15] == 1)begin
			
			case (mLCD_ST)
				0:begin
					mLCD_ST<=1;
				end
				1:begin
						case(x)
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
					mLCD_ST<=2;
					end
				2:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	3;
					end
				3:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    4;                    
						end
					end
				4:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else begin 
						mDLY    <=    0;
						mLCD_ST <= 0;
						end
					end
					
					
		/////// JORDY: Daqui pra baixo, até a proxima indicação, por favor retire e teste para ver se realmente não precisa.
		///////   	   Caso não dê para você testar, apague estas linhas e deixe os demais comentários.  -->>>
		
		
				5:begin
					LUT_DATA <=	9'h010;
					mLCD_ST<=6;
					end
				6:begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	7;
					end
				7:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    8;                    
						end
					end
				8:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else begin
							mDLY    <=    0;
							//mLCD_ST <= 0;
						end
					end 
			
			
		/////// JORDY: Daqui pra cima, por favor retire e teste para ver se realmente não precisa.
		///////   	   Caso não dê para você testar, apague estas linhas e deixe os demais comentários.  <<<--		
					
					
			endcase
		
		end
		
		/////// JORDY: Daqui pra baixo, até a proxima indicação, por favor retire e teste para ver se realmente não precisa.
		///////   	   Caso não dê para você testar, apague estas linhas e deixe os demais comentários.  -->>>
		
		//// Rotina que avança uma DDRAM (posição do cursor):
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
		
		/////// JORDY: Daqui pra cima, por favor retire e teste para ver se realmente não precisa.
		///////   	   Caso não dê para você testar, apague estas linhas e deixe os demais comentários.  <<<--	
		
		
		//// Rotina que avança uma DDRAM (posição do cursor):
		if (SW[17] == 0 && SW[16] == 1 && SW[15] == 1)begin
		
			case (mLCD_ST)
				0:begin
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
					//passando op para asc2
					//sum=0,sub=1,mult=2,div=3
						case (op)
							0:LUT_DATA_op <= 9'h12B;
							1:LUT_DATA_op <= 9'h12D;
							2:LUT_DATA_op <= 9'h12A;
							3:LUT_DATA_op <= 9'h12F;
						endcase
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
					if(LUT_INDEX == 11) LUT_INDEX <= 0;
					else begin LUT_INDEX	<=	LUT_INDEX + 1'b1; 
					mLCD_ST<=1; 
					end
				end
				1:begin
						case(LUT_INDEX)
							//Initial
						1:	LUT_DATA	<=	LUT_DATA_a;
						2:	LUT_DATA	<=	LUT_DATA_op;
						//3:	LUT_DATA	<=	9'h120;
						3:	LUT_DATA	<=	LUT_DATA_b;
						4:	LUT_DATA	<=	9'h13D;
						5:	LUT_DATA	<=	LUT_DATA_res2;
						6: LUT_DATA <= LUT_DATA_res1;
						7: LUT_DATA <= 9'h120; // Espaço em branco em ASCII
						8: LUT_DATA <= 9'h120;
						9: LUT_DATA <= 9'h120;
						10: LUT_DATA <= 9'h120;
						11: LUT_DATA <= 9'h001; // Comando de Clear
					endcase
					mLCD_ST<=2;
					end
				2:	begin
					mLCD_DATA	<=	LUT_DATA[7:0];
					mLCD_RS		<=	LUT_DATA[8];
					mLCD_Start	<=	1;
					mLCD_ST		<=	3;
					end
				3:  begin
                    if(mLCD_Done)
						begin
							mLCD_Start    <=    0;
							mLCD_ST        <=    4;                    
						end
					end
				4:  begin
					if(mDLY<18'h3FFFE)
						mDLY    <=    mDLY + 1'b1;
                    else begin 
						mDLY    <=    0;
						mLCD_ST <= 0;
						end
					end
				endcase			
			
		
		end
	end
	
end

	///// Instanciando o module LCD:
	lcd lcd(
		
		//    Lado da control_unit:
		.iDATA(mLCD_DATA),
		.iRS(mLCD_RS),
		.iStart(mLCD_Start),
		.oDone(mLCD_Done),
		.iCLK(CLOCK_50),
		.iRST_N(DLY_RST),
		//    Interface LCD:
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)    
	);

	
endmodule 