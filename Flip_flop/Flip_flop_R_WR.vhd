-------------------------------------------------------
--! @file
--! @brief Flip_flop_R_WR :
--! This entity with synchronization reset is uesd to perform a special port. 
--!	It could be read by microcontroller and writen by I2C. That means if I2C set
--! 'i2c_write' on one, it would put the data of 'i2c_data_in' into the output 'uc_read'.
--! It could be one or zero.It just likes its write fonction.
--!	Then we can use its output as the input of microcontroller. 
--! It likes read by microcontroller.
-------------------------------------------------------

--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

------------------------------------------------------------

--! Flip_flop_R_WR entity brief description
--! Detailed description of this 
--! Flip_flop_R_WR design element.
entity Flip_flop_R_WR is

Port( 
	clk 				: in  STD_LOGIC;
    clk_ena 			: in  STD_LOGIC;
	sync_rst 			: in  STD_LOGIC;
	i2c_write 			: in  STD_LOGIC;
	i2c_data_in 		: in  STD_LOGIC;
			  
	data_out 			: out  STD_LOGIC
	);
          
end Flip_flop_R_WR;

--! @brief Architecture definition of the Flip_flop_R_WR
--! @details More details about this Flip_flop_R_WR element.
architecture Behavioral of Flip_flop_R_WR is

begin

--! @brief Process combination of the Architecture
--! @details More details about this combination element.
combination: process (clk) is

begin
	if (rising_edge(clk)) then
		if (clk_ena = '1') then
			if (sync_rst = '1') then
				if( i2c_write = '1') then
				data_out <= i2c_data_in;
				end if;
			else
			data_out <= '0';	--!if sync_rst equals to '0', that means reset, then output equals to '0'	
			end if;	
		end if;
	end if;
end process combination;
	
end architecture Behavioral;