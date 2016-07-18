library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
entity Condition_detect is

  port (
    clk							: in STD_LOGIC;
	 clk_ena						: in STD_LOGIC;
	 sync_rst					: in STD_LOGIC;
	 SCL_in 			         : in STD_LOGIC;
    SDA_in             		: in STD_LOGIC;
	 
    start_detected_point         : out  STD_LOGIC;
	 stop_detected_point          : out  STD_LOGIC;
	 error_detected_point         : out  STD_LOGIC); 
	 
end entity Condition_detect;

architecture fsm of Condition_detect is

type t_state is ( 
init,start_detecting,start_detected,stop_detecting,stop_detected,error);
 
signal state: t_state ;

begin



transitions_and_storage: process (clk) is

begin

if (rising_edge(clk))then
	if(clk_ena = '1') then
	
		case state is 
			
			when init  =>
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= start_detecting;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= stop_detecting;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
				
				
			when start_detecting  =>
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= start_detecting;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
			
			when start_detected  =>
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= error;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
				
				
			when stop_detecting  =>
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= stop_detected;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= stop_detecting;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
				
			when stop_detected  =>
			
				if ((SCL_in = '1') and (SDA_in = '1')) then
				state <= stop_detected;
				end if;
			
				if ((SCL_in = '1') and (SDA_in = '0')) then
				state <= start_detected;
				end if;
				
				if (SCL_in = '0')then
				state <= init;
				end if;
			
			when error  =>
			
				if (SCL_in = '0')then
				state <= init;
				end if;
			
		end case;

	end if;
	
	if (sync_rst = '0') then 
	
	state <= init;
	
	end if;
	
end if;

end process transitions_and_storage;





stateaction: process (state) is
	
begin
	            -- Default values for all combinational outputs calculated
               -- by this process
               start_detected_point <= '0';
               stop_detected_point  <= '0';
               error_detected_point <= '0';
				
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

