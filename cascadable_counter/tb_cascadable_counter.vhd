-------------------------------------------------------
--! @file
--! @brief tb_cascadable_counter :testbench for the entity cascadable_counter
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cascadable_counter is
end tb_cascadable_counter;

--! @brief Architecture definition of the tb_cascadable_counter
--! @details More details about this tb_cascadable_counter element.
architecture Behavioral of tb_cascadable_counter is

--! use a entity as a component
component cascadable_counter is

	generic(max_count: positive := 2);
	port (clk: in std_logic;
			ena: in std_logic;
			sync_rst:in std_logic;
			casc_in: in std_logic;
			count: out integer range 0 to (max_count-1);
			casc_out: out std_logic
			);
			
end component cascadable_counter;

--! use signals internals simulate these ports of component
	
	signal clk: STD_LOGIC;
	signal ena: STD_LOGIC;
	signal sync_rst: STD_LOGIC;
	signal casc_in: STD_LOGIC;
	signal count: integer; 
	signal casc_out: STD_LOGIC;
	
begin
	
	
	
--! an instance of component		

	gen_ena: cascadable_counter
	generic map (max_count => 2)
	port map(
			clk => clk, 
			ena => ena, 
			sync_rst => sync_rst, 
			casc_in => casc_in, 
			count => count, 
			casc_out => casc_out
			);

				
	sync_rst <= '1';	
	casc_in <= '1';
	ena <= '1';
--! process of generating a ena signal	



--! process of generating a clock signal	

clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
end process clk_signal;
end architecture Behavioral;
	

	
 
	
		
