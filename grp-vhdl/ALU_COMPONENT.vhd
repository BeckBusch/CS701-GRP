library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ALU_COMPONENT is
    Port ( a, b         : in  std_logic_vector(15 downto 0);
           op           : in  std_logic_vector(1 downto 0);
           carry_in     : in  std_logic;
           zout			: out std_logic;
		   aluout 		: out std_logic_vector(15 downto 0));
end ALU_COMPONENT;

architecture Behavioral of ALU_COMPONENT is
	-- Signals
	signal tmp : std_logic_vector(15 downto 0);
begin

		   -- Addition
	tmp <= std_logic_vector(unsigned(a) + unsigned(b) + unsigned(carry_in + "0000000000000000")) when op = "00" else
	       -- Subtraction
		   std_logic_vector(unsigned(a) - unsigned(b)) when op = "01" else
	       -- OR
		   a or b when op = "10" else
	       -- AND
		   a and b when op = "11" else
		   "XXXXXXXXXXXXXXXX";
	
	aluout <= tmp;
    zout <= '1' when (tmp = "0000000000000000") else '0';
	
	
end Behavioral;