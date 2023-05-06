library ieee;
use ieee.std_logic_1164.all;
package mux_values is

-- program counter input selection pc_mux_sel
	constant pc_ir: std_logic_vector(1 downto 0) := "00";
	constant pc_dm: std_logic_vector(1 downto 0) := "01";
	constant pc_const: std_logic_vector(1 downto 0) := "10";
	constant pc_rx: std_logic_vector(1 downto 0) := "11";
	
-- register file input selection rf_mux_sel
	constant rf_ir: std_logic_vector(2 downto 0) := "000";
	constant rf_dm: std_logic_vector(2 downto 0) := "001";
	constant rf_rx: std_logic_vector(2 downto 0) := "010";
	constant rf_alu: std_logic_vector(2 downto 0) := "011";
	constant rf_rzmax: std_logic_vector(2 downto 0) := "100";
	constant rf_sip: std_logic_vector(2 downto 0) := "101";
	constant rf_er: std_logic_vector(2 downto 0) := "110";
	constant rf_mem_hep: std_logic_vector(2 downto 0) := "111";
	
-- data memory address input select  m_address_mux_sel
	constant m_address_ir: std_logic_vector(1 downto 0) := "00";
	constant m_address_rx: std_logic_vector(1 downto 0) := "01";
	constant m_address_rz: std_logic_vector(1 downto 0) := "10";
	constant m_address_pc: std_logic_vector(1 downto 0) := "11";

-- data memory input selection mem_data_mux_sel
	constant mem_data_ir: std_logic_vector(1 downto 0) := "00";
	constant mem_data_dprr: std_logic_vector(1 downto 0) := "01";
	constant mem_data_rx: std_logic_vector(1 downto 0) := "10";
	
-- ALU a input selection alu_mux_a
	constant alu_rx_a: std_logic_vector(1 downto 0) := "00";
	constant alu_ir: std_logic_vector(1 downto 0) := "01";
	constant alu_const: std_logic_vector(1 downto 0) := "10";
	constant alu_fifo: std_logic_vector(1 downto 0) := "11";
	
-- ALU b input selection alu_mux_b
	constant alu_rx_b: std_logic := '0';
	constant alu_rz: std_logic := '1';

-- internal or external program memory selection mem_sel
	constant mem_pm: std_logic := '1';
	constant mem_dm: std_logic:= '0';
	

	
-- ALU operation selection alu_op
	constant alu_add: std_logic_vector(1 downto 0) := "00";
	constant alu_sub: std_logic_vector(1 downto 0) := "01";
	constant alu_andd: std_logic_vector(1 downto 0)  := "10";
	constant alu_orr: std_logic_vector(1 downto 0) := "11";
	
end mux_values;	
