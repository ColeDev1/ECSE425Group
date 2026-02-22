library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache is
generic(
	ram_size : INTEGER := 32768; -- Bytes
	cache_size : INTEGER := 512; -- Bytes
	num_of_blocks: INTEGER := 32;
	block_size : INTEGER := 128; -- bits
	
	cache_delay : time := 10 ns;
	clock_period : time := 1 ns

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
    
    -- Memory 
	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (7 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (7 downto 0);
	m_waitrequest : in std_logic
);
end cache;

architecture arch of cache is
TYPE CACHE IS ARRAY(cache_size-1 downto 0) OF STD_LOGIC_VECTOR(135 DOWNTO 0);
signal cache_block: CACHE: 
signal write_waitreq_reg: STD_LOGIC := '1';
signal read_waitreq_reg: STD_LOGIC := '1';
SIGNAL read_address_reg: INTEGER RANGE 0 to cache_size-1;

type state_type is (IDLE,READING,READ_READY,WRITING,READ_MISS,READ_HIT,WRITE_MISS,WRITE_HIT,WRITE_MEM,READ_MEM);
signal state: state_type;
signal next_state: state_type;

-- Sub-FSM for moving blocks
type memory_access_state is (
    mem_1, mem_2, mem_3, mem_4, 
    mem_5, mem_6, mem_7, mem_8, 
    mem_9, mem_10, mem_11, mem_12, 
    mem_13, mem_14, mem_15, mem_16
);
signal mem_state: memory_access_state := mem_1;
signal next_mem_state : memory_access_state;




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

avalon_structure_proc : process (state)
variable tag_match: STD_LOGIC;

begin
	case state is
		when IDLE =>
			s_waitrequest <= '1';
			if s_read = '1' then 
				next_state <= READING;
			elsif s_write = '1' then
				next_state <= WRITING;
			else
				next_state <= IDLE;
			end if;
			
		when READING =>	
			--condition here must be combinational logic between s_addr(31 downto something) and cacheArray(something downto 31 less than something)
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
			
			--get start addr
			case next_mem_state is 
				when mem_1 => 
					m_addr <= s_addr(31 downto 4) & "0000";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_2;
						-- write to cache here
					end if;

				when mem_2 => 
					m_addr <= s_addr(31 downto 4) & "0001";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_3;
						-- write to cache here
					end if;

				when mem_3 => 
					m_addr <= s_addr(31 downto 4) & "0010";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_4;
						-- write to cache here
					end if;

				when mem_4 => 
					m_addr <= s_addr(31 downto 4) & "0011";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_5;
						-- write to cache here
					end if;

				when mem_5 => 
					m_addr <= s_addr(31 downto 4) & "0100";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_6;
						-- write to cache here
					end if;

				when mem_6 => 
					m_addr <= s_addr(31 downto 4) & "0101";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_7;
						-- write to cache here
					end if;

				when mem_7 => 
					m_addr <= s_addr(31 downto 4) & "0110";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_8;
						-- write to cache here
					end if;

				when mem_8 => 
					m_addr <= s_addr(31 downto 4) & "0111";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_9;
						-- write to cache here
					end if;

				when mem_9 => 
					m_addr <= s_addr(31 downto 4) & "1000";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_10;
						-- write to cache here
					end if;

				when mem_10 => 
					m_addr <= s_addr(31 downto 4) & "1001";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_11;
						-- write to cache here
					end if;

				when mem_11 => 
					m_addr <= s_addr(31 downto 4) & "1010";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_12;
						-- write to cache here
					end if;

				when mem_12 => 
					m_addr <= s_addr(31 downto 4) & "1011";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_13;
						-- write to cache here
					end if;

				when mem_13 => 
					m_addr <= s_addr(31 downto 4) & "1100";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_14;
						-- write to cache here
					end if;

				when mem_14 => 
					m_addr <= s_addr(31 downto 4) & "1101";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_15;
						-- write to cache here
					end if;

				when mem_15 => 
					m_addr <= s_addr(31 downto 4) & "1110";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_16;
						-- write to cache here
					end if;

				when mem_16 => 
					m_addr <= s_addr(31 downto 4) & "1111";
					m_read <= '1';
					next_state <= READ_MISS;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_1;
						next_state <= READ_READY; -- Transaction complete
						m_read <= '0';
						-- write to cache here
						s_readdata <= write to output here
						--maybe set s_waitrequest to '0' here
						s_waitrequest <= '0';
						--set output word to cache set
					end if;

				when others => 
					next_mem_state <= mem_1;
					next_state <= IDLE;
			end case;
			
		--the below state is likely not needed	
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
			--this state is to create a 1 clock cycle buffer to read the read_data
			next_state <= IDLE;
			 --maybe need to put somewhere else
		
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
			case next_mem_state is 
				when mem_1 => 
					m_addr <= s_addr(31 downto 4) & "0000";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_2;
						--Read from cache here --write to mem here
					end if;

				when mem_2 => 
					m_addr <= s_addr(31 downto 4) & "0001";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_3;
						--Read from cache here --write to mem here
					end if;

				when mem_3 => 
					m_addr <= s_addr(31 downto 4) & "0010";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_4;
						--Read from cache here 
						--write to mem here
					end if;

				when mem_4 => 
					m_addr <= s_addr(31 downto 4) & "0011";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_5;
						--Read from cache here --write to mem here
					end if;

				when mem_5 => 
					m_addr <= s_addr(31 downto 4) & "0100";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_6;
						--Read from cache here --write to mem here
					end if;

				when mem_6 => 
					m_addr <= s_addr(31 downto 4) & "0101";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_7;
						--Read from cache here --write to mem here
					end if;

				when mem_7 => 
					m_addr <= s_addr(31 downto 4) & "0110";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_8;
						--Read from cache here --write to mem here
					end if;

				when mem_8 => 
					m_addr <= s_addr(31 downto 4) & "0111";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_9;
						--Read from cache here --write to mem here
					end if;

				when mem_9 => 
					m_addr <= s_addr(31 downto 4) & "1000";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_10;
						--Read from cache here --write to mem here
					end if;

				when mem_10 => 
					m_addr <= s_addr(31 downto 4) & "1001";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_11;
						--Read from cache here --write to mem here
					end if;

				when mem_11 => 
					m_addr <= s_addr(31 downto 4) & "1010";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_12;
						--Read from cache here --write to mem here
					end if;

				when mem_12 => 
					m_addr <= s_addr(31 downto 4) & "1011";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_13;
						--Read from cache here --write to mem here
					end if;

				when mem_13 => 
					m_addr <= s_addr(31 downto 4) & "1100";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_14;
						--Read from cache here --write to mem here
					end if;

				when mem_14 => 
					m_addr <= s_addr(31 downto 4) & "1101";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_15;
						--Read from cache here --write to mem here
					end if;

				when mem_15 => 
					m_addr <= s_addr(31 downto 4) & "1110";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_16;
						--Read from cache here --write to mem here
					end if;

				when mem_16 => 
					m_addr <= s_addr(31 downto 4) & "1111";
					m_write <= '1';
					next_state <= WRITE_MEM;
					if (m_waitrequest = '0') then
						next_mem_state <= mem_1;
						next_state <= IDLE; -- Transaction complete
						m_write <= '0';
						--Read from cache here --write to mem here
						--maybe set s_waitrequest to '0' here
						s_waitrequest <= '0';
						--set output word to cache set
					end if;

				when others => 
					next_mem_state <= mem_1;
					next_state <= IDLE;
			end case;
	end case;
end process avalon_structure_proc;

-- waitrequest control processes for read and write
waitreq_w_proc: PROCESS (s_write)
	BEGIN
		IF(s_write'event AND s_write = '1')THEN
			write_waitreq_reg <= '0' after cache_delay, '1' after cache_delay + clock_period;
		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (s_read)
	BEGIN
		IF(memread'event AND s_read = '1')THEN
			read_waitreq_reg <= '0' after cache_delay, '1' after cache_delay + clock_period;
		END IF;
	END PROCESS;
	-- Final waitrequest, determined by the read and write states.
	waitrequest <= write_waitreq_reg AND read_waitreq_reg;

end arch;