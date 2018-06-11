module lcd(clk, LCD_data_in, LCD_DATA, LCD_RS, LCD_RW, LCD_EN);

	input clk; 
	input [7:0]LCD_data_in;
	output LCD_RS, LCD_RW;
	output reg LCD_EN;
	output [7:0] LCD_DATA;


	assign LCD_RW = 0;
	assign LCD_RS = 1;
	assign LCD_DATA = LCD_data_in;

	always @(posedge clk) begin
		LCD_EN <= 1;
		//LCD_E <= 0;
	end

endmodule 