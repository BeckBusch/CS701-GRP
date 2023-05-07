library IEEE;
use IEEE.std_logic_1164.all;

-- when using remember that write is mispelled as writ, since write is reserved

entity REG1_1 is
    port (
        reg_in : in std_logic;
        writ : in std_logic;
        reset : in std_logic;
        clk : in std_logic;

        reg_out : out std_logic

    );

end REG1_1;

architecture behaviour of REG1_1 is
    signal reg_in_wrap : std_logic_vector(0 downto 0);
    signal reg_out_wrap : std_logic_vector(0 downto 0);
begin
    REG : entity work.REG1_GENERIC
    generic map(
        LEN => 1
    )
    port map(
        reg_in => reg_in_wrap,
        writ => writ,
        reset => reset,
        clk => clk,

        reg_out => reg_out_wrap
    );

    reg_in_wrap <= "" & reg_in;
    reg_out <= reg_out_wrap(0);
end behaviour;
