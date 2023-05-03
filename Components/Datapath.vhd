library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Datapath is
    port (
        -- general
        clk : in std_logic;

        -- memory address interface
        mem_address_mux_sel : in std_logic_vector(1 downto 0);
        mem_sel : in std_logic;
        address_out : out std_logic_vector(16 downto 0);

        -- memory data interface
        mem_data_mux_sel : in std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(15 downto 0);

        -- alu
        alu_op : in std_logic_vector(1  downto 0);
        alu_data_a_mux_sel : in std_logic_vector(1  downto 0);
        alu_data_b_mux_sel : in std_logic;
        alu_carry_in : in std_logic;
        zout : out std_logic;

        -- pc
        pc_mux_sel : in std_logic_vector(1  downto 0);
        data_in : in std_logic_vector(15 downto 0);
        pc_reg_write : in std_logic;
        pc_reg_reset : in std_logic

        -- rf
        rf_write : in std_logic;
        rf_reset : in std_logic;
        rf_z_mux_sel : in std_logic_vector(2 downto 0);
        rf_x_mux_sel : in std_logic;
        rf_z_mux_sel : in std_logic;
        rf_x_sel : in std_logic_vector(3 downto 0);
        rf_z_sel : in std_logic_vector(3 downto 0);
        ccd : out std_logic_vector(3 downto 0);
        pcd : out std_logic_vector(3 downto 0)
    );
end Datapath;


architecture Behaviour of Datapath is
    -- Components
    component Addr_Mem_Inter is
        port (
            data_a_mux : in std_logic_vector(1 downto 0);
            mem_sel : in std_logic;

            pc_hold : in std_logic_vector(15 downto 0);
            rx : in std_logic_vector(15 downto 0);
            rz : in std_logic_vector(15 downto 0);
            ir_hold : in std_logic_vector(15 downto 0);

            addr : out std_logic_vector(16 downto 0));
    end component;

    component Data_Mem_Inter is
        port (
            data_a_mux : in std_logic_vector(1 downto 0);
    
            ir_hold : in std_logic_vector(15 downto 0);
            rx : in std_logic_vector(15 downto 0);
            dprr : in std_logic_vector(1 downto 0);
    
            data : out std_logic_vector(15 downto 0));
    end component;

    component ALU is
        Port ( 
            alu_op    : in  std_logic_vector(1  downto 0);
            data_a_mux: in  std_logic_vector(1  downto 0);
            data_b_mux: in  std_logic;
            rx        : in  std_logic_vector(15 downto 0);
            rz        : in  std_logic_vector(15 downto 0);
            ir_hold   : in  std_logic_vector(15 downto 0);
            flmr      : in  std_logic_vector(15 downto 0);
            carry_in  : in  std_logic;
            zout      : out std_logic;
            aluout    : out std_logic_vector(15 downto 0));
    end component;

    component PC_COMPONENT is
        port (
            pc_mux_sel : in std_logic_vector(1 downto 0);
            m_out : in std_logic_vector(15 downto 0);
            rx : in std_logic_vector(15 downto 0);
            ir_hold : std_logic_vector(15 downto 0);
    
            reg_write : in std_logic;
            reg_reset : in std_logic;
            reg_clk : in std_logic;
    
            pc_hold : out std_logic_vector(15 downto 0));
    end component;

    component RF is
        port (
            clk : in std_logic;
            writ : in std_logic;
            reset : in std_logic;
    
            z_mux_sel : in std_logic_vector(2 downto 0);
            selx_mux_sel : in std_logic;
            selz_mux_sel : in std_logic;
    
    
            ir_hold_19_16 : in std_logic_vector(3 downto 0);
            cu_selx : in std_logic_vector(3 downto 0);
            cu_selz : in std_logic_vector(3 downto 0);
            ir_hold_23_20 : in std_logic_vector(3 downto 0);
    
            ir_hold_15_0 : in std_logic_vector(15 downto 0);
            m_out : in std_logic_vector(15 downto 0);
            in_rx : in std_logic_vector(15 downto 0);
            aluout : in std_logic_vector(15 downto 0);
            rz_max : in std_logic_vector(15 downto 0);
            sip_hold : in std_logic_vector(15 downto 0);
            er_temp : in std_logic_vector(15 downto 0);
            mem_hp_low : in std_logic_vector(15 downto 0);
    
            rx : out std_logic_vector(15 downto 0);
            rz : out std_logic_vector(15 downto 0);
            ccd : out std_logic_vector(15 downto 0);
            pcd : out std_logic_vector(15 downto 0);
            flmr : out std_logic_vector(15 downto 0));
    end component;
    
    -- Signals
        -- TODO: Organise by where the meetings come from.
    signal pc_hold : std_logic_vector(15 downto 0);
    signal rx : std_logic_vector(15 downto 0);
    signal rz : std_logic_vector(15 downto 0);
    signal ir_hold : std_logic_vector(31 downto 0);
    signal dprr : std_logic_vector(1 downto 0);
    signal flmr : std_logic_vector(15 downto 0);
    signal aluout : std_logic_vector(15 downto 0);
    signal maxout : std_logic_vector(15 downto 0);
    signal sip_hold : std_logic_vector(15 downto 0);
    signal er_temp : std_logic_vector(15 downto 0);
    signal er : std_logic_vector(1 downto 0);
    signal mem_hp_low : std_logic_vector(15 downto 0); -- 7 bits of data from ?????

begin
    -- Port mappings

    -- control signals
    -- inputs
        -- mem_address_mux_sel : in std_logic_vector(1 downto 0);
        -- mem_sel : in std_logic;
    -- outputs
        -- address_out : out std_logic_vector(16 downto 0);
    Addr_Mem_Inter_1 : Addr_Mem_Inter port map(
        data_a_mux => mem_address_mux_sel,
        mem_sel => mem_sel,
        pc_hold => pc_hold,
        rx => rx,
        rz => rz,
        ir_hold => ir_hold(15 downto 0),
        addr => address_out
    );

    -- control signals
    -- inputs
        -- mem_data_mux_sel : in std_logic_vector(1 downto 0)
    -- outputs
        -- data_out : out std_logic_vector(15 downto 0);
    Data_Mem_Inter_1 : Data_Mem_Inter port map(
        data_a_mux => mem_data_mux_sel,
        ir_hold => ir_hold(15 downto 0),
        rx => rx,
        dprr => dprr,
        data => data_out
    );

    -- control signals
    -- inputs
        -- alu_op : in std_logic_vector(1  downto 0);
        -- alu_data_a_mux_sel : in std_logic_vector(1  downto 0);
        -- alu_data_b_mux_sel : in std_logic;
        -- alu_carry_in : in std_logic;
    -- outputs
        -- zout : out std_logic;
    ALU_1 : ALU port map ( 
            alu_op => alu_op,
            data_a_mux => alu_data_a_mux_sel,
            data_b_mux => alu_data_b_mux_sel,
            rx => rx,
            rz => rz,
            ir_hold => ir_hold(15 downto 0),
            flmr => flmr,
            carry_in => alu_carry_in,
            zout => zout,
            aluout => aluout
    );

    -- control signals
    -- inputs
        -- pc_mux_sel : in std_logic_vector(1  downto 0);
        -- data_in : in std_logic_vector(15 downto 0);
        -- pc_reg_write : in std_logic;
        -- pc_reg_reset : in std_logic;
        -- clk : in std_logic; -- this is the clock for every reg
    PC_COMPONENT_1 : PC_COMPONENT port map (
            pc_mux_sel => pc_mux_sel,
            m_out => data_in,
            rx => rx,
            ir_hold => ir_hold(15 downto 0),
            reg_write => pc_reg_write,
            reg_reset => pc_reg_reset,
            reg_clk => clk,
            pc_hold => pc_hold
    );

    -- control signals
    -- inputs
        -- clk : in std_logic; -- this is the clock for every reg
        -- rf_write : in std_logic;
        -- rf_reset : in std_logic;
        -- rf_z_mux_sel : in std_logic_vector(2 downto 0);
        -- rf_x_mux_sel : in std_logic;
        -- rf_z_mux_sel : in std_logic;
        -- rf_x_sel : in std_logic_vector(3 downto 0);
        -- rf_z_sel : in std_logic_vector(3 downto 0);
        -- data_in : in std_logic_vector(15 downto 0); -- shared with PC
        -- mem_hp_low : in std_logic_vector(15 downto 0); -- 7 bits of data from ?????
    -- outputs
        -- ccd : out std_logic_vector(3 downto 0);
        -- pcd : out std_logic_vector(3 downto 0);
    RF_1 : RF port map (
            clk => clk,
            writ => rf_write,
            reset => rf_reset,
            z_mux_sel => rf_mux_sel,
            selx_mux_sel => rf_x_mux_sel,
            selz_mux_sel => rf_z_mux_sel,
    
    
            ir_hold_19_16 => ir_hold(19 downto 16),
            cu_selx => rf_x_sel,
            cu_selz => rf_z_sel,
            ir_hold_23_20 => ir_hold(23 downto 20),
    
            ir_hold_15_0 => ir_hold(15 downto 0),
            m_out => data_in,
            in_rx => rx, -- i dont actually think we need this?
            aluout => aluout,
            rz_max => maxout,
            sip_hold => sip_hold,
            er_temp => er_temp, -- two-bit signal, better to change it in the RF file later
            mem_hp_low => mem_hp_low, -- I have no idea what this is
    
            rx  => rx,
            rz => rz,
            ccd => ccd,
            pcd => pcd,
            flmr => flmr
        );

    -- Signal mappings
    er_temp <= "00000000000000" & er;

end Behaviour;
