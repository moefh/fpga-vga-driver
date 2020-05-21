module vga_test(
	input wire clk,
	input wire spr_clk,
	input wire spr_cmd,
	input wire spr_ser,
	output wire r, g, b,
	output wire h_sync,
	output wire v_sync,
	output wire led,
	output wire [6:0] lcd
);

	reg  vga_clk_count = 1'b0;
	wire vga_pixel_strobe = (vga_clk_count == 1);

	assign led = ~b;
	
	// calculate vga pixel clock strobe (divide main clock by 2 to get 25MHz)
	always @(posedge clk) begin
		vga_clk_count <= ~vga_clk_count;
	end
	
	wire [3:0] spr_command;

	vga vga_inst(clk, vga_pixel_strobe, spr_clk, spr_cmd, spr_ser, h_sync, v_sync, r, g, b, spr_command);
	
	lcd7seg lcd_inst(spr_command, lcd);
	
endmodule
