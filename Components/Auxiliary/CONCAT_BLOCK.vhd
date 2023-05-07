library IEEE;
use IEEE.std_logic_1164.all;

entity CONCAT_BLOCK is
    generic (
        LEN_A : natural := 16;
        LEN_B : natural := 16
    );
    port (
        signal a : in std_logic_vector(LEN_A - 1 downto 0);
        signal b : in std_logic_vector(LEN_B - 1 downto 0);
        signal out : in std_logic_vector(LEN_A + LEN_B - 1 downto 0)
    );

end CONCAT_BLOCK;

architecture behaviour of CONCAT_BLOCK is
begin
    out <= a & b;
end behaviour;
