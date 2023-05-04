library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_PC is
end testbench_PC;

architecture Behavioral of testbench_PC is

    -- Component declaration
    component PC_COMPONENT is
        port (
            pc_mux_sel : in std_logic_vector(1 downto 0);
            m_out : in std_logic_vector(15 downto 0);
            rx : in std_logic_vector(15 downto 0);
            ir_hold : std_logic_vector(15 downto 0);

            reg_write : in std_logic;
            reg_reset : in std_logic;
            reg_clk : in std_logic;

            pc_hold : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Input signals
    signal pc_mux_sel : std_logic_vector(1 downto 0);
    signal m_out : std_logic_vector(15 downto 0);
    signal rx : std_logic_vector(15 downto 0);
    signal ir_hold : std_logic_vector(15 downto 0);

    signal reg_write : std_logic;
    signal reg_reset : std_logic;
    signal reg_clk : std_logic;

    -- out
    signal pc_hold : std_logic_vector(15 downto 0);

begin

    -- Instantiate the ALU
    PC_1 : PC_COMPONENT port map(
        pc_mux_sel => pc_mux_sel,
        m_out => m_out,
        rx => rx,
        ir_hold => ir_hold,

        reg_write => reg_write,
        reg_reset => reg_reset,
        reg_clk => reg_clk,

        pc_hold => pc_hold
    );

    -- Stimulus Process
    stim_proc : process
    begin
        reg_write <= '1';
        reg_reset <= '0';
        m_out <= "1010101010101010";
        rx <= "1100110011001100";
        ir_hold <= "0000000000001111";

        reg_clk <= '0';
        pc_mux_sel <= "00";

        wait for 5 ns;

        reg_clk <= '1';
        wait for 5 ns;

        reg_clk <= '0';
        wait for 5 ns;

        reg_clk <= '1';
        wait for 5 ns;

        reg_clk <= '0';
        wait for 5 ns;

        reg_clk <= '1';
        wait for 5 ns;

        reg_clk <= '0';
        pc_mux_sel <= "01";
        wait for 5 ns;

        reg_clk <= '1';
        wait for 5 ns;

        reg_clk <= '0';
        pc_mux_sel <= "10";
        wait for 5 ns;

        reg_clk <= '1';
        wait for 5 ns;

        reg_clk <= '0';
        pc_mux_sel <= "11";
        wait for 5 ns;

        reg_clk <= '1';
        wait for 5 ns;        

        -- End simulation
        wait;
    end process;
end Behavioral;
