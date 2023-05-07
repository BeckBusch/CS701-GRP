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
-- CREATED		"Sun May 07 23:31:05 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ReCOPQuartus IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END ReCOPQuartus;

ARCHITECTURE bdf_type OF ReCOPQuartus IS 

COMPONENT recopcore
	PORT(CLK : IN STD_LOGIC;
		 Reset : IN STD_LOGIC;
		 clr_irq_in : IN STD_LOGIC;
		 dprr_write : IN STD_LOGIC;
		 clr_irq_write : IN STD_LOGIC;
		 dprr_reset : IN STD_LOGIC;
		 clr_irq_reset : IN STD_LOGIC;
		 dpc_in : IN STD_LOGIC;
		 dpc_write : IN STD_LOGIC;
		 dpc_reset : IN STD_LOGIC;
		 z_write : IN STD_LOGIC;
		 dprr_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 head : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ir_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 m_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SIP_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 clr_irq : OUT STD_LOGIC;
		 dpc : OUT STD_LOGIC;
		 addr : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
		 ccd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dpcr_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pcd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 SOP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

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

SIGNAL	ir_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	m_out :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	mem_addr :  STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL	mem_data :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sip :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sop :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	sys_clk :  STD_LOGIC;
SIGNAL	sys_clock :  STD_LOGIC;
SIGNAL	sys_reset :  STD_LOGIC;
SIGNAL	we :  STD_LOGIC;


BEGIN 



b2v_inst : recopcore
PORT MAP(CLK => sys_clock,
		 Reset => sys_reset,
		 ir_out => ir_out,
		 m_data => m_out,
		 SIP_in => sip,
		 addr => mem_addr,
		 data => mem_data,
		 SOP => sop);


b2v_inst2 : de1_diagram
PORT MAP(clk_clk => CLOCK_50,
		 switch_pio_external_connection_export => sip(7 DOWNTO 0),
		 clk_1_clk_clk => sys_clk,
		 clk_1_clk_reset_reset_n => sys_reset);


b2v_memory_block : ram_interface
PORT MAP(mem_clk => sys_clk,
		 w => we,
		 address => mem_addr,
		 data_in => mem_data,
		 ir_out => ir_out,
		 m_out => m_out);

LEDR(9 DOWNTO 0) <= sop(9 DOWNTO 0);

sip(7 DOWNTO 0) <= SW;
END bdf_type;