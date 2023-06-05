
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.opcodes.all;
use work.mux_values.all;

entity Control_Unit is
	port (
		CLK : in std_logic;
		Reset : in std_logic;
		-- Debug_Mode          : in  STD_LOGIC;
		--nios_control        : in  STD_LOGIC;
		--init_up		    	: out std_logic;         -- uP initialisation
		we : out std_logic := '0'; -- write ram

		-- IR
		Opcode : in std_logic_vector (5 downto 0);
		Addressing_Mode : in std_logic_vector (1 downto 0);
		Rz : in std_logic_vector(3 downto 0);
		Rx : in std_logic_vector(3 downto 0);
		Operand : in std_logic_vector(15 downto 0);
		write_ir : out std_logic;
		reset_ir : out std_logic;

		-- Pc:
		write_pc : out std_logic;
		pc_mux_sel : out std_logic_vector(1 downto 0);
		reset_pc : out std_logic;

		-- RF Block:
		write_rf : out std_logic;
		rf_mux_sel : out std_logic_vector(2 downto 0);
		rf_mux_sel_x : out std_logic;
		rf_mux_sel_z : out std_logic;
		reset_rf : out std_logic;
		rf_value_sel_x : out std_logic_vector(3 downto 0);
		rf_value_sel_z : out std_logic_vector(3 downto 0);

		-- memory address and data interface
		mem_sel : out std_logic;
		m_address_mux_sel : out std_logic_vector(1 downto 0);
		mem_data_mux_sel : out std_logic_vector(1 downto 0);

		--AlU
		alu_mux_A : out std_logic_vector(1 downto 0);
		alu_mux_B : out std_logic;
		alu_op : out std_logic_vector(1 downto 0);
		carry : out std_logic;
		z : in std_logic;
		clr_z : out std_logic;

		--SIP
		write_sip : out std_logic;
		reset_sip : out std_logic;
		-- Ssop
		write_sop : out std_logic;
		reset_sop : out std_logic;

		--dpcr
		write_dpcr : out std_logic;
		reset_dpcr : out std_logic;
		dpcr_mux_sel : out std_logic;

		--dpc and irq
		dpc_flag : in std_logic;
		irq_flag : in std_logic;
		reset_dpc : out std_logic;
		reset_irq : out std_logic;
		reset_dprr : out std_logic

	);
end Control_Unit;

architecture Behavioral of Control_Unit is
	-- states for the Pulse Distributor state machine
	type State_Type is (Ini, Test, Test2, E0, E1, E1bis, E2, T0, T1, T2, T3, N1, N2);
	signal State, Next_State : State_Type;
	type Opcode_Type is (ldr_v, str_v, andd_v, orr_v, add_v, subv_v, subi_v, jmp_v, present_v, datacall_v, sz_v, clfz_v, lsip_v, ssop_v, noop_v, max_v, strpc_v);
	signal Opcode_View : Opcode_Type;
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
	process (State, Opcode, Addressing_Mode) -- Include other necessary input signals
	begin

		case Opcode is
			when ldr =>
				Opcode_View <= ldr_v;
			when str =>
				Opcode_View <= str_v;
			when andd =>
				Opcode_View <= andd_v;
			when orr =>
				Opcode_View <= orr_v;
			when add =>
				Opcode_View <= add_v;
			when subv =>
				Opcode_View <= subv_v;
			when subi =>
				Opcode_View <= subi_v;
			when jmp =>
				Opcode_View <= jmp_v;
			when present =>
				Opcode_View <= present_v;
			when datacall =>
				Opcode_View <= datacall_v;
			when sz =>
				Opcode_View <= sz_v;
			when clfz =>
				Opcode_View <= clfz_v;
			when lsip =>
				Opcode_View <= lsip_v;
			when ssop =>
				Opcode_View <= ssop_v;
			when noop =>
				Opcode_View <= noop_v;
			when max =>
				Opcode_View <= max_v;
			when strpc =>
				Opcode_View <= strpc_v;
			when others =>
		end case;
		-- Implement combinational logic for generating control signals based on the input signals and the current state
		-- Generate Next_State signal based on the current state, Debug_Mode, and DP_Memory_Signal

		case State is

			when Ini =>
				next_state <= T0;
				-- Add state logic
				write_ir <= '0';
				write_pc <= '0';
				write_rf <= '0';
				write_sip <= '0';
				write_sop <= '0';
				write_dpcr <= '0';
				reset_dpcr <= '1';
				reset_dprr<='0';
				reset_ir <= '1';
				reset_sip <= '1';
				reset_sop <= '0';
				reset_pc <= '1';
				carry <= '0';
			when T0 => -- T1: 
			write_sop <= '0';
				if (dpc_flag = '1' and irq_flag = '1') then
					next_state <= N1;
				else
					next_state <= T1;
				end if;

			when N1 =>
				rf_mux_sel <= rf_mem_hep;      -- this is actually selecting dprr
				rf_mux_sel_x<='1';--selecting to hardcode reg
				rf_value_sel_x <= "0101";           --hard code write to 10 on z mux
				write_rf <= '1';
				next_state <= N2;

			when N2 =>
				rf_mux_sel <= rf_rx;
				write_sop <= '1';
				reset_irq <= '1';
				next_state <= T0;

			when T1 => --fetch  instruction from program memory
				next_state <= T2;
				reset_pc <= '0';
				reset_ir <= '0';
				reset_dpcr <= '0';
				reset_dpc <= '0';
				reset_irq <= '0';
				write_pc <= '1';
				write_ir <= '1';
				write_dpcr <= '0';

				m_address_mux_sel <= m_address_pc;
				mem_sel <= mem_pm;
				-- ir <- pm 
				write_ir <= '1';
				-- pc <- pc + 1
				pc_mux_sel <= pc_const;
				write_pc <= '1';
			when T2 => -- decoding instruction and execute
				next_state <= T3;
				write_pc <= '0';
				write_ir <= '0';

				if Addressing_mode = inherent then -- inherent AM
					case opcode is

						when clfz => --add func          --check func 
							clr_z <= '1';
						when noop =>
							null;
							-- do nothing
						when others =>
							-- should be invalid instruction code
					end case;

				elsif Addressing_mode = direct then --direct Am
					case opcode is
						when ldr => --check func
							m_address_mux_sel <= m_address_ir;
							rf_mux_sel <= rf_dm;
							rf_mux_sel_x <= '0';
							write_rf <= '1';

						when str => --check func

							mem_data_mux_sel <= mem_data_rx;
							m_address_mux_sel <= m_address_ir;
							mem_sel <= mem_dm;
							we <= '1';

						when strpc => --check func(not sure)
							mem_data_mux_sel <= mem_data_pc;
							m_address_mux_sel <= m_address_ir;
							mem_sel <= mem_dm;
							we <= '1';

						when others =>
							-- should be invalid instruction code
					end case;

				elsif Addressing_mode = indirect then
					case opcode is

						when add => --check func 
							alu_op <= alu_add;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_alu;
							rf_mux_sel_z <= '0';
							write_rf <= '1';
						when andd => --check func 
							alu_op <= alu_andd;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_alu;
							rf_mux_sel_z <= '0'; --selecting to rz
							write_rf <= '1';
						when orr => --check func 
							alu_op <= alu_orr;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_alu;
							rf_mux_sel_z <= '0';
							write_rf <= '1';

						when ldr => --check func not sure  
							m_address_mux_sel <= m_address_rx;
							rf_mux_sel <= rf_dm;
							rf_mux_sel_z <= '0';
							write_rf <= '1';

						when str => --check func  store rx  on rz
							mem_data_mux_sel <= mem_data_rx;
							m_address_mux_sel <= m_address_rz;
							mem_sel <= mem_dm;
							we <= '1';

						when jmp => --check func  juming pc to rx
							pc_mux_sel <= pc_rx;
							write_pc <= '1';

						when datacall => --check func  (not sure)
							dpcr_mux_sel <= dpcr_r7;
							rf_mux_sel_z <= '1'; --selecting to hardcode reg
							rf_value_sel_z <= x"7";
							write_dpcr <= '1';

						when lsip =>
							write_sip <= '1';

						when ssop => --check func  whaterver is on rx will be loaded to sop
							rf_mux_sel <= rf_rx;
							write_sop <= '1';

						when others =>
							-- should be invalid instruction code
					end case;

				elsif Addressing_mode = immediate then -- immediate AM

					case opcode is
						when add => --check func
							alu_op <= alu_add;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_ir;
							write_rf <= '1';

						when subi => --check func
							alu_op <= alu_sub;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rz;
							rf_mux_sel <= rf_ir;
							write_rf <= '1';

						when subv => --check func
							alu_op <= alu_sub;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_alu;
							write_rf <= '1';

						when andd => --check func
							alu_op <= alu_andd;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_alu;
							write_rf <= '1';
						when orr => --check func
							alu_op <= alu_orr;
							alu_mux_a <= alu_ir;
							alu_mux_b <= alu_rx_b;
							rf_mux_sel <= rf_alu;
							write_rf <= '1';
						when ldr => --check func
							rf_mux_sel <= rf_ir;
							rf_mux_sel_x <= '0';
							write_rf <= '1';

						when str => --check func  store operand on rz
							mem_data_mux_sel <= mem_data_ir;
							m_address_mux_sel <= m_address_rz;
							mem_sel <= mem_dm;
							we <= '1';

						when jmp => --check func
							pc_mux_sel <= pc_ir;
							write_pc <= '1';

						when present => --check func  -- TODO: present broken
							alu_op <= alu_orr;
							alu_mux_a <= alu_rx_a;
							alu_mux_b <= alu_rz;

						when datacall => --check func  
							dpcr_mux_sel <= dpcr_ir;
							write_dpcr <= '1';

						when max => --check func  
							rf_mux_sel <= rf_rzmax;
							write_rf <= '1';

						when sz => --check func
							if z = '1' then
								pc_mux_sel <= pc_ir;
								write_pc <= '1';
							else
								pc_mux_sel <= pc_const;
								write_pc <= '1';
							end if;
						when others =>
							-- should be invalid instruction code
					end case;
				end if;

			when T3 =>
				next_state <= T0;
				write_ir <= '0';
				write_pc <= '0';
				write_rf <= '0';
				write_sip <= '0';
				write_sop <= '0';
				write_dpcr <= '0';
				we <= '0';
				carry <= '0';

				if (Addressing_mode = immediate and opcode = present and z = '1') then
					pc_mux_sel <= pc_ir;
					write_pc <= '1';

				elsif (Addressing_mode = immediate and opcode = present and z = '0') then
					null;

				elsif (Addressing_mode = indirect and opcode = lsip) then
					rf_mux_sel <= rf_sip;
					rf_mux_sel_z <= '0';
				end if;
			when others =>
				--  should be invalid instruction code
		end case;
	end process;

end Behavioral;
