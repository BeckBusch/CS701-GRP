library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Data_Mem_Inter is
    port (
        data_a_mux : in std_logic_vector(1 downto 0);

        ir_hold : in std_logic_vector(15 downto 0);
        rx : in std_logic_vector(15 downto 0);
        dprr : in std_logic_vector(15 downto 0);

        data : out std_logic_vector(15 downto 0));
end Data_Mem_Inter;

architecture Behaviour of Data_Mem_Inter is

    component MUX4_1 is
        port (
            sel : in std_logic_vector(1 downto 0);
            a, b, c, d : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0));
    end component;

    signal data_a_mux_out : std_logic_vector(15 downto 0);

begin

    MUX4_1_1 : MUX4_1 port map(
        sel => data_a_mux,
        a => ir_hold,
        b => rx,
        c => dprr,
        d => "0000000000000000",
        outp => data_a_mux_out
    );

    data <=  data_a_mux_out;

end Behaviour;
