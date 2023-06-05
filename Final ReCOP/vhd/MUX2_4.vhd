library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity MUX2_4 is
    port (
        sel : in std_logic;
        a, b : in std_logic_vector(3 downto 0);
        outp : out std_logic_vector(3 downto 0));
end MUX2_4;

architecture Behavioral of MUX2_4 is
begin
    outp <= a when (sel = '0') else
        b;
end Behavioral;
