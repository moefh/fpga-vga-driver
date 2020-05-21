module sprite_control(
	input wire clk,
	input wire spr_clk,
	input wire spr_cmd,
	input wire spr_ser,
	
	output wire       out_write,
	output wire [3:0] out_command,
	output wire [9:0] out_data
);

	reg in_clk_prev = 1'b0;
	reg in_clk  = 1'b0;
	reg in_cmd  = 1'b0;
	reg in_ser  = 1'b0;
	
	reg       reg_write    =  1'b0;
	reg [3:0] reg_command  =  4'h0;
	reg [9:0] reg_data     = 10'b0;
	reg [2:0] cmd_len      =  3'b0;
	
	assign out_write   = reg_write;
	assign out_command = reg_command;
	assign out_data    = reg_data;
	
	always @(posedge clk) begin
		in_clk_prev <= in_clk;
		in_clk <= spr_clk;
		in_cmd <= spr_cmd;
		in_ser <= spr_ser;
		
		if (in_clk & ~in_clk_prev) begin
			if (in_cmd) begin
				reg_write <= 1'b1;
				cmd_len <= 1'd0;
			end else begin
				reg_write <= 1'b0;
				if (cmd_len != 3'd4) begin
 					cmd_len     <= cmd_len + 3'd1;
					reg_command <= {reg_command[2:0], in_ser};
				end else begin
					reg_data    <= {reg_data[8:0],    in_ser};
				end
			end
		end else begin
			reg_write <= 1'b0;
		end
	end

endmodule
