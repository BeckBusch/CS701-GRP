library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
use work.port_locations.all;


entity Average_ASP is
    port (
        clk : in std_logic;
        send : out tdma_min_port;
        recv : in tdma_min_port
    );
end entity;

architecture Behavioural of Average_ASP is

    type shift_array is array (0 to 31) of std_logic_vector (15 downto 0); -- 32 values of 16 bit numbers
    signal shift_data : shift_array;

begin
    process (clk)
        variable sum : integer := 0;
        variable state : natural := 8;
        variable addr_0 : std_logic_vector(3 downto 0) := "0000";

    begin
        if (rising_edge(clk)) then

            case recv.data(31 downto 28) is -- switch signal header
                when AVG_HEADER => -- asp config
                    case recv.data(19 downto 16) is -- switch mode
                        when "0000" =>
                            state := 8;
                        when "0001" =>
                            state := 4;
                        when "0010" =>
                            state := 16;
                        when "0011" =>
                            state := 32;
                        when others => -- noop
                    end case;

                    addr_0 := recv.data(23 downto 20); -- destination config
						  
						  send.addr <= RECOP_PORT;
						  send.data <= x"000000" & AVG_PORT;

                when DATA_HEADER  => -- audio processing
                    sum := 0;

                    case state is
                        when 8 => ------------------------------------------------ 8 values - default
                            for i in 7 downto 1 loop
                                shift_data(i) <= shift_data(i - 1);
                            end loop;
                            shift_data(0) <= recv.data(15 downto 0); -- load new value
                            for i in 7 downto 0 loop
                                sum := sum + to_integer(unsigned(shift_data(i)));
                            end loop;
                            sum := sum / 8;

                        when 4 => ------------------------------------------------ 4 values
                            for i in 3 downto 1 loop
                                shift_data(i) <= shift_data(i - 1);
                            end loop;
                            shift_data(0) <= recv.data(15 downto 0); -- load new value
                            for i in 3 downto 0 loop
                                sum := sum + to_integer(unsigned(shift_data(i)));
                            end loop;
                            sum := sum / 4;

                        when 16 => ------------------------------------------------ 16 values
                            for i in 15 downto 1 loop
                                shift_data(i) <= shift_data(i - 1);
                            end loop;
                            shift_data(0) <= recv.data(15 downto 0); -- load new value
                            for i in 15 downto 0 loop
                                sum := sum + to_integer(unsigned(shift_data(i)));
                            end loop;
                            sum := sum / 16;

                        when 32 => ------------------------------------------------ 32 values
                            for i in 31 downto 1 loop
                                shift_data(i) <= shift_data(i - 1);
                            end loop;
                            shift_data(0) <= recv.data(15 downto 0); -- load new value
                            for i in 31 downto 0 loop
                                sum := sum + to_integer(unsigned(shift_data(i)));
                            end loop;
                            sum := sum / 32;

                        when others => -- noop
                    end case;

                    send.data(15 downto 0) <= std_logic_vector(to_unsigned(sum, 16)); -- data
                    send.addr <= "0000" & addr_0; -- address

                when others => -- signal header noop
            end case; -- end signal switch

        end if;
    end process;
end architecture;
