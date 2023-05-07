library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity MAX is
    Port (
        rx : in std_logic_vector(15 downto 0);
        rz : in std_logic_vector(15 downto 0);
        max_out : out std_logic_vector(15 downto 0)
    );
end MAX;

architecture Behavioral of MAX is

begin

    max_out <= rx when rx > rz else rz;
	
end Behavioral;