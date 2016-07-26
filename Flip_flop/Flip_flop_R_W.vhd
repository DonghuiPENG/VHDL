-------------------------------------------------------
--! @file
--! @brief Flip_flop_R_W :flip_flop for a port can be used to
--! read by microcontrolleur and write by I2C
-------------------------------------------------------

--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------

--! Flip_flop_R_W entity brief description
--! Detailed description of this 
--! Flip_flop_R_W design element.
entity Flip_flop_R_W is

Port( 
	clk 				: in  STD_LOGIC;
    clk_ena 			: in  STD_LOGIC;
	sync_rst 			: in  STD_LOGIC;
	i2c_write 			: in  STD_LOGIC;
	i2c_data_in 		: in  STD_LOGIC;
			  
	uc_read 			: out  STD_LOGIC
	);
          
end Flip_flop_R_W;

--! @brief Architecture definition of the Flip_flop_R_W
--! @details More details about this Flip_flop_R_W element.
architecture Behavioral of Flip_flop_R_W is

begin

--! @brief Process combination of the Architecture
--! @details More details about this combination element.
combination: process (clk) is

begin
	if (rising_edge(clk)) then
		if (clk_ena = '1') then
			if (sync_rst = '1') then
				if( i2c_write = '1') then
				uc_read <= i2c_data_in;
				end if;
			else
			uc_read <= '0';		
			end if;	
		end if;
	end if;
end process combination;
	
end architecture Behavioral;