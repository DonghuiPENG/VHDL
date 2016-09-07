--! Use standard library
library IEEE;
--! Use logic elements
use IEEE.STD_LOGIC_1164.ALL;


entity tb_I2c_slave_engine is
end tb_I2c_slave_engine;

--! @brief Architecture definition of the tb_SCL_detect
--! @details More details about this tb_SCL_detect element.
architecture Behavioral of tb_I2c_slave_engine is

component I2c_slave_engine is

port(
		clk: in std_logic;				
		clk_ena: in std_logic;			
		sync_rst: in std_logic;		
		ctl_role_r: in std_logic;
		ctl_ack_r: in std_logic;
		ctl_reset_r: in std_logic;
		
		status_busy_r: in std_logic;
		status_rw_r: in std_logic;
		status_rxfull_r: in std_logic;
		status_txempty_r: in std_logic;		
		status_ackrec_r: in std_logic;	
		
		txdata: in std_logic_vector (7 downto 0);
		
		address: in std_logic_vector (6 downto 0);
		
		status_busy_w: out std_logic;
		status_rw_w: out std_logic;
		status_stop_detected_s: out std_logic;
		status_start_detected_s: out std_logic;
		status_error_detected_s: out std_logic;
		status_rxfull_s: out std_logic;
		status_txempty_s: out std_logic;
		status_ackrec_s: out std_logic;
		
		rxdata: out std_logic_vector (7 downto 0)
		);


end component I2c_slave_engine;

    signal  clk:  std_logic;				
	signal	clk_ena:  std_logic;			
	signal	sync_rst:  std_logic;		
	signal	ctl_role_r:  std_logic;
	signal	ctl_ack_r:  std_logic;
	signal	ctl_reset_r:  std_logic;
		
	signal	status_busy_r:  std_logic;
	signal	status_rw_r:  std_logic;
	signal	status_rxfull_r:  std_logic;
	signal	status_txempty_r:  std_logic;		
	signal	status_ackrec_r:  std_logic;	
		
	signal	txdata:  std_logic_vector (7 downto 0);	
	signal	address:  std_logic_vector (6 downto 0);
		
	signal	status_busy_w:  std_logic;
	signal	status_rw_w:  std_logic;
	signal	status_stop_detected_s:  std_logic;
	signal	status_start_detected_s:  std_logic;
	signal	status_error_detected_s:  std_logic;
	signal	status_rxfull_s:  std_logic;
	signal	status_txempty_s:  std_logic;
	signal	status_ackrec_s:  std_logic;
		
	signal	rxdata:  std_logic_vector (7 downto 0);
	
begin
	
	

--! an instance of component		
	uut: I2c_slave_engine
	port map(  
			clk => clk,
			clk_ena => clk_ena, 
			sync_rst => sync_rst, 
			ctl_role_r => ctl_role_r,
			ctl_ack_r => ctl_ack_r,
			ctl_reset_r	=> ctl_reset_r,
			
			status_busy_r => status_busy_r,
			status_rw_r => status_rw_r,
			status_rxfull_r => status_rxfull_r,
			status_txempty_r => status_txempty_r,
			status_ackrec_r => status_ackrec_r,
			
			txdata => txdata,
			address => address, 
		
			status_busy_w => status_busy_w,
			status_rw_w => status_rw_w,
			status_stop_detected_s	=> status_stop_detected_s,
			status_start_detected_s => status_start_detected_s,
			status_error_detected_s => status_error_detected_s,
			status_rxfull_s => status_rxfull_s,
			status_txempty_s => status_txempty_s,
			status_ackrec_s => status_ackrec_s,
			
			rxdata => rxdata
			);
	

	
	
	
	
