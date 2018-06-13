module lcd(clk, LCD_data_in, LCD_DATA, LCD_RS, LCD_RW, LCD_EN);

	input clk; 
	input [7:0]LCD_data_in;
	output reg LCD_RW;
	output reg LCD_EN, LCD_RS;
	output reg[7:0] LCD_DATA;


	assign LCD_RW = 0;
	
	reg [1:0] estado_atual;
	parameter init_FS = 0, init_D=1, clear = 2, writ_com = 3; writ_data = 4;

	
	//assign LCD_DATA = LCD_data_in;
	
	always @(posedge clk)begin
		      case (estado_atual)
       init_FS: begin
					 LCD_RS = 0;
                LCD_DATA = 8'h38;
					 estado_atual <= init_D;
               end               
       init_D: begin
                LCD_DATA = 8'h0F;
					 estado_atual <= clear;
               end
       clear: begin
                LCD_DATA = 8'h01;
					 estado_atual <= write_data;
               end
       writ_data: begin
					 LCD_RS= 1;
                LCD_DATA = LCD_data_in;
					 
               end					
      endcase 
	end
	
	
	reg [2:0] count;
	always @(posedge clk) begin
	
	case(LCD_data_in==8'h38)
	
	if(count!=0) count <= count + 1;
	end
	
	always @(posedge clk) begin
		LCD_EN <= (count!=0);
	end

endmodule 