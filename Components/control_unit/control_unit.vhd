
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.opcodes.all;
use work.mux_values.all;

entity Control_Unit is
    Port (
        CLK                 : in  STD_LOGIC;
        Reset               : in  STD_LOGIC;
        Debug_Mode          : in  STD_LOGIC;
		nios_control        : in  STD_LOGIC;
		init_up		    	: out std_logic; -- uP initialisation

	-- IR
        Opcode              : in  STD_LOGIC_VECTOR (5 downto 0); 
        Addressing_Mode     : in  STD_LOGIC_VECTOR (1 downto 0); 
		Rz       	    : in std_logic_vector(3 downto 0);
       	Rx       	    : in std_logic_vector(3 downto 0);
        Operand             : in std_logic_vector(15 downto 0);
        write_ir            : out std_logic;
        load_ir	            : out std_logic;
		ir_reset 	    : in std_logic;
   

        
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
        mem_sel         : out std_logic;
        m_address_mux_sel       : out std_logic_vector(1 downto 0);
	mem_data_mux_sel 	: out std_logic_vector(1 downto 0);

	--AlU
		alu_mux_A		: out std_logic_vector(1 downto 0);
		alu_mux_B		: out std_logic;
		alu_op			: out std_logic_vector(1 downto 0);
    	z               : in std_logic;
		clr_z           : out std_logic;

	--SIP
	   write_sip : out std_logic;

	-- Ssop
	  write_sop : out std_logic
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
    process (State, Debug_Mode, Opcode, Addressing_Mode) -- Include other necessary input signals
    begin
        -- Implement combinational logic for generating control signals based on the input signals and the current state
        -- Generate Next_State signal based on the current state, Debug_Mode, and DP_Memory_Signal

        case State is
     
            when Ini =>
                -- Add state logic

		
		
		
            when Test =>
                -- Add state logic
            when Test2 =>

            when T0 =>                   --fetch  instruction from program memory

				next_state <= T1;
				-- ir <- pm 
				write_ir <= '1';
				-- pc <- pc + 1
				pc_mux_sel <= pc_const;   
				write_pc <= '1';
		
	     	when T1 =>                     -- T1: decoding instruction
				next_state <= T2;
				-- detect addressing mode and prepare for execution
				case Addressing_mode is
					
					when immediate => 		-- register immediate
						-- ar <- ir[15..0]
						--m_address_mux_sel   <= m_address_ir;
						--mem_sel <= mem_pm;
						-- pc <- pc + 1
						--pc_in_sel <= pc_const;   --sel inc
						--write_pc <= '1'; 

					when direct => 			-- direct addressing
						-- ar <- ir[15..0]
						--m_address_mux_sel<= m_address_ir;
						--mem_sel <= '1';
					when others =>			 -- inherent and inderct
						-- do nothing
				end case;

            
            when T2 =>                          --execute
                next_state <= T0;

				if Addressing_mode = inherent then      -- inherent AM
					case opcode is
						
						when clfz =>   --add func          --check func 
							if z = '1' then
								clr_z <= '1';
							end if;
						when noop =>
							-- do nothing
						when others =>
							-- should be invalid instruction code
					end case;

				elsif Addressing_mode = direct then
					case opcode is
						when ldr =>
							rf_mux_sel <= rf_dm;
							write_rf <= '1';
						when str =>              
							mem_data_mux_sel  <= mem_data_rx;
							m_address_mux_sel<=m_address_rx;
							mem_sel <= mem_dm;
						when strpc =>          --check func(not sure)
							mem_data_mux_sel  <= mem_data_dprr;
							 m_address_mux_sel<= m_address_ir;
							mem_sel <= mem_dm;
						when others =>
							-- should be invalid instruction code
					end case;
					
				elsif Addressing_mode = indirect then    
					case opcode is

						when add =>                         --check func 
							alu_op <= alu_add;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_alu;
							rf_mux_sel_z <= '1';
							write_rf <= '1';
							--ld_c <= '1';
							--ld_z <= '1';
							--ld_v <= '1';
							--ld_n <= '1';

						when andd =>                             --check func 
							alu_op <= andd;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_alu;
							rf_mux_sel_z <= '1';
							write_rf <= '1';
							--ld_z <= '1';
						
						when orr =>                                 --check func 
							alu_op <= orr;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_alu;
							rf_mux_sel_z <= '1';
							write_rf <= '1';
							--ld_z <= '1';

						when ldr =>                                --check func 
							rf_mux_sel <= rf_ir;
							rf_mux_sel_z <= '1';
							write_rf <= '1';

						when str =>                               --chek func (unsure) 
							mem_data_mux_sel <= mem_data_rx;
							mem_sel <= mem_dm;

						when jmp =>                                --check func(unsure) 
							pc_mux_sel <= pc_rx;
							write_pc <= '1';

						when datacall =>                             --add func 
							mem_data_mux_sel <= mem_data_rx;
							mem_data_mux_sel <= mem_data_rx;
							pc_mux_sel <= pc_ir;
							write_pc <= '1';

						when lsip =>                               --highly unsure
						    rf_mux_sel<=rf_sip;
							rf_mux_sel_z<='1';

						when ssop =>                                  --add func 
							rf_mux_sel <= rf_rx;
							write_sop <= '1';

						when others =>
							-- should be invalid instruction code
					end case;

				elsif Addressing_mode = immediate then             -- immediate AM
					
					case opcode is	 
						when add =>            --check func
							alu_op <= alu_add;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_ir;
							write_rf <= '1';
							--ld_c <= '1';
							--ld_z <= '1';
							--ld_v <= '1';
							--ld_n <= '1';
						when subi=>                   --check func
							alu_op <= alu_sub;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_ir;
							write_rf <= '1';
							--ld_c <= '1';
							--ld_z <= '1';
							--ld_v <= '1';
							--ld_n <= '1';
						when subv =>                  --check func
							alu_op <= subv;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_alu;
							write_rf <= '1';
							--ld_c <= '1';
							--ld_z <= '1';
							--ld_v <= '1';
							--ld_n <= '1';
						when andd =>                    --check func
							alu_op <= andd;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_alu;
							write_rf <= '1';
							--ld_z <= '1';
						
						when orr =>                       --check func
							alu_op <= orr;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_alu;
							write_rf <= '1';
							--ld_z <= '1';

						when ldr =>                     --check func
							rf_mux_sel <= rf_ir;
							write_rf <= '1';

						when str =>                              --check func
							mem_data_mux_sel <= mem_data_rx;
							mem_sel <= mem_dm;

						when jmp =>                          --check func
							pc_mux_sel <= pc_ir;
							write_pc <= '1';

						when sz=>                                    --check func
							if z='1' then
								pc_mux_sel <= pc_ir;
								write_pc<='1';
							else
								pc_mux_sel<=pc_const;
								write_pc<='1';
							end if ;


						when others =>
							-- should be invalid instruction code
					end case;
				end if;	
            when T3 =>
                -- Add state logic
            when others =>
                --  should be invalid instruction code
        end case;
    end process;

end Behavioral;










