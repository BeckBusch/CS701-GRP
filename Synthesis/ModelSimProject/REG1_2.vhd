library IEEE;
use IEEE.std_logic_1164.all;

-- when using remember that write is mispelled as writ, since write is reserved

entity REG1_2 is
    port (
        reg_in : in std_logic_vector(1 downto 0);
        writ : in std_logic;
        reset : in std_logic;
        clk : in std_logic;

        reg_out : out std_logic_vector(1 downto 0)

    );

end REG1_2;

architecture behaviour of REG1_2 is
begin
    REG : entity work.REG1_GENERIC
    generic map(
        LEN => 2
    )
    port map(
        reg_in => reg_in,
        writ => writ,
        reset => reset,
        clk => clk,

        reg_out => reg_out
    );
end behaviour;
