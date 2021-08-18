library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity inputController is
  port(
	clk: in std_logic;
	Data_A:in std_logic_vector(1023 downto 0);
	en_A: in std_logic;
	Data_B:in std_logic_vector(1023 downto 0);
	en_B: in std_logic;
	Data_T:in std_logic_vector(15 downto 0);
	en_T: in std_logic;
	start: in std_logic;
	len:in Integer;
	dep:in Integer;
	wid:in Integer;
	bnn_rdy: out std_logic;
	resetPE: out std_logic_vector(2 downto 0);
	o_A,o_B: buffer std_logic_vector(31 downto 0);
	o_T: buffer std_logic_vector(63 downto 0);
	outBufferIn: in std_logic
	
  );
end;

architecture aufbau of inputController is

component fifo
    generic(g_WIDTH : natural := 20); 
    port(
        i_rst_sync : in std_logic;
        i_clk      : in std_logic;
  
        -- FIFO Write Interface
        i_wr_en   : in  std_logic;
        i_wr_data : in  std_logic_vector(g_WIDTH-1 downto 0);
        o_full    : out std_logic;
 
        -- FIFO Read Interface
		i_rd_en   : in  std_logic;
		o_rd_data : out std_logic_vector(g_WIDTH-1 downto 0);
		o_empty   : out std_logic
      
    );
end component;
	
	
component command_cal
    port(
	
		clk: in std_logic;
		i_rdy: in std_logic;
		i_depthA: in Integer;
		i_widthB: in integer;
		o_com: buffer std_logic_vector(19 downto 0);
		wr_en: out  std_logic;
		i_full: in std_logic
      
    );
end component;

component inputBuffer
	port(
	
		clk, rst, start: in std_logic;
		weA, weB, weT: in std_logic;
		dataA, dataB: in  std_logic_vector(1023 downto 0);
		dataT: in std_logic_vector(15 downto 0);
		resetPE: out std_logic_vector(2 downto 0);
		comando: in std_logic_vector(19 downto 0);
		readCo: out std_logic;
		empty: in std_logic;
		len: in integer;
		o_A,o_B: buffer std_logic_vector(31 downto 0);
		o_T: buffer std_logic_vector(63 downto 0);
		bnnRdy: out std_logic;
		outBufferIn: in std_logic
    );
end component;

signal comI, comO:std_logic_vector(19 downto 0);
signal full, enC, rst, rdC, empty:std_logic;

begin
	CAL :  command_cal port map(
		clk,
		i_rdy => start,
		i_depthA => dep,
		i_widthB => wid,
		o_com => comI,
		wr_en => enC,
		i_full => full
	);
	fi :  fifo port map(
	
	    i_rst_sync => rst,
        i_clk => clk,
        i_wr_en => enC, 
        i_wr_data => comI,
        o_full => full,
		i_rd_en => rdC,
		o_rd_data => comO,
		o_empty => empty
	
	);
	inp :  inputBuffer port map(
	
		
		clk, 
		rst => rst, 
		start => start,
		weA => en_A,
		weB => en_B,
		weT => en_T,
		dataA => Data_A,
		dataB => Data_B,
		dataT => Data_T,
		resetPE => resetPE,
		comando => comO,
		readCo => rdC,
		empty => empty,
		len => len,
		o_A => o_A,
		o_B => o_B,
		o_T => o_T,
		bnnRdy => bnn_rdy,
		outBufferIn => outBufferIn
	
	
	);
	
	rst <= '0';

end;