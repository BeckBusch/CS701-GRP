
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.opcodes.all;

entity Control_Unit is
    Port (
        CLK                 : in  STD_LOGIC;
        Reset               : in  STD_LOGIC;
        Debug_Mode          : in  STD_LOGIC;
	nios_control        : in  STD_LOGIC;
	init_up		    : out std_logic; -- uP initialisation

	-- IR
        Opcode              : in  STD_LOGIC_VECTOR (5 downto 0); -- Define appropriate bit range for Opcode
        Addressing_Mode     : in  STD_LOGIC_VECTOR (1 downto 0); -- Define appropriate bit range for Addressing Mode
	Rz       	    : in std_logic_vector(3 downto 0);
       	Rx       	    : in std_logic_vector(3 downto 0);
        Operand             : in std_logic_vector(15 downto 0);
        write_ir            : out std_logic;
        load_ir	            : out std_logic;
	ir_reset 	    : in std_logic;
        ir_load_msb         : out std_logic;
        ir_load_lsb 	    : out std_logic;

        
	-- Pc:
  	write_pc               : out std_logic;
	pc_mux_sel 	       : out std_logic_vector(1  downto 0);
        reset_pc	       : in std_logic;

	
	-- RF Block:
  	write_rf                : out std_logic;
	rf_mux_sel 		: out std_logic_vector(2 downto 0);
        rf_mux_sel_x 		: out std_logic;
        rf_mux_sel_z 		: out std_logic;
        reset_rf : in std_logic;
        rf_value_sel_x : in std_logic_vector(3 downto 0);
        rf_value_sel_z : in std_logic_vector(3 downto 0);

	-- memory address and data interface
        write_m_address         : out std_logic;
        m_address_mux_sel       : out std_logic_vector(1 downto 0);
	mem_data_mux_sel 	: out std_logic_vector(1 downto 0);

	--AlU
	alu_mux_A		: out std_logic_vector(1 downto 0);
	alu_mux_B		: out std_logic;
	alu_op			: out std_logic_vector(1 downto 0)

	
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
            when T0 =>                   --fetch

		next_state <= T1;
		-- ir <- pm 
		write_ir <= '1';
		-- pc <- pc + 1
		pc_in_sel <= "00";
		write_pc <= '1';

		
		-- T1: decoding instruction
		when T1 =>
			next_state <= T2;
			-- detect addressing mode and prepare for execution
			case opcode(10 downto 9) is
				when stack => -- stack addressing
					if opcode(7) = '0' then
						-- push type operation
						dm_adr_sel <= selsp2adr;
						sp_in_sel <= selspop2sp;
						sp_op_sel <= dec_sp;
						ld_sp <= '1';
					else
						-- pull type operation
						dm_adr_sel <= selspop2adr;
						sp_in_sel <= selspop2sp;
						sp_op_sel <= inc_sp;
						ld_sp <= '1';
					end if;
					-- push: ar <- sp, pull: ar <- sp + 1
					ld_ar <= '1';
				when indirect => -- register indirect addressing
					-- ar <- Ry
					dm_adr_sel <= selry2adr;
					ld_ar <= '1';
				when direct => -- direct addressing
					-- ar <- ir[24..9]
					dm_adr_sel <= selir2adr;
					ld_ar <= '1';
				when others => -- inherent and immediate
					-- do nothing
			end case;

            when T1 =>                           --decode 
                -- Add state logic
            when T2 =>                          --execute
                -- Add state logic
            when T3 =>
                -- Add state logic
            when others =>
                -- Add default state logic
        end case;
    end process;

end Behavioral;










