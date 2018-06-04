module lcd(module LCDmodule(clk, RxD, LCD_RS, LCD_RW, LCD_E, LCD_DataBus);

input clk, RxD;
output LCD_RS, LCD_RW, LCD_E;
output [7:0] LCD_DataBus;

wire RxD_data_ready;
wire [7:0] RxD_data;


assign LCD_RS = RxD_data[7];
assign LCD_DataBus = {1'b0, RxD_data[6:0]};   // sends only 7 bits to the module, padded with a '0' in front to make 8 bits

assign LCD_RW = 0;

reg [2:0] count;

always @(posedge clk) 
	if(RxD_data_ready | (count!=0)) 
		count <= count + 1;

reg LCD_E;
always @(posedge clk) 
	LCD_E <= (count!=0);
	
	
	
/* 	
  // initialize the LCD module
  WriteCommByte(0x38);   // "Function Set" in 8 bits mode
  WriteCommByte(0x0F);   // "Display ON" with cursors ON
  WriteCommByte(0x01);   // "Clear Display", can take up to 1.64ms, so the delay
  Sleep(2);

  // display "hello"
  WriteCommByte('h'+0x80);
  WriteCommByte('e'+0x80);
  WriteCommByte('l'+0x80);
  WriteCommByte('l'+0x80);
  WriteCommByte('o'+0x80); 
  
  https://www.fpga4fun.com/TextLCDmodule.html
  http://www.dinceraydin.com/lcd/commands.htm
  
*/

endmodule
