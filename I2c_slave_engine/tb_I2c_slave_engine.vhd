-------------------------------------------------------
--! @file
--! @brief tb_I2c_slave_engine :testbench for the entity I2c_slave_engine
-------------------------------------------------------


--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;


entity tb_I2c_slave_engine is
end tb_I2c_slave_engine;

--! @brief Architecture definition of the tb_I2c_slave_engine
--! @details More details about this tb_I2c_slave_engine element.
architecture Behavioral of tb_I2c_slave_engine is


--! use a entity as a component
component I2c_slave_engine is

port(
		clk								: in std_logic;				
		clk_ena							: in std_logic;			
		sync_rst						: in std_logic;		
		SCL_in							: in STD_LOGIC;
		SDA_in							: in STD_LOGIC;
		
		
		ctl_role_r						: in std_logic;
		ctl_ack_r						: in std_logic;
		ctl_reset_r						: in std_logic;
		
		
		
		--status_rxfull_r: in std_logic;
		--status_txempty_r: in std_logic;		
		
		
		txdata							: in std_logic_vector (7 downto 0);
		
		address							: in std_logic_vector (6 downto 0);
		
		sda_out							: out STD_LOGIC;

		status_busy_w					: out std_logic;
		status_rw_w						: out std_logic;
		status_stop_detected_s			: out std_logic;
		status_start_detected_s			: out std_logic;
		status_error_detected_s			: out std_logic;
		status_rxfull_s					: out std_logic;
		status_txempty_s				: out std_logic;
		status_ackrec_w					: out std_logic;
		
		rxdata							: out std_logic_vector (7 downto 0)
		
	);


end component I2c_slave_engine;
	
	--! use internals signals simulate these ports of component	
	signal sda_master					:  std_logic;
	signal sda							:  std_logic;
	
    signal  clk							:  std_logic;				
	signal	clk_ena						:  std_logic:= '1';			
	signal	sync_rst					:  std_logic:= '1';
	signal  SCL_in						:  std_logic;
	signal  SDA_in						:  std_logic;
	
	signal	ctl_role_r					:  std_logic;
	signal	ctl_ack_r					:  std_logic;
	signal	ctl_reset_r					:  std_logic;
		
	
	
	--signal	status_rxfull_r:  std_logic;
	--signal	status_txempty_r:  std_logic;		
	
		
	signal	txdata						:  std_logic_vector (7 downto 0);	
	signal	address						:  std_logic_vector (6 downto 0);
	
	signal  sda_out						:  std_logic;
		
	signal	status_busy_w				:  std_logic;
	signal	status_rw_w					:  std_logic;
	signal	status_stop_detected_s		:  std_logic;
	signal	status_start_detected_s		:  std_logic;
	signal	status_error_detected_s		:  std_logic;
	signal	status_rxfull_s				:  std_logic;
	signal	status_txempty_s			:  std_logic;
	signal	status_ackrec_w				:  std_logic;
		
	signal	rxdata						:  std_logic_vector (7 downto 0);
	
begin
	
	

--! an instance of component		
	uut1: I2c_slave_engine
	port map(  
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			SCL_in => SCL_in,
			SDA_in => SDA_in,
			
			ctl_role_r => ctl_role_r,
			ctl_ack_r => ctl_ack_r,
			ctl_reset_r	=> ctl_reset_r,
			
			
			
			--status_rxfull_r => status_rxfull_r,
			--status_txempty_r => status_txempty_r,
			
			
			txdata => txdata,
			address => address, 
			sda_out => sda_out,
		
			status_busy_w => status_busy_w,
			status_rw_w => status_rw_w,
			status_stop_detected_s	=> status_stop_detected_s,
			status_start_detected_s => status_start_detected_s,
			status_error_detected_s => status_error_detected_s,
			status_rxfull_s => status_rxfull_s,
			status_txempty_s => status_txempty_s,
			status_ackrec_w => status_ackrec_w,
			
			rxdata => rxdata
			);

--! combine I2c_slave_engine data line output and I2c_master_engine data line output to data line		
SDA <= sda_out and sda_master;
SDA_in <= sda;

--! process of generating a clk signal
clk_signal: process is
	begin 
	
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
			
end process clk_signal;

--! process of generating a SCL_in signal
SCL_in_signal: process is
	begin 
	
		SCL_in <= '0';
		wait for 1600 ns;
		SCL_in <= '1';
		wait for 1600 ns;
			
end process SCL_in_signal;

--! process of generating a sda_master signal
sda_master_signal: process is
	begin 
	
	--! simulate a master-transmitter addressing a slave receiver with a 7-bit address
		-- sda_master <= '1';
		-- wait for 320*9 ns;
		-- sda_master <= '0';
		-- wait for 320*64 ns;
		-- sda_master <= '1';
		-- wait for 320*10 ns;
		-- sda_master <= '0';
		-- wait for 320*10 ns;
		-- sda_master <= '1';
		-- wait for 320*10 ns;
		
		-- sda_master <= '1';
		-- wait for 320*10*8 ns;
		-- sda_master <= '1';
		-- wait for 320*10 ns;
		-- sda_master <= '0';
		-- wait for 320*4 ns;
		-- sda_master <= '1';
		-- wait for 320*3 ns;
	--! simulate a master reads a slave immediately after the first byte
		-- sda_master <= '1';
		-- wait for 320*9 ns;
		-- sda_master <= '0';
		-- wait for 320*64 ns;
		-- sda_master <= '1';
		-- wait for 320*10*12 ns;
		-- sda_master <= '0';
		-- wait for 320*4 ns;
		-- sda_master <= '1';
		-- wait for 320*3 ns;
	--! simulate combined format
		sda_master <= '1';
		wait for 320*9 ns;
		sda_master <= '0';
		wait for 320*64 ns;
		sda_master <= '1';
		wait for 320*10 ns;
		sda_master <= '0';
		wait for 320*10 ns;
		sda_master <= '1';
		wait for 320*10 ns;
		
		sda_master <= '1';
		wait for 320*10*8 ns;
		sda_master <= '1';
		wait for 320*10 ns;
		sda_master <= '0';
		wait for 320*4 ns;
		sda_master <= '1';
		wait for 320*2 ns;
		sda_master <= '0';
		wait for 320*1 ns;
		
		
		sda_master <= '0';
		wait for 320*63 ns;
		sda_master <= '1';
		wait for 320*10*12 ns;
		sda_master <= '0';
		wait for 320*4 ns;
		sda_master <= '1';
		wait for 320*3 ns;
		
end process sda_master_signal;

--! process of generating a ctl_role_r signal
ctl_role_r_signal: process is
	begin 	
		ctl_role_r <= '0';
		wait ;
			
end process ctl_role_r_signal;

--! process of generating a ctl_ack_r signal
ctl_ack_r_signal: process is
	begin 	
		ctl_ack_r <= '0';
		wait ;
			
end process ctl_ack_r_signal;

--! process of generating a ctl_reset_r signal
ctl_reset_r_signal: process is
	begin 	
		ctl_reset_r <= '0';
		wait ;
			
end process ctl_reset_r_signal;

--! process of generating a txdata signal
txdata_signal: process is
	begin 	
		txdata <= "10101010";
		wait ;
			
end process txdata_signal;

--! process of generating a address signal
address_signal: process is
	begin 	
		address <= "0000001";
		wait ;
			
end process address_signal;
	
end architecture Behavioral;	
