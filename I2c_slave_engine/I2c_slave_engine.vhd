-----------------------------------------------------------------
--! @file 
--! @brief I2c_slave_engine : 
--! @details This entity with synchronization reset is used to simulate the whole slave engine 
--! design with register. By the way, those ports is simulated for the part of register insteading 
--! of Avalon interface. According to the I2C slave engine, we need to use some components what it needs
--! to work well. For example, there are have cascadable_counter, scl_tick_generator, shift_register_transmitter, 
--! shift_register_receiver, Condition_detect and SCL_detect. At the begining, I2c_slave_engine would work
--! after receiving a start condition. Then it judges that if it matchs its own address by receiving one byte 
--! after the start condition detected. If it is matched, it will launch transmitter shift register or 
--! receiver shift register to work until receiving a stop condition.
--! To manage our shift_register, we have created three switchs.
-----------------------------------------------------------------
--! PENG Donghui
-----------------------------------------------------------------




--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! I2c_slave_engine entity brief description
--! Detailed description of this 
--! I2c_slave_engine design element.
entity I2c_slave_engine is

port(
		clk								: in std_logic;--! clock input			
		clk_ena							: in std_logic;--! clock_enable input		
		sync_rst						: in std_logic;--! synchronization reset input	
		SCL_in							: in STD_LOGIC;--! I2C clock line input
		SDA_in							: in STD_LOGIC;--! I2C data line input
		
		
		ctl_role_r						: in std_logic;--!read data from bit CTL_ROLE
		ctl_ack_r						: in std_logic;--!read data from bit CTL_ACK
		ctl_reset_r						: in std_logic;--!read data from bit CTL_RESET
		
		
		--status_rxfull_r: in std_logic;
		--status_txempty_r: in std_logic;		
		
		
		txdata							: in std_logic_vector (7 downto 0);--!read data from byte TX
		
		address							: in std_logic_vector (6 downto 0);--!read data from 7 bits OWN_ADDR
		
		sda_out							: out STD_LOGIC;--! means output from I2c_slave_engine to I2C data line 

		status_busy_w					: out std_logic;--! indicate the command of busy state
		status_busy						: out std_logic;--! indicate the situation of busy state
		status_rw						: out std_logic;--! indicate the situation of read or write state
		status_stop_detected_s			: out std_logic;--! indicate the situation of stop state
		status_start_detected_s			: out std_logic;--! indicate the situation of start state
		status_error_detected_s			: out std_logic;--! indicate the situation of error state
		status_rxfull_s					: out std_logic;--! indicate the situation of full RX
		status_txempty_s				: out std_logic;--! indicate the situation of empty TX
		status_ackrec_w					: out std_logic;--! means the command of ACK received
		status_ackrec					: out std_logic;--! means the situation of ACK received
		
		rxdata							: out std_logic_vector (7 downto 0);--!write data to byte RX
		
		interrupt_rw					: out std_logic;--! indicate read/write received update
		
		slave_address					: out std_logic_vector (6 downto 0)--!read data from 7 bits slave_address
		
	  );


end entity I2c_slave_engine;


--! @brief Architecture definition of the I2c_slave_engine
--! @details More details about this I2c_slave_engine element.
architecture fsm of I2c_slave_engine is

	
	
	--! Component scl_tick_generator
	component scl_tick_generator is

	generic( max_count	: positive := 8);
	
	port(	
		clk_50MHz	: in std_logic;--! clock input
		sync_rst	: in std_logic;--! synchronization reset input
		ena			: in std_logic;--! clock_enable input
		
		scl_tick	: out std_logic--! scl_tick output
		);	
		
	end component scl_tick_generator;
	
	

	--! Component Shift register transmitter
	component shift_register_transmitter is

	port( 
		clk				: in std_logic;--! clock input
		clk_ena			: in std_logic;--! clock_enable input
		sync_rst		: in std_logic;--! synchronization reset input
		TX				: in std_logic_vector (7 downto 0);--! TX register input	
		rising_point	: in std_logic;--! rising_point input
		sampling_point	: in std_logic;--! sampling_point input
		falling_point	: in std_logic;--! falling_point input
		writing_point	: in std_logic;--! writing_point input
		scl_tick		: in std_logic;--! scl_tick input
		sda_in			: in std_logic;--! sda_in input
		
		ACK_out			: out std_logic;--! ACK_out output
		ACK_valued		: out std_logic;--! ACK_valued output '1', To inform ACK_out is newly valued
		TX_captured		: out std_logic;--! TX_captured output, TX_captured = '1'  ==>  the buffer(byte_to_be_sent) captured the data from TX and Microcontroller could update TX register
		sda_out			: out std_logic--! sda_out output
		);				
		  
	end component shift_register_transmitter;
	
	
	--! Component Shift register receiver
	component shift_register_receiver is
	
	port(
		clk				: in std_logic;--! clock input
		clk_ena			: in std_logic;--! clock_enable input
		sync_rst		: in std_logic;--! synchronization reset input
		scl_tick		: in std_logic;--! scl_tick input
		sda_in			: in std_logic;--! sda_in input
		falling_point	: in std_logic;--! falling_point input
		sampling_point	: in std_logic;--! sampling_point input
		writing_point	: in std_logic;--! writing_point input
		ACK_in			: in std_logic;--! acknowledge bit input
		sda_out			: out std_logic;--! sda_out output
		ACK_sent		: out std_logic;--! ACK_sent output, triger a '1' when ACK is sent		
		data_received	: out std_logic;--! data_received bit output
		RX				: out std_logic_vector (7 downto 0)--! RX received byte output
		);
	 
	end component shift_register_receiver;
	
	--! Component Condition_detect
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
	
	--! Component SCL_detect
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


--! almost these signals used to connect components, and the last two signals for save address data and read/write data

	
	signal SCL_tick					: STD_LOGIC; 
	signal sda_out_t1				: STD_LOGIC;--! transmitter1 data line output
	signal sda_out_r1				: STD_LOGIC;--! receiver1 data line output
	signal sda_out_r2				: STD_LOGIC;--! receiver2 data line output
	
	signal SCL_rising_point 		: STD_LOGIC;
	signal SCL_stop_point			: STD_LOGIC;
	signal SCL_sample_point 		: STD_LOGIC;
	signal SCL_start_point 			: STD_LOGIC;
	signal SCL_falling_point 		: STD_LOGIC;
	signal SCL_write_point 			: STD_LOGIC;
	signal SCL_error_indication 	: STD_LOGIC;
	
	signal receiver1_switch			: STD_LOGIC:='0';--! to connect receiver1 sync_rst
	signal receiver2_switch			: STD_LOGIC:='0';--! to connect receiver2 sync_rst
	signal transmitter1_switch		: STD_LOGIC:='0';--! to connect transmitter1 sync_rst
	signal ACK_sent1				: STD_LOGIC;
	signal ACK_sent2				: STD_LOGIC;
	
	signal data_received1			: STD_LOGIC;
	signal RX1						: std_logic_vector (7 downto 0);	
	signal start_detected_point		: STD_LOGIC;
	signal stop_detected_point		: STD_LOGIC;
	signal error_detected_point		: STD_LOGIC;
						
	--signal address_received			: std_logic_vector (6 downto 0);--! to save address_received data	
	signal rw_received				: STD_LOGIC;--! to save read/write data

	
--! type t_state as 8 differents states: 
--! init,start,receiver1,receiver1_waiting,receiver2,transmitter1,stop,error
	type t_state is (INIT, start, receiver1,receiver1_waiting, receiver2, transmitter1, stop, error );
	signal state: t_state := INIT;

	
	
	
begin

	
			
	
	
	--! an instance of component scl_tick_generator	 
	Stg: scl_tick_generator
	port map(
	clk_50MHz => clk,
	sync_rst => sync_rst,
	ena => clk_ena,
	
	scl_tick => scl_tick
	);
	
	
	--! an instance of component shift_register_transmitter	 
	t1: shift_register_transmitter
	port map(
	clk => clk,
	clk_ena => clk_ena,
	sync_rst => transmitter1_switch,
	TX => txdata,		-- To connect with TX register
	rising_point => SCL_rising_point,
	sampling_point => SCL_sample_point,
	falling_point => SCL_falling_point,
	writing_point => SCL_write_point,
	scl_tick => scl_tick,
	sda_in => sda_in,
	
	sda_out => sda_out_t1,
	ACK_out => status_ackrec,
	ACK_valued => status_ackrec_w,
	TX_captured => status_txempty_s
	);
	
	--! an instance of component shift_register_receiver	 
	r1: shift_register_receiver
	port map(
	clk => clk,
	clk_ena => clk_ena,
	sync_rst => receiver1_switch,
	scl_tick => scl_tick,
	sda_in => sda_in,
	falling_point => SCL_falling_point,
	sampling_point => SCL_sample_point,
	writing_point => SCL_write_point,
	ACK_in => ctl_ack_r,
	
	sda_out => sda_out_r1, 				
	ACK_sent=> ACK_sent1,
	data_received => data_received1,
	RX => RX1	
	);
	 
	--! an instance of component shift_register_receiver	 
	r2: shift_register_receiver
	port map(
	clk => clk,
	clk_ena => clk_ena,
	sync_rst => receiver2_switch,
	scl_tick => scl_tick,
	sda_in => sda_in,
	falling_point => SCL_falling_point,
	sampling_point => SCL_sample_point,
	writing_point => SCL_write_point,
	ACK_in => ctl_ack_r,
	
	sda_out => sda_out_r2, 				
	ACK_sent=> ACK_sent2,
	data_received => status_rxfull_s,
	RX => rxdata -- To connect with rxdata register
	);
	
	--! an instance of component Condition_detect 
	Cd: Condition_detect
	port map(
	clk => clk,
	clk_ena => clk_ena,
	sync_rst => sync_rst,
	SCL_in => scl_in,
	SDA_in => SDA_in,
	
	start_detected_point => start_detected_point,
	stop_detected_point => stop_detected_point,
	error_detected_point => error_detected_point
	);
	 
	--! an instance of component SCL_detect 
	Sd: SCL_detect
	port map(  
	sync_rst => sync_rst,
	clk => clk, 
	clk_ena => clk_ena, 
	SCL_in => SCL_in,
	SCL_tick => scl_tick,
				
	SCL_stop_point => SCL_stop_point,
	SCL_start_point => SCL_start_point,
	SCL_rising_point => SCL_rising_point,
	SCL_falling_point => SCL_falling_point,
	SCL_sample_point => SCL_sample_point,
	SCL_write_point => SCL_write_point,
	SCL_error_indication => SCL_error_indication
	);


--! @brief Process transitions_and_storage of the Architecture
--! @details More details about this transitions_and_storage element.			
transitions_and_storage: process (clk) is
	
begin 

if(rising_edge(clk)) then
	if(clk_ena = '1') then
		if ( (sync_rst = '1') and (ctl_reset_r = '1') )then
			
				if(ctl_role_r = '0') then
--! transfer the state depend on the value of state current and transtions					
					case state is	 
						
					when INIT =>--! state current is init
						if (start_detected_point = '1') then--! transfer to the start state 
							state <= start;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state 
							state <= error;
						end if;
					
					when start =>--! state current is start
						if (SCL_falling_point= '1') then--! transfer to the receiver1 state
						state <= receiver1;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state 
							state <= error;
						end if;
							
					when receiver1 =>--! state current is receiver1
						
						if  (data_received1 = '1') then--! transfer to the receiver1_waiting state
							state <= receiver1_waiting;
						
						else 
							state <= receiver1;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state 
							state <= error;
						end if;
					
					
					
					when receiver1_waiting=>--! state current is receiver1_waiting
						if (ACK_sent1 = '1') then
							if(ctl_ack_r = '0') then 
								if (rw_received = '0') then--! transfer to the receiver2 state 
								state <= receiver2;
								end if;
							
								if (rw_received = '1') then--! transfer to the transmitter1 state 
								state <= transmitter1;
								end if;
							else
								state <= INIT;--! indicate the address received is not match
							end if;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state
							state <= error;
						end if;
						
					when receiver2 =>--! state current is receiver2
						if (stop_detected_point = '1') then--! transfer to the stop state 
							state <= stop;
						else 
							state <= receiver2;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state 
							state <= error;
						end if;
						
					when transmitter1 =>--! state current is transmitter1 
						if (stop_detected_point = '1') then--! transfer to the stop state 
							state <= stop;
						else
							state <= transmitter1;
						end if;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state 
							state <= error;
						end if;
					
					when stop =>--! state current is stop 
						state <= INIT;
						
						if ((SCL_error_indication = '1') or (error_detected_point = '1')) then--! transfer to the error state 
							state <= error;
						end if;
					
					when error =>--! state current is error 
						if(sync_rst = '0') then--! transfer to the init state 
							state <= init;
						end if;
					
					end case;
				else
				
					state <= INIT;--! if ctl_role_r equal to 1 , state transfer to init 
					
				end if;
			
		else
			state <= INIT;--! if synchronization reset equal to 0 , state transfer to init 
		end if;
	end if;
end if;

end process transitions_and_storage;	 



--! @brief Process stateaction of the Architecture
--! @details More details about this stateaction element.
stateaction: process (state) is
	
begin
--! Default values for all combinational outputs calculated
--! by this process
		receiver1_switch <= '0';
		receiver2_switch <= '0';
		transmitter1_switch <= '0';
		
        status_busy_w <= '1';
		status_busy <= '1';
		status_rw <= rw_received;
		status_stop_detected_s <= '0';
		status_start_detected_s <= '0';
		status_error_detected_s <= '0';
		
		interrupt_rw <= '0' ;
		
--! task for each state				
case state is
		
		when INIT => 
			status_busy <= '0';--! means the slave is not busy	
		
		when start => 
			status_start_detected_s <= '1';--! means the slave has detected a start condition
			
			
		when receiver1 =>
			
			receiver1_switch <= '1';--! opening the switch of component receiver1
			
		when receiver1_waiting => 
			interrupt_rw <= '1';--! active interrupt read/write received
			receiver1_switch <= '1';--! opening the switch of component receiver1	
			rw_received <= RX1(0);--!save read/write data into rw_received signal
			slave_address <= RX1(7 downto 1);--!save address data into address_received signal
			
		
		when receiver2 => 
			receiver2_switch <= '1';--! opening the switch of component receiver2
			
			
		when transmitter1 => 
			transmitter1_switch <= '1';--! opening the switch of component transmitter1

		when stop =>
			status_busy <= '0';--! means the slave is not busy again
			status_stop_detected_s <= '1';--! means the slave has detected a stop condition
				
		when error =>
			status_error_detected_s <= '1';--! means the slave has detected an error 
					
		end case;
	
	end process stateaction;
	
	
--! use logic 'and' to combinate those outputs of shift_registers into I2C data line 	
sda_out <= sda_out_r1 and sda_out_r2 and sda_out_t1;
	
	
end architecture fsm;

