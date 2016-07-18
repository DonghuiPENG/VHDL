library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cascadable_counter is
end tb_cascadable_counter;

architecture Behavioral of tb_cascadable_counter is

component cascadable_counter is
	 generic ( divisor : positive := 8); 
	 
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ena : in  STD_LOGIC;
           cascade_in : in  STD_LOGIC;
           count : out  integer range 0 to (divisor-1);
           cascade_out : out  STD_LOGIC);
end component;

   signal rst: STD_LOGIC;
	signal clk: STD_LOGIC;
	signal ena: STD_LOGIC;
	signal cascade_in: STD_LOGIC;
	signal count: integer; 
	signal clk_ena: STD_LOGIC;
	
begin
	
	
	
	
	gen_ena: cascadable_counter
	generic map (divisor => 2)
	port map (rst => rst, 
				clk => clk, 
				ena => ena, 
				cascade_in => cascade_in, 
				count => count, 
				cascade_out => clk_ena);

				
	rst <= '1';	
	cascade_in <= '1';
	ena <= '1';
clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10ns;
		clk <= '0';
		wait for 10ns;
			
	end process clk_signal;
	

	
 
	
		

end architecture Behavioral;