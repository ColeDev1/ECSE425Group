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
type state_type is (IDLE,READING,READ_READY,WRITING,READ_MISS,READ_HIT,WRITE_MISS,WRITE_HIT,WRITE_MEM,READ_MEM);
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
			if s_read = '1' then 
				next_state <= READING;
			elsif s_write = '1' then
				next_state <=WRITING;
			else
				next_state <= IDLE;
			end if;
		when READING =>			
			if valid = '1' and match then
				next_state <= READ_HIT;
			else	
				next_state <= READ_MISS;
			end if;
		when READ_HIT =>
			--this state is just reading from cache
			next_state <= READ_READY;
			s_readdata <= ... memory array here;
			s_waitrequest <= '0';
			
		when READ_MISS =>
			--this state is setting up 16 memory accesses
			--figure out where we are in realtion to the 16 bytes in a cache line // block
			--set the addr to the first byte then in read mem we just need to do 16 sequential reads 
		when READ_MEM =>
			--this state is 16 accesses
			--then place them in cache
			if memory access is complete then 
				next_state <= READ_HIT;
				s_addr <= needs to be reset to what it was before
			else
				next_state <= READ_MEM;
			end if;
			--complete 16 sequential byte accesses in memory
			--could be for loop here to access the 16 bytes
			
		when READ_READY =>
			--this state is to create a 1 clock cycle buffer to read the read data
			next_state <= IDLE;
			s_waitrequest <='1'; --maybe need to put somewhere else
		
		when WRITING =>
			--check for tag match
			if Tag and Valid then
				next_state <= WRITE_HIT;
			else	
				next_state <= WRITE_MISS;
			end if;
		
		when WRITE_HIT =>
			--write to cache 
			--set dirty bit to 1
			
		when WRITE_MISS =>
			--this state to set up memory access
			if v = '1' and d = '1' then 
				write to memory;
				if m_waitrequest = '0' then 
					next_state <= WRITE_MEM;
				else 
					next_state <= WRITE_MISS;
				end if;
			else
				next_state <= WRITE_MEM;
			end if;
			
		when WRITE_MEM =>
			-- must read 16 bytes and then write our new byte into the cache;
			if access is complete then 
				next_state <= IDLE;
			else
				next_state <= WRITE_MEM;
			end if;
		
			
	end case;
end arch;