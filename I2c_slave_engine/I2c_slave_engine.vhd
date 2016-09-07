-----------------------------------------------------------------
--! @file I2c_slave_engine.vhd
--! @brief 
--! @details 
--! PENG Donghui
-----------------------------------------------------------------




--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--!
entity I2c_slave_engine is

port(
		clk: in std_logic;				
		clk_ena: in std_logic;			
		sync_rst: in std_logic;		
		ctl_role_r: in std_logic;
		--ctl_ack_r: in std_logic;
		--ctl_rw_r: in std_logic;
		ctl_reset_r: in std_logic;
		
		status_busy_r: in std_logic;
		status_rw_r: in std_logic;
		status_rxfull_r: in std_logic;
		status_txempty_r: in std_logic;		
		status_ackrec_r: in std_logic;	
		
		txdata: in std_logic_vector (7 downto 0);
		
		address: in std_logic_vector (6 downto 0);
		
		status_busy_w: out std_logic;
		status_rw_w: out std_logic;
		status_stop_detected_s: out std_logic;
		status_start_detected_s: out std_logic;
		--status_restart_detected_s: out std_logic;
		status_rxfull_s: out std_logic;
		status_txempty_s: out std_logic;
		status_ackrec_s: out std_logic
		
		rxdata: out std_logic_vector (7 downto 0);
		
	  );


end entity I2c_slave_engine;


--! Moore & Mealy Combined Machine
architecture fsm of shift_register_receiver is

type state_type is (INIT, start, receiver1, receiver2, transmitter1, stop, error );
signal state: state_type := INIT;
signal address_received: std_logic_vector (6 downto 0);	
	
	--! Component Shift register transmitter
	component shift_register_transmitter is

	port(clk: in std_logic;
		  clk_ena: in std_logic;
		  sync_rst: in std_logic;
		  TX: in std_logic_vector (7 downto 0);		-- To connect with TX register
		  rising_point: in std_logic;
		  sampling_point: in std_logic;
		  falling_point: in std_logic;
		  writing_point: in std_logic;
		  scl_tick: in std_logic;
		  sda_in: in std_logic;
		  ACK_out: out std_logic;
		  ACK_valued: out std_logic;
		  TX_captured: out std_logic;
		  sda_out: out std_logic);				
		  
	end component shift_register_transmitter;
	
	
	--! Component Shift register receiver
	component shift_register_receiver is
	port(clk: in std_logic;
	 clk_ena: in std_logic;
	 sync_rst: in std_logic;
	 scl_tick: in std_logic;
	 sda_in: in std_logic;
	 falling_point: in std_logic;
	 sampling_point: in std_logic;
	 writing_point: in std_logic;
	 ACK_in: in std_logic;
	 sda_out: out std_logic;
	 data_received: out std_logic;
	 RX: out std_logic_vector (7 downto 0));
	 
	end component shift_register_receiver;
	
	
	component Condition_detect is
	port(
    clk						: in STD_LOGIC;--! clock input
	clk_ena					: in STD_LOGIC;--! clock_enable input
	sync_rst				: in STD_LOGIC;--! synchronization reset input
	SCL_in 			        : in STD_LOGIC;--! I2C clock line input
    SDA_in             		: in STD_LOGIC;--! I2C data line input
	 
    start_detected_point    : out  STD_LOGIC;--! detected start condition 
	stop_detected_point     : out  STD_LOGIC;--! detected stop condition
	error_detected_point    : out  STD_LOGIC --! detected error condition
	); 
	 
	end component Condition_detect;
	
	
	component SCL_detect is
	Port( 
        clk 					:in  STD_LOGIC;--! clock input
        clk_ena 				:in  STD_LOGIC;--! clock_enable input
		sync_rst 				:in  STD_LOGIC;--! synchronization reset input
        SCL_in 					:in  STD_LOGIC;--! I2C clock line input
		SCL_tick 				:in  STD_LOGIC;--! tick clock line input
			  
		SCL_rising_point 		:out  STD_LOGIC;--! detected SCL_rising_point 
		SCL_stop_point 			:out  STD_LOGIC;--! detected SCL_stop_point 
		SCL_sample_point 		:out  STD_LOGIC;--! detected SCL_sample_point 
		SCL_start_point 		:out  STD_LOGIC;--! detected SCL_start_point 
		SCL_falling_point 		:out  STD_LOGIC;--! detected SCL_falling_point 
		SCL_write_point 		:out  STD_LOGIC;--! detected SCL_write_point 
		SCL_error_indication 	:out  STD_LOGIC --! detected SCL_error_indication 
		);
          
	end component SCL_detect;
	
begin
	
	
			
	transmitter: shift_register_transmitter
	port map(clk => clk_50MHz,
		  clk_ena => clk_ena,
		  sync_rst => rst_variable,
		  TX => TX,		-- To connect with TX register
		  rising_point => rising_point,
		  sampling_point => sampling_point,
		  falling_point => falling_point,
		  writing_point => writing_point,
		  scl_tick => scl_tick,
		  sda_out => sda_out_1,
		  sda_in => sda_in,
		  ACK_out => ACK_out,
		  ACK_valued => ACK_valued,
		  TX_captured => TX_captured);
	
	
	 receiver: shift_register_receiver
	 port map(clk => clk_50MHz,
	 clk_ena => clk_ena,
	 sync_rst => rst_variable,
	 scl_tick => scl_tick,
	 sda_in => sda_in,
	 falling_point => falling_point,
	 sampling_point => sampling_point,
	 writing_point => writing_point,
	 ACK_in => ACK_in,
	 sda_out => sda_out_2, 				--sda_out,
	 data_received => data_received,
	 RX => RX);
	 
	 
	 Condition_detect: Condition_detect
	 port map(clk => clk_50MHz,
	 clk_ena => clk_ena,
	 sync_rst => rst_variable,
	 SCL_in => SCL_in,
	 SDA_in => SDA_in,
	 start_detected_point => start_detected_point,
	 stop_detected_point => stop_detected_point,
	 error_detected_point => error_detected_point,
	 );
	 
	 
	SCL_detect: SCL_detect
	port map(  
			sync_rst => sync_rst,
			clk => clk, 
			clk_ena => clk_ena, 
			SCL_in => SCL_in,
			SCL_tick => SCL_tick,
				
			SCL_stop_point => SCL_stop_point,
			SCL_start_point => SCL_start_point,
			SCL_rising_point => SCL_rising_point,
			SCL_falling_point => SCL_falling_point,
			SCL_sample_point => SCL_sample_point,
			SCL_write_point => SCL_write_point,
			SCL_error_indication => SCL_error_indication
			);


			
transitions_and_storage: process (clk) is
	
begin 

if(rising_edge(clk)) then
	if(clk_ena = '1') then
		if(sync_rst = '1') then
			
				if(ctl_role_r = '0') then
					case state is	 
						
					when INIT =>
						if (start_detected_point = '1') then 
							state <= start;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then 
							state <= error;
						end if;
					
					when start =>
						state <= receiver1;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then 
							state <= error;
						end if;
							
					when receiver1 =>
						if ( (data_received <= '1') and (address = address_received) )then 
							if (status_rw_w = '0') then 
								state <= receiver2;
							end if;
							
							if (status_rw_w = '1') then 
								state <= transmitter1;
							end if;
						
						else 
							state <= INIT;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then 
							state <= error;
						end if;
						
					when receiver2 => 
						if (stop_detected_point = '1') then 
							state <= stop;
						else 
							state <= receiver2;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then 
							state <= error;
						end if;
						
					when transmitter1 => 
						if (stop_detected_point = '1') then 
							state <= stop;
						else
							state <= transmitter1;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then 
							state <= error;
						end if;
					
					when stop => 
						state <= INIT;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then 
							state <= error;
						end if;
					
					end case;
				end if;
			
		else
			state <= INIT;
		end if;
	end if;
end if;

end process transitions_and_storage;	 




stateaction: process (state) is
	
begin

        status_busy_w <= '1';
		status_rw_w <= '1';
		status_stop_detected_s <= '0';
		status_start_detected_s <= '0';
		--status_restart_detected_s: out std_logic;
		status_rxfull_s <= '0';
		status_txempty_s <= '0';
		status_ackrec_s <= '0';
		
		rxdata <= (others => '0');
			
case state is
		
		when INIT => 
			null;	
		
		when start => 
			status_start_detected_s <= '1';	
			
		when receiver1 => 
			if(data_received = '1') then
				status_rxfull_s <= '1';
				rxdata <= RX ;	
				status_rw_w <= RX(0);
				address_received <= RX(7 downto 1);
			end if;		
		
		when receiver2 => 
			if(data_received = '1') then
				status_rxfull_s <= '1';
			end if;
			
		when transmitter1 => 
			if (TX_captured = '1') then 
				status_txempty_s <= '1';
			end if;
			
			if (ACK_valued = '1') then 
				status_ackrec_s <= ACK_out;
			end if;

		when stop =>
			status_busy_w <= '0';
			status_stop_detected_s <= '1';
				
		when error =>
				
					
		end case;
	
	end process stateaction;
	
end architecture fsm;

