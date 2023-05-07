library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_recop is
end testbench_recop;

architecture behaviour of testbench_recop is
    COMPONENT ReCOPCore
        PORT
        (
            CLK		:	 IN STD_LOGIC;
            Reset		:	 IN STD_LOGIC;
            m_data		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            head		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ir_out		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            clr_irq_in		:	 IN STD_LOGIC;
            dprr_in		:	 IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            dprr_write		:	 IN STD_LOGIC;
            clr_irq_write		:	 IN STD_LOGIC;
            dprr_reset		:	 IN STD_LOGIC;
            clr_irq_reset		:	 IN STD_LOGIC;
            dpc_in		:	 IN STD_LOGIC;
            dpc_write		:	 IN STD_LOGIC;
            dpc_reset		:	 IN STD_LOGIC;
            z_write		:	 IN STD_LOGIC;
            SIP_in		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ccd		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            pcd		:	 OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            addr		:	 OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
            clr_irq		:	 OUT STD_LOGIC;
            dpcr_out		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            dpc		:	 OUT STD_LOGIC;
            data		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            SOP		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    

begin
end behaviour;