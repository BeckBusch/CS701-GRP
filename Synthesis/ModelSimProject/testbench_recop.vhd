LIBRARY ieee;
USE ieee.std_logic_1164.all; 

entity testbench_recop is
end testbench_recop;

architecture Behavioral of testbench_recop is


    component ReCOPCore IS 
        PORT
        (
            CLK :  IN  STD_LOGIC;
            Reset :  IN  STD_LOGIC;
            clr_irq_in :  IN  STD_LOGIC;
            dprr_write :  IN  STD_LOGIC;
            clr_irq_write :  IN  STD_LOGIC;
            dprr_reset :  IN  STD_LOGIC;
            clr_irq_reset :  IN  STD_LOGIC;
            dpc_in :  IN  STD_LOGIC;
            dpc_write :  IN  STD_LOGIC;
            dpc_reset :  IN  STD_LOGIC;
            z_write :  IN  STD_LOGIC;
            dprr_in :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            head :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            ir_out :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_data :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            SIP_in :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            clr_irq :  OUT  STD_LOGIC;
            dpc :  OUT  STD_LOGIC;
            addr :  OUT  STD_LOGIC_VECTOR(16 DOWNTO 0);
            ccd :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
            data :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
            dpcr_out :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            pcd :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
            SOP :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)

        );
    END component;

    signal CLK           :  STD_LOGIC := '1';
    signal Reset         :  STD_LOGIC := '0';
    signal clr_irq_in    :  STD_LOGIC := '0';
    signal dprr_write    :  STD_LOGIC := '0';
    signal clr_irq_write :  STD_LOGIC := '0';
    signal dprr_reset    :  STD_LOGIC := '0';
    signal clr_irq_reset :  STD_LOGIC := '0';
    signal dpc_in        :  STD_LOGIC := '0';
    signal dpc_write     :  STD_LOGIC := '0';
    signal dpc_reset     :  STD_LOGIC := '0';
    signal z_write       :  STD_LOGIC := '0';
    signal dprr_in       :  STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    signal head          :  STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal ir_out        :  STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal m_data        :  STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal SIP_in        :  STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal clr_irq       :  STD_LOGIC := '0';
    signal dpc           :  STD_LOGIC := '0';
    signal addr          :  STD_LOGIC_VECTOR(16 DOWNTO 0) := (others => '0');
    signal ccd           :  STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal data          :  STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal dpcr_out      :  STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    signal pcd           :  STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal SOP           :  STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    --- clock signals
    constant half_clk_period: time := 10 ns;
    signal finished : std_logic := '0';

begin

    DUT : ReCOPCore port map (
        CLK => CLK,
        Reset => Reset,
        clr_irq_in => clr_irq_in,
        dprr_write => dprr_write,
        clr_irq_write => clr_irq_write,
        dprr_reset => dprr_reset,
        clr_irq_reset => clr_irq_reset,
        dpc_in => dpc_in,
        dpc_write => dpc_write,
        dpc_reset => dpc_reset,
        z_write => z_write,
        dprr_in => dprr_in,
        head => head,
        ir_out => ir_out,
        m_data => m_data,
        SIP_in => SIP_in,
        clr_irq => clr_irq,
        dpc => dpc,
        addr => addr,
        ccd => ccd,
        data => data,
        dpcr_out => dpcr_out,
        pcd => pcd,
        SOP => SOP
    );

    CLK  <= not CLK after half_clk_period when finished /= '1' else '0';

    stim_proc : process
    begin
        finished <= '0';

        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';
        
        wait for 400 ns;

        -- End simulation
        finished <= '1';
        wait;
    end process;
end Behavioral;
