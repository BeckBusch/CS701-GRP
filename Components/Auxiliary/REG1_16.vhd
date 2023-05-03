library IEEE;
use IEEE.std_logic_1164.all;

entity REG1_16 is
    port (
        reg_in : in std_logic_vector(15 downto 0);
        writ : in std_logic;
        reset : in std_logic;
        clk : in std_logic;

        reg_out : out std_logic_vector(15 downto 0)

    );

end REG1_16;

architecture behaviour of REG1_16 is
begin

    process (clk) is
    begin

        if rising_edge(clk) then
            if (writ = '1') then
                reg_out <= reg_in;

            elsif (reset = '1') then
                reg_out <= "0000000000000000";

            end if;
        end if;
    end process;
end behaviour;
