library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
use work.port_locations.all;


entity asp_peak is
	port (
		clock : in  std_logic;
		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture rtl of asp_peak is
	signal s_peak   : std_logic_vector(15 downto 0)   := (others => '0');
	signal s_previous : std_logic_vector(15 downto 0) := (others => '0');
	signal inverted    :  std_logic_vector(15 downto 0) := (others => '0');
	signal addr_0   : std_logic_vector(3 downto 0) := "0001";         -- will be addr of dac aasp
	signal addr_1   : std_logic_vector(3 downto 0) := "0001";          -- will be addr of moving average asp  "0011"
	signal func_0   : std_logic_vector(1 downto 0) := "00";
	signal enable_0   : std_logic := '0';
	signal enable_1   : std_logic := '0';
	signal un_used_val : std_logic_vector(15 downto 0) := "1111110000001111";
	signal destination : std_logic_vector(3 downto 0) := "0001";

	signal y_prev: signed(15 downto 0) := (others => '0');
    	signal x_cur: signed(15 downto 0);
    	signal y_cur: signed(15 downto 0);
	signal a: signed(7 downto 0);
    	signal b: signed(7 downto 0);


begin

	

	process(clock)
		variable ax : signed(23 downto 0);
		variable by : signed(23 downto 0);
		variable calc  : signed(23 downto 0);
	begin
		if rising_edge(clock) then

			if recv.data(31 downto 28) = "1001" then                            --configure asp  
				-- mode is divided in two for ease (bit 19 to 18) is operation and 17 to 16 is where to pass that operation
				-- currently it passes to dac channel 0 or 1 for testing but than can changed to passing to moving average asp or fir asp or recop
				-- it will read destination and make it its addr_0 or addr_1

				-- forwarding location
				if recv.data(16) = '0' then
					addr_0   <= recv.data(23 downto 20);
					enable_0 <= recv.data(17);
				else
					addr_1   <= recv.data(23 downto 20);
					enable_1 <= recv.data(17);
				end if;
                                        
				destination<=recv.data(27 downto 24);
				func_0   <= recv.data(19 downto 18);
				un_used_val<= recv.data(15 downto 0);
				
				send.addr <= RECOP_PORT;
				send.data <= x"000000" & PEAK_PORT;

	

			elsif recv.data(31 downto 28) = DATA_HEADER and recv.data(16) = '0' and enable_0 = '1' then
				x_cur <= signed(recv.data(15 downto 0));
				a <= signed(un_used_val(15 downto 8));
				b<= signed(un_used_val(7 downto 0));

				case func_0 is
					when "00" =>
						send.addr <=  "0000" & destination ;
						send.data <= x"8000" & std_logic_vector(x_cur);


					when "10" =>    --peak detection
						if unsigned(s_previous) > unsigned(s_peak) and unsigned(s_previous) > unsigned(x_cur) then
							s_peak <= s_previous;
						end if;

						s_previous <= std_logic_vector(x_cur);
						send.addr <=  "0000" & addr_0;
						send.data <= x"8000" & s_peak;

					
					when "11" =>   --inversion
						if unsigned(x_cur) > unsigned(s_peak) then
							s_peak <= std_logic_vector(x_cur);
						end if;

						inverted <= std_logic_vector(unsigned(s_peak) - unsigned(x_cur));
						send.addr <=  "0000" & addr_0;
						send.data <= x"8000" & inverted;

					when "01" =>  --iir
						ax := shift_right(a * x_cur, 8);
						by := shift_right(b * y_prev, 8);

						calc := ax + by;

						y_cur <= to_signed(to_integer(calc), y_cur'length);
						y_prev <= y_cur;

						send.addr <=  "0000" & addr_0;
						send.data <= x"8000" & std_logic_vector(y_cur);

					when others =>
						send.addr <= x"01";
						send.data <= x"00000000";
				end case;
		
            elsif recv.data(31 downto 28) = DATA_HEADER and recv.data(16) = '1' and enable_1 = '1' then
					  
				x_cur <= signed(recv.data(15 downto 0));
				a <= signed(un_used_val(15 downto 8));
				b<= signed(un_used_val(7 downto 0));
			
				case func_0 is
					when "00" =>       --direct pass
						send.addr <=  "0000" & destination;
						send.data <= x"8000" & std_logic_vector(x_cur);

					-- Enable DAC channel 1
					when "10" =>         --peak detect of signal
						if unsigned(s_previous) > unsigned(s_peak) and unsigned(s_previous) > unsigned(x_cur) then
							s_peak <= s_previous;
						end if;
						s_previous <= std_logic_vector(x_cur);

						send.addr <=  "0000" & addr_1;
						send.data <= x"8000" & s_peak;

					-- Enable ADC channel 0
					when "11" =>             --inversion of siganl 
						if unsigned(x_cur) > unsigned(s_peak) then
							s_peak <= std_logic_vector(x_cur);
						end if;
						inverted <= std_logic_vector(unsigned(s_peak) - unsigned(x_cur));

						send.addr <=  "0000" & addr_1;
						send.data <= x"8000" & inverted;

				    when "01" =>                   --iir 
						ax := shift_right(a * x_cur, 8);
						by := shift_right(b * y_prev, 8);

						calc := ax + by;

						y_cur <= to_signed(to_integer(calc), y_cur'length);

						send.addr <=  "0000" & addr_1;
						send.data <= x"8000" & std_logic_vector(y_cur);

				    when others =>
						send.addr <= x"01";
						send.data <= x"00000000";
				end case;
			else
				send.addr <= (others => '0');
				send.data <= (others => '0');
			end if;

		end if;
	end process;


end architecture;
