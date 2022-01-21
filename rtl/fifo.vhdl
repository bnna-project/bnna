library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity fifo is
  generic (
    conWIDTH : natural := 24; -- width of input
    conDEPTH : integer := 4096 -- depth of storage
    );
  port (
    reset :in std_logic; --reset
    clk :in std_logic; --clock
    enWR :in std_logic; --enable write
    dataWR :in std_logic_vector(conWIDTH-1 downto 0); --write
    full :out std_logic; -- indicates that fifo is full
    enRD :in std_logic; -- enable read
    dataRD :out std_logic_vector(conWIDTH-1 downto 0);-- read
    empty :out std_logic -- indicates that fifo is empty
    );
end fifo;
 
architecture behavior of fifo is
 
  type Fbuffer is array (0 to conDEPTH-1) of std_logic_vector(conWIDTH-1 downto 0);--store comands
  signal wFbuffer : Fbuffer := (others => (others => '0'));
 
  signal currentWR   : integer range 0 to conDEPTH-1 := 0; --current write index
  signal currentRD   : integer range 0 to conDEPTH-1 := 0; --current read index
  signal currentStored : integer range -1 to conDEPTH+1 := 0; -- stored comands
  signal sFULL  : std_logic;-- indicates that fifo is full
  signal sEMPTY : std_logic;-- indicates that fifo is empty
   
begin
 
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then --reset
	  
        currentStored <= 0;
        currentWR   <= 0;
        currentRD   <= 0;
		
      else
 
       
        if (enWR = '1' and enRD = '0') then --updates the current number of comands
          currentStored <= currentStored + 1;
        elsif (enWR = '0' and enRD = '1') then
          currentStored <= currentStored - 1;
        end if;
		
		
 
        
        if (enWR = '1' and sFULL = '0') then--updates current wirte index
          if currentWR = conDEPTH-1 then
            currentWR <= 0;
          else
            currentWR <= currentWR + 1;
          end if;
        end if;
		
		
 
               
        if (enRD = '1' and sEMPTY = '0') then --updates current read index
          if currentRD = conDEPTH-1 then
            currentRD <= 0;
          else
            currentRD <= currentRD + 1;
          end if;
        end if;
		
		
 
        
        if enWR = '1' then -- stores the comands in the right index
          wFbuffer(currentWR) <= dataWR;
        end if;
		
		
         
      end if;                          
    end if;                             
  end process;
  
  dataRD <= wFbuffer(currentRD);  --read output
  sFULL  <= '1' when currentStored = conDEPTH else '0'; -- indicates that fifo is full
  sEMPTY <= '1' when currentStored = 0       else '0'; -- indicates that fifo is empty
  full  <= sFULL; --sets the full signal to the full output 
  empty <= sEMPTY;--sets the empty signal to the empty output 
  
  
  
end;