-------------------------------------------------------
--! @file
--! @brief Condition_detect :detect those states from I2C clock line
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
        clk : 					in  STD_LOGIC;--! clock input
        clk_ena : 				in  STD_LOGIC;--! clock_enable input
		sync_rst : 				in  STD_LOGIC;--! synchronization reset input
        SCL_in : 				in  STD_LOGIC;--! I2C clock line input
		SCL_tick : 				in  STD_LOGIC;--! tick clock line input
			  
		SCL_rising_point : 		out  STD_LOGIC;--! detected SCL_rising_point output
		SCL_stop_point : 		out  STD_LOGIC;--! detected SCL_stop_point output
		SCL_sample_point : 		out  STD_LOGIC;--! detected SCL_sample_point output
		SCL_start_point : 		out  STD_LOGIC;--! detected SCL_start_point output
		SCL_falling_point : 	out  STD_LOGIC;--! detected SCL_falling_point output
		SCL_write_point : 		out  STD_LOGIC;--! detected SCL_write_point output
		SCL_error_point : 		out  STD_LOGIC --! detected SCL_error_point output
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
			
				if ((SCL_tick = '1') and (SCL_in = '1')) then
				state <= rising;
				end if;
			
				if ((SCL_tick = '1') and (SCL_in = '0')) then
				state <= falling;
				end if;
				
			
			when rising =>--! state current is rising
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= stop;
				end if;
				
				if (SCL_in = '0') then
				state <= error;
				end if;
			
			when stop =>--! state current is stop
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= sample;
				end if;

				if (SCL_in = '0') then
				state <= error;
				end if;
			
			
			when sample =>--! state current is sample
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= start;
				end if;

				if (SCL_in = '0') then
				state <= error;
				end if;
			
			
			when start =>--! state current is start
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= waiting;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '0'))then 
				state <= falling;
				end if;
			

			when waiting =>--! state current is waiting
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= waiting;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '0'))then 
				state <= falling;
				end if;
			
			
			when falling =>--! state current is falling
				if ((SCL_tick = '1') and (SCL_in = '0'))  then 
				state <= waiting1;
				end if;

				if (SCL_in = '1') then
				state <= error;
				end if;
				
			
			when waiting1 =>--! state current is waiting1
				
				if ((SCL_tick = '1') and (SCL_in = '0'))  then 
				state <= writing;
				end if;

				if (SCL_in = '1') then
				state <= error;
				end if;
			
				
			
			when writing =>--! state current is writing
				
				if ((SCL_tick = '1') and (SCL_in = '0'))  then 
				state <= waiting2;
				end if;

				if (SCL_in = '1') then
				state <= error;
				end if;
				

			when waiting2 =>--! state current is waiting2
				
				if ((SCL_tick = '1') and (SCL_in = '0')) then 
				state <= waiting2;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= rising;
				end if;
				
			when error =>--! state current is error
				
				if (sync_rst = '0') then 
				state <= init;
				end if;

		end case ;
		
	end if;
--! if synchronization reset equal to 0 , state transfer to init 						
	if (sync_rst = '0') then
	
	state <= init;
	
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
               SCL_error_point  <= '0';

--! task for each state			
	case state is
		
		when init => 
			NULL;
		
		when rising => 
			SCL_rising_point <= '1';
			
		when stop => 
			SCL_stop_point <= '1';
		
		when sample => 
			SCL_sample_point <= '1';
			
		when start => 
			SCL_start_point <= '1';
			
		when waiting =>
			NULL;
					
		when falling => 
			SCL_falling_point <= '1';
	
		when waiting1 => 
			NULL;
					
		when writing => 
			SCL_write_point <= '1';
				
		when waiting2 => 
			NULL;

		when error =>
			SCL_error_point <= '1';

	end case;
	
end process stateaction;
	
end architecture fsm;