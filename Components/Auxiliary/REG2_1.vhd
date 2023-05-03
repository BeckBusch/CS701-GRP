library IEEE;
use IEEE.std_logic_1164.all;

-- when using remember that write is mispelled as writ, since write is reserved

entity REG2_1 is
    port (
        reg_in : in std_logic_vector(1 downto 0);
        writ : in std_logic;
        reset : in std_logic;
        clk : in std_logic;

        reg_out : out std_logic_vector(1 downto 0)

    );

end REG2_1;

architecture behaviour of REG2_1 is
begin

    process (clk) is
    begin

        if rising_edge(clk) then
            if (writ = '1') then
                reg_out <= reg_in;

            elsif (reset = '1') then
                reg_out <= "00";

            end if;
        end if;
    end process;
end behaviour;
