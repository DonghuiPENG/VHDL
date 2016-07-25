library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Flip_flop_R_W is
end tb_Flip_flop_R_W;

architecture Behavioral of tb_Flip_flop_R_W is

component Flip_flop_R_W is

    Port ( clk : in  STD_LOGIC;
           clk_ena : in  STD_LOGIC;
			  sync_rst : in  STD_LOGIC;
			  i2c_write : in  STD_LOGIC;
			  i2c_data_in : in  STD_LOGIC;
			  
			  uc_read : out  STD_LOGIC
			  );
          
end component Flip_flop_R_W;

   signal clk: STD_LOGIC:= '0';
	signal clk_ena: STD_LOGIC;
	signal sync_rst: STD_LOGIC;
	signal i2c_write: STD_LOGIC;
	signal i2c_data_in: STD_LOGIC;
	signal uc_read : STD_LOGIC;
	--signal i2c_read : STD_LOGIC;
	
	
begin

	uut: Flip_flop_R_W
	port map (clk => clk,
				clk_ena => clk_ena, 
				sync_rst => sync_rst, 
				i2c_write => i2c_write,
				i2c_data_in => i2c_data_in,
				--uc_read => i2c_read;
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
				
	i2c_write_signal: process is
	begin 
	
		i2c_write <= '1';
		wait for 20 ns;
		i2c_write <= '0';
		wait for 20 ns;
			
	end process i2c_write_signal;
	
	i2c_data_in_signal: process is
	begin 
	
		i2c_data_in <= '0';
		wait for 30 ns;
		i2c_data_in <= '1';
		wait for 30 ns;
			
	end process i2c_data_in_signal;
	
end architecture Behavioral;