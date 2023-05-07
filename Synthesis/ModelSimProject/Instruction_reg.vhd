library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_reg is
    Port (
        CLK           : in  STD_LOGIC;
        ir_write      : in  STD_LOGIC;
        ir_reset      : in  STD_LOGIC;
        ir_out        : in  STD_LOGIC_VECTOR (31 downto 0);            --m_out
 	    AM            : out STD_LOGIC_VECTOR (1 downto 0);                 --ir_31_to_30  
        Opcode        : out STD_LOGIC_VECTOR (5 downto 0);                 --ir_29_to_24   
        Rz_Field      : out STD_LOGIC_VECTOR (3 downto 0);     --ir_23_to_20 
        Rx_Field      : out STD_LOGIC_VECTOR (3 downto 0);      --ir_19_to_16
        Operand       : out STD_LOGIC_VECTOR (15 downto 0)                --ir_15_to_0 
    );
end Instruction_reg;

architecture Behavioral of Instruction_reg is
    component REG1_32 is
        port (
            signal reg_in : in std_logic_vector(31 downto 0);
            signal writ : in std_logic;
            signal reset : in std_logic;
            signal clk : in std_logic;
    
            signal reg_out : out std_logic_vector(31 downto 0)
    
        );
    
    end component;

    signal Instruction_Register : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    IR : REG1_32 port map(
        reg_in => ir_out,
        writ => ir_write,
        reset => ir_reset,
        clk => clk,
        reg_out => Instruction_Register

    );
    
    AM <= Instruction_Register(31 downto 30); -- Connect to instruction decoder
    Opcode <= Instruction_Register(29 downto 24); -- Connect to instruction decoder
    Rz_Field  <= Instruction_Register(23 downto 20); -- Connect to sel_z input multiplexer
    Rx_Field  <= Instruction_Register(19 downto 16); -- Connect to sel_x input multiplexer
    Operand   <= Instruction_Register(15 downto 0); -- Connect to sel_x input multiplexer
end Behavioral;