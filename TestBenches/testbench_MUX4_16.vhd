library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_MUX4_16 is
end testbench_MUX4_16;

architecture Behavioral of testbench_MUX4_16 is

    -- Component declaration
    component MUX4_16 is
        Port ( 
            sel   : in  std_logic_vector(1 downto 0);
            a, b, c, d : in  std_logic_vector(15 downto 0);
            outp  : out std_logic_vector(15 downto 0));
    end component;

    -- Input signals
    signal mux_sel : std_logic_vector(1 downto 0) := "00";
    signal a : std_logic_vector(15 downto 0) := x"0000";
    signal b : std_logic_vector(15 downto 0) := x"0001";
    signal c : std_logic_vector(15 downto 0) := x"0002";
    signal d : std_logic_vector(15 downto 0) := x"0003";
    signal mux_out : std_logic_vector(15 downto 0) := x"0004";

begin

    -- Instantiate the ALU
    MUX4_16_1 : MUX4_16 port map(
        sel => mux_sel,
        a => a,
        b => b,
        c => c,
        d => d,
        outp => mux_out
    );

    -- Stimulus Process
    stim_proc : process
    begin
        -- Mux select
        mux_sel <= "00";
        wait for 10 ns;
        assert mux_out = x"0000"
            report "Select A error" severity error;

        mux_sel <= "01";
        wait for 10 ns;
        assert mux_out = x"0001"
        report "Select B error" severity error;
        
        mux_sel <= "10";
        wait for 10 ns;
        assert mux_out = x"0002"
            report "Select C error" severity error;

        mux_sel <= "11";
        wait for 10 ns;
        assert mux_out = x"0003"
            report "Select D error" severity error;

        wait;
    end process;
end Behavioral;
