library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Flip_flop_RC_S is
end tb_Flip_flop_RC_S;

architecture Behavioral of tb_Flip_flop_RC_S is

component Flip_flop_RC_S is

    Port ( clk : in  STD_LOGIC;
           clk_ena : in  STD_LOGIC;
			  sync_rst : in  STD_LOGIC;
           uc_clear : in  STD_LOGIC;
			  i2c_set : in  STD_LOGIC;
			  
			  uc_read : out  STD_LOGIC
			  );
          
end component Flip_flop_RC_S;

   signal clk: STD_LOGIC:= '0';
	signal clk_ena: STD_LOGIC;
	signal sync_rst: STD_LOGIC;
	signal uc_clear: STD_LOGIC;
	signal i2c_set: STD_LOGIC;
	signal uc_read : STD_LOGIC;
	
	
begin

	uut: Flip_flop_RC_S
	port map (clk => clk,
				clk_ena => clk_ena, 
				sync_rst => sync_rst, 
				uc_clear => uc_clear,
				i2c_set => i2c_set,
				
				uc_read => uc_read);
				
	sync_rst <= '1';
	clk_ena <= '1';
	
	clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
	end process clk_signal;
				
	uc_clear_signal: process is
	begin 
	
		uc_clear <= '1';
		wait for 20 ns;
		uc_clear <= '0';
		wait for 20 ns;
			
	end process uc_clear_signal;
	
	i2c_set_signal: process is
	begin 
	
		i2c_set <= '0';
		wait for 20 ns;
		i2c_set <= '1';
		wait for 20 ns;
			
	end process i2c_set_signal;
	
end architecture Behavioral;