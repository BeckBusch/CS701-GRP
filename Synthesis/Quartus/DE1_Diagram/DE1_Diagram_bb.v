
module DE1_Diagram (
	clk_clk,
	reset_reset_n,
	led_pio_external_connection_export,
	button_pio_irq_irq,
	switch_pio_external_connection_export,
	sev_seg_pio_external_connection_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	led_pio_external_connection_export;
	output		button_pio_irq_irq;
	input	[7:0]	switch_pio_external_connection_export;
	output	[27:0]	sev_seg_pio_external_connection_export;
endmodule
