module vga(
	input wire clk,
	input wire pixel_strobe,
	
	input wire spr_clk,
	input wire spr_cmd,
	input wire spr_ser,

	output wire h_sync,
	output wire v_sync,
	output wire r, g, b,
	
	output wire [3:0] debug_spr_command
//	output wire [9:0] debug_spr_data
);

	localparam VGA_H_SCREEN = 10'd640;
	localparam VGA_V_SCREEN = 10'd480;

	localparam VGA_H_SYNC_START  =  10'd16;  // vsync ON  at pixel 16
	localparam VGA_H_SYNC_END    = 10'd112;  // vsync OFF at pixel 112
	localparam VGA_H_DRAW_START  = 10'd160;  // draw ON  at pixel 160 
	localparam VGA_H_DRAW_END    = 10'd800;  // draw OFF at pixel 800

	localparam VGA_V_SYNC_START  =  10'd10;  // hsync ON  at line 10
	localparam VGA_V_SYNC_END    =  10'd12;  // hsync OFF at line 12
	localparam VGA_V_DRAW_START  =  10'd45;  // draw  ON  at line 45
	localparam VGA_V_DRAW_END    = 10'd525;  // draw  OFF at line 525

	reg [9:0] v_count = 9'b0;
	reg [9:0] h_count = 9'b0;

	wire [9:0] x = (h_count < VGA_H_DRAW_START) ? VGA_H_SCREEN : (h_count - VGA_H_DRAW_START);
	wire [9:0] y = (v_count < VGA_V_DRAW_START) ? VGA_V_SCREEN : (v_count - VGA_V_DRAW_START);

	// advance v_count and h_count
	always @(posedge clk) begin
		if (pixel_strobe) begin
			if (h_count == VGA_H_DRAW_END-10'd1) begin
				h_count <= 10'b0;
				if (v_count == VGA_V_DRAW_END-10'd1)
					v_count <= 10'b0;
				else
					v_count <= v_count + 10'b1; 
			end else begin
				h_count <= h_count + 10'b1;
			end
		end
	end
	
	wire       spr_write;
	wire [3:0] spr_command;
	wire [9:0] spr_data;
	sprite_control spr_cnt(clk, spr_clk, spr_cmd, spr_ser, spr_write, spr_command, spr_data);

	assign debug_spr_command = spr_command;
	//assign debug_spr_data    = spr_data;
	
	wire       spr0_en;
	wire [9:0] spr0_x1;
	wire [8:0] spr0_y1;
	wire [9:0] spr0_x2;
	wire [8:0] spr0_y2;
	wire [2:0] spr0_color;
	sprite_reg spr0(clk, spr_write, spr_command, spr_data, spr0_en, spr0_x1, spr0_y1, spr0_x2, spr0_y2, spr0_color);

	// generate image
	assign h_sync = (h_count >= VGA_H_SYNC_START) && (h_count < VGA_H_SYNC_END);
	assign v_sync = (v_count >= VGA_V_SYNC_START) && (v_count < VGA_V_SYNC_END);
	wire   blank  = ((v_count < VGA_V_DRAW_START || v_count >= VGA_V_DRAW_END) ||
	                 (h_count < VGA_H_DRAW_START || h_count >= VGA_H_DRAW_END));

	assign r = (~blank) & spr0_en & spr0_color[2] & (x >= spr0_x1 && x <= spr0_x2 && y >= spr0_y1 && y <= spr0_y2);
	assign g = (~blank) & spr0_en & spr0_color[1] & (x >= spr0_x1 && x <= spr0_x2 && y >= spr0_y1 && y <= spr0_y2);
	assign b = (~blank) & spr0_en & spr0_color[0] & (x >= spr0_x1 && x <= spr0_x2 && y >= spr0_y1 && y <= spr0_y2);

	//assign r = ~blank;
	//assign g = ~blank;
	//assign b = ~blank;
	
endmodule
