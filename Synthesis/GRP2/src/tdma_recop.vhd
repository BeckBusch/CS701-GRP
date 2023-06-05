library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
use work.port_locations.all;

entity tdma_recop is
    port (
        addr : in tdma_min_addr;
        dprr_write : out std_logic;
		  
    );
end entity;

architecture behaviour of tdma_recop is
begin
    dprr_write <= '1' when addr = RECOP_PORT else '0';
	 
	 
end behaviour;