-----------------------------------------------------------------
--! @file shift_register_receiver.vhd
--! @brief shift register to receive 8-bit data
--! @details Created 21/07/2016
--! Last Update 08/09/2016 				
--! Changhua DING
-----------------------------------------------------------------




--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! This is the shift register receiver entity:
--! to receive the sda bit and combine to an entire byte with double buffer mechanism
entity shift_register_receiver is

port(clk: in std_logic;				--! clock input
	 clk_ena: in std_logic;			--! clock enable input
	 sync_rst: in std_logic;		--! synchronous reset input
	 scl_tick: in std_logic;		--! scl_tick input
	 sda_in: in std_logic;			--! sda_in input 
	 falling_point: in std_logic;	--! falling_point input
	 sampling_point: in std_logic;	--! sampling_point input
	 writing_point: in std_logic;	--! writing_point input
	 ACK_in: in std_logic;			--! acknowledge bit input
	 sda_out: out std_logic;		--! sda_out output
	 ACK_sent: out std_logic;		--! ACK_sent output, triger a '1' when ACK is sent
	 data_received: out std_logic;	--! data_received bit output
	 RX: out std_logic_vector (7 downto 0) --! RX received byte output
	 );


end entity shift_register_receiver;


--! Moore & Mealy Combined Machine
architecture FSM of shift_register_receiver is

signal reg_write: std_logic;
signal go: std_logic;
signal data: std_logic_vector (7 downto 0);
signal byte_to_be_used: std_logic_vector (7 downto 0);
type state_type is (CLEAR, S7, S6, S5, S4, S3, S2, S1, S0, READ_DATA, S_WAIT, SEND_ACK, ACK_TEMP_1, ACK_TEMP_2);
signal state: state_type := CLEAR;


begin

	-- 1.
	--! Transition, storages and transit action
	P_transition_and_storage: process(clk) is
	
	
	begin
		if(rising_edge(clk)) then
			if(clk_ena = '1') then
				if(sync_rst = '1') then
					case state is
					
					when CLEAR => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S7;
						end if;
						
						
					when S7 =>
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S6;
						end if;
						
					when S6 => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S5;
						end if;
					
					when S5 => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S4;
						end if;
						
					when S4 => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S3;
						end if;
						
					when S3 => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S2;
						end if;
						
					when S2 => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S1;
						end if;
					
					when S1 => 
					
						if(sampling_point = '1' and scl_tick = '1') then
							state <= S0;
						end if;
						
					when S0 =>
					
						if(falling_point = '1' and scl_tick = '1') then
							state <= READ_DATA;
							byte_to_be_used <= data;					-- A Transit action that happend once per cycle
						end if;
						
					when READ_DATA =>
					
						if(go = '1') then
							state <= S_WAIT;
						end if;
					
					when S_WAIT =>
						
						if(writing_point = '1' and scl_tick = '1') then
							state <= SEND_ACK;
						end if;
						
					when SEND_ACK =>
					
						if(falling_point = '1' and scl_tick = '1') then
							state <= ACK_TEMP_1;
						end if;
					
					when ACK_TEMP_1 =>
						state <= ACK_TEMP_2;
					
					when ACK_TEMP_2 =>
					
						if(scl_tick = '1') then
							state <= CLEAR;
						end if;
			
					end case;
				else
					state <= CLEAR;
				end if;
		
			end if;		-- if(clk_ena = '1')
		end if;			-- if(rising_edge(clk))
		
	
	end process P_transition_and_storage;
	
	
	
	-- 2.
	--! State actions
	P_stataction: process(state) is
	
	begin
	
		case state is
		
		
		when CLEAR =>
	
			reg_write <= '0';
			data <= (others => '0');
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S7 => 
			
			reg_write <= '0';
			data(7) <= sda_in;
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S6 => 
			
			reg_write <= '0';
			data(6) <= sda_in;
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S5 => 
			
			reg_write <= '0';
			data(5) <= sda_in;
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S4 => 
			
			reg_write <= '0';
			data(4) <= sda_in;
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S3 => 
			
			reg_write <= '0';
			data(3) <= sda_in;
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S2 => 
			
			reg_write <= '0';
			data(2) <= sda_in;
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S1 => 
			
			reg_write <= '0';
			data(1) <= sda_in;
			sda_out <= '1';	
			ACK_sent <= '0';
			
		when S0 => 
			
			reg_write <= '0';
			data(0) <= sda_in;	
			sda_out <= '1';
			ACK_sent <= '0';
			
		when READ_DATA => 
		
			
			reg_write <= '1';
			sda_out <= '1';
			ACK_sent <= '0';
			
		when S_WAIT =>
			
			reg_write <= '0';
			sda_out <= '1';
			ACK_sent <= '0';
			
		when SEND_ACK =>
			
			reg_write <= '0';
			sda_out <= ACK_in;
			ACK_sent <= '0';
			
		when ACK_TEMP_1 =>		-- Maintain the ACK temporally
			
			reg_write <= '0';
			sda_out <= ACK_in;
			ACK_sent <= '1';
		
		when ACK_TEMP_2 =>
		
			reg_write <= '0';
			sda_out <= ACK_in;
			ACK_sent <= '0';
		
		end case;
	
	end process P_stataction;
	
	-- 3.
	--! Internal buffer
	P_internal_buffer: process(clk) is
	
	begin
		if(rising_edge(clk)) then
			if(clk_ena = '1' ) then
				if(sync_rst = '1') then
					
					if(reg_write = '1') then
						RX <= byte_to_be_used;
						go <= '1';
						data_received <= '1';
					else
						go <= '0';
						data_received <= '0';
					end if;
				else 
					-- Nothing
				end if;
			
			end if;
		end if;
	
	end process P_internal_buffer;
	
end architecture FSM;





