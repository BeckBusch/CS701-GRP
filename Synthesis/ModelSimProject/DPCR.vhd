LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DPCR IS
    PORT(
        rx : IN STD_LOGIC_VECTOR(15 downto 0);
        rz : IN STD_LOGIC_VECTOR(15 downto 0);
        ir_hold : IN STD_LOGIC_VECTOR(15 downto 0);
        dpcr_sel : in std_logic;
        writ : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        reg_out : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
END DPCR;

architecture behaviour of DPCR is

    COMPONENT reg1_32
	PORT(writ : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reg_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 reg_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
    END COMPONENT;

    component MUX2_16 is
        Port ( sel   : in  std_logic;
               a, b  : in  std_logic_vector(15 downto 0);
               outp  : out std_logic_vector(15 downto 0));
    end component;

    signal mux_out : std_logic_vector(15 downto 0);
    signal concat : std_logic_vector(31 downto 0);

    begin
        DPCR_REG : REG1_32 port map(
            reg_in => concat,
            writ => writ,
            reset => reset,
            clk => clk,
            reg_out => reg_out
    
        );

        MUX : MUX2_16 port map (
            sel => dpcr_sel,
            a => rz,
            b => ir_hold,
            outp => mux_out
        );

        concat <= rx & mux_out;

end behaviour;