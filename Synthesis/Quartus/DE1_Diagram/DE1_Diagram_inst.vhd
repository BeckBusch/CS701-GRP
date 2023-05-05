	component DE1_Diagram is
		port (
			clk_clk                                : in  std_logic                     := 'X';             -- clk
			reset_reset_n                          : in  std_logic                     := 'X';             -- reset_n
			led_pio_external_connection_export     : out std_logic_vector(7 downto 0);                     -- export
			button_pio_irq_irq                     : out std_logic;                                        -- irq
			switch_pio_external_connection_export  : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			sev_seg_pio_external_connection_export : out std_logic_vector(27 downto 0)                     -- export
		);
	end component DE1_Diagram;

	u0 : component DE1_Diagram
		port map (
			clk_clk                                => CONNECTED_TO_clk_clk,                                --                             clk.clk
			reset_reset_n                          => CONNECTED_TO_reset_reset_n,                          --                           reset.reset_n
			led_pio_external_connection_export     => CONNECTED_TO_led_pio_external_connection_export,     --     led_pio_external_connection.export
			button_pio_irq_irq                     => CONNECTED_TO_button_pio_irq_irq,                     --                  button_pio_irq.irq
			switch_pio_external_connection_export  => CONNECTED_TO_switch_pio_external_connection_export,  --  switch_pio_external_connection.export
			sev_seg_pio_external_connection_export => CONNECTED_TO_sev_seg_pio_external_connection_export  -- sev_seg_pio_external_connection.export
		);

