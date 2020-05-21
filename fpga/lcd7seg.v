module lcd7seg(
	input  wire [3:0] num,
	output wire [6:0] seg
);

	assign seg = ((num == 4'H0) ? 7'b1111110 :
					  (num == 4'H1) ? 7'b0110000 :
					  (num == 4'H2) ? 7'b1101101 :
					  (num == 4'H3) ? 7'b1111001 :
					  (num == 4'H4) ? 7'b0110011 :
					  (num == 4'H5) ? 7'b1011011 :
					  (num == 4'H6) ? 7'b1011111 :
					  (num == 4'H7) ? 7'b1110000 :
					  (num == 4'H8) ? 7'b1111111 :
					  (num == 4'H9) ? 7'b1111011 :
					  (num == 4'HA) ? 7'b1110111 :
					  (num == 4'HB) ? 7'b0011111 :
					  (num == 4'HC) ? 7'b1001110 :
					  (num == 4'HD) ? 7'b0111101 :
					  (num == 4'HE) ? 7'b1001111 :
					  (num == 4'HF) ? 7'b1000111 :
					                  7'b0000001);
	
endmodule
