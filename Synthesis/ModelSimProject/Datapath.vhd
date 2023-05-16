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
-- CREATED		"Mon May 08 01:37:19 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Datapath IS 
	PORT
	(
		dprr_write :  IN  STD_LOGIC;
		dprr_reset :  IN  STD_LOGIC;
		mem_sel :  IN  STD_LOGIC;
		pc_write :  IN  STD_LOGIC;
		pc_reset :  IN  STD_LOGIC;
		carry_in :  IN  STD_LOGIC;
		alu_b_mux :  IN  STD_LOGIC;
		dpcr_write :  IN  STD_LOGIC;
		dpcr_reset :  IN  STD_LOGIC;
		dpcr_sel :  IN  STD_LOGIC;
		clr_irq_write :  IN  STD_LOGIC;
		clr_irq_reset :  IN  STD_LOGIC;
		dpc_in :  IN  STD_LOGIC;
		dpc_write :  IN  STD_LOGIC;
		dpc_reset :  IN  STD_LOGIC;
		z_write :  IN  STD_LOGIC;
		z_reset :  IN  STD_LOGIC;
		SOP_write :  IN  STD_LOGIC;
		SOP_reset :  IN  STD_LOGIC;
		SIP_write :  IN  STD_LOGIC;
		SIP_reset :  IN  STD_LOGIC;
		rf_write :  IN  STD_LOGIC;
		rf_reset :  IN  STD_LOGIC;
		rf_sel_x :  IN  STD_LOGIC;
		rf_sel_z :  IN  STD_LOGIC;
		sys_clk :  IN  STD_LOGIC;
		clr_irq_in :  IN  STD_LOGIC;
		ir_write :  IN  STD_LOGIC;
		ir_reset :  IN  STD_LOGIC;
		alu_a_mux :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		alu_op :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		dprr_in :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		head :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		ir_out :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		m_data :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		mem_addr_mux :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		mem_data_mux :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		pc_mux_sel :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		rf_cu_x :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		rf_cu_z :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		rf_z_input_sel :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		SIP_in :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		dpc :  OUT  STD_LOGIC;
		z_out :  OUT  STD_LOGIC;
		clr_irq :  OUT  STD_LOGIC;
		addr :  OUT  STD_LOGIC_VECTOR(16 DOWNTO 0);
		am :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		ccd :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		data :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		dpcr_out :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		opcode :  OUT  STD_LOGIC_VECTOR(5 DOWNTO 0);
		operand :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		pcd :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		rx_field :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		rz_field :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		SOP :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END Datapath;

ARCHITECTURE bdf_type OF Datapath IS 

COMPONENT alu
	PORT(data_b_mux : IN STD_LOGIC;
		 carry_in : IN STD_LOGIC;
		 alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 data_a_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 flmr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ir_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rx : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rz : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 zout : OUT STD_LOGIC;
		 aluout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT reg1_1
	PORT(reg_in : IN STD_LOGIC;
		 writ : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reg_out : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT reg1_8
	PORT(writ : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reg_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 reg_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT reg1_2
	PORT(writ : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reg_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 reg_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT instruction_reg
	PORT(CLK : IN STD_LOGIC;
		 ir_write : IN STD_LOGIC;
		 ir_reset : IN STD_LOGIC;
		 ir_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 AM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Opcode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		 Operand : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Rx_Field : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Rz_Field : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT max
	PORT(rx : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rz : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 max_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT addr_mem_inter
	PORT(mem_sel : IN STD_LOGIC;
		 data_a_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ir_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rx : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rz : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 addr : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
	);
END COMPONENT;

COMPONENT data_mem_inter
	PORT(data_a_mux : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dprr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ir_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rx : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pc_component
	PORT(reg_write : IN STD_LOGIC;
		 reg_reset : IN STD_LOGIC;
		 reg_clk : IN STD_LOGIC;
		 ir_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 m_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_mux_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 rx : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_hold : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rf
	PORT(clk : IN STD_LOGIC;
		 writ : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 selx_mux_sel : IN STD_LOGIC;
		 selz_mux_sel : IN STD_LOGIC;
		 aluout : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 cu_selx : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 cu_selz : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 ir_hold_15_0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ir_hold_19_16 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 ir_hold_23_20 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 m_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 mem_hp_low : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rz_max : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 sip_hold : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 z_mux_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 ccd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 flmr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pcd : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 rx : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rz : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT reg1_16
	PORT(writ : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reg_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 reg_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dpcr IS
    PORT(
        rx : IN STD_LOGIC_VECTOR(15 downto 0);
        rz : IN STD_LOGIC_VECTOR(15 downto 0);
        ir_hold : IN STD_LOGIC_VECTOR(15 downto 0);
        dpcr_sel : IN STD_LOGIC;
        writ : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        reg_out : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
END COMPONENT;

SIGNAL	aluout :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	clk :  STD_LOGIC;
SIGNAL	data_in :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	dprr :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	flmr :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	head_data :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	max_out :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	operand_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	pc_reg :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	rx_data :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	rx_field_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	rz_data :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	rz_field_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sip :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	z_in :  STD_LOGIC;


BEGIN 



b2v_alu_block : alu
PORT MAP(data_b_mux => alu_b_mux,
		 carry_in => carry_in,
		 alu_op => alu_op,
		 data_a_mux => alu_a_mux,
		 flmr => flmr,
		 ir_hold => operand_ALTERA_SYNTHESIZED,
		 rx => rx_data,
		 rz => rz_data,
		 zout => z_in,
		 aluout => aluout);


b2v_clr_irq_reg : reg1_1
PORT MAP(reg_in => clr_irq_in,
		 writ => clr_irq_write,
		 reset => clr_irq_reset,
		 clk => clk,
		 reg_out => clr_irq);


b2v_dpc_reg : reg1_1
PORT MAP(reg_in => dpc_in,
		 writ => dpc_write,
		 reset => dpc_reset,
		 clk => clk,
		 reg_out => dpc);

 b2v_dpcr_reg : dpcr   PORT map(
        rx => rx_data,
        rz => rz_data,
        ir_hold => operand_ALTERA_SYNTHESIZED,
        dpcr_sel => dpcr_sel,
        writ => dpcr_write,
        reset => dpcr_reset,
        clk => clk,
        reg_out => dpcr_out
    );

b2v_DPRR_reg : reg1_2
PORT MAP(writ => dprr_write,
		 reset => dprr_reset,
		 clk => clk,
		 reg_in => dprr_in,
		 reg_out => dprr);


b2v_instruction_register_block : instruction_reg
PORT MAP(CLK => clk,
		 ir_write => ir_write,
		 ir_reset => ir_reset,
		 ir_out => ir_out,
		 AM => am,
		 Opcode => opcode,
		 Operand => operand_ALTERA_SYNTHESIZED,
		 Rx_Field => rx_field_ALTERA_SYNTHESIZED,
		 Rz_Field => rz_field_ALTERA_SYNTHESIZED);


b2v_max_block : max
PORT MAP(rx => operand_ALTERA_SYNTHESIZED,
		 rz => rz_data,
		 max_out => max_out);


b2v_mem_addr : addr_mem_inter
PORT MAP(mem_sel => mem_sel,
		 data_a_mux => mem_addr_mux,
		 ir_hold => operand_ALTERA_SYNTHESIZED,
		 pc_hold => pc_reg,
		 rx => rx_data,
		 rz => rz_data,
		 addr => addr);


b2v_mem_data : data_mem_inter
PORT MAP(data_a_mux => mem_data_mux,
		 dprr => dprr,
		 ir_hold => operand_ALTERA_SYNTHESIZED,
		 pc_hold => pc_reg,
		 rx => rx_data,
		 data => data);


b2v_pc_register : pc_component
PORT MAP(reg_write => pc_write,
		 reg_reset => pc_reset,
		 reg_clk => clk,
		 ir_hold => operand_ALTERA_SYNTHESIZED,
		 m_out => data_in,
		 pc_mux_sel => pc_mux_sel,
		 rx => rx_data,
		 pc_hold => pc_reg);


b2v_rf_block : rf
PORT MAP(clk => clk,
		 writ => rf_write,
		 reset => rf_reset,
		 selx_mux_sel => rf_sel_x,
		 selz_mux_sel => rf_sel_z,
		 aluout => aluout,
		 cu_selx => rf_cu_x,
		 cu_selz => rf_cu_z,
		 ir_hold_15_0 => operand_ALTERA_SYNTHESIZED,
		 ir_hold_19_16 => rx_field_ALTERA_SYNTHESIZED,
		 ir_hold_23_20 => rz_field_ALTERA_SYNTHESIZED,
		 m_out => data_in,
		 mem_hp_low => head_data,
		 pc_hold => pc_reg,
		 rz_max => max_out,
		 sip_hold => sip,
		 z_mux_sel => rf_z_input_sel,
		 ccd => ccd,
		 flmr => flmr,
		 pcd => pcd,
		 rx => rx_data,
		 rz => rz_data);


b2v_SIP_reg : reg1_16
PORT MAP(writ => SIP_write,
		 reset => SIP_reset,
		 clk => clk,
		 reg_in => SIP_in,
		 reg_out => sip);


b2v_SOP_reg : reg1_16
PORT MAP(writ => SOP_write,
		 reset => SOP_reset,
		 clk => clk,
		 reg_in => rx_data,
		 reg_out => SOP);


b2v_z_reg : reg1_1
PORT MAP(reg_in => z_in,
		 writ => z_write,
		 reset => z_reset,
		 clk => clk,
		 reg_out => z_out);

clk <= sys_clk;
data_in <= m_data;
head_data <= head;
operand <= operand_ALTERA_SYNTHESIZED;
rx_field <= rx_field_ALTERA_SYNTHESIZED;
rz_field <= rz_field_ALTERA_SYNTHESIZED;

END bdf_type;