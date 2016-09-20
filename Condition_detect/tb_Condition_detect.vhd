-------------------------------------------------------
--! @file
--! @brief tb_Condition_detect_Condition_detect :testbench for the entity Condition_detect
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Condition_detect is
end tb_Condition_detect;

--! @brief Architecture definition of the tb_Condition_detect
--! @details More details about this tb_Condition_detect element.
architecture Behavioral of tb_Condition_detect is

--! use a entity as a component
component Condition_detect is

  port (
    clk						: in STD_LOGIC;
	clk_ena					: in STD_LOGIC;
	sync_rst				: in STD_LOGIC;
	SCL_in 			        : in STD_LOGIC;
    SDA_in             		: in STD_LOGIC;
	 
    start_detected_point         : out  STD_LOGIC;
	stop_detected_point          : out  STD_LOGIC;
	error_detected_point         : out  STD_LOGIC
	); 
	 
end component Condition_detect;

--! use signals internals simulate these ports of component
    signal clk						: STD_LOGIC:= '0';
	signal clk_ena					: STD_LOGIC;
	signal sync_rst					: STD_LOGIC;
	signal SCL_in					: STD_LOGIC;
	signal SDA_in					: STD_LOGIC; 
	
	signal start_detected_point 	: STD_LOGIC;
	signal stop_detected_point  	: STD_LOGIC;
	signal error_detected_point 	: STD_LOGIC;

	
begin
--! an instance of component	
	uut: Condition_detect
	port map(   
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			SCL_in => SCL_in,
			SDA_in => SDA_in,
				
			start_detected_point => start_detected_point,
			stop_detected_point => stop_detected_point,
			error_detected_point => error_detected_point
			);
	
				
	
	sync_rst <= '1';
	--clk_ena <= '1';
	
--! process of generating a clock signal	
clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
end process clk_signal;

--! process of generating a clock enable signal	
clk_ena_signal: process is
	begin 
	
		clk_ena <= '1';
		wait for 20 ns;
		clk_ena <= '0';
		wait for 20 ns;
			
end process clk_ena_signal;

--! process of generating a SCL_in signal	
SCL_in_signal: process is
	begin 
		
		SCL_in <= '0';
		wait for 640 ns;
		SCL_in <= '1';
		wait for 640 ns;
			
end process SCL_in_signal;

--! process of generating a SDA_in signal	
SDA_in_signal: process is
	begin 
	
		SDA_in <= '1';
		wait for 1120 ns;
		SDA_in <= '0';
		wait for 960 ns;
		SDA_in <= '1';
		wait for 320 ns;
		SDA_in <= '0';
		wait for 960 ns;
		SDA_in <= '1';
		wait for 1120 ns;
			
end process SDA_in_signal;
	


end architecture Behavioral;