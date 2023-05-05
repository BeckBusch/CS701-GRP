library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_MAX is
end testbench_MAX;

architecture Behavioral of testbench_MAX is

    -- Component declaration
    component MAX is
        Port (
            rx : in std_logic_vector(15 downto 0);
            rz : in std_logic_vector(15 downto 0);
            max_out : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Input signals
    signal rx : std_logic_vector(15 downto 0) := (others => '0');
    signal rz : std_logic_vector(15 downto 0) := (others => '0');

    -- Output signals
    signal max_out : std_logic_vector(15 downto 0) := (others => '0');

    -- Clock signal
    signal clk : std_logic := '0';
    constant half_clk_period: time := 5 ns;
    signal finished : std_logic := '0';

begin

    -- Instantiate the ALU
    DUT : MAX port map(
        rx => rx,
        rz => rz,
        max_out => max_out
    );

    -- Clock
    clk <= not clk after half_clk_period when finished /= '1' else '0';

    -- Stimulus Process
    stim_proc : process
    begin
        finished <= '0';

        -- RZ is max
        rx <= x"0123";
        rz <= x"0004";
        wait for 10 ns;
        assert max_out = x"0004"
            report "RZ max" severity error;

        -- RX 15-12 is max
        rx <= x"5123";
        rz <= x"0004";
        wait for 10 ns;
        assert max_out = x"0005"
            report "RX(15..12) max" severity error;

        -- RX 11-8 is max
        rx <= x"0523";
        rz <= x"0004";
        wait for 10 ns;
        assert max_out = x"0005"
            report "RX(11..8) max" severity error;

        -- RX 7-4 is max
        rx <= x"0153";
        rz <= x"0004";
        wait for 10 ns;
        assert max_out = x"0005"
            report "RX(7..4) max" severity error;

        -- RX 3-0 is max
        rx <= x"0125";
        rz <= x"0004";
        wait for 10 ns;
        assert max_out = x"0005"
            report "RX(3..0) max" severity error;

        -- End simulation
        finished <= '1';
        wait;
    end process;
end Behavioral;
