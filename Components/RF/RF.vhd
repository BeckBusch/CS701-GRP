library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RF is
    port (
        clk : in std_logic;
        writ : in std_logic;
        reset : in std_logic;

        z_mux_sel : in std_logic_vector(2 downto 0);
        selx_mux_sel : in std_logic;
        selz_mux_sel : in std_logic;


        ir_hold_19_16 : in std_logic_vector(3 downto 0);
        cu_selx : in std_logic_vector(3 downto 0);
        cu_selz : in std_logic_vector(3 downto 0);
        ir_hold_23_20 : in std_logic_vector(3 downto 0);

        ir_hold_15_0 : in std_logic_vector(15 downto 0);
        m_out : in std_logic_vector(15 downto 0);
        in_rx : in std_logic_vector(15 downto 0);
        aluout : in std_logic_vector(15 downto 0);
        rz_max : in std_logic_vector(15 downto 0);
        sip_hold : in std_logic_vector(15 downto 0);
        er_temp : in std_logic_vector(15 downto 0);
        mem_hp_low : in std_logic_vector(15 downto 0);

        rx : out std_logic_vector(15 downto 0);
        rz : out std_logic_vector(15 downto 0);
        ccd : out std_logic_vector(15 downto 0);
        pcd : out std_logic_vector(15 downto 0);
        flmr : out std_logic_vector(15 downto 0);
    )
