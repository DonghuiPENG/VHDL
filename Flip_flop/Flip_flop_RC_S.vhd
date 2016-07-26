-------------------------------------------------------
--! @file
--! @brief Flip_flop_RC_S :flip_flop for a port can be used to
--! read or clear by microcontrolleur and set by I2C
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
			  
		uc_read 		: out  STD_LOGIC
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
				if( uc_clear = '1') then
				uc_read <= '0';
				elsif (i2c_set ='1' )then
				uc_read <= '1';
				end if;		
			else
			uc_read <= '0';
			end if;
		end if;
	end if;

end process combination;
	
end architecture Behavioral;