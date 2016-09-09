--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;

entity register_slave is
end register_slave;

architecture Behavioral of register_slave is

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


component	flip_flop_RW_R is

	port(clk: in std_logic;						--! clock input
		 clk_ena: in std_logic;					--! clock enable input
		 sync_rst: in std_logic;				--! '0' active synchronous reset input
		 uc_data_in: in std_logic;				--! microcontroller data input
		 uc_write_command: in std_logic;		--! '1' active microcontroller write command input
		 data_out: out std_logic				--! data_out output
	);

end component flip_flop_RW_R;


component flip_flop_RW_RC is

	port(clk: in std_logic;					--! clock input
		 clk_ena: in std_logic;				--! clock enable input
		 sync_rst: in std_logic;			--! '0' active synchronous reset input
		 uc_data_in: in std_logic;			--! microcontroller data input
		 uc_write_command: in std_logic;	--! '1' active microcontroller write command input
		 i2c_clear_command: in std_logic;	--! '1' active I2C clear command input
		 data_out: out std_logic			--! data_out output
	);
	
end component flip_flop_RW_RC;

signal 

begin

CTL6: flip_flop_RW_R
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_data_in => uc_data_in,
			uc_write_command => uc_write_command,
			data_out => data_out
			);
			
CTL5: flip_flop_RW_R
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_data_in => uc_data_in,
			uc_write_command => uc_write_command,
			data_out => data_out
			);

CTL4: flip_flop_RW_R
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_data_in => uc_data_in,
			uc_write_command => uc_write_command,
			data_out => data_out
			);
			
CTL0: flip_flop_RW_R
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_data_in => uc_data_in,
			uc_write_command => uc_write_command,
			data_out => data_out
			);

STATUS7: Flip_flop_R_WR
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			i2c_write => i2c_write,
			i2c_data_in => i2c_data_in,
			data_out => data_out
			
			);		

			
STATUS6: Flip_flop_R_WR
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			i2c_write => i2c_write,
			i2c_data_in => i2c_data_in,
			data_out => data_out
			
			);
			
STATUS5: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
			data_out => data_out
			
			);

STATUS4: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
			data_out => data_out
			
			);
			
STATUS3: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
			data_out => data_out
			
			);
			
STATUS2: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
			data_out => data_out
			
			);
			
STATUS1: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
			data_out => data_out
			
			);
			
STATUS0: Flip_flop_RC_S
	port map(	
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			uc_clear => uc_clear,
			i2c_set => i2c_set,
			data_out => data_out
			
			);
