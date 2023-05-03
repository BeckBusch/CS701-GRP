library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RF_Block is
    Port (
        CLK          : in  STD_LOGIC;
        Reset        : in  STD_LOGIC;
        Sel_x        : in  STD_LOGIC_VECTOR (3 downto 0);
        Sel_z        : in  STD_LOGIC_VECTOR (3 downto 0);
        Sel_Data_In  : in  STD_LOGIC_VECTOR (2 downto 0);
        Operand_IR   : in  STD_LOGIC_VECTOR (15 downto 0);
        Memory_Out   : in  STD_LOGIC_VECTOR (15 downto 0);
        Rx_Out       : in  STD_LOGIC_VECTOR (15 downto 0);
        ALU_Out      : in  STD_LOGIC_VECTOR (15 downto 0);
        MAX_Out      : in  STD_LOGIC_VECTOR (15 downto 0);
        SIP_Out      : in  STD_LOGIC_VECTOR (15 downto 0);
        ER_Val       : in  STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_Rx  : out STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_Rz  : out STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_ccd : out STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_pcd : out STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_flmr: out STD_LOGIC_VECTOR (15 downto 0)
    );
end RF_Block;

architecture Behavioral of RF_Block is
    type Register_Array is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
    signal Register_File : Register_Array := (others => (others => '0'));
    signal Data_In       : STD_LOGIC_VECTOR (15 downto 0);

begin
    -- z-input multiplexer
    process (Sel_Data_In, Operand_IR, Memory_Out, Rx_Out, ALU_Out, MAX_Out, SIP_Out, ER_Val)
    begin
        case Sel_Data_In is
            when "000" => Data_In <= Operand_IR;
            when "001" => Data_In <= Memory_Out;
            when "010" => Data_In <= Rx_Out;
            when "011" => Data_In <= ALU_Out;
            when "100" => Data_In <= MAX_Out;
            when "101" => Data_In <= SIP_Out;
            when "110" => Data_In <= ER_Val;
            when others => Data_In <= (others => '0');
        end case;
    end process;

    -- Register file read/write process
    process (CLK, Reset)
    begin
        if Reset = '1' then
            Register_File <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            Register_File(to_integer(unsigned(Sel_z))) <= Data_In;
        end if;
    end process;

    -- Register file outputs
    Data_Out_Rx   <= Register_File(to_integer(unsigned(Sel_x)));
    Data_Out_Rz   <= Register_File(to_integer(unsigned(Sel_z)));
    Data_Out_ccd  <= Register_File(7);
    Data_Out_pcd  <= Register_File

end Behavioral;