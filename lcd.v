module lcd(clk, LCD_data_in, LCD_DATA, LCD_RS, LCD_RW, LCD_EN);

	input clk; 
	input [7:0]LCD_data_in;
	output LCD_RS;
	output reg LCD_EN, LCD_RW;
	output reg[7:0] LCD_DATA;


	//assign LCD_RW = 0;
	assign LCD_RS = 1;
	initial begin
	LCD_RW=0;
	LCD_DATA=8'h38;
	#10;
	LCD_DATA=8'h0F;
	
	end
	
	//assign LCD_DATA = LCD_data_in;
	
	reg [2:0] count;
	always @(posedge clk) begin
	if(count!=0) count <= count + 1;
	end
	
	always @(posedge clk) begin
		LCD_EN <= (count!=0);
	end

endmodule 