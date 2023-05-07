library IEEE;
use IEEE.std_logic_1164.all;

entity REG1_GENERIC is
    generic (
        LEN : natural;
    )
    port (
        signal reg_in : in std_logic_vector(LEN - 1 downto 0);
        signal writ : in std_logic;
        signal reset : in std_logic;
        signal clk : in std_logic;

        signal reg_out : out std_logic_vector(LEN - 1 downto 0)

    );

end REG1_GENERIC;

architecture behaviour of REG1_GENERIC is
begin

    process (clk) is
    begin

        if falling_edge(clk) then
            if (reset = '1') then
                reg_out <= (others => '0');

            elsif (writ = '1') then
                reg_out <= reg_in;

            end if;
        end if;
    end process;
end behaviour;
