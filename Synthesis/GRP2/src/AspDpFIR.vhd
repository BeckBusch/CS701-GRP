
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
use work.port_locations.all;




entity AspDpFIR is
	port (
		clock : in  std_logic;

		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture behaviour of AspDpFIR is

	signal addr_0   : std_logic_vector(3 downto 0) := "0001";
	signal addr_1   : std_logic_vector(3 downto 0) := "0001";
	signal other_0  : std_logic_vector(1 downto 0) := "00";
	signal other_1  : std_logic_vector(1 downto 0) := "00";
	signal enable_0 : std_logic := '1';
	signal enable_1 : std_logic := '1';


	type slv_array_t is array (natural range <>) of std_logic_vector(15 downto 0);
    signal ch0_reg : slv_array_t(0 to 3);
    signal ch1_reg : slv_array_t(0 to 3);
    signal fir_val : std_logic_vector(15 downto 0) := "1100000000000100";

begin
	process(clock)
		variable sum : signed(20 downto 0);
	begin
		if rising_edge(clock) then
			-- checks what type of data it is then does stuff from
			if recv.data(31 downto 28) = FIR_HEADER then
				-- forwarding location
				if recv.data(16) = '0' then
					addr_0   <= recv.data(23 downto 20);
					other_0  <= recv.data(19 downto 18);
					enable_0 <= recv.data(17);
				else
					addr_1   <= recv.data(23 downto 20);
					other_1  <= recv.data(19 downto 18);
					enable_1 <= recv.data(17);
				end if;

                if recv.data(19) = '1' then
                    fir_val <= recv.data(15 downto 0);
                end if;

                send.addr <= "0000" & recv.data(27 downto 24);
                send.data <= x"DEADBEEF";

			-- check if data
			elsif recv.data(31 downto 28) = DATA_HEADER then

				-- ch 0
				if recv.data(16) = '0' then
                    -- cascade
                    for i in 3 downto 1 loop
                        ch0_reg(i) <= ch0_reg(i-1);
                    end loop; 

                    ch0_reg(0) <= recv.data(15 downto 0);

                    if enable_0 = '1' then
                        -- sum
                        sum := (others => '0');
                        for i in 0 to 3 loop
                            sum := sum + signed(ch0_reg(i)) * signed(fir_val(4*(1+i)-1 downto 4 * i ));
                        end loop;
                        
                        -- fir vals are fixed point
                        sum := shift_right(sum, 2);
                        
					    send.addr <= "0000" & addr_0;
					    send.data <= x"8000" & std_logic_vector(sum(15 downto 0));
                    else
                        send.addr <= (others => '0');
                        send.data <= (others => '0');
                    end if;

				-- ch 1
				elsif recv.data(16) = '1' then
                    -- cascade
                    for i in 3 downto 1 loop
                        ch1_reg(i) <= ch1_reg(i-1);
                    end loop; 

                    ch1_reg(0) <= recv.data(15 downto 0);

                    if enable_1 = '1' then

                        -- sum
                        sum := (others => '0');
                        for i in 0 to 3 loop
                            sum := sum + signed(ch1_reg(i)) * signed(fir_val(4*(1+i)-1 downto 4 * i ));
                        end loop;
                        
                        -- fir vals are fixed point
                        sum := shift_right(sum, 2);

					    send.addr <= "0000" & addr_1;
					    send.data <= x"8001" & std_logic_vector(sum(15 downto 0));
                    else
                        send.addr <= (others => '0');
                        send.data <= (others => '0');
                    end if;

				-- muted channel
				else
					send.addr <= (others => '0');
					send.data <= (others => '0');
				end if;

				-- doesnt do anything if its not data or config
			end if;
		end if;
	end process;

end architecture;

