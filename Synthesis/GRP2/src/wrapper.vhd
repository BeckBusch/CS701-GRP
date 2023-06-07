library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
use work.port_locations.all;

entity wrapper is
	port (
		signal clk : in std_logic;
		signal output : out std_logic_vector(9 downto 0)
	);
end entity;

architecture wrap of wrapper is
   signal r_port : tdma_min_port;
   signal s_port : tdma_min_port;
	 
	component AspDpFIR is
		port (
			clock : in  std_logic;
			send  : out tdma_min_port;
			recv  : in  tdma_min_port
		);
	end component;
		 
begin
	 r_port.addr <= (others => '0');
	 r_port.data <= (others => '0');
	 
	 output <= s_port.data(9 downto 0);
	 
    dut : AspDpFIR
    port map (
		clock => clk,
		send  => s_port,
		recv  => r_port
    );
end architecture;