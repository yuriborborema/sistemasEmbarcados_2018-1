// o Reset_Delay cria uma variavel que começa juntamente com o clock com o valor de zero.
// depois de um tempo, ela permanece 1 durante todo o restante.
// Dessa maneira você atribui valores a outras variaveis enquanto o valor de oRESET é zero, depois quando ele torna 1 você não mais a atribui.
// Assim você consegue inicializar as variaveis que desejar. 

module	Reset_Delay( input iCLK, output reg oRESET);
reg	[3:0]	Cont;

always@(posedge iCLK)
begin
	if(Cont!=4'hF)
	begin
		Cont	<=	Cont + 1'b1;
		oRESET	<=	1'b0;
	end
	else
	oRESET	<=	1'b1;
end

endmodule