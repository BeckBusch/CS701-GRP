library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX2_12 is
  Port ( sel   : in  std_logic;
         a, b  : in  std_logic_vector(11 downto 0);
         outp  : out std_logic_vector(11 downto 0));
end MUX2_12;

architecture Behavioral of MUX2_12 is
begin
	outp <= a when (sel='0') else
			b;
end Behavioral;
