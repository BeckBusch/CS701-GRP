library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Test is
end ALU_Test;

architecture Behavioral of ALU_Test is

  -- Component declaration
  component ALU is
    Port ( alu_op    : in  std_logic_vector(1 downto 0);
           data_a_mux: in  std_logic_vector(1 downto 0);
           data_b_mux: in  std_logic;
           rx        : in  std_logic_vector(15 downto 0);
           rz        : in  std_logic_vector(15 downto 0);
           ir_hold   : in  std_logic_vector(15 downto 0);
           flmr      : in  std_logic_vector(15 downto 0);
           carry_in  : in  std_logic;
           zout      : out std_logic;
           aluout    : out std_logic_vector(15 downto 0));
  end component;

  -- Input signals
  signal alu_op    : std_logic_vector(1 downto 0);
  signal data_a_mux: std_logic_vector(1 downto 0);
  signal data_b_mux: std_logic;
  signal rx        : std_logic_vector(15 downto 0);
  signal rz        : std_logic_vector(15 downto 0);
  signal ir_hold   : std_logic_vector(15 downto 0);
  signal flmr      : std_logic_vector(15 downto 0);
  signal carry_in  : std_logic;

  -- Output signals
  signal zout      : std_logic;
  signal aluout    : std_logic_vector(15 downto 0);

begin

  -- Instantiate the ALU
  DUT : ALU port map(
    alu_op     => alu_op,
    data_a_mux => data_a_mux,
    data_b_mux => data_b_mux,
    rx         => rx,
    rz         => rz,
    ir_hold    => ir_hold,
    flmr       => flmr,
    carry_in   => carry_in,
    zout       => zout,
    aluout     => aluout
  );
  
  -- Stimulus Process
  stim_proc: process
  begin
	  
	  -- Test cases

	  -- Addition operation
	  alu_op <= "00";
	  data_a_mux <= "00";
	  data_b_mux <= '1';
	  rx <= "0100000000000000";
	  rz <= "0111111111111111";
	  ir_hold <= "0000000000000000";
	  flmr <= "0000000000000000";
	  carry_in <= '0';
	  wait for 10 ns;
	  assert aluout = "1011111111111111" and zout = '0'
		report "Addition operation failed" severity error;
	 
	  -- Addition operation with carry in
	  alu_op <= "00";
	  data_a_mux <= "00";
	  data_b_mux <= '1';
	  rx <= "0000000000000001";
	  rz <= "0000000000000001";
	  ir_hold <= "0000000000000000";
	  flmr <= "0000000000000000";
	  carry_in <= '1';
	  wait for 10 ns;
	  assert aluout = "0000000000000011" and zout = '0'
		report "Addition operation failed" severity error;
		
	  -- Subtraction operation
	  alu_op <= "01";
	  data_a_mux <= "00";
	  data_b_mux <= '1';
	  rx <= "1111111111111111";
	  rz <= "1010101010101010";
	  ir_hold <= "0000000000000000";
	  flmr <= "0000000000000000";
	  carry_in <= '0';
	  wait for 10 ns;
	  assert aluout = "0101010101010101" and zout = '0'
		report "Subtraction operation failed" severity error;
		
	  -- Zout from subtraction
	  alu_op <= "01";
	  data_a_mux <= "00";
	  data_b_mux <= '1';
	  rx <= "1111111111111111";
	  rz <= "1111111111111111";
	  ir_hold <= "0000000000000000";
	  flmr <= "0000000000000000";
	  carry_in <= '0';
	  wait for 10 ns;
	  assert aluout = "0000000000000000" and zout = '1'
		report "Zout from subtraction failed" severity error;

	  -- OR operation
	  alu_op <= "10";
	  data_a_mux <= "00";
	  data_b_mux <= '1';
	  rx <= "1010101010101010";
	  rz <= "1111111111111111";
	  ir_hold <= "0000000000000000";
	  flmr <= "0000000000000000";
	  carry_in <= '0';
	  wait for 10 ns;
	  assert aluout = "1111111111111111" and zout = '0'
		report "OR operation failed" severity error;
		
	  -- AND operation
	  alu_op <= "11";
	  data_a_mux <= "00";
	  data_b_mux <= '1';
	  rx <= "1010101010101010";
	  rz <= "1111111111111111";
	  ir_hold <= "0000000000000000";
	  flmr <= "0000000000000000";
	  carry_in <= '0';
	  wait for 10 ns;
	  assert aluout = "1010101010101010" and zout = '0'
		report "AND operation failed" severity error;
		
	  -- End simulation
	  wait;
	end process;
end Behavioral;