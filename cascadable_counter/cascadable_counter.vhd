library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cascadable_counter is
	 generic ( divisor : positive := 8); 
	 
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ena : in  STD_LOGIC;
           cascade_in : in  STD_LOGIC;
           count : out  integer range 0 to (divisor-1);
           cascade_out : out  STD_LOGIC);
end cascadable_counter;

architecture fsm of cascadable_counter is

	 
	signal count_state: integer range 0 to (divisor-1);
begin
	
	


	
	transitions_and_storage: process (clk,ena) is
	
	variable count_var: integer range 0 to (divisor-1):=0;
	
	begin
	   
		if (rising_edge(clk) and (ena = '1'))then

		
			if(cascade_in = '1') then
				if(count_var = (divisor-1)) then
					count_var := 0;
				else
					count_var := count_var + 1;
				end if;
				
			if (rst = '0')then
			count_var := 0;
			end if;
				
			end if;
		end if;
	count<=count_var;
	count_state<=count_var;
	end process transitions_and_storage;
	
	
	
	stateaction: process (count_state) is
	
	begin
		if(count_state = 0 ) then
				cascade_out <= '1';
			else
				cascade_out <= '0';
		end if;
	end process stateaction;
end architecture fsm;