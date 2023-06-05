library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PC_2 is
    port (
        pc_mux_sel : in std_logic_vector(1 downto 0);
        m_out : in std_logic_vector(15 downto 0);
        rx : in std_logic_vector(15 downto 0);
        ir_hold : std_logic_vector(15 downto 0);

        reg_write : in std_logic;
        reg_reset : in std_logic;
        reg_clk : in std_logic;

        pc_hold : out std_logic_vector(15 downto 0));
end PC_2;

architecture behaviour of PC_2 is

    component MUX4_16 is
        port (
            sel : in std_logic_vector(1 downto 0);
            a, b, c, d : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0));
    end component;

    signal counter : std_logic_vector(15 downto 0) := (others => '0');

    signal mux_out : std_logic_vector(15 downto 0);

    signal pc_out : std_logic_vector(15 downto 0);
    signal pc_increment : std_logic_vector(15 downto 0) := (others => '0');

begin

    MUX4_16_1 : MUX4_16 port map(
        sel => pc_mux_sel,
        a => m_out,
        b => rx,
        c => ir_hold,
        d => pc_increment,
        outp => mux_out
    );

    process (reg_clk) is
    begin
        if rising_edge(reg_clk) then
            if (reg_reset = '1') then
                counter <= (others => '0');
                pc_increment <= (others => '0');
            else
                counter <= mux_out;
                pc_increment <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process;

    pc_hold <= counter;

end behaviour;
