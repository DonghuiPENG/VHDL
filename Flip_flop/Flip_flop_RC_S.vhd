-------------------------------------------------------
--! @file
--! @brief Flip_flop_RC_S :
--! This entity with synchronization reset is uesd to perform a special port. 
--!	It could be read or cleared by microcontroller and writen by I2C. 
--! That means if microcontroller set 'uc_clear' on one, it 
--! would set the output on zero. If I2C set 'i2c_set' on one, it 
--! would set the output on one. It just likes its set fonction.
--! Then we can use its output as the input of microcontroller. 
--! It likes read by microcontroller.
-------------------------------------------------------

--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------
--! Flip_flop_RC_S entity brief description
--! Detailed description of this 
--! Flip_flop_RC_S design element.
entity Flip_flop_RC_S is

    Port( 
		clk 			: in  STD_LOGIC;
        clk_ena 		: in  STD_LOGIC;
		sync_rst 		: in  STD_LOGIC;
        uc_clear 		: in  STD_LOGIC;
		i2c_set 		: in  STD_LOGIC;
			  
		data_out 		: out  STD_LOGIC
		);
          
end Flip_flop_RC_S;

--! @brief Architecture definition of the Flip_flop_RC_S
--! @details More details about this Flip_flop_RC_S element.
architecture Behavioral of Flip_flop_RC_S is

begin

--! @brief Process combination of the Architecture
--! @details More details about this combination element.
combination: process (clk) is

begin
	if (rising_edge(clk)) then
		if (clk_ena = '1') then
			if (sync_rst = '1') then
				if( uc_clear = '1') then--! if uc_clear act, output equals to '0'
				data_out <= '0';
				elsif (i2c_set ='1' )then--! if i2c_set act, output equals to '1'
				data_out <= '1';
				end if;		
			else
			data_out <= '0';--!if sync_rst equals to '0', that means reset, then output equals to '0'
			end if;
		end if;
	end if;

end process combination;
	
end architecture Behavioral;