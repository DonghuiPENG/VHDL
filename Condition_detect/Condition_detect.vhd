-------------------------------------------------------
--! @file
--! @brief Condition_detect : 
--! This entity with synchronization reset is used to
--! detect the condition of action from master by line SCL and SDA.
--! According to the protocol of I2C, we need to use these two lines inputs.
--! First, we need to judge the SDA data on every SCL high level. There are 
--! also three outputs to indicate these conditions. Stop condition means SDA 
--! from zero to one, start condition means SDA from one to zero. Start condition
--! could be acted after the stop condition on the same SCL high level, that 
--! means restart condition. It's same as a stop with a start. But, it can't act
--! the stop condition after the start condition , that makes no sense. And the  
--! state will transfer to init state. If it's on SCL low level, it would also 
--! transfer to init state and waiting for the next judgement.
-------------------------------------------------------
--! \image html Condition_detect.svg
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------

--! Condition_detect entity brief description
--! Detailed description of this 
--! Condition_detect design element.
entity Condition_detect is

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
	 
end entity Condition_detect;

--! @brief Architecture definition of the Condition_detect
--! @details More details about this Condition_detect element.
architecture fsm of Condition_detect is

--! type t_state as 6 differents states: 
--! init,start_detecting,start_detected,stop_detecting,stop_detected,error.
type t_state is ( 
init,start_detecting,start_detected,stop_detecting,stop_detected,error);
 
signal state: t_state ;

begin


--! @brief Process transitions_and_storage of the Architecture
--! @details More details about this transitions_and_storage element.
transitions_and_storage: process (clk) is

begin

if (rising_edge(clk))then
	if(clk_ena = '1') then
--! transfer the state depend on the value of state current and transtions	
		case state is 
			
			when init  =>--! state current is init
			
				if ((SCL_in = '1') and (SDA_in = '1')) then--! waiting the start condition state
				state <= start_detecting;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then--! waiting the stop condition state
				state <= stop_detecting;
				end if;
				
				if (SCL_in = '0')then--! return to init state
				state <= init;
				end if;
				
				
			when start_detecting  =>--! state current is start_detecting
			
				if ((SCL_in = '1') and (SDA_in = '1')) then--! keep on the same state 
				state <= start_detecting;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then--! transfer to the start condition state
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then--! return to init state
				state <= init;
				end if;
			
			when start_detected  =>--! state current is start_detected
			
				if ((SCL_in = '1') and (SDA_in = '1')) then--! transfer to error state
				state <= error;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then--! keep on the same state
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then--! return to init state
				state <= init;
				end if;
				
				
			when stop_detecting  =>--! state current is stop_detecting
			
				if ((SCL_in = '1') and (SDA_in = '1')) then--! transfer to the stop condition state
				state <= stop_detected;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then--! keep on the same state
				state <= stop_detecting;
				end if;
				
				if (SCL_in = '0')then--! return to init state
				state <= init;
				end if;
				
			when stop_detected  =>--! state current is stop_detected
			
				if ((SCL_in = '1') and (SDA_in = '1')) then--! transfer to the stop condition state
				state <= stop_detected;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then--! transfer to the start condition state
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then--! return to init state
				state <= init;
				end if;
			
			when error  =>--! state current is error
			
				if (SCL_in = '0')then--! return to init state
				state <= init;
				end if;
			
		end case;

	
--! if synchronization reset equals to 0 , state transfer to init state	
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
               start_detected_point <= '0';
               stop_detected_point  <= '0';
               error_detected_point <= '0';
--! task for each state				
case state is
		
		when init => --! do nothing
				NULL;
		
		when start_detecting => --! do nothing
				NULL;
			
		when start_detected => --! means detect start condition
				start_detected_point <= '1';
		
		when stop_detecting => --! do nothing
				NULL;
			
		when stop_detected => --! means detect stop condition
				stop_detected_point <= '1';

		when error =>--! means detect error condition
				error_detected_point <= '1';
					
		end case;
	
	end process stateaction;
	
end architecture fsm;

