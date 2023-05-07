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
-- CREATED		"Sun May 07 20:42:09 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY RAM_Interface IS 
	PORT
	(
		mem_clk :  IN  STD_LOGIC;
		write_high :  IN  STD_LOGIC;
		w :  IN  STD_LOGIC;
		address :  IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
		data_in :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		ir_out :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		m_out :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END RAM_Interface;

ARCHITECTURE bdf_type OF RAM_Interface IS 

COMPONENT ram1
	PORT(wren : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pm_ram
	PORT(wren : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ram_mem_inter
	PORT(in_mem_clk : IN STD_LOGIC;
		 w : IN STD_LOGIC;
		 write_high : IN STD_LOGIC;
		 address : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		 data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dout_dm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 dout_pm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_mem_clk : OUT STD_LOGIC;
		 w_dm : OUT STD_LOGIC;
		 w_pm : OUT STD_LOGIC;
		 addr_dm : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 addr_pm : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		 data_dm : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data_pm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ir_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 m_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	dout_dm :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	dout_pm :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_data_memory : ram1
PORT MAP(wren => SYNTHESIZED_WIRE_0,
		 clock => SYNTHESIZED_WIRE_1,
		 address => SYNTHESIZED_WIRE_2,
		 data => SYNTHESIZED_WIRE_3,
		 q => dout_dm);


SYNTHESIZED_WIRE_1 <= NOT(SYNTHESIZED_WIRE_10);



SYNTHESIZED_WIRE_7 <= NOT(SYNTHESIZED_WIRE_10);



b2v_program_memory_32 : pm_ram
PORT MAP(wren => SYNTHESIZED_WIRE_6,
		 clock => SYNTHESIZED_WIRE_7,
		 address => SYNTHESIZED_WIRE_8,
		 data => SYNTHESIZED_WIRE_9,
		 q => dout_pm);


b2v_ram_mem_block : ram_mem_inter
PORT MAP(in_mem_clk => mem_clk,
		 w => w,
		 write_high => write_high,
		 address => address,
		 data_in => data_in,
		 dout_dm => dout_dm,
		 dout_pm => dout_pm,
		 out_mem_clk => SYNTHESIZED_WIRE_10,
		 w_dm => SYNTHESIZED_WIRE_0,
		 w_pm => SYNTHESIZED_WIRE_6,
		 addr_dm => SYNTHESIZED_WIRE_2,
		 addr_pm => SYNTHESIZED_WIRE_8,
		 data_dm => SYNTHESIZED_WIRE_3,
		 data_pm => SYNTHESIZED_WIRE_9,
		 ir_out => ir_out,
		 m_out => m_out);


END bdf_type;