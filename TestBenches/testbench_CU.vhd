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
            --Debug_Mode : in std_logic;
            --nios_control : in std_logic;
            --init_up : out std_logic; -- uP initialisation
            we : out std_logic; -- write ram
            -- IR
            Opcode : in std_logic_vector (5 downto 0);
            Addressing_Mode : in std_logic_vector (1 downto 0);
            Rz : in std_logic_vector(3 downto 0);
            Rx : in std_logic_vector(3 downto 0);
            Operand : in std_logic_vector(15 downto 0);
            write_ir : out std_logic;
            --ir_reset : in std_logic;
            -- Pc:
            write_pc : out std_logic;
            pc_mux_sel : out std_logic_vector(1 downto 0);
            reset_pc : out std_logic;
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
    signal CLK : std_logic;
    signal Reset : std_logic;
    --signal Debug_Mode : std_logic;
    --signal nios_control : std_logic;
    signal Opcode : std_logic_vector (5 downto 0);
    signal Addressing_Mode : std_logic_vector (1 downto 0);
    signal Rz : std_logic_vector(3 downto 0);
    signal Rx : std_logic_vector(3 downto 0);
    signal Operand : std_logic_vector(15 downto 0);
    --signal ir_reset : std_logic;
    signal reset_pc : std_logic;
    signal z : std_logic;
    --signal init_up : std_logic; -- uP initialisation
    signal we : std_logic; -- write ram
    signal write_ir : std_logic;
    signal write_pc : std_logic;
    signal pc_mux_sel : std_logic_vector(1 downto 0);
    signal write_rf : std_logic;
    signal rf_mux_sel : std_logic_vector(2 downto 0);
    signal rf_mux_sel_x : std_logic;
    signal rf_mux_sel_z : std_logic;
    signal reset_rf : std_logic;
    signal rf_value_sel_x : std_logic_vector(3 downto 0);
    signal rf_value_sel_z : std_logic_vector(3 downto 0);
    signal mem_sel : std_logic;
    signal m_address_mux_sel : std_logic_vector(1 downto 0);
    signal mem_data_mux_sel : std_logic_vector(1 downto 0);
    signal alu_mux_A : std_logic_vector(1 downto 0);
    signal alu_mux_B : std_logic;
    signal alu_op : std_logic_vector(1 downto 0);
    signal clr_z : std_logic;
    signal write_sip : std_logic;
    signal write_sop : std_logic;
    signal write_dpcr : std_logic;
    signal reset_dpcr : std_logic;

begin

    -- Instantiate the ALU
    CU : Control_Unit port map(
        CLK => CLK,
        Reset => Reset,
        --Debug_Mode => Debug_Mode,
        --nios_control => nios_control,
        Opcode => Opcode,
        Addressing_Mode => Addressing_Mode,
        Rz => Rz,
        Rx => Rx,
        Operand => Operand,
        --ir_reset => ir_reset,
        reset_pc => reset_pc,
        z => z,
        --init_up => init_up,
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

    -- Clock generator (with period of 10 ns)
    clk_gen : process
    begin
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0';
        wait for 5 ns;
    end process clk_gen;

    -- instruction format
    -- |AM(2)|OP(6)|Rz(3)|Ry(3)|OTHERs(16)|

    stim_proc : process -- Test cases
    begin
        -- AND Test operation
        Reset <= '0';
        Opcode <= "001000";
        Addressing_Mode <= "01";
        Rz <= "0010";
        Rx <= "0011";
        Operand <= "1111111111111111";
        reset_pc <= '0';
        z <= '0';
        wait for 20 ns;

         -- AND Test operation
         Reset <= '0';
         Opcode <= "011000";
         Addressing_Mode <= "11";
         Rz <= "0000";
         Rx <= "0000";
         Operand <= "0000000100000000";
         reset_pc <= '0';
         z <= '0';
         wait for 20 ns;

        -- End simulation
        wait;
    end process;
end Behavioral;
