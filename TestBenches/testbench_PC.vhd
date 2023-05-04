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
    signal reg_clk : std_logic := '0';

    -- out
    signal pc_hold : std_logic_vector(15 downto 0) := x"0000";

    constant half_clk_period: time := 5 ns;
    signal finished : std_logic := '0';

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

    -- Clock
    reg_clk <= not reg_clk after half_clk_period when finished /= '1' else '0';

    -- Stimulus Process
    stim_proc : process
    begin
        finished <= '0';

        -- Initialising values
        reg_write <= '1';
        reg_reset <= '0';

        m_out <= x"0000";
        rx <= x"0001";
        ir_hold <= x"0002";

        -- Select data in
        pc_mux_sel <= "00";
        wait for 10 ns;
        assert pc_hold = x"0000"
            report "Data in select" severity error;

        -- Select RX
        pc_mux_sel <= "01";
        wait for 10 ns;    
        assert pc_hold = x"0001"
            report "rx select" severity error;

        -- Select operand
        pc_mux_sel <= "10";
        wait for 10 ns;    
        assert pc_hold = x"0002"
            report "Operand select" severity error;

        -- Select PC + 1
        pc_mux_sel <= "11";
        wait for 10 ns;    
        assert pc_hold = x"0003"
            report "PC + 1 select" severity error;

        -- End simulation
        finished <= '1';
        wait;
    end process;
end Behavioral;
