
library ieee;
use ieee.std_logic_1164.all;
use work.mux_p;

entity MUXGEN_16 is
  generic(
    NUM : natural);  -- Number of inputs
  port(
    v_i   : in  mux_p.slv_array_t(0 to NUM - 1);
    sel_i : in  natural range 0 to NUM - 1;
    z_o   : out std_logic_vector(15 downto 0));
end MUXGEN_16;

architecture behaviour of MUXGEN_16 is
begin
  z_o <= v_i(sel_i);
end architecture;