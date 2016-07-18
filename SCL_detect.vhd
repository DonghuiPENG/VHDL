library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SCL_detect is

    Port ( sync_rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           clk_ena : in  STD_LOGIC;
           SCL_in : in  STD_LOGIC;
			  SCL_tick : in  STD_LOGIC;
			  
			  SCL_rising_point : out  STD_LOGIC;
			  SCL_stop_point : out  STD_LOGIC;
			  SCL_sample_point : out  STD_LOGIC;
			  SCL_start_point : out  STD_LOGIC;
			  SCL_falling_point : out  STD_LOGIC;
			  SCL_write_point : out  STD_LOGIC;
			  SCL_error_point : out  STD_LOGIC
			  );
          
end SCL_detect;

architecture fsm of SCL_detect is
	type t_state is ( 
	init,
	stop,start,rising,falling,sample,writing,waiting,waiting1,waiting2,error);
 
	signal state: t_state ;
	--signal token : STD_LOGIC := '0';

	
begin


	
	transitions_and_storage: process (clk) is
	
	
	begin
	   
		if (rising_edge(clk)) then
			if (clk_ena = '1') then
		
		case state is 
			
			when init  =>
			
				if ((SCL_tick = '1') and (SCL_in = '1')) then
				state <= rising;
				end if;
			
				if ((SCL_tick = '1') and (SCL_in = '0')) then
				state <= falling;
				end if;
				
			--case state is 
			
			when rising =>
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= stop;
				end if;
				
				if (SCL_in = '0') then
				state <= error;
				end if;
			
			when stop =>
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= sample;
				end if;

				if (SCL_in = '0') then
				state <= error;
				end if;
			
			
			when sample =>
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= start;
				end if;

				if (SCL_in = '0') then
				state <= error;
				end if;
			
			
			when start =>
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= waiting;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '0'))then 
				state <= falling;
				end if;
			

			when waiting =>
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= waiting;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '0'))then 
				state <= falling;
				end if;
			
			
			when falling =>
				if ((SCL_tick = '1') and (SCL_in = '0'))  then 
				state <= waiting1;
				end if;

				if (SCL_in = '1') then
				state <= error;
				end if;
				
			
			when waiting1 =>
				
				if ((SCL_tick = '1') and (SCL_in = '0'))  then 
				state <= writing;
				end if;

				if (SCL_in = '1') then
				state <= error;
				end if;
			
				
			
			when writing =>
				
				if ((SCL_tick = '1') and (SCL_in = '0'))  then 
				state <= waiting2;
				end if;

				if (SCL_in = '1') then
				state <= error;
				end if;
				

			when waiting2 =>
				
				if ((SCL_tick = '1') and (SCL_in = '0')) then 
				state <= waiting2;
				end if;
				
				if ((SCL_tick = '1') and (SCL_in = '1')) then 
				state <= rising;
				end if;
				
			when error =>
				
				if (sync_rst = '0') then 
				state <= init;
			--	token  <= '0';
				end if;

		end case ;
		
		end if;
					
		if (sync_rst = '0') then
		state <= init;
		--token  <= '0';
		end if;
	
		end if;

	
	end process transitions_and_storage;
	
	
	
	stateaction: process (state) is
	
	begin
	            -- Default values for all combinational outputs calculated
               -- by this process
               SCL_stop_point <= '0';
               SCL_start_point  <= '0';
               SCL_rising_point  <= '0';
               SCL_falling_point  <= '0';
               SCL_sample_point  <= '0';
               SCL_write_point  <= '0';
               SCL_error_point  <= '0';
				
		case state is
		
			when init => 
			  NULL;
		
			when rising => 
				SCL_rising_point <= '1';
				--token <= '1';
			
			when stop => 
				SCL_stop_point <= '1';
			--	token <= '1';
		
			when sample => 
				SCL_sample_point <= '1';
				--token <= '1';
			
			when start => 
				SCL_start_point <= '1';
				--token <= '1';

			when waiting =>
				NULL;
				--token <= '1';
					
			when falling => 
				SCL_falling_point <= '1';
				--token <= '1';
	
			when waiting1 => 
				NULL;
				--token <= '1';
					
			when writing => 
				SCL_write_point <= '1';
				--token <= '1';
				
			when waiting2 => 
				NULL;
				--token <= '1';

			when error =>
				SCL_error_point <= '1';
			--token <= '1';

		end case;
	
	end process stateaction;
	
end architecture fsm;