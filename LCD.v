module lcd(module LCDmodule(CLOCK_50, LCD_RS_out, LCD_RW_out, LCD_E_out);

input CLOCK_50;
output LCD_RS_out, LCD_RW_out, LCD_E_out;
output [7:0] LCD_Data_out;

wire [7:0] LCD_data_in;
wire [7:0] LCD_RS_in;


assign LCD_RW = 0;
assign LCD_RS_out = LCD_RS_in;
assign LCD_Data_out = LCD_data_in;


reg LCD_E;
always @(posedge clk) begin
	LCD_E <= 1;
	LCD_E <= 0;
	end

endmodule
