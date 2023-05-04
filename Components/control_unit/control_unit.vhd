
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit is
    Port (
        CLK                 : in  STD_LOGIC;
        Reset               : in  STD_LOGIC;
        Debug_Mode          : in  STD_LOGIC;
	init_up		    : out std_logic; -- uP initialisation

	-- IR
        Opcode              : in  STD_LOGIC_VECTOR (5 downto 0); -- Define appropriate bit range for Opcode
        Addressing_Mode     : in  STD_LOGIC_VECTOR (1 downto 0); -- Define appropriate bit range for Addressing Mode
	Rz       	    : in std_logic_vector(3 downto 0);
       	Rx       	    : in std_logic_vector(3 downto 0);
        Operand             : in std_logic_vector(15 downto 0);
        write_ir            : out std_logic;
	ir_reset 	    : in std_logic;
        ir_load_msb         : in std_logic;
        ir_load_lsb 	    : in std_logic;

        
	-- Pc:
  	write_pc               : out std_logic;
	pc_mux_sel 	       : out std_logic_vector(3  downto 0);

	
	-- RF Block:
  	write_rf                : out std_logic;
	rf_mux_sel 		: out std_logic_vector(2 downto 0);
        rf_mux_sel_x 		: out std_logic;
        rf_mux_sel_z 		: out std_logic;

	-- memory address and data interface
        write_m_address         : out std_logic;
        m_address_mux_sel       : out std_logic_vector(1 downto 0);
	mem_data_mux_sel 	: out std_logic_vector(1 downto 0);

	--AlU
	alu_mux_A		: out std_logic_vector(1 downto 0);
	alu_mux_B		: out std_logic_vector(1 downto 0);
	alu_op			: out std_logic_vector(2 downto 0);
	
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
    -- states for the Pulse Distributor state machine
    type State_Type is (Ini, Test, Test2, E0, E1, E1bis, E2, T0, T1, T2, T3);
    signal State, Next_State : State_Type;

begin
    -- Pulse Distributor (State Machine)
    process (CLK, Reset)
    begin
        if Reset = '1' then
            State <= Ini;
        elsif rising_edge(CLK) then
            State <= Next_State;
        end if;
    end process;

    -- Operation Decoder
    process (State, Debug_Mode, DP_Memory_Signal, Opcode, Addressing_Mode) -- Include other necessary input signals
    begin
        -- Implement combinational logic for generating control signals based on the input signals and the current state
        -- Generate Next_State signal based on the current state, Debug_Mode, and DP_Memory_Signal

        case State is
     
            when Ini =>
                -- Add state logic
            when Test =>
                -- Add state logic
            when Test2 =>
                -- Add state logic
            when E0 =>
                -- Add state logic
            when E1 =>
                -- Add state logic
            when E1bis =>
                -- Add state logic
            when E2 =>
                -- Add state logic
            when T0 =>
                -- Add state logic
            when T1 =>
                -- Add state logic
            when T2 =>
                -- Add state logic
            when T3 =>
                -- Add state logic
            when others =>
                -- Add default state logic
        end case;
    end process;

end Behavioral;










