library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAM_Mem_Inter is
    port (
        -- system inputs
        in_mem_clk : in std_logic;

        -- datapath inputs
        address : in std_logic_vector(16 downto 0);
        data_in : in std_logic_vector(15 downto 0);

        -- control unit inputs
        w : in std_logic;
        write_high : in std_logic;  -- used for program memory only

        --Memory outputs
        out_mem_clk : out std_logic;

        data_dm : out std_logic_vector(15 downto 0);
        w_dm : out std_logic;
        addr_dm : out std_logic_vector(11 downto 0);

        data_pm : out std_logic_vector(31 downto 0);
        w_pm : out std_logic;
        addr_pm : out std_logic_vector(10 downto 0);

        -- Memory Inputs
        dout_dm : in std_logic_vector(15 downto 0);
        dout_pm : in std_logic_vector(31 downto 0);

        -- Datapath Outputs
        m_out : out std_logic_vector(15 downto 0);
        ir_out : out std_logic_vector(31 downto 0)
    );
end RAM_Mem_Inter;

architecture behaviour of RAM_Mem_Inter is

    component MUX2_16 is
        port (
            sel : in std_logic;
            a, b : in std_logic_vector(15 downto 0);
            outp : out std_logic_vector(15 downto 0)
        );
    end component;

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
	 
	 -- signal internal_pm_addr : std_logic_vector(11 downto 0);

begin

    -- ADDRESS_DATA_MUX : MUX2_12 port map(
    --     sel => address(16),
    --     a => address(11 downto 0),
    --     b => x"000",
    --     outp => addr_dm
    -- );


    -- ADDRESS_PM_MUX : MUX2_12 port map(
    --     sel => address(16),
    --     a => x"000",
    --     b => address(11 downto 0),
    --     outp => internal_pm_addr
    -- );

    ENABLE_DATA_WRITE : MUX2_1 port map(
        sel => address(16),
        a => w,
        b => '0',
        outp => w_dm
    );

    ENABLE_PM_WRITE : MUX2_1 port map(
        sel => address(16),
        a => '0',
        b => w,
        outp => w_pm
    );

    out_mem_clk <= in_mem_clk;
    data_dm <= data_in;
    data_pm <= dout_pm(31 downto 16) & data_in when write_high = '1' else
               data_in & dout_pm(15 downto 0);
	 addr_pm <= address(10 downto 0);

     addr_dm <= address(11 downto 0);

    m_out <= dout_dm;
    ir_out <= dout_pm;

end behaviour;
