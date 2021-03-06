-------------------------------------------------------
--! @file
--! @brief tb_Flip_flop_R_WR :testbench for the entity flip_flop_R_WR
-------------------------------------------------------
 
--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Flip_flop_R_WR is
end tb_Flip_flop_R_WR;

--! @brief Architecture definition of the tb_Flip_flop_R_WR
--! @details More details about this tb_Flip_flop_R_Wr element.
architecture Behavioral of tb_Flip_flop_R_WR is


--! use a entity as a component
component Flip_flop_R_WR is

    Port( 
		clk 			: in  STD_LOGIC;
        clk_ena 		: in  STD_LOGIC;
		sync_rst 		: in  STD_LOGIC;
		i2c_write 		: in  STD_LOGIC;
		i2c_data_in 	: in  STD_LOGIC;
			  
		data_out 		: out  STD_LOGIC
		);
          
end component Flip_flop_R_WR;

--! use signals internals simulate these ports of component

	signal clk			: STD_LOGIC:= '0';
	signal clk_ena		: STD_LOGIC;
	signal sync_rst		: STD_LOGIC;
	signal i2c_write	: STD_LOGIC;
	signal i2c_data_in	: STD_LOGIC;
	
	signal data_out 		: STD_LOGIC;
	signal i2c_read : STD_LOGIC;
	signal uc_read : STD_LOGIC;
	
	
begin

--! an instance of component		
	uut: Flip_flop_R_WR
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			i2c_write => i2c_write,
			i2c_data_in => i2c_data_in,
			data_out => i2c_read
			
		--	data_out => uc_read
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

--! process of generating a write signal by I2C					
i2c_write_signal: process is
	begin 
	
		i2c_write <= '1';
		wait for 20 ns;
		i2c_write <= '0';
		wait for 20 ns;
			
end process i2c_write_signal;

--! process of generating a data_in signal by I2C					
i2c_data_in_signal: process is
	begin 
	
		i2c_data_in <= '0';
		wait for 30 ns;
		i2c_data_in <= '1';
		wait for 30 ns;
			
end process i2c_data_in_signal;
	
end architecture Behavioral;