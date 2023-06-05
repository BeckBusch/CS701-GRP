library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX8_16 is
  Port ( sel   : in  std_logic_vector(2 downto 0);
         a, b, c, d, e, f, g, h : in  std_logic_vector(15 downto 0);
         outp  : out std_logic_vector(15 downto 0));
end MUX8_16;

architecture Behavioral of MUX8_16 is
begin
	outp <= a when (sel(2)='0' and sel(1)='0' and sel(0)='0') else
			b when (sel(2)='0' and sel(1)='0' and sel(0)='1') else
			c when (sel(2)='0' and sel(1)='1' and sel(0)='0') else
			d when (sel(2)='0' and sel(1)='1' and sel(0)='1') else
			e when (sel(2)='1' and sel(1)='0' and sel(0)='0') else
			f when (sel(2)='1' and sel(1)='0' and sel(0)='1') else
			g when (sel(2)='1' and sel(1)='1' and sel(0)='0') else
			h;
end Behavioral;
