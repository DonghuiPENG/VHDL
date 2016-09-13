--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;


entity	Avalon_interface is

	port(
		address			: in std_logic;					
		byteenable		: in std_logic;				
		readed			: in std_logic;								
		writed			: in std_logic;		
		writedata		: in std_logic;	
		waitrequest		: in std_logic;
		
		readdatavalid	: out std_logic;
		readdata		: out std_logic
		);

end entity Avalon_interface;

architecture fsm of Avalon_interface is

begin



end architecture fsm;