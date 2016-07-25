library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Flip_flop_R_W is

    Port ( clk : in  STD_LOGIC;
           clk_ena : in  STD_LOGIC;
			  sync_rst : in  STD_LOGIC;
			  i2c_write : in  STD_LOGIC;
			  i2c_data_in : in  STD_LOGIC;
			  
			  uc_read : out  STD_LOGIC
			  );
          
end Flip_flop_R_W;

architecture Behavioral of Flip_flop_R_W is

begin

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