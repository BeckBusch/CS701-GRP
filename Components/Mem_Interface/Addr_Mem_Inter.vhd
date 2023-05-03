library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Addr_Mem_Inter is
    port (
        data_a_mux : in std_logic_vector(1 downto 0);
        mem_sel : in std_logic;

        pc_hold : in std_logic_vector(15 downto 0);
        rx : in std_logic_vector(15 downto 0);
        rz : in std_logic_vector(15 downto 0);
        ir_hold : in std_logic_vector(15 downto 0);

        addr : out std_logic_vector(16 downto 0));
end Addr_Mem_Inter;

architecture Behaviour of Addr_Mem_Inter is

    component MUX4_16 is
        port (
            sel : in std_logic_vector(1 downto 0);
            a, b, c, d : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0));
    end component;

    signal data_a_mux_out : std_logic_vector(15 downto 0);

begin

    MUX4_16_1 : MUX4_16 port map(
        sel => data_a_mux,
        a => pc_hold,
        b => rx,
        c => rz,
        d => ir_hold,
        outp => data_a_mux_out
    );

    addr <= mem_sel & data_a_mux_out;

end Behaviour;
