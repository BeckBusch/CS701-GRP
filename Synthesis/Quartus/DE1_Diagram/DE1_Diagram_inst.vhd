	component DE1_Diagram is
		port (
			button_pio_irq_irq                     : out std_logic;                                        -- irq
			clk_1_clk_clk                          : out std_logic;                                        -- clk
			clk_1_clk_reset_reset_n                : out std_logic;                                        -- reset_n
			led_pio_external_connection_export     : out std_logic_vector(7 downto 0);                     -- export
			reset_reset_n                          : in  std_logic                     := 'X';             -- reset_n
			sev_seg_pio_external_connection_export : out std_logic_vector(27 downto 0);                    -- export
			sev_seg_pio_s1_address                 : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			sev_seg_pio_s1_readdata                : out std_logic_vector(31 downto 0);                    -- readdata
			switch_pio_external_connection_export  : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			clk_clk                                : in  std_logic                     := 'X'              -- clk
		);
	end component DE1_Diagram;

	u0 : component DE1_Diagram
		port map (
			button_pio_irq_irq                     => CONNECTED_TO_button_pio_irq_irq,                     --                  button_pio_irq.irq
			clk_1_clk_clk                          => CONNECTED_TO_clk_1_clk_clk,                          --                       clk_1_clk.clk
			clk_1_clk_reset_reset_n                => CONNECTED_TO_clk_1_clk_reset_reset_n,                --                 clk_1_clk_reset.reset_n
			led_pio_external_connection_export     => CONNECTED_TO_led_pio_external_connection_export,     --     led_pio_external_connection.export
			reset_reset_n                          => CONNECTED_TO_reset_reset_n,                          --                           reset.reset_n
			sev_seg_pio_external_connection_export => CONNECTED_TO_sev_seg_pio_external_connection_export, -- sev_seg_pio_external_connection.export
			sev_seg_pio_s1_address                 => CONNECTED_TO_sev_seg_pio_s1_address,                 --                  sev_seg_pio_s1.address
			sev_seg_pio_s1_readdata                => CONNECTED_TO_sev_seg_pio_s1_readdata,                --                                .readdata
			switch_pio_external_connection_export  => CONNECTED_TO_switch_pio_external_connection_export,  --  switch_pio_external_connection.export
			clk_clk                                => CONNECTED_TO_clk_clk                                 --                             clk.clk
		);

