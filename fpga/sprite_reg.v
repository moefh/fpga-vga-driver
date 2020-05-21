module sprite_reg(
	input wire clk,
	
	input wire       write,
	input wire [3:0] command,
	input wire [9:0] data,
	
	output wire       out_enable,
	output wire [9:0] out_x1,
	output wire [8:0] out_y1,
	output wire [9:0] out_x2,
	output wire [8:0] out_y2,
	output wire [2:0] out_color
);
	
	reg       spr_enable =  1'b1;
	reg [9:0] spr_x1     = 10'd0;
	reg [8:0] spr_y1     =  9'd0;
	reg [9:0] spr_x2     = 10'd100;
	reg [8:0] spr_y2     =  9'd100;
	reg [2:0] spr_color  =  3'b111;

	assign out_enable = spr_enable;
	assign out_x1     = spr_x1;
	assign out_y1     = spr_y1;
	assign out_x2     = spr_x2;
	assign out_y2     = spr_y2;
	assign out_color  = spr_color;

	always @(posedge clk) begin
		if (write) begin
			case (command)
			4'h1 : spr_enable = data[0];
			4'h2 : spr_x1     = data[9:0];
			4'h3 : spr_y1     = data[8:0];
			4'h4 : spr_x2     = data[9:0];
			4'h5 : spr_y2     = data[8:0];
			4'h6 : spr_color  = data[2:0];
			endcase
		end
	end
	
endmodule
