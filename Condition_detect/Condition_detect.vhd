-------------------------------------------------------
--! @file
--! @brief Condition_detect :detect those conditions from master
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
	 
    start_detected_point    : out  STD_LOGIC;--! detected start output
	stop_detected_point     : out  STD_LOGIC;--! detected stop output
	error_detected_point    : out  STD_LOGIC --! detected error output
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
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= start_detecting;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= stop_detecting;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
				
				
			when start_detecting  =>--! state current is start_detecting
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= start_detecting;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
			
			when start_detected  =>--! state current is start_detected
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= error;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
				
				
			when stop_detecting  =>--! state current is stop_detecting
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= stop_detected;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= stop_detecting;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
				
			when stop_detected  =>--! state current is stop_detected
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= stop_detected;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
			
			when error  =>--! state current is error
			
				if (SCL_in = '0')then
				state <= init;
				end if;
			
		end case;

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
               start_detected_point <= '0';
               stop_detected_point  <= '0';
               error_detected_point <= '0';
--! task for each state				
case state is
		
		when init => 
				NULL;
		
		when start_detecting => 
				NULL;
			
		when start_detected => 
				start_detected_point <= '1';
		
		when stop_detecting => 
				NULL;
			
		when stop_detected => 
				stop_detected_point <= '1';

		when error =>
				error_detected_point <= '1';
					
		end case;
	
	end process stateaction;
	
end architecture fsm;

