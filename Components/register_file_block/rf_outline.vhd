library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RF_Block is
    Port (
        CLK         : in  STD_LOGIC;
        Reset       : in  STD_LOGIC;
        Sel_x       : in  STD_LOGIC_VECTOR (3 downto 0);
        Sel_z       : in  STD_LOGIC_VECTOR (3 downto 0);
        Data_In     : in  STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_Rx : out STD_LOGIC_VECTOR (15 downto 0);
        Data_Out_Rz : out STD_LOGIC_VECTOR (15 downto 0)
    );
end RF_Block;

architecture Behavioral of RF_Block is
    type Register_Array is array (0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
    signal Register_File : Register_Array := (others => (others => '0'));

begin
    process (CLK, Reset)
    begin
        if Reset = '1' then
            Register_File <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            Register_File(to_integer(unsigned(Sel_z))) <= Data_In;
        end if;
    end process;

    Data_Out_Rx <= Register_File(to_integer(unsigned(Sel_x)));
    Data_Out_Rz <= Register_File(to_integer(unsigned(Sel_z)));

end Behavioral;
