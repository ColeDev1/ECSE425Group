library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache is
generic(
	ram_size : INTEGER := 32768;
);
port(
	clock : in std_logic;
	reset : in std_logic;
	
	-- Avalon interface --
	s_addr : in std_logic_vector (31 downto 0);
	s_read : in std_logic;
	s_readdata : out std_logic_vector (31 downto 0);
	s_write : in std_logic;
	s_writedata : in std_logic_vector (31 downto 0);
	s_waitrequest : out std_logic; 
    
	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (7 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (7 downto 0);
	m_waitrequest : in std_logic
);
end cache;

architecture arch of cache is
type state_type is (IDLE,READING,READ_READY,WRITING);
signal state: state_type;
signal next_state: state_type;
-- declare signals here

begin

-- make circuits here
process (clock, reset)
begin
	if reset = '1' then
		state <= IDLE;
	elsif (clk'event and clk = '1') then
		state <= next_state;
	end if;
end process;
--state
--four states
avalon_structure_proc : process (clock)

	case state is
		when IDLE =>
		
			if s_read = '1' and  then
				next_state <= READING;
				m_read <= '1';
				
			elsif s_write = '1' then
				next_state <= WRITING;
				
			else	
				next_state <= IDLE;
			end if;
			
		when READING =>
			
			if m_waitrequest = '1' then
				next_state <= READ_READY;
				--set s_waitrequest to 0
			else	
				next_state <= READING;
			end if;
			
		when READ_READY =>	
			next_state <= IDLE;
			s_waitrequest <= '1';
			
			
		when WRITING =>
			if m_waitrequest = '1' then
				next_state <= WRITING;
			else	
				next_state <= IDLE;
			end if;
		when others =>
			next_state => IDLE;
	end case;

end arch;