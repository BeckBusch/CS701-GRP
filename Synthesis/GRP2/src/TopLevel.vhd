library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TopLevel is
	generic (
		ports : positive := 8
	);
	port (
		CLOCK_50      : in    std_logic;
		CLOCK2_50     : in    std_logic;
		CLOCK3_50     : in    std_logic;

		FPGA_I2C_SCLK : out   std_logic;
		FPGA_I2C_SDAT : inout std_logic;
		AUD_ADCDAT    : in    std_logic;
		AUD_ADCLRCK   : inout std_logic;
		AUD_BCLK      : inout std_logic;
		AUD_DACDAT    : out   std_logic;
		AUD_DACLRCK   : inout std_logic;
		AUD_XCK       : out   std_logic;
		
		send_nios_addr: in    tdma_min_addr;
		send_nios_data: in    tdma_min_data;
		recv_nios_addr: out   tdma_min_addr;
		recv_nios_data: out   tdma_min_data;
		
		send_recop_addr: in    tdma_min_addr;
		send_recop_data: in    tdma_min_data;
		recv_recop_addr: out   tdma_min_addr;
		recv_recop_data: out   tdma_min_data

	);
end entity;

architecture rtl of TopLevel is

	signal clock : std_logic;

	signal adc_empty : std_logic;
	signal adc_get   : std_logic;
	signal adc_data  : std_logic_vector(16 downto 0);
	signal dac_full  : std_logic;
	signal dac_put   : std_logic;
	signal dac_data  : std_logic_vector(16 downto 0);

	signal send_port : tdma_min_ports(0 to ports-1);
	signal recv_port : tdma_min_ports(0 to ports-1);
	

begin

	clock <= CLOCK_50;
	
	send_port(2).addr <= send_nios_addr;
	send_port(2).data <= send_nios_data;
	
	recv_nios_addr <= recv_port(2).addr;
	recv_nios_data <= recv_port(2).data;
	
	send_port(7).addr <= send_recop_addr;
	send_port(7).data <= send_recop_data;
	
	recv_recop_addr <= recv_port(7).addr;
	recv_recop_data <= recv_port(7).data;

	adc_dac : entity work.Audio
	generic map (
		enable_adc => false
	)
	port map (
		ref_clock     => CLOCK3_50,
		fpga_i2c_sclk => FPGA_I2C_SCLK,
		fpga_i2c_sdat => FPGA_I2C_SDAT,
		aud_adcdat    => AUD_ADCDAT,
		aud_adclrck   => AUD_ADCLRCK,
		aud_bclk      => AUD_BCLK,
		aud_dacdat    => AUD_DACDAT,
		aud_daclrck   => AUD_DACLRCK,
		aud_xck       => AUD_XCK,

		clock         => clock,
		adc_empty     => adc_empty,
		adc_get       => adc_get,
		adc_data      => adc_data,
		dac_full      => dac_full,
		dac_put       => dac_put,
		dac_data      => dac_data
	);

	tdma_min : entity work.TdmaMin
	generic map (
		ports => ports
	)
	port map (
		clock => clock,
		sends => send_port,
		recvs => recv_port
	);

	asp_adc : entity work.AspAdc
	port map (
		clock => clock,
		empty => adc_empty,
		get   => adc_get,
		data  => adc_data,

		send  => send_port(0),
		recv  => recv_port(0)
	);

	asp_dac : entity work.AspDac
	port map (
		clock => clock,
		full  => dac_full,
		put   => dac_put,
		data  => dac_data,

		send  => send_port(1),
		recv  => recv_port(1)
	);
	
	asp_dp : entity work.AspDp
	port map (
		clock => clock,
		send =>send_port(3),
		recv => recv_port(3)
	);
	
	asp_fir : entity work.AspDpFIR
	port map (
		clock => clock,
		send  =>send_port(4),
		recv  => recv_port(4)
	);
	
	asp_peak : entity work.asp_peak
	port map (
		clock => clock,
		send =>send_port(5),
		recv => recv_port(5)
	);
	
	asp_average : entity work.Average_ASP
	port map (
		clk => clock,
		send =>send_port(6),
		recv => recv_port(6)
	);

end architecture;
