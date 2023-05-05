library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAM_Mem_Inter is
    port (
        -- datapath inputs
        in_mem_clk : in std_logic;
        w : in std_logic;
        address : in std_logic_vector(16 downto 0);
        data_in : in std_logic_vector(15 downto 0);

        --Memory outputs
        out_mem_clk : out std_logic;
        out_data_in : out std_logic_vector(16 downto 0);

        addr_dm : out std_logic_vector(11 downto 0);
        w_dm : out std_logic;
        addr_pm : out std_logic_vector(11 downto 0);
        w_pm : out std_logic;

        -- Memory Inputs
        dout_dm : in std_logic_vector(15 downto 0);
        dout_pm : in std_logic_vector(15 downto 0);

        -- Datapath Outputs
        m_out : out std_logic_vector(15 downto 0)
    );
end RAM_Mem_Inter;

architecture behaviour of RAM_Mem_Inter is

    component MUX2_12 is
        port (
            sel : in std_logic;
            a, b : in std_logic_vector(11 downto 0);
            outp : out std_logic_vector(11 downto 0));
    end component;

    component MUX2_1 is
        port (
            sel : std_logic;
            a, b : in std_logic;
            outp : out std_logic);
    end component;

begin

    MUX2_12_1 : MUX2_12 port map(
        sel => address(16),
        a => address(11 downto 0),
        b => X"0000",
        outp => addr_dm
    );
    MUX2_12_2 : MUX2_12 port map(
        sel => address(16),
        a => X"0000",
        b => address(11 downto 0),
        outp => addr_pm
    );
    MUX2_1_1 : MUX2_1 port map(
        sel => address(16),
        a => w,
        b => '0',
        outp => w_dm
    );
    MUX2_12_2 : MUX2_1 port map(
        sel => address(16),
        a => '0',
        b => w,
        outp => w_pm
    );

    MUX2_16_1 : MUX2_16 port map(
        sel => address(16),
        a => dout_dm,
        b => dout_pm,
        outp => m_out
    );

    out_mem_clk <= in_mem_clk;
    out_data_in <= data_in;

end behaviour;
