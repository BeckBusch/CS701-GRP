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
    signal clk : std_logic;

    signal reg_out : std_logic_vector(15 downto 0);

begin

    -- Instantiate the ALU
    PC_1 : REG1_16 port map(
        reg_in => reg_in,
        writ => writ,
        reset => reset,
        clk => clk,

        reg_out => reg_out
    );

    -- Stimulus Process
    stim_proc : process
    begin
        
        reg_in <= "1111000011110000";
        writ <= '1';
        reset <= '0';
        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;

        writ <= '1';
        reset <= '1';
        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;

        writ <= '1';
        reset <= '0';
        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;

        reg_in <= "1100110011001100";
        writ <= '1';
        reset <= '0';
        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;

        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;

        clk <= '0';
        wait for 5 ns;

        clk <= '1';
        wait for 5 ns;
        -- End simulation
        wait;
    end process;
end Behavioral;
