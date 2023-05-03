library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX4_16 is
  Port ( sel   : in  std_logic_vector(1 downto 0);
         a, b, c, d : in  std_logic_vector(15 downto 0);
         outp  : out std_logic_vector(15 downto 0));
end MUX4_16;

architecture Behavioral of MUX4_16 is
begin
	outp <= a when (sel(1)='0' and sel(0)='0') else
			b when (sel(1)='0' and sel(0)='1') else
			c when (sel(1)='1' and sel(0)='0') else
			d;
end Behavioral;
