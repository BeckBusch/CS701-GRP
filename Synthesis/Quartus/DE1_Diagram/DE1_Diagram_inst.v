	DE1_Diagram u0 (
		.clk_clk                                (<connected-to-clk_clk>),                                //                             clk.clk
		.reset_reset_n                          (<connected-to-reset_reset_n>),                          //                           reset.reset_n
		.led_pio_external_connection_export     (<connected-to-led_pio_external_connection_export>),     //     led_pio_external_connection.export
		.button_pio_irq_irq                     (<connected-to-button_pio_irq_irq>),                     //                  button_pio_irq.irq
		.switch_pio_external_connection_export  (<connected-to-switch_pio_external_connection_export>),  //  switch_pio_external_connection.export
		.sev_seg_pio_external_connection_export (<connected-to-sev_seg_pio_external_connection_export>)  // sev_seg_pio_external_connection.export
	);

