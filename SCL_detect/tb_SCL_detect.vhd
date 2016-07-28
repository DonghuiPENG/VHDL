-------------------------------------------------------
--! @file
--! @brief tb_SCL_detect :testbench for the entity SCL_detect
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;


entity tb_SCL_detect is
end tb_SCL_detect;

--! @brief Architecture definition of the tb_SCL_detect
--! @details More details about this tb_SCL_detect element.
architecture Behavioral of tb_SCL_detect is


--! use a entity as a component
component SCL_detect is
	 
    Port( 
		sync_rst 				: in  STD_LOGIC;
        clk 					: in  STD_LOGIC;
        clk_ena 				: in  STD_LOGIC;
        SCL_in 					: in  STD_LOGIC;
		SCL_tick 				: in  STD_LOGIC;
			  
		SCL_rising_point 		: out  STD_LOGIC;
		SCL_stop_point 			: out  STD_LOGIC;
		SCL_sample_point 		: out  STD_LOGIC;
		SCL_start_point 		: out  STD_LOGIC;
		SCL_falling_point 		: out  STD_LOGIC;
		SCL_write_point 		: out  STD_LOGIC;
		SCL_error_indication 	: out  STD_LOGIC
		);
			  
end component;

--! use signals internals simulate these ports of component
	signal sync_rst					: STD_LOGIC;
	signal clk						: STD_LOGIC := '0';
	signal clk_ena					: STD_LOGIC;
	signal SCL_in					: STD_LOGIC  ;
	signal SCL_tick					: STD_LOGIC ; 
	
	signal SCL_rising_point 		: STD_LOGIC;
	signal SCL_stop_point			: STD_LOGIC;
	signal SCL_sample_point 		: STD_LOGIC;
	signal SCL_start_point 			: STD_LOGIC;
	signal SCL_falling_point 		: STD_LOGIC;
	signal SCL_write_point 			: STD_LOGIC;
	signal SCL_error_indication 	: STD_LOGIC;

	
begin

--! an instance of component		
	uut: SCL_detect
	port map(  
			sync_rst => sync_rst,
			clk => clk, 
			clk_ena => clk_ena, 
			SCL_in => SCL_in,
			SCL_tick => SCL_tick,
				
			SCL_stop_point => SCL_stop_point,
			SCL_start_point => SCL_start_point,
			SCL_rising_point => SCL_rising_point,
			SCL_falling_point => SCL_falling_point,
			SCL_sample_point => SCL_sample_point,
			SCL_write_point => SCL_write_point,
			SCL_error_indication => SCL_error_indication
			);
	
				
	
	sync_rst <= '1';
	clk_ena <= '1';

--! process of generating a clock signal	
clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
end process clk_signal;

--! process of generating a SCL_tick signal		
SCL_tick_signal: process is
	begin 
	
		SCL_tick <= '1';
		wait for 20 ns;
		SCL_tick <= '0';
		wait for 140 ns;
			
end process SCL_tick_signal;

--! process of generating a SCL_in signal	
SCL_in_signal: process is
	begin 
		
		SCL_in <= '1';
		wait for 2560 ns;
		SCL_in <= '0';
		wait for 2560 ns;
			
end process SCL_in_signal;
	


end architecture Behavioral;