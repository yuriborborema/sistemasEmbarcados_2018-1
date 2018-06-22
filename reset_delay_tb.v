module	Reset_Delay_tb( input iCLK, output reg oRESET);
reg	[3:0]	Cont;

initial Cont=0;
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