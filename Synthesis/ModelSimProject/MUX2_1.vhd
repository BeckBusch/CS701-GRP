library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity MUX2_1 is
    port (
        sel : in std_logic;
        a, b : in std_logic;
        outp : out std_logic);
end MUX2_1;

architecture Behavioral of MUX2_1 is
begin
    outp <= a when (sel = '0') else
        b;
end Behavioral;
