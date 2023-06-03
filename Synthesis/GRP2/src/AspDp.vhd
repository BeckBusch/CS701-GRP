library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity AspDp is
	port (
		clock : in  std_logic;

		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture rtl of AspDp is

	-- signal addr_0   : std_logic_vector(3 downto 0) := "0001";
	-- signal mode_0   : std_logic_vector(3 downto 0) := "0000";

begin

	-- process(clock)
	-- begin
	-- 	if rising_edge(clock) then

	-- 		-- checks what type of data it is then does stuff from
	-- 		if recv.data(31 downto 28) = "1001" then
	-- 			addr_0   <= recv.data(23 downto 20);
	-- 			mode_0   <= recv.data(19 downto 16);
	-- 		end if;

	-- 	end if;
	-- end process;

	process(clock)
		variable temp    : std_logic_vector(15 downto 0) := x"0000";
	begin
		if rising_edge(clock) then
			send.addr <= x"01";

			-- check if data
			if recv.data(31 downto 28) = "1000" then
				temp :=  recv.data(15) & recv.data(13 downto 0) & "0";

				-- positive number
				if recv.data(15) = '0' then
					-- test if larger than 4096
					if signed(temp) > 4096 then
						send.data <= x"800" & "000" & recv.data(16) & "0001000000000000";
					else
						send.data <= x"800" & "000" & recv.data(16) & temp;
					end if;

				-- negative number
				else
					-- test if smaller than -4096
					if signed(temp) < -4096 then
						send.data <= x"800" & "000" & recv.data(16) & "1111000000000000";
					else
						send.data <= x"800" & "000" & recv.data(16) & temp;
					end if;
				end if;
			end if;
		end if;
	end process;

end architecture;
