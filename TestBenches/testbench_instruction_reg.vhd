library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_reg_tb is
end Instruction_reg_tb;

architecture SIM of Instruction_reg_tb is
    signal CLK_tb           : STD_LOGIC := '0';
    signal ir_write_tb      : STD_LOGIC := '0';
    signal ir_reset_tb      : STD_LOGIC := '0';
    signal ir_out_tb        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal AM_tb            : STD_LOGIC_VECTOR (1 downto 0);
    signal Opcode_tb        : STD_LOGIC_VECTOR (5 downto 0);
    signal Rz_Field_tb      : STD_LOGIC_VECTOR (3 downto 0);
    signal Rx_Field_tb      : STD_LOGIC_VECTOR (3 downto 0);
    signal Operand_tb       : STD_LOGIC_VECTOR (15 downto 0);

    component Instruction_reg
        Port (
            CLK           : in  STD_LOGIC;
            ir_write      : in  STD_LOGIC;
            ir_reset      : in  STD_LOGIC;
            ir_out        : in  STD_LOGIC_VECTOR (31 downto 0);
            AM            : out STD_LOGIC_VECTOR (1 downto 0);
            Opcode        : out STD_LOGIC_VECTOR (5 downto 0);
            Rz_Field      : out STD_LOGIC_VECTOR (3 downto 0);
            Rx_Field      : out STD_LOGIC_VECTOR (3 downto 0);
            Operand       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

begin
    DUT : Instruction_reg port map(
        CLK => CLK_tb,
        ir_write => ir_write_tb,
        ir_reset => ir_reset_tb,
        ir_out => ir_out_tb,
        AM => AM_tb,
        Opcode => Opcode_tb,
        Rz_Field => Rz_Field_tb,
        Rx_Field => Rx_Field_tb,
        Operand => Operand_tb
    );

    CLK_process : process
    begin
        CLK_tb <= '0';
        wait for 10 ns;
        CLK_tb <= '1';
        wait for 10 ns;
    end process;

    Stimulus_process : process
    begin
        -- Reset the instruction register
        ir_reset_tb <= '1';
        wait for 20 ns;
        ir_reset_tb <= '0';

        -- Test case 1: Writing to the instruction register
        ir_out_tb <= "10111011001001001001010101011011";
        ir_write_tb <= '1';
        wait for 20 ns;
        ir_write_tb <= '0';
        wait for 20 ns;

        -- Test case 2: Writing another value to the instruction register
        ir_out_tb <= "01010101100110011001100110011001";
        ir_write_tb <= '1';
        wait for 20 ns;
        ir_write_tb <= '0';
        wait for 20 ns;

        -- Test case 3: Reset the instruction register
        ir_reset_tb <= '1';
        wait for 20 ns;
        ir_reset_tb <= '0';
        wait;

    end process;

end SIM;
