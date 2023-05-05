library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity MAX is
    Port (
        rx : in std_logic_vector(15 downto 0);
        rz : in std_logic_vector(15 downto 0);
        max_out : out std_logic_vector(15 downto 0)
    );
end MAX;

architecture Behavioral of MAX is
	-- Signals
	signal rx32 : std_logic_vector(3 downto 0);
	signal rx10 : std_logic_vector(3 downto 0);
	signal rx3210 : std_logic_vector(3 downto 0);
	signal final : std_logic_vector(3 downto 0);

begin

	rx32 <= rx(15 downto 12) when rx(15 downto 12) > rx(11 downto 8) else 
            rx(11 downto 8);
    
    rx10 <= rx(7 downto 4) when rx(7 downto 4) > rx(3 downto 0) else 
            rx(3 downto 0);
            
    rx3210 <= rx32 when rx32 > rx10 else
              rx10;

    final <= rx3210 when rx3210 > rz(3 downto 0) else
             rz(3 downto 0);

    max_out <= x"000" & final;
	
end Behavioral;