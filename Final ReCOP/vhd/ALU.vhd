library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
  Port ( alu_op    : in  std_logic_vector(1  downto 0);
         data_a_mux: in  std_logic_vector(1  downto 0);
		 data_b_mux: in  std_logic;
		 rx        : in  std_logic_vector(15 downto 0);
         rz        : in  std_logic_vector(15 downto 0);
         ir_hold   : in  std_logic_vector(15 downto 0);
         flmr      : in  std_logic_vector(15 downto 0);
         carry_in  : in  std_logic;
         zout      : out std_logic;
         aluout    : out std_logic_vector(15 downto 0));
end ALU;

architecture Behavioral of ALU is
  -- Components
  component MUX2_16 is
    Port ( sel   : in  std_logic;
           a, b  : in  std_logic_vector(15 downto 0);
           outp  : out std_logic_vector(15 downto 0));
  end component;
  
  component MUX4_16 is
    Port ( sel   : in  std_logic_vector(1 downto 0);
           a, b, c, d : in  std_logic_vector(15 downto 0);
           outp  : out std_logic_vector(15 downto 0));
  end component;
  
  component ALU_COMPONENT is
    Port ( a, b         : in  std_logic_vector(15 downto 0);
           op           : in  std_logic_vector(1 downto 0);
           carry_in     : in  std_logic;
           zout			: out std_logic;
		   aluout 		: out std_logic_vector(15 downto 0));
  end component;

  -- Signals
  signal data_a_mux_out : std_logic_vector(15 downto 0);
  signal data_b_mux_out : std_logic_vector(15 downto 0);

begin

  -- Multiplexers
  MUX4_16_1 : MUX4_16 port map(
    sel => data_a_mux,
    a   => rx,
    b   => ir_hold,
    c   => X"0001",
    d   => flmr,
    outp => data_a_mux_out
  );
  
  MUX2_16_1 : MUX2_16 port map(
    sel  => data_b_mux,
    a    => rx,
    b    => rz,
    outp => data_b_mux_out
  );
  
  -- ALU operation
  ALU_COMPONENT_1 : ALU_COMPONENT port map(
    a        => data_a_mux_out,
    b        => data_b_mux_out,
    op       => alu_op,
    carry_in => carry_in,
    zout     => zout,
    aluout   => aluout
  );

end Behavioral;
