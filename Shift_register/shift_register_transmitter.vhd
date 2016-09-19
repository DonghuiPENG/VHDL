---------------------------------------------------------
--! @file
--! @brief Shift register for transmitter with internal buffer  
--! Updated 21/07/2016
--! Changhua DING
----------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic element
use ieee.std_logic_1164.all;
--! Use unsigned 
use ieee.std_logic_unsigned.all;	


--! shift register transmitter entity
entity shift_register_transmitter is

	port(clk: in std_logic;					--! clock input
		  clk_ena: in std_logic;			--! clock enable input
		  sync_rst: in std_logic;			--! synchronous reset input
		  TX: in std_logic_vector (7 downto 0);		--! TX register input
		  rising_point: in std_logic;		--! rising_point input
		  sampling_point: in std_logic;		--! sampling_point input
		  falling_point: in std_logic;		--! falling_point input
		  writing_point: in std_logic;		--! writing_point input
		  scl_tick: in std_logic;			--! scl_tick input
		  sda_in: in std_logic;				--! sda_in input
		  ACK_out: out std_logic;			--! ACK_out output
		  ACK_valued: out std_logic;		--! ACK_valued output To inform ACK_out is newly valued
		  TX_captured: out std_logic;		--! TX_captured output, TX_captured = '1'  ==>  the buffer(byte_to_be_sent) captured the data from TX and Microcontroller could update TX register
		  sda_out: out std_logic);			--! sda_out output
		  
end entity shift_register_transmitter;



--! Behavioral architecture, with shift register's state machine and an internal buffer
architecture fsm of shift_register_transmitter is

	signal reg_write: std_logic;						-- reg_write is the internal signal to inform the internal buffer to renew the data from byte_to_be_sent
	signal go: std_logic;
	signal byte_to_be_sent: std_logic_vector(7 downto 0);
	signal data: std_logic_vector(7 downto 0);					-- ????????????????????????????
	type state_type is(CLEAR, WRITE_DATA, S7, S6, S5, S4, S3, S2, S1, S0, S_WAIT, RECEIVE_ACK);
	signal state: state_type := CLEAR;
	
begin

	--Moore & Mealy Combined Machine 
	
	-- Transition and storage
	P_transition_and_storage: process (clk) is
	
	
	begin
	
		if(rising_edge(clk)) then
		
			if(clk_ena = '1') then
				if(sync_rst = '0') then			-- rst 0 actif
					state <= CLEAR;
				else
				
					case state is
					
					when CLEAR => 
						if(go = '1') then
							state <= WRITE_DATA;
						end if;
						
					when WRITE_DATA => 
						
						if (writing_point = '1' and scl_tick = '1') then
							state <= S7;
						end if;
						
					when S7 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S6;
						end if;
					
					when S6 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S5;
						end if;
					
					when S5 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S4;
						end if;
					
					when S4 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S3;
						end if;
						
					when S3 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S2;
						end if;
						
					when S2 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S1;
						end if;
						
					when S1 =>
						if (writing_point = '1' and scl_tick = '1') then
							state <= S0;
						end if;
						
					when S0 =>
						if (writing_point = '1' and scl_tick = '1') then			-- rising_point
							state <= S_WAIT;
						end if;
						
					when S_WAIT =>
						if(sampling_point = '1' and scl_tick ='1') then
							state <= RECEIVE_ACK;
							ACK_out <= sda_in;								-- A Transit action ACK_out changes only once per cycle
						end if;
						
					when RECEIVE_ACK => 
						if(falling_point = '1' and scl_tick = '1') then
							state <= CLEAR;
						end if;	
						
					end case;
					
				end if; -- if (sync_rst ='1') 
			end if; -- if (clk_ena = '1')
		end if;   -- if(rising_edge(clk))
	
			
	end process P_transition_and_storage;
	
	
	-- Outputs conditions
	P_stataction: process(state) is
	
	begin
		case state is
		
		when CLEAR =>
			data <= (others => '0');			-- Clear internal buffer to x0
			reg_write <= '1';
			sda_out <= '1';						-- to be kept at '1' in order to AND with others SDA
			ACK_valued <= '0';
			
		when WRITE_DATA => 
			
			data <= byte_to_be_sent;
			reg_write <= '0';
			sda_out <= '1';						-- to be kept at '1' in order to AND with others SDA
			ACK_valued <= '0';
			
		when S7 => 
			
			reg_write <= '0';
			sda_out <= data(7);
			ACK_valued <= '0';
	
		when S6 => 
			
			reg_write <= '0';
			sda_out <= data(6);
			ACK_valued <= '0';
			
		when S5 => 
			
			reg_write <= '0';
			sda_out <= data(5);
			ACK_valued <= '0';
		
		when S4 => 
			
			reg_write <= '0';
			sda_out <= data(4);
			ACK_valued <= '0';
			
		when S3 => 
			
			reg_write <= '0';
			sda_out <= data(3);
			ACK_valued <= '0';
		
		when S2 => 
			
			reg_write <= '0';
			sda_out <= data(2);
			ACK_valued <= '0';
			
		when S1 => 
			
			reg_write <= '0';
			sda_out <= data(1);
			ACK_valued <= '0';
			
		when S0 => 
			
			reg_write <= '0';
			sda_out <= data(0);
			ACK_valued <= '0';
			
		when S_WAIT =>
			
			reg_write <= '0';
			sda_out <= '1';			-- to be kept at '1' in order to AND with others SDA
			ACK_valued <= '0';
			
		when RECEIVE_ACK =>
			
			reg_write <= '0';
			sda_out <= '1';			-- to be kept at '1' in order to AND with others SDA
			ACK_valued <= '1';
			
			
		end case;

	end process P_stataction;
		
	-- Internal buffer process
	P_internal_buffer : process(clk) is
	
	begin
		if(rising_edge(clk)) then
			if(clk_ena = '1') then
				if(sync_rst = '1') then
				
					if(reg_write = '1') then
						byte_to_be_sent <= TX;
						go <= '1';
						TX_captured <= '1';
					else	
						go <= '0';
						TX_captured <= '0';
					end if;	
				
				else
					-- nothing ???????
				end if;  -- if(rst)
			end if;   	-- if(rising clk)
	
		end if;
	end process P_internal_buffer;


end architecture fsm;
