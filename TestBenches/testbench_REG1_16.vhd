library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_REG1_16 is
end testbench_REG1_16;

architecture Behavioral of testbench_REG1_16 is

    -- Component declaration
    component REG1_16 is
        port (
            signal reg_in : in std_logic_vector(15 downto 0);
            signal writ : in std_logic;
            signal reset : in std_logic;
            signal clk : in std_logic;

            signal reg_out : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Input signals
    signal reg_in : std_logic_vector(15 downto 0);
    signal writ : std_logic;
    signal reset : std_logic;
    signal clk : std_logic := '0';

    signal reg_out : std_logic_vector(15 downto 0);

    constant half_clk_period: time := 5 ns;
    signal finished : std_logic := '0';

begin

    -- Instantiate the ALU
    PC_1 : REG1_16 port map(
        reg_in => reg_in,
        writ => writ,
        reset => reset,
        clk => clk,

        reg_out => reg_out
    );

    -- Clock
    clk <= not clk after half_clk_period when finished /= '1' else '0';

    -- Stimulus Process
    stim_proc : process
    begin
        finished <= '0';
        
        -- Writing to register
        reg_in <= x"0001";
        writ <= '1';
        reset <= '0';
        wait for 10 ns;
        assert reg_out = x"0001"
            report "Write operation error" severity error;

        -- Checking that register doesn't write when write signal is off
        reg_in <= x"0000";
        writ <= '0';
        reset <= '0';
        wait for 10 ns;
        assert reg_out = x"0001"
            report "Register hold error" severity error;

        -- Writing to register when there is something in it
        reg_in <= x"0002";
        writ <= '1';
        reset <= '0';
        wait for 10 ns;
        assert reg_out = x"0002"
            report "Overwrite operation error" severity error;

        -- Resetting register
        writ <= '0';
        reset <= '1';
        wait for 10 ns;
        assert reg_out = x"0000"
            report "Register reset error" severity error;

        -- Testing register write and reset at the same time
        reg_in <= x"0003";
        writ <= '1';
        reset <= '0';
        wait for 10 ns;

        writ <= '1';
        reset <= '1';
        wait for 10 ns;
        assert reg_out = x"0000"
            report "Reset register error due to write signal" severity error;

        -- End simulation
        finished <= '1';
        wait;
    end process;
end Behavioral;
