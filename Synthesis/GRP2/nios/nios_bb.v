
module nios (
	clk_clk,
	hex_0_external_connection_export,
	hex_1_external_connection_export,
	hex_2_external_connection_export,
	hex_3_external_connection_export,
	hex_4_external_connection_export,
	hex_5_external_connection_export,
	key_external_connection_export,
	ledr_external_connection_export,
	recv_addr_external_connection_export,
	recv_data_external_connection_export,
	send_addr_external_connection_export,
	send_data_external_connection_export,
	sw_external_connection_export,
	reset_recop_external_connection_export);	

	input		clk_clk;
	output	[6:0]	hex_0_external_connection_export;
	output	[6:0]	hex_1_external_connection_export;
	output	[6:0]	hex_2_external_connection_export;
	output	[6:0]	hex_3_external_connection_export;
	output	[6:0]	hex_4_external_connection_export;
	output	[6:0]	hex_5_external_connection_export;
	input	[3:0]	key_external_connection_export;
	output	[9:0]	ledr_external_connection_export;
	input	[7:0]	recv_addr_external_connection_export;
	input	[31:0]	recv_data_external_connection_export;
	output	[7:0]	send_addr_external_connection_export;
	output	[31:0]	send_data_external_connection_export;
	input	[9:0]	sw_external_connection_export;
	output		reset_recop_external_connection_export;
endmodule
