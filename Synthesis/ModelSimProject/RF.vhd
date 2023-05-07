library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RF is
    port (
        clk : in std_logic;
        writ : in std_logic;
        reset : in std_logic;

        selx_mux_sel : in std_logic;
        ir_hold_19_16 : in std_logic_vector(3 downto 0);
        cu_selx : in std_logic_vector(3 downto 0);

        selz_mux_sel : in std_logic;
        cu_selz : in std_logic_vector(3 downto 0);
        ir_hold_23_20 : in std_logic_vector(3 downto 0);

        z_mux_sel : in std_logic_vector(2 downto 0);
        ir_hold_15_0 : in std_logic_vector(15 downto 0);
        m_out : in std_logic_vector(15 downto 0);
        aluout : in std_logic_vector(15 downto 0);
        rz_max : in std_logic_vector(15 downto 0);
        sip_hold : in std_logic_vector(15 downto 0);
        pc_hold : in std_logic_vector(15 downto 0);
        mem_hp_low : in std_logic_vector(15 downto 0);

        rx : out std_logic_vector(15 downto 0);
        rz : out std_logic_vector(15 downto 0);
        ccd : out std_logic_vector(3 downto 0);
        pcd : out std_logic_vector(3 downto 0);
        flmr : out std_logic_vector(15 downto 0));
end RF;

architecture behaviour of RF is
    -- components
    component RF_REG_ALT is
        port (
            writ, clk, reset : in std_logic;
            sel_x, sel_z : in std_logic_vector(3 downto 0);
            z : in std_logic_vector(15 downto 0);
            out_rx, out_rz, out_ccd, out_pcd, out_flmr : out std_logic_vector(15 downto 0)
        );
    end component;

    component MUX8_16 is
        port (
            sel : in std_logic_vector(2 downto 0);
            a, b, c, d, e, f, g, h : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0));
    end component;

    component MUX2_4 is
        port (
            sel : in std_logic;
            a, b : in std_logic_vector(3 downto 0);
            outp : out std_logic_vector(3 downto 0));
    end component;

    signal out_z : std_logic_vector(15 downto 0);
    signal out_sel_x, out_sel_z : std_logic_vector(3 downto 0);
    signal internal_rx : std_logic_vector(15 downto 0);
    signal internal_ccd : std_logic_vector(15 downto 0);
    signal internal_pcd : std_logic_vector(15 downto 0);
    signal crop_hp : std_logic_vector(15 downto 0);

begin
    -- multiplexers
    MUX8_16_1 : MUX8_16 port map(
        sel => z_mux_sel,
        a => ir_hold_15_0,
        b => m_out,
        c => internal_rx,
        d => aluout,
        e => rz_max,
        f => sip_hold,
        g => pc_hold,
        h => crop_hp,
        outp => out_z
    );

    MUX2_4_1 : MUX2_4 port map(
        sel => selx_mux_sel,
        a => ir_hold_19_16,
        b => cu_selx,
        outp => out_sel_x
    );

    MUX2_4_2 : MUX2_4 port map(
        sel => selx_mux_sel,
        a => ir_hold_23_20,
        b => cu_selz,
        outp => out_sel_z
    );

    RF_REG_1 : RF_REG_ALT port map(
        sel_x => out_sel_x,
        sel_z => out_sel_z,
        z => out_z,
        writ => writ,
        clk => clk,
        reset => reset,
        out_rx => internal_rx,
        out_rz => rz,
        out_ccd => internal_ccd,
        out_pcd => internal_pcd,
        out_flmr => flmr
    );

    crop_hp <= "000000000" & mem_hp_low(6 downto 0);
    rx <= internal_rx;
    ccd <= internal_ccd(3 downto 0);
    pcd <= internal_pcd(3 downto 0);

end behaviour;
