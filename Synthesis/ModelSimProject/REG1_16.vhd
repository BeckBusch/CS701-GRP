library IEEE;
use IEEE.std_logic_1164.all;

entity REG1_16 is
    port (
        signal reg_in : in std_logic_vector(15 downto 0);
        signal writ : in std_logic;
        signal reset : in std_logic;
        signal clk : in std_logic;

        signal reg_out : out std_logic_vector(15 downto 0)

    );

end REG1_16;

architecture behaviour of REG1_16 is
begin
    REG : entity work.REG1_GENERIC
    generic map(
        LEN => 16
    )
    port map(
        reg_in => reg_in,
        writ => writ,
        reset => reset,
        clk => clk,

        reg_out => reg_out
    );
end behaviour;
