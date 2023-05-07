-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"
-- CREATED		"Sun May 07 20:16:58 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ReCOPQuartus IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ReCOPQuartus;

ARCHITECTURE bdf_type OF ReCOPQuartus IS 

COMPONENT de1_diagram
	PORT(clk_clk : IN STD_LOGIC;
		 reset_reset_n : IN STD_LOGIC;
		 sev_seg_pio_s1_address : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 switch_pio_external_connection_export : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 button_pio_irq_irq : OUT STD_LOGIC;
		 clk_1_clk_clk : OUT STD_LOGIC;
		 clk_1_clk_reset_reset_n : OUT STD_LOGIC;
		 led_pio_external_connection_export : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sev_seg_pio_external_connection_export : OUT STD_LOGIC_VECTOR(27 DOWNTO 0);
		 sev_seg_pio_s1_readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT control_unit
	PORT(CLK : IN STD_LOGIC;
		 Reset : IN STD_LOGIC;
		 z : IN STD_LOGIC;
		 Addressing_Mode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 Operand : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Rx : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Rz : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 we : OUT STD_LOGIC;
		 write_ir : OUT STD_LOGIC;
		 reset_ir : OUT STD_LOGIC;
		 write_pc : OUT STD_LOGIC;
		 reset_pc : OUT STD_LOGIC;
		 write_rf : OUT STD_LOGIC;
		 rf_mux_sel_x : OUT STD_LOGIC;
		 rf_mux_sel_z : OUT STD_LOGIC;
		 reset_rf : OUT STD_LOGIC;
		 mem_sel : OUT STD_LOGIC;
		 alu_mux_B : OUT STD_LOGIC;
		 carry : OUT STD_LOGIC;
		 clr_z : OUT STD_LOGIC;
		 write_sip : OUT STD_LOGIC;
		 reset_sip : OUT STD_LOGIC;
		 write_sop : OUT STD_LOGIC;
		 reset_sop : OUT STD_LOGIC;
		 write_dpcr : OUT STD_LOGIC;
		 reset_dpcr : OUT STD_LOGIC;
		 alu_mux_A : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 alu_op : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 m_address_mux_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mem_data_mux_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 pc_mux_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 rf_mux_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 rf_value_sel_x : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rf_value_sel_z : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT datapath
	PORT(sys_clk : IN STD_LOGIC;
		 rf_write : IN STD_LOGIC;
		 ir_write : IN STD_LOGIC;
		 alu_b_mux : IN STD_LOGIC;
		 rf_reset : IN STD_LOGIC;
		 ir_reset : IN STD_LOGIC;
		 rf_sel_x : IN STD_LOGIC;
		 rf_sel_z : IN STD_LOGIC;
		 carry_in : IN STD_LOGIC;
		 pc_write : IN STD_LOGIC;
		 pc_reset : IN STD_LOGIC;
		 clr_irq_in : IN STD_LOGIC;
		 dprr_write : IN STD_LOGIC;
		 mem_sel : IN STD_LOGIC;
		 clr_irq_write : IN STD_LOGIC;
		 dprr_reset : IN STD_LOGIC;
		 clr_irq_reset : IN STD_LOGIC;
		 dpc_in : IN STD_LOGIC;
		 dpcr_write : IN STD_LOGIC;
		 dpc_write : IN STD_LOGIC;
		 dpcr_reset : IN STD_LOGIC;
		 dpc_reset : IN STD_LOGIC;
		 z_write : IN STD_LOGIC;
		 SOP_write : IN STD_LOGIC;
		 z_reset : IN STD_LOGIC;
		 SOP_reset : IN STD_LOGIC;
		 SIP_write : IN STD_LOGIC;
		 SIP_reset : IN STD_LOGIC;
		 alu_a_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dprr_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 head : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ir_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 m_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 mem_addr_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mem_data_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 pc_mux_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 rf_cu_x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rf_cu_z : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rf_z_input_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 SIP_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 clr_irq : OUT STD_LOGIC;
		 dpc : OUT STD_LOGIC;
		 z_out : OUT STD_LOGIC;
		 addr : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
		 am : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ccd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dpcr_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 opcode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		 operand : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pcd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rx_field : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rz_field : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 SOP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram_interface
	PORT(mem_clk : IN STD_LOGIC;
		 w : IN STD_LOGIC;
		 write_high : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ir_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 m_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	alu_a_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	alu_mux_b :  STD_LOGIC;
SIGNAL	alu_op :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	am :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	carry :  STD_LOGIC;
SIGNAL	cu_x :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	cu_z :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	dpcr_reset :  STD_LOGIC;
SIGNAL	dpcr_write :  STD_LOGIC;
SIGNAL	ir_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	ir_reset :  STD_LOGIC;
SIGNAL	ir_write :  STD_LOGIC;
SIGNAL	m_out :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	mem_addr :  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL	mem_addr_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	mem_data :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	mem_data_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	mem_sel :  STD_LOGIC;
SIGNAL	opcode :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	operand :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	pc_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	pc_reset :  STD_LOGIC;
SIGNAL	pc_write :  STD_LOGIC;
SIGNAL	rf_reset :  STD_LOGIC;
SIGNAL	rf_write :  STD_LOGIC;
SIGNAL	rf_x_mux :  STD_LOGIC;
SIGNAL	rf_z_in :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	rf_z_mux :  STD_LOGIC;
SIGNAL	rx_field :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	rz_field :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sip :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sip_reset :  STD_LOGIC;
SIGNAL	sip_write :  STD_LOGIC;
SIGNAL	sop :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sop_reset :  STD_LOGIC;
SIGNAL	sop_write :  STD_LOGIC;
SIGNAL	sys_clk :  STD_LOGIC;
SIGNAL	sys_reset :  STD_LOGIC;
SIGNAL	we :  STD_LOGIC;
SIGNAL	z_reset :  STD_LOGIC;
SIGNAL	zout :  STD_LOGIC;


BEGIN 



b2v_de1 : de1_diagram
PORT MAP(clk_clk => CLOCK_50,
		 switch_pio_external_connection_export => sip(7 DOWNTO 0),
		 clk_1_clk_clk => sys_clk,
		 clk_1_clk_reset_reset_n => sys_reset);


b2v_inst : control_unit
PORT MAP(CLK => sys_clk,
		 Reset => sys_reset,
		 z => zout,
		 Addressing_Mode => am,
		 Opcode => opcode,
		 Operand => operand,
		 Rx => rx_field,
		 Rz => rz_field,
		 we => we,
		 write_ir => ir_write,
		 reset_ir => ir_reset,
		 write_pc => pc_write,
		 reset_pc => pc_reset,
		 write_rf => rf_write,
		 rf_mux_sel_x => rf_x_mux,
		 rf_mux_sel_z => rf_z_mux,
		 reset_rf => rf_reset,
		 alu_mux_B => alu_mux_b,
		 carry => carry,
		 clr_z => z_reset,
		 write_sip => sip_write,
		 reset_sip => sip_reset,
		 write_sop => sop_write,
		 reset_sop => sop_reset,
		 write_dpcr => dpcr_write,
		 reset_dpcr => dpcr_reset,
		 alu_mux_A => alu_a_mux,
		 alu_op => alu_op,
		 m_address_mux_sel => mem_addr_mux,
		 mem_data_mux_sel => mem_data_mux,
		 pc_mux_sel => pc_mux,
		 rf_mux_sel => rf_z_in,
		 rf_value_sel_x => cu_x,
		 rf_value_sel_z => cu_z);


b2v_inst1 : datapath
PORT MAP(sys_clk => sys_clk,
		 rf_write => rf_write,
		 ir_write => ir_write,
		 alu_b_mux => alu_mux_b,
		 rf_reset => rf_reset,
		 ir_reset => ir_reset,
		 rf_sel_x => rf_x_mux,
		 rf_sel_z => rf_z_mux,
		 carry_in => carry,
		 pc_write => pc_write,
		 pc_reset => pc_reset,
		 dpcr_write => dpcr_write,
		 dpcr_reset => dpcr_reset,
		 SOP_write => sop_write,
		 z_reset => z_reset,
		 SOP_reset => sop_reset,
		 SIP_write => sip_write,
		 SIP_reset => sip_reset,
		 alu_a_mux => alu_a_mux,
		 alu_op => alu_op,
		 ir_out => ir_out,
		 m_data => m_out,
		 mem_addr_mux => mem_addr_mux,
		 mem_data_mux => mem_data_mux,
		 pc_mux_sel => pc_mux,
		 rf_cu_x => cu_x,
		 rf_cu_z => cu_z,
		 rf_z_input_sel => rf_z_in,
		 SIP_in => sip,
		 z_out => zout,
		 addr => mem_addr,
		 am => am,
		 data => mem_data,
		 opcode => opcode,
		 operand => operand,
		 rx_field => rx_field,
		 rz_field => rz_field);


b2v_memory_block : ram_interface
PORT MAP(mem_clk => sys_clk,
		 w => we,
		 address => mem_addr,
		 data_in => mem_data,
		 ir_out => ir_out,
		 m_out => m_out);


sip(7 DOWNTO 0) <= SW;
END bdf_type;