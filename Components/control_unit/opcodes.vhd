
library ieee;
use ieee.std_logic_1164.all;

package opcodes is

-- instruction format
-- --------------------------------------------------
-- |AM(2)|OP(6)|Rz(3)|Ry(3)|OTHERs(16)|
-- --------------------------------------------------


-- addressing modes (AM)
	constant implicit: std_logic_vector(1 downto 0) := "00"; --inherent
	constant stack: std_logic_vector(1 downto 0) := "01"; --immediate 
	constant direct: std_logic_vector(1 downto 0) := "10";
	constant indirect: std_logic_vector(1 downto 0) := "11";


-- operations with immediate, direct and indirect AM
	-- immediate: LDR Rz #value
	-- direct: LDR Rz $address
	-- indirect: LDR Rz Ry

	constant ldr	: std_logic_vector(5 downto 0) := "000000";
	constant str	: std_logic_vector(5 downto 0) := "000010";
	constant andd	: std_logic_vector(5 downto 0) := "001000";
	constant  orr	: std_logic_vector(5 downto 0) := "011000";
	constant add	: std_logic_vector(5 downto 0) := "111000";
	constant subv	: std_logic_vector(5 downto 0) := "000011";
	constant sub	: std_logic_vector(5 downto 0) := "000100";
	constant jmp	: std_logic_vector(5 downto 0) := "011000";
	constant present	: std_logic_vector(5 downto 0) := "011100";
	constant datacall	: std_logic_vector(5 downto 0) := "101000";

	constant sz		: std_logic_vector(5 downto 0) := "010100";
	constant clfz	: std_logic_vector(5 downto 0) := "010000";

	constant lsip	: std_logic_vector(5 downto 0) := "110111";
	constant ssop	: std_logic_vector(5 downto 0) := "111010";
      constant noop	: std_logic_vector(5 downto 0) := "110100";
	constant max	: std_logic_vector(5 downto 0) := "011110";
	constant strpc	: std_logic_vector(5 downto 0) := "011101";
	
end opcodes;