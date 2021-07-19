library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--gets vectors and tresholds and distributes them over the PE 
--according to the FiFo principle  
--each vector multiplication must be pushed into the block 

entity inputBuffer is
  port(
    clk: in std_logic;
    we: in std_logic;
	len: in integer;
    dataIn: in std_logic_vector(1023 downto 0);
	weightIn: in std_logic_vector(1023 downto 0);
    dataOut: buffer std_logic_vector(31 downto 0);
	weightOut: buffer std_logic_vector(31 downto 0);
	resetPE: out std_logic_vector(2 downto 0);
	resetIn: in std_logic;
	tresIn : in std_logic_vector(7 downto 0);
	tresOut: out std_logic_vector(31 downto 0)
  );
end;


architecture behavior of inputBuffer is
type ramtype is array (2047 downto 0) of std_logic_vector(1023 downto 0);
signal mem: ramtype; --memory for vectors

type ramtypeb is array (2047 downto 0) of std_logic_vector(1023 downto 0);
signal memb: ramtypeb;--memory for vectors

type tresHoldBuffer is array (2047 downto 0) of std_logic_vector(7 downto 0);
signal treshold: tresHoldBuffer; --memory for tresHold

type adressRAM is array (4 downto 1) of std_logic_vector(10 downto 0);
signal addr:adressRAM := (others => "00000000000"); --memory for the addresses of the vectors for each PE

type stateRAM is array (4 downto 1) of std_logic_vector(7 downto 0);
signal state: stateRAM := (others =>  "00000000");-- statuts of how much of a vector the PE has processed


 begin
  process(clk, dataIn)
	variable lastAdd: std_logic_vector(10 downto 0):= "00000000000";
	variable nextAdd: std_logic_vector(10 downto 0):= "00000000001";
	variable von, bis : integer;
	variable tmp : std_logic;
  begin
    if rising_edge(clk) then
	  resetPE <= "000";
      if we = '1' then
		 mem(to_integer(unsigned(lastAdd)+ "00000000001")) <= dataIn;
		 memb(to_integer(unsigned(lastAdd)+ "00000000001")) <= weightIn;
		 treshold(to_integer(unsigned(lastAdd)+ "00000000001")) <= tresIn;
		 lastAdd := std_logic_vector( unsigned(lastAdd) + "00000000001");
      end if;


	  for I in 1 to 4 loop --chech if each PE has vectors to calculate. Gives out the next part of the vector or assigns new vectors to a PE 


		if state(I) = "00000000" then -- current PE hasnt assign vectors
			if nextAdd <= lastAdd then
				addr(I) <= nextAdd;
				nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001");
				state(I) <= "00000001";
			end if;


		elsif state(I) > "10000000" then -- current PE has complete a vector calculate

			state(I) <= "00000000";
		    resetPE <=  std_logic_vector(to_unsigned(I, 3));

			if nextAdd <= lastAdd then
				addr(I) <= nextAdd;
				nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001");
				state(I)<= "00000001";
			end if;


		elsif state(I) > "00000000" then --current PE has assign vectors and gets the next 8-bit

			von := to_integer((unsigned(state(I)) * 8)-1);
			bis := to_integer((unsigned(state(I))-1) * 8);
			dataOut(7 downto 0) <= mem(to_integer(unsigned(addr(I))))(von downto bis);
			weightOut(7 downto 0) <= memb(to_integer(unsigned(addr(I))))(von downto bis);
			if(state(I) = "00000000") then
				tresOut(7 downto 0) <= treshold(to_integer(unsigned(addr(I))));
			end if;
			state(I) <= std_logic_vector(unsigned(state(I)) + "00000001");

		end if;


	  end loop;


	  if (resetIn = '1') then --Reset is 1 when all vector have been push in. Whenn all calculations are finished, the rest signal will be sent to the resetController
		for J in 1 to 4 loop
			tmp:= '1';
			if state(j) > "00000000" then
				tmp:= '1';
			end if;
		end loop;
	    if nextAdd > lastAdd and tmp = '1' then
		  resetPE <= "111";
		end if;
	  end if;
    end if;
  end process;

end;