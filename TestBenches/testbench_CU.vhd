library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_CU is
end testbench_CU;

architecture Behavioral of testbench_CU is
    -- Component declaration
    component Control_Unit is
        port (

            CLK : in std_logic;
            Reset : in std_logic;
            Debug_Mode : in std_logic;
            nios_control : in std_logic;
            init_up : out std_logic; -- uP initialisation
            we : out std_logic; -- write ram
            -- IR
            Opcode : in std_logic_vector (5 downto 0);
            Addressing_Mode : in std_logic_vector (1 downto 0);
            Rz : in std_logic_vector(3 downto 0);
            Rx : in std_logic_vector(3 downto 0);
            Operand : in std_logic_vector(15 downto 0);
            write_ir : out std_logic;
            ir_reset : in std_logic;
            -- Pc:
            write_pc : out std_logic;
            pc_mux_sel : out std_logic_vector(1 downto 0);
            reset_pc : in std_logic;
            -- RF Block:
            write_rf : out std_logic;
            rf_mux_sel : out std_logic_vector(2 downto 0);
            rf_mux_sel_x : out std_logic;
            rf_mux_sel_z : out std_logic;
            reset_rf : out std_logic;
            rf_value_sel_x : out std_logic_vector(3 downto 0);
            rf_value_sel_z : out std_logic_vector(3 downto 0);
            -- memory address and data interface
            mem_sel : out std_logic;
            m_address_mux_sel : out std_logic_vector(1 downto 0);
            mem_data_mux_sel : out std_logic_vector(1 downto 0);
            --AlU
            alu_mux_A : out std_logic_vector(1 downto 0);
            alu_mux_B : out std_logic;
            alu_op : out std_logic_vector(1 downto 0);
            z : in std_logic;
            clr_z : out std_logic;
            --SIP
            write_sip : out std_logic;
            -- Ssop
            write_sop : out std_logic;
            --dpcr
            write_dpcr : out std_logic;
            reset_dpcr : out std_logic
        );
    end component;

    -- Input signals
    signal CLK : in std_logic;
    signal Reset : in std_logic;
    signal Debug_Mode : in std_logic;
    signal nios_control : in std_logic;
    signal Opcode : in std_logic_vector (5 downto 0);
    signal Addressing_Mode : in std_logic_vector (1 downto 0);
    signal Rz : in std_logic_vector(3 downto 0);
    signal Rx : in std_logic_vector(3 downto 0);
    signal Operand : in std_logic_vector(15 downto 0);
    signal ir_reset : in std_logic;
    signal reset_pc : in std_logic;
    signal z : in std_logic;

    -- Output signals
    signal init_up : out std_logic; -- uP initialisation
    signal we : out std_logic; -- write ram
    signal write_ir : out std_logic;
    signal write_pc : out std_logic;
    signal pc_mux_sel : out std_logic_vector(1 downto 0);
    signal write_rf : out std_logic;
    signal rf_mux_sel : out std_logic_vector(2 downto 0);
    signal rf_mux_sel_x : out std_logic;
    signal rf_mux_sel_z : out std_logic;
    signal reset_rf : out std_logic;
    signal rf_value_sel_x : out std_logic_vector(3 downto 0);
    signal rf_value_sel_z : out std_logic_vector(3 downto 0);
    signal mem_sel : out std_logic;
    signal m_address_mux_sel : out std_logic_vector(1 downto 0);
    signal mem_data_mux_sel : out std_logic_vector(1 downto 0);
    signal alu_mux_A : out std_logic_vector(1 downto 0);
    signal alu_mux_B : out std_logic;
    signal alu_op : out std_logic_vector(1 downto 0);
    signal clr_z : out std_logic;
    signal write_sip : out std_logic;
    signal write_sop : out std_logic;
    signal write_dpcr : out std_logic;
    signal reset_dpcr : out std_logic;

begin

    -- Instantiate the ALU
    DUT : Control_Unit port map(
        CLK => CLK,
        Reset => Reset,
        Debug_Mode => Debug_Mode,
        nios_control => nios_control,
        Opcode => Opcode,
        Addressing_Mode => Addressing_Mode,
        Rz => Rz,
        Rx => Rx,
        Operand => Operand,
        ir_reset => ir_reset,
        reset_pc => reset_pc,
        z => z,
        init_up => init_up,
        we => we,
        write_ir => write_ir,
        write_pc => write_pc,
        pc_mux_sel => pc_mux_sel,
        write_rf => write_rf,
        rf_mux_sel => rf_mux_sel,
        rf_mux_sel_x => rf_mux_sel_x,
        rf_mux_sel_z => rf_mux_sel_z,
        reset_rf => reset_rf,
        rf_value_sel_x => rf_value_sel_x,
        rf_value_sel_z => rf_value_sel_z,
        mem_sel => mem_sel,
        m_address_mux_sel => m_address_mux_sel,
        mem_data_mux_sel => mem_data_mux_sel,
        alu_mux_A => alu_mux_A,
        alu_mux_B => alu_mux_B,
        alu_op => alu_op,
        clr_z => clr_z,
        write_sip => write_sip,
        write_sop => write_sop,
        write_dpcr => write_dpcr,
        reset_dpcr => reset_dpcr
    );

    -- Stimulus Process
    stim_proc : process
    begin

        -- Test cases
        -- Test operation
        CLK <= "";
        Reset <= "";
        Debug_Mode <= "";
        nios_control <= "";
        Opcode <= "";
        Addressing_Mode <= "";
        Rz <= "";
        Rx <= "";
        Operand <= "";
        ir_reset <= "";
        reset_pc <= "";
        z <= "";
        wait for 10 ns;
        assert test = "" and test = ''
        report "Test operation failed" severity error;
        
        -- End simulation
        wait;
    end process;
end Behavioral;
