library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity PC_COMPONENT is
    port (
        pc_mux_sel : in std_logic_vector(1 downto 0);
        m_out : in std_logic_vector(15 downto 0);
        rx : in std_logic_vector(15 downto 0);
        ir_hold : std_logic_vector(15 downto 0);

        reg_write : in std_logic;
        reg_reset : in std_logic;
        reg_clk : in std_logic;

        pc_hold : out std_logic_vector(15 downto 0));
end PC_COMPONENT;

architecture behaviour of PC_COMPONENT is

    component MUX4_16 is
        port (
            sel : in std_logic_vector(1 downto 0);
            a, b, c, d : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0));
    end component;

    component REG1_16 is
        port (
            reg_in : in std_logic_vector(15 downto 0);
            writ : in std_logic;
            reset : in std_logic;
            clk : in std_logic;

            reg_out : out std_logic_vector(15 downto 0)
        );
    end component;

    signal mux_out : std_logic_vector(15 downto 0);

    signal pc_out : std_logic_vector(15 downto 0);
    signal pc_increment : std_logic_vector(15 downto 0);

begin

    MUX4_16_1 : MUX4_16 port map(
        sel => pc_mux_sel,
        a => m_out,
        b => rx,
        c => ir_hold,
        d => pc_increment,
        outp => mux_out
    );

    REG1_16_1 : REG1_16 port map(
        reg_in => mux_out,
        writ => reg_write,
        reset => reg_reset,
        clk => reg_clk,
        reg_out => pc_out
    );

    pc_increment <= std_logic_vector(unsigned(pc_out) + 1);

    pc_hold <= pc_out;

end behaviour;
