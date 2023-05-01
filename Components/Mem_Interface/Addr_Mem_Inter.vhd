library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Data_Addr_Inter is
    port (
        data_a_mux : in std_logic_vector(1 downto 0);
        mem_sel : in std_logic_vector(1 downto 0);

        pc_hold : in std_logic_vector(15 downto 0);
        rx : in std_logic_vector(15 downto 0);
        rz : in std_logic_vector(15 downto 0);
        ir_hold : in std_logic_vector(15 downto 0);

        addr : out std_logic_vector(16 downto 0));
end Data_Addr_Inter;

architecture Behaviour of Data_Addr_Inter is

    component MUX4_1 is
        port (
            sel : in std_logic_vector(1 downto 0);
            a, b, c, d : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0));
    end component;

    --signals

    --first mux usage

    -- concentration 

    --signal assignment
