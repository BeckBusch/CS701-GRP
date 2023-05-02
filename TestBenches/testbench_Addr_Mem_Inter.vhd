library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench_Addr_Mem_Inter is
end testbench_Addr_Mem_Inter;

architecture Behavior of testbench_Addr_Mem_Inter is

    -- Component declaration
    component Addr_Mem_Inter is
        port (
            data_a_mux : in std_logic_vector(1 downto 0);
            mem_sel : in std_logic;

            pc_hold : in std_logic_vector(15 downto 0);
            rx : in std_logic_vector(15 downto 0);
            rz : in std_logic_vector(15 downto 0);
            ir_hold : in std_logic_vector(15 downto 0);

            addr : out std_logic_vector(16 downto 0));
    end component;

    -- Input signals
    signal data_a_mux : std_logic_vector(1 downto 0);
    signal mem_sel : std_logic;
    signal pc_hold : std_logic_vector(15 downto 0);
    signal rx : std_logic_vector(15 downto 0);
    signal rz : std_logic_vector(15 downto 0);
    signal ir_hold : std_logic_vector(15 downto 0);

    -- Output signals
    signal addr : std_logic_vector(16 downto 0);

begin

    -- Instantiate the ALU
    DUT : Addr_Mem_Inter port map(
        data_a_mux => data_a_mux,
        mem_sel => mem_sel,
        pc_hold => pc_hold,
        rx => rx,
        rz => rz,
        ir_hold => ir_hold,
        addr => addr
    );

    -- Stimulus Process
    stim_proc : process
    begin

        -- pc_hold, 0 operation
        data_a_mux <= "00";
        mem_sel <= '0';
        pc_hold <= "1111111111111111";
        rx <= "1010101010101010";
        rz <= "1100110011001100";
        ir_hold <= "1111000011110000";
        wait for 10 ns;
        assert addr = "01111111111111111"
        report "PC Hold, mem sel 0 operation failed" severity error;

        -- rx, 1 operation
        data_a_mux <= "01";
        mem_sel <= '1';
        pc_hold <= "1111111111111111";
        rx <= "1010101010101010";
        rz <= "1100110011001100";
        ir_hold <= "1111000011110000";
        wait for 10 ns;
        assert addr = "11010101010101010"
        report "rx 1 operation failed" severity error;

        -- rz, 0 operation
        data_a_mux <= "10";
        mem_sel <= '0';
        pc_hold <= "1111111111111111";
        rx <= "1010101010101010";
        rz <= "1100110011001100";
        ir_hold <= "1111000011110000";
        wait for 10 ns;
        assert addr = "01100110011001100"
        report "rz 0 operation failed" severity error;

        -- ir_hold, 1 operation
        data_a_mux <= "11";
        mem_sel <= '1';
        pc_hold <= "1111111111111111";
        rx <= "1010101010101010";
        rz <= "1100110011001100";
        ir_hold <= "1111000011110000";  
        wait for 10 ns;
        assert addr = "11111000011110000"
        report "ir_hold 1 operation failed" severity error;

        -- End simulation
        wait;
    end process;
end Behavior;
