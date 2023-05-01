library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX2_1 is
  Port ( sel   : in  std_logic;
         a, b  : in  std_logic_vector(15 downto 0);
         outp  : out std_logic_vector(15 downto 0));
end MUX2_1;

architecture Behavioral of MUX2_1 is
begin
	outp <= a when (sel='0') else
			b;
end Behavioral;
