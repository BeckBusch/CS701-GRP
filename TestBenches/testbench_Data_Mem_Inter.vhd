library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_Data_Mem_Inter is
end testbench_Data_Mem_Inter;

architecture Behavior of testbench_Data_Mem_Inter is

    -- Component declaration
    component Data_Mem_Inter is
        port (
            data_a_mux : in std_logic_vector(1 downto 0);

            ir_hold : in std_logic_vector(15 downto 0);
            rx : in std_logic_vector(15 downto 0);
            dprr : in std_logic_vector(1 downto 0);

            data : out std_logic_vector(15 downto 0));
    end component;

    -- Input signals
    signal data_a_mux : std_logic_vector(1 downto 0);
    signal ir_hold : std_logic_vector(15 downto 0);
    signal rx : std_logic_vector(15 downto 0);
    signal dprr : std_logic_vector(1 downto 0);

    -- Output signals
    signal data : std_logic_vector(15 downto 0);

begin

    -- Instantiate the ALU
    DUT : Data_Mem_Inter port map(
        data_a_mux => data_a_mux,
        ir_hold => ir_hold,
        rx => rx,
        dprr => dprr,
        data => data
    );

    -- Stimulus Process
    stim_proc : process
    begin

        -- ir_hold
        data_a_mux <= "00";
        ir_hold <= "1111000011110000";
        rx <= "1010101010101010";
        dprr <= "11";
        wait for 10 ns;
        assert data = "1111000011110000"
        report "ir_hold, operation failed" severity error;

        -- rx
        data_a_mux <= "01";
        ir_hold <= "1111000011110000";
        rx <= "1010101010101010";
        dprr <= "11";
        wait for 10 ns;
        assert data = "1010101010101010"
        report "rx, operation failed" severity error;

        -- dprr
        data_a_mux <= "10";
        ir_hold <= "1111000011110000";
        rx <= "1010101010101010";
        dprr <= "11";
        wait for 10 ns;
        assert data = "0000000000000011"
        report "dprr, operation failed" severity error;

        -- nothing
        data_a_mux <= "11";
        wait for 10 ns;
        assert data = "0000000000000000"
        report "false input, operation failed" severity error;


        -- End simulation
        wait;
    end process;
end Behavior;
