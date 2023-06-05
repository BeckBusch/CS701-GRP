library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
use work.port_locations.all;

entity tdma_addr_circuit is
    port (
        dpcr : in std_logic_vector(31 downto 0);
        addr : out tdma_min_addr
    );
end entity;

architecture behaviour of tdma_addr_circuit is
    signal header : std_logic_vector(3 downto 0);
begin
    header <= dpcr(31 downto 28);

    addr <= ADC_PORT when header = ADC_HEADER else
            DAC_PORT when header = DAC_HEADER else
            FIR_PORT when header = FIR_HEADER else
            PEAK_PORT when header = PEAK_HEADER else
            AVG_PORT when header = AVG_HEADER else
            "0000" & dpcr(27 downto 24) when header = DATA_HEADER else
            "00000000";
end behaviour;