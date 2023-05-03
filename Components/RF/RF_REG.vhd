library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity RF_REG is
    port (
        sel_x : in std_logic_vector(3 downto 0);
        sel_z : in std_logic_vector(3 downto 0);

        z : in std_logic_vector(15 downto 0);

        writ : in std_logic;
        clk : in std_logic;
        reset : in std_logic;

        out_rx : out std_logic_vector(15 downto 0);
        out_rz : out std_logic_vector(15 downto 0);

        out_ccd : out std_logic_vector(15 downto 0);
        out_pcd : out std_logic_vector(15 downto 0);
        out_flmr : out std_logic_vector(15 downto 0)
    );

end RF_REG;
architecture Behavioral of RF_REG is

    type ram_array is array (0 to 15) of std_logic_vector (15 downto 0);

    signal ram_data : ram_array := (
        x"0000", x"0000", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000",
        x"0000", x"0000", x"0000", x"0000"
    );

begin

    process (clk)
    begin
        if (rising_edge(clk)) then

            if (writ = '1') then
                ram_data(to_integer(unsigned(sel_z))) <= z;
            end if;

            if (reset = '1') then
                for i in 0 to 15 loop
                    ram_data(i) <= "0000000000000000";
                end loop;
            end if;

        end if;
    end process;

    -- no clue if these two are correct outputs
    out_rx <= ram_data(to_integer(unsigned(sel_x)));
    out_rz <= ram_data(to_integer(unsigned(sel_z)));

    out_ccd <= ram_data(8); -- R7
    out_pcd <= ram_data(9); -- R8
    out_flmr <= ram_data(11); -- R10

end Behavioral;
