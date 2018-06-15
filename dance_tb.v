module dance(SW,Clock,led,position);

	input Clock;
    input [3:0] SW;
	reg way;  // Determina o sentido de rotação dos leds
	reg [23:0] slow_count;
	output reg [4:0] position;
	output reg [17:0] led;
	
	/*Remover depois*/
	initial begin 
		position <= 0;
		way <= 0;
	end
		
	//always @(posedge Clock)	slow_count <= slow_count + 1'b1;
		
	always @ (posedge Clock) begin
		//if (slow_count == 0) begin
			// Direita para esquerda
			if(SW == 0) begin
				if(position < 18) begin
					if(position != 0) led[position - 1] <= 0;
					led[position] <= 1;
					position <= position + 1;
				end else begin
					led[17] <= 0;
					position <= 0;	
				end
			// Esquerda para direita
			end else if(SW == 1) begin	
				if(position > 0) begin
					led[0] <= 0;
					if(position != 17) led[position + 1] <= 0;
					led[position] <= 1;
					position <= position - 1;
				end else begin
					led[0] <= 1;
					led[1] <= 0;
					position <= 17;	
				end
			end
			// Vai e volta 
			else if(SW == 2) begin//else if(SW[2] == 1) begin	
				if(position > 0 & position < 17) begin					
					led[position] <= 1;
					if(way == 0) begin
						if(position != 0) led[position - 1] <= 0;
						led[position] <= 1;
						position <= position + 1;
					end else if(way == 1) begin
						if(position != 17) led[position + 1] <= 0;
						led[position] <= 1;
						position <= position - 1;
					end
				end 
				else if (position == 0 ) begin 
					way <= 0;
					position <=  position + 1;
				end else if (position == 17) begin 
					way <= 1;
					position <= position - 1;
				end 
			end			
		//end
	end	
endmodule 
