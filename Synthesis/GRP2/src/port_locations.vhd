library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

package port_locations is

    constant ADC_PORT    : std_logic_vector(7 downto 0) := "00000000";
    constant DAC_PORT    : std_logic_vector(7 downto 0) := "00000001";
    constant NIOS_PORT   : std_logic_vector(7 downto 0) := "00000010";
    constant DP_PORT     : std_logic_vector(7 downto 0) := "00000011";
    constant FIR_PORT    : std_logic_vector(7 downto 0) := "00000100";
    constant PEAK_PORT   : std_logic_vector(7 downto 0) := "00000101";
    constant AVG_PORT    : std_logic_vector(7 downto 0) := "00000110";
    constant RECOP_PORT  : std_logic_vector(7 downto 0) := "00000111";
    
    constant DATA_HEADER : std_logic_vector(3 downto 0) := "1000";
    constant ADC_HEADER  : std_logic_vector(3 downto 0) := "1010";
    constant DAC_HEADER  : std_logic_vector(3 downto 0) := "1011";
--  constant DP_HEADER   : std_logic_vector(3 downto 0) := "1010";
    constant FIR_HEADER  : std_logic_vector(3 downto 0) := "1111";
    constant PEAK_HEADER : std_logic_vector(3 downto 0) := "1001";
    constant AVG_HEADER  : std_logic_vector(3 downto 0) := "1110";

end port_locations;