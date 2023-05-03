library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_reg is
    Port (
        CLK           : in  STD_LOGIC;
        Reset         : in  STD_LOGIC;
        load_ir1      : in  STD_LOGIC;                                 --load_msb
        Load_ir2      : in  STD_LOGIC;                                --load_lsb
        PM_output     : in  STD_LOGIC_VECTOR (15 downto 0);            --m_out
 	AM            : out STD_LOGIC_VECTOR (1 downto 0);                 --ir_31_to_30  
        Opcode        : out STD_LOGIC_VECTOR (5 downto 0);                 --ir_29_to_24   
        Rz_Field      : out STD_LOGIC_VECTOR (3 downto 0);     --ir_23_to_20 
        Rx_Field      : out STD_LOGIC_VECTOR (3 downto 0);      --ir_19_to_16
        Operand       : out STD_LOGIC_VECTOR (15 downto 0)                --ir_15_to_0 
    );
end Instruction_reg;

architecture Behavioral of Instruction_reg is
    signal Instruction_Register : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    process (CLK, Reset)
    begin
        if Reset = '1' then
            Instruction_Register <= (others => '0');
        elsif rising_edge(CLK) then
            if Load_ir1 = '1' then
                 Instruction_Register(31 downto 30) <= PM_output(15 downto 14);
                 Instruction_Register(29 downto 24) <= PM_output(13 downto 8);  
		 Instruction_Register(23 downto 20) <= PM_output(7 downto 4);  
		 Instruction_Register(19 downto 16) <= PM_output(3 downto 0);    
            elsif Load_ir2= '1' then  
                 Instruction_Register(15 downto 0) <= PM_output(15 downto 0);  
            end if;
        end if;
    end process;
    
    AM<= Instruction_Register(31 downto 30); -- Connect to instruction decoder
    Opcode<= Instruction_Register(29 downto 24); -- Connect to instruction decoder
    Rz_Field  <= Instruction_Register(23 downto 20); -- Connect to sel_z input multiplexer
    Rx_Field  <= Instruction_Register(19 downto 16); -- Connect to sel_x input multiplexer
    Operand   <= Instruction_Register(15 downto 0); -- Connect to sel_x input multiplexer
end Behavioral;