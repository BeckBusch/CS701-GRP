

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.mux_p;

entity RF_REG_ALT is
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

end RF_REG_ALT;

architecture Behavioral of RF_REG_ALT is

    signal mux_signals : mux_p.slv_array_t(0 to 15);
    signal sel_x_internal : integer;
    signal sel_z_internal : integer;
    signal write_z : std_logic_vector(0 to 15);

begin

    REG_FILE :
    for I in 0 to 15 generate
        REGX : entity work.REG1_GENERIC
        generic map(
            LEN => 16
        )
        port map(
            reg_in => z, 
            writ => write_z(i),
            reset => reset,
            clk => clk,
            reg_out => mux_signals(i)
        );
    end generate REG_FILE;

    process(sel_z, writ)
    begin
        write_z <= (others => '0');
        write_z(to_integer(unsigned(sel_z))) <= writ;
    end process;

    out_rx <= mux_signals(to_integer(unsigned(sel_x)));
    out_rz <= mux_signals(to_integer(unsigned(sel_z)));

    out_ccd <= mux_signals(8); -- R7
    out_pcd <= mux_signals(9); -- R8
    out_flmr <= mux_signals(11); -- R10

end Behavioral;
