library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Condition_detect is
end tb_Condition_detect;

architecture Behavioral of tb_Condition_detect is



component Condition_detect is

  port (
    clk							: in STD_LOGIC;
	 clk_ena						: in STD_LOGIC;
	 sync_rst					: in STD_LOGIC;
	 SCL_in 			         : in STD_LOGIC;
    SDA_in             		: in STD_LOGIC;
	 
    start_detected_point         : out  STD_LOGIC;
	 stop_detected_point          : out  STD_LOGIC;
	 error_detected_point         : out  STD_LOGIC); 
	 
end component Condition_detect;


   signal clk: STD_LOGIC:= '0';
	signal clk_ena: STD_LOGIC ;
	signal sync_rst: STD_LOGIC;
	signal SCL_in: STD_LOGIC  ;
	signal SDA_in: STD_LOGIC ; 
	
	signal start_detected_point : STD_LOGIC;
	signal stop_detected_point  : STD_LOGIC;
	signal error_detected_point : STD_LOGIC;

	
begin
	
	uut: Condition_detect
	port map(clk => clk,
				clk_ena => clk_ena, 
				sync_rst => sync_rst, 
				SCL_in => SCL_in,
				SDA_in => SDA_in,
				
				start_detected_point => start_detected_point,
				stop_detected_point => stop_detected_point,
				error_detected_point => error_detected_point);
	
				
	
	sync_rst <= '1';
	clk_ena <= '1';
	
clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
end process clk_signal;
	
SCL_in_signal: process is
	begin 
		
		SCL_in <= '0';
		wait for 640 ns;
		SCL_in <= '1';
		wait for 640 ns;
			
end process SCL_in_signal;

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