-------------------------------------------------------
--! @file
--! @brief cascadable_counter :
--! This entity with synchronization reset
--! is used to count a loop number from zero to maximum value. By the way,
--! we can change the maximum value by change the value on generic.
--! When the number counted arrive to the maximum value,the output
--! 'count' need to be set on zero. At the same time, output 'cascade_out'
--! would be set on one for one period. When the 'count' keep on counting,
--! 'cascade_out' would be set on zero.
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;


------------------------------------------------------------

--! cascadable_counter entity brief description
--! Detailed description of this 
--! cascadable_counter design element.
entity cascadable_counter is
	generic ( divisor : positive := 2); 
	 
    Port( 
		clk 			:in  STD_LOGIC;--! clock input
        clk_ena 		:in  STD_LOGIC;--! clock_enable input
		sync_rst 		:in  STD_LOGIC;--! synchronization reset input
        cascade_in 		:in  STD_LOGIC;--! cascade_in input
        
		count 			:out  integer range 0 to (divisor-1);--! count by variable
        cascade_out 	:out  STD_LOGIC--! maximum count then works
		);
end cascadable_counter;

--! @brief Architecture definition of the cascadable_counter
--! @details More details about this cascadable_counter element.
architecture fsm of cascadable_counter is
 
	signal count_state: integer range 0 to (divisor-1);

begin

--! @brief Process transitions_and_storage of the Architecture
--! @details More details about this transitions_and_storage element.	
transitions_and_storage: process (clk) is
	
begin
	   
if rising_edge(clk) then
	if (clk_ena = '1')then
		if(cascade_in = '1') then
			if(count_state = (divisor-1)) then--! when 'count_state' reach maximum value, it assign the 'count_state' to 0 
			count_state <= 0;
			else
			count_state <= count_state + 1;--! count one by one each time 
			end if;
		end if;

		if (sync_rst = '0')then --! if the sync_rst equal to '0', after the rising_edge, we'll reset the count_state
		count_state <= 0;
		end if;
	end if;
end if;
	count<=count_state;
	
end process transitions_and_storage;
	
	
--! @brief Process stateaction of the Architecture
--! @details More details about this stateaction element.	
stateaction: process (count_state) is
	
begin
	if(count_state = 0 ) then--! have action in the count_state equals to 0
	cascade_out <= '1';
	else
	cascade_out <= '0';--! do nothing in the others states
	end if;

end process stateaction;
end architecture fsm;