module dance(SW,Clock,led);

	input Clock;
	input [3:0] SW;
	output reg [17:0] led;
	reg [25:0] slow_count;
	reg [5:0] position;
	
	parameter left=0,right=1,invert=2;
	
	always @(posedge Clock)
		slow_count <= slow_count + 1'b1;
		
	always @ (posedge Clock) begin
		if (slow_count == 0) begin
			if(SW[0]==1) begin				
				//if(position < 18) begin
				//	if(position != 0) led[position - 1] <= 0;
				//	led[2] <= 1;
				//	position <= position + 1;
				//end else
				//	led[position] <= 0;
				//	position <= 0;				
				//end
				
			end
		end
endmodule 