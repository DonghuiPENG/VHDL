-- Cascadable counter to generate the clock enable signal
-- To use for the testbench of max_cycles.vhd(tb_max_cycles.vhd)
-- With synchronous reset
-- 22/06/2016

library ieee;
use ieee.std_logic_1164.all;

entity cascadable_counter is

	generic(max_count: positive := 2);
	port (clk: in std_logic;
			ena: in std_logic;
			sync_rst:in std_logic;
			casc_in: in std_logic;
			count: out integer range 0 to (max_count-1);
			casc_out: out std_logic
			);
			
end entity cascadable_counter;

architecture fsm of cascadable_counter is

	signal count_state: integer range 0 to (max_count-1);   -- define and initialize the signal

begin

	transitions_and_strorage: process(clk, ena, sync_rst) is

	begin
	if(rising_edge(clk)) then
		if((sync_rst = '1') )then
			if(ena = '1') then

				if(count_state = (max_count-1)) then
					count_state <= 0;
					count <= 0;
				else
					count_state <= count_state + 1;
					count <= count_state + 1;
				end if;
				
			else
				count_state <= count_state;
				count <= count_state;
			end if;
		else
			count_state <= 0;	
			count <= 0;
		end if;
		
	end if;
	
	end process transitions_and_strorage;

	--
	--
	transitactions: process (count_state, casc_in, ena, sync_rst, clk) is
	begin

	  if((count_state = 0 and casc_in = '1') and ((ena = '1') and (sync_rst = '1')) )then
			casc_out <= '1';						
	  else	
		casc_out <= '0';
		   
	  end if;
	  
	end process transitactions;
	
end architecture fsm;


