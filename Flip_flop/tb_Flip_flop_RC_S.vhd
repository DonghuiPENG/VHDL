-------------------------------------------------------
--! @file
--! @brief tb_Flip_flop_RC_S :testbench for the entity flip_flop_rc_s
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Flip_flop_RC_S is
end tb_Flip_flop_RC_S;

--! @brief Architecture definition of the tb_Flip_flop_RC_S
--! @details More details about this tb_Flip_flop_RC_S element.
architecture Behavioral of tb_Flip_flop_RC_S is

component Flip_flop_RC_S is

    Port( 
		clk 			: in  STD_LOGIC;
        clk_ena 		: in  STD_LOGIC;
		sync_rst 		: in  STD_LOGIC;
        uc_clear 		: in  STD_LOGIC;
		i2c_set 		: in  STD_LOGIC;
			  
		data_out 		: out  STD_LOGIC
		);
          
end component Flip_flop_RC_S;

--! use signals internals simulate these ports of component
	signal clk			: STD_LOGIC:= '0';
	signal clk_ena		: STD_LOGIC;
	signal sync_rst		: STD_LOGIC;
	signal uc_clear		: STD_LOGIC;
	signal i2c_set		: STD_LOGIC;
	
	signal data_out 		: STD_LOGIC;
	
	
begin

--! an instance of component		
	uut: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
				
			data_out => data_out
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

--! process of generating a clear signal by microcontrolleur					
uc_clear_signal: process is
	begin 
	
		uc_clear <= '1';
		wait for 20 ns;
		uc_clear <= '0';
		wait for 20 ns;
			
end process uc_clear_signal;

--! process of generating a set signal by I2C						
i2c_set_signal: process is
	begin 
	
		i2c_set <= '0';
		wait for 20 ns;
		i2c_set <= '1';
		wait for 20 ns;
			
end process i2c_set_signal;
	
end architecture Behavioral;