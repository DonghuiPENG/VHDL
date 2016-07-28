-------------------------------------------------------
--! @file
--! @brief Condition_detect :
--! This entity with synchronization reset is used to separate the SCL_tick in differents 
--! states according to SCL_in. It's just like simulating those point on the period of SCL_in.
--! It's not the real point like its meanings. In fact, there are 10 SCL_tick periods in one 
--! SCL_in period. We are defining certains SCL_tick period as certains points of SCL_in period.
--! It's just like naming those SCL_ticks to be used in the future.
--! On SCL_in low level, there are two sequence points like falling and write. On SCL_in high level, there
--! are four sequence points like rising,stop,sample and start. All of these points would hold on its value
--! on one SCL_tick period. 
--! If there are more than 5 SCL_tick periods in half SCL_in period, it will stay on the waiting state to 
--! wait for the SCL_in level changes. If there are less than 5 SCL_tick periods in half SCL_in period, it
--! will transfer to error state.
--! First, it need to judge the SCL_in level to start its special points. Then, it would transfer its state  
--! one by one in each SCL_tick period. It always works until the SCL_in signal disappear. Or it transfer to 
--! init state when synchronization reset equals to '0'.
-------------------------------------------------------
--! \image html SCL_detect.svg
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------

--! SCL_detect entity brief description
--! Detailed description of this 
--! SCL_detect design element.
entity SCL_detect is
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
          
end SCL_detect;

--! @brief Architecture definition of the SCL_detect
--! @details More details about this SCL_detect element.
architecture fsm of SCL_detect is

--! type t_state as 11 differents states: 
--! init,stop,start,rising,falling,sample,writing,waiting,waiting1,waiting2,error
type t_state is ( 
init,stop,start,rising,falling,sample,writing,waiting,waiting1,waiting2,error);
 
signal state: t_state ;

	
begin


--! @brief Process transitions_and_storage of the Architecture
--! @details More details about this transitions_and_storage element.
transitions_and_storage: process (clk) is
	
begin
	   
if (rising_edge(clk)) then
	if (clk_ena = '1') then
--! transfer the state depend on the value of state current and transtions			
		case state is 
			
			when init  =>--! state current is init
			
				if ((SCL_tick = '1') and (SCL_in = '1')) then--! transfer to the rising state
				state <= rising;
				end if;
			
				if ((SCL_tick = '1') and (SCL_in = '0')) then--! transfer to the falling state
				state <= falling;
				end if;
				
			
			when rising =>--! state current is rising
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then --! transfer to the stop state
				state <= stop;
				end if;
				
				if (SCL_in = '0') then--! transfer to the error state
				state <= error;
				end if;
			
			when stop =>--! state current is stop
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then --! transfer to the sample state
				state <= sample;
				end if;

				if (SCL_in = '0') then--! transfer to the error state
				state <= error;
				end if;
			
			
			when sample =>--! state current is sample
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then --! transfer to the start state
				state <= start;
				end if;

				if (SCL_in = '0') then--! transfer to the error state
				state <= error;
				end if;
			
			
			when start =>--! state current is start
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then --! transfer to the waiting state
				state <= waiting;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '0'))then --! transfer to the falling state
				state <= falling;
				end if;
			

			when waiting =>--! state current is waiting
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then --! keep on the same state 
				state <= waiting;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '0'))then --! transfer to the falling state
				state <= falling;
				end if;
			
			
			when falling =>--! state current is falling
				if ((SCL_tick = '1') and (SCL_in = '0'))  then --! transfer to the waiting1 state
				state <= waiting1;
				end if;

				if (SCL_in = '1') then--! transfer to the error state
				state <= error;
				end if;
				
			
			when waiting1 =>--! state current is waiting1
				
				if ((SCL_tick = '1') and (SCL_in = '0'))  then  --! transfer to the writing state
				state <= writing;
				end if;

				if (SCL_in = '1') then--! transfer to the error state
				state <= error;
				end if;
			
				
			
			when writing =>--! state current is writing
				
				if ((SCL_tick = '1') and (SCL_in = '0'))  then  --! transfer to the waiting2 state
				state <= waiting2;
				end if;

				if (SCL_in = '1') then--! transfer to the error state
				state <= error;
				end if;
				

			when waiting2 =>--! state current is waiting2
				
				if ((SCL_tick = '1') and (SCL_in = '0')) then --! keep on the same state 
				state <= waiting2;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then --! transfer to the rising state
				state <= rising;
				end if;
				
			when error =>--! state current is error
				
				if (sync_rst = '0') then --! transfer to the init state
				state <= init;
				end if;

		end case ;
		
	
--! if synchronization reset equal to 0 , state transfer to init 						
		if (sync_rst = '0') then
	
		state <= init;
	
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
               SCL_stop_point <= '0';
               SCL_start_point  <= '0';
               SCL_rising_point  <= '0';
               SCL_falling_point  <= '0';
               SCL_sample_point  <= '0';
               SCL_write_point  <= '0';
               SCL_error_indication  <= '0';

--! task for each state			
	case state is
		
		when init => --! do nothing
			NULL;
		
		when rising => --! means this SCL_tick named rising
			SCL_rising_point <= '1';
			
		when stop => --! means this SCL_tick named stop
			SCL_stop_point <= '1';
		
		when sample => --! means this SCL_tick named sample
			SCL_sample_point <= '1';
			
		when start => --! means this SCL_tick named start
			SCL_start_point <= '1';
			
		when waiting =>--! do nothing
			NULL;
					
		when falling => --! means this SCL_tick named falling
			SCL_falling_point <= '1';
	
		when waiting1 => --! do nothing
			NULL;
					
		when writing => --! means this SCL_tick named writing
			SCL_write_point <= '1';
				
		when waiting2 => --! do nothing
			NULL;

		when error =>--! means there has an error
			SCL_error_indication <= '1';

	end case;
	
end process stateaction;
	
end architecture fsm;