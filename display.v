module display(number,seg);
	input [3:0] number;
   output reg [7:0] seg;

	// Referencia: https://github.com/thiagohenrique1/verilog_aula/blob/master/project/seven_seg.v
	always @ (number) begin
		case(number)  
			4'h0: seg = 8'hc0;
			4'h1: seg = 8'hf9;
			4'h2: seg = 8'ha4;
			4'h3: seg = 8'hb0;
			4'h4: seg = 8'h99;
			4'h5: seg = 8'h92;
			4'h6: seg = 8'h82;
			4'h7: seg = 8'hf8;
			4'h8: seg = 8'h80;
			4'h9: seg = 8'h90;
			4'ha: seg = 8'h88;
			4'hb: seg = 8'h83;
			4'hc: seg = 8'hc6;
			4'hd: seg = 8'ha1;
			4'he: seg = 8'h86;
			4'hf: seg = 8'h8e;
		endcase
	end
endmodule 
