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
	generic ( divisor : positive := 2); 
	 
    Port(  
		clk 			:in  STD_LOGIC;
        clk_ena 		:in  STD_LOGIC;
		sync_rst 		:in  STD_LOGIC;
        cascade_in 		:in  STD_LOGIC;
        
		count 			:out  integer range 0 to (divisor-1);
        cascade_out 	:out  STD_LOGIC
		);
end component;

--! use signals internals simulate these ports of component
	
	signal clk: STD_LOGIC;
	signal clk_ena: STD_LOGIC;
	signal sync_rst: STD_LOGIC;
	signal cascade_in: STD_LOGIC;
	signal count: integer; 
	signal cascade_out: STD_LOGIC;
	
begin
	
	
	
--! an instance of component		

	gen_ena: cascadable_counter
	generic map (divisor => 2)
	port map(
			clk => clk, 
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			cascade_in => cascade_in, 
			count => count, 
			cascade_out => cascade_out
			);

				
	sync_rst <= '1';	
	cascade_in <= '1';
	clk_ena <= '1';
--! process of generating a clock signal	

clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
end process clk_signal;
end architecture Behavioral;
	

	
 
	
		
