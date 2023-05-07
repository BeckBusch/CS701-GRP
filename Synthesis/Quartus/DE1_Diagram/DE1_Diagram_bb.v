
module DE1_Diagram (
	button_pio_irq_irq,
	led_pio_external_connection_export,
	reset_reset_n,
	sev_seg_pio_external_connection_export,
	sev_seg_pio_s1_address,
	sev_seg_pio_s1_readdata,
	switch_pio_external_connection_export,
	clk_1_clk_clk,
	clk_1_clk_reset_reset_n);	

	output		button_pio_irq_irq;
	output	[7:0]	led_pio_external_connection_export;
	input		reset_reset_n;
	output	[27:0]	sev_seg_pio_external_connection_export;
	input	[1:0]	sev_seg_pio_s1_address;
	output	[31:0]	sev_seg_pio_s1_readdata;
	input	[7:0]	switch_pio_external_connection_export;
	output		clk_1_clk_clk;
	output		clk_1_clk_reset_reset_n;
endmodule
