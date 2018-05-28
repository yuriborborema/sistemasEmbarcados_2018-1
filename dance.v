module dance(SW,Clock,led);

	input Clock;
	input [17:0] SW;
	output reg [17:0] led;
	reg [24:0] slow_count;
	reg [5:0] position;
	reg flag; // Determina o sentido de rotação dos leds
	
	parameter left=0,right=1;
		
	always @(posedge Clock)
		slow_count <= slow_count + 1'b1;
		
	always @ (posedge Clock) begin
		if (slow_count == 0) begin
			// Direita para esquerda
			if(SW[0] == 1) begin	
				if(position < 18) begin
					if(position != 0) led[position - 1] <= 0;
					led[position] <= 1;
					position <= position + 1;
				end else begin
					led[position] <= 0;
					position <= 0;	
				end
			// Esquerda para direita
			end else if(SW[1] == 1) begin	
				if(position > 0) begin
					if(position != 17) led[position + 1] <= 0;
					led[position] <= 1;
					position <= position - 1;
				end else begin
					led[position] <=0;
					position <= 17;	
				end
			end
			// Vai e volta 
			end else if(SW[2] == 1) begin	
				if(position > 0 & position < 17) begin					
					led[position] <= 1;
					if(way == left) begin
						if(position != 0) led[position - 1] <= 0;
						led[position] <= 1;
						position <= position + 1;
					end else if(way == right) begin
						if(position != 17) led[position + 1] <= 0;
						led[position] <= 1;
						position <= position - 1;
					end
				end else if(position == 0) way = left;
				else if (position == 17) way == right;			
			end			
		end
	end	
endmodule 
