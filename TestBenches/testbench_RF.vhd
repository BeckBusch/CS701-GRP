library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_RF is
end testbench_RF;

architecture Behavioral of testbench_RF is

    -- Component declaration
    component RF is
        port (
            clk : in std_logic;
            writ : in std_logic;
            reset : in std_logic;
    
            selx_mux_sel : in std_logic;
            ir_hold_19_16 : in std_logic_vector(3 downto 0);
            cu_selx : in std_logic_vector(3 downto 0);
    
            selz_mux_sel : in std_logic;
            cu_selz : in std_logic_vector(3 downto 0);
            ir_hold_23_20 : in std_logic_vector(3 downto 0);
    
            z_mux_sel : in std_logic_vector(2 downto 0);
            ir_hold_15_0 : in std_logic_vector(15 downto 0);
            m_out : in std_logic_vector(15 downto 0);
            aluout : in std_logic_vector(15 downto 0);
            rz_max : in std_logic_vector(15 downto 0);
            sip_hold : in std_logic_vector(15 downto 0);
            pc_hold : in std_logic_vector(15 downto 0);
            mem_hp_low : in std_logic_vector(15 downto 0);
    
            rx : out std_logic_vector(15 downto 0);
            rz : out std_logic_vector(15 downto 0);
            ccd : out std_logic_vector(3 downto 0);
            pcd : out std_logic_vector(3 downto 0);
            flmr : out std_logic_vector(15 downto 0));
    end component;

    -- Input signals
    signal writ : std_logic;
    signal reset : std_logic;
    signal clk : std_logic := '1';

    --- clock signals
    constant half_clk_period: time := 5 ns;
    signal finished : std_logic := '0';

    -- Input
    signal selx_mux_sel : std_logic;
    signal ir_hold_19_16 : std_logic_vector(3 downto 0);
    signal cu_selx : std_logic_vector(3 downto 0);

    signal selz_mux_sel : std_logic;
    signal cu_selz : std_logic_vector(3 downto 0);
    signal ir_hold_23_20 : std_logic_vector(3 downto 0);

    signal z_mux_sel : std_logic_vector(2 downto 0);
    signal ir_hold_15_0 : std_logic_vector(15 downto 0);
    signal m_out : std_logic_vector(15 downto 0);
    signal aluout : std_logic_vector(15 downto 0);
    signal rz_max : std_logic_vector(15 downto 0);
    signal sip_hold : std_logic_vector(15 downto 0);
    signal pc_hold : std_logic_vector(15 downto 0);
    signal mem_hp_low : std_logic_vector(15 downto 0);

    signal rx : std_logic_vector(15 downto 0);
    signal rz : std_logic_vector(15 downto 0);
    signal ccd : std_logic_vector(3 downto 0);
    signal pcd : std_logic_vector(3 downto 0);
    signal flmr : std_logic_vector(15 downto 0);

begin

    -- Instantiate the ALU
    DUT : RF
    port map(
        clk => clk,
        writ => writ,
        reset => reset,

        selx_mux_sel => selx_mux_sel,
        ir_hold_19_16 => ir_hold_19_16,
        cu_selx => cu_selx,

        selz_mux_sel => selz_mux_sel,
        cu_selz => cu_selz,
        ir_hold_23_20 => ir_hold_23_20,

        z_mux_sel => z_mux_sel,
        ir_hold_15_0 => ir_hold_15_0,
        m_out => m_out,
        aluout => aluout,
        rz_max => rz_max,
        sip_hold => sip_hold,
        pc_hold => pc_hold,
        mem_hp_low => mem_hp_low,

        rx => rx,
        rz => rz,
        ccd => ccd,
        pcd => pcd,
        flmr => flmr
);

    -- Clock
    clk <= not clk after half_clk_period when finished /= '1' else '0';

    -- Stimulus Process
    stim_proc : process
    begin
        finished <= '0';
        
        -- Init
        writ <= '1';
        reset <= '0';
        selz_mux_sel <= '1';
        selx_mux_sel <= '1';

        -- Writing to RZ
        z_mux_sel <= "000";
        ir_hold_15_0 <= x"BEEF";
        cu_selz <= x"0";
        wait for 10 ns;
        assert rz = x"BEEF"
            report "Write IR operation error" severity error;

        -- Writing to RZ while reading from RX
        ir_hold_15_0 <= x"DEAD";
        cu_selz <= x"1";
        cu_selx <= x"0";
        wait for 10 ns;
        assert rx = x"BEEF" and rz = x"DEAD"
            report "Write RZ Read RX error" severity error;

        -- Read and write from RZ in same clock cycle
        ir_hold_15_0 <= x"AC1D";
        assert rz = x"DEAD"
            report "Read RZ before write error" severity error;
        wait for 10 ns;
        assert rz = x"AC1D"
            report "Read RZ after write error" severity error;


        -- End simulation
        finished <= '1';
        wait;
    end process;
end Behavioral;
