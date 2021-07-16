library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity reg is
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


architecture behavior of reg is
type ramtype is array (2047 downto 0) of std_logic_vector(1023 downto 0);
signal mem: ramtype;

type ramtypeb is array (2047 downto 0) of std_logic_vector(1023 downto 0);
signal memb: ramtypeb;

type tresHoldBuffer is array (2047 downto 0) of std_logic_vector(7 downto 0);
signal treshold: tresHoldBuffer;

 begin 
  process(clk, dataIn)
    variable adressA, adressB, adressC, adressD, lastAdd: std_logic_vector(10 downto 0):= "00000000000";
	variable stateA, stateB, stateC, stateD:std_logic_vector(7 downto 0):= "00000000";
	variable nextAdd: std_logic_vector(10 downto 0):= "00000000001";
	variable von, bis: integer;
  begin
    if rising_edge(clk) then
	  resetPE <= "000";
      if we = '1' then 
		 mem(to_integer(unsigned(lastAdd)+ "00000000001")) <= dataIn;
		 memb(to_integer(unsigned(lastAdd)+ "00000000001")) <= weightIn;
		 treshold(to_integer(unsigned(lastAdd)+ "00000000001")) <= tresIn;
		 lastAdd := std_logic_vector( unsigned(lastAdd) + "00000000001");
      end if;
	  
	  if stateA > "00000000" then
		  von := to_integer((unsigned(stateA) * 8)-1);
		  bis := to_integer((unsigned(stateA)-1) * 8);
	      dataOut(7 downto 0) <= mem(to_integer(unsigned(adressA)))(von downto bis);
		  weightOut(7 downto 0) <= memb(to_integer(unsigned(adressA)))(von downto bis);
		  if(stateA = "00000000") then 
		     tresOut(7 downto 0) <= treshold(to_integer(unsigned(adressA)));
		  end if;
		  stateA := std_logic_vector(unsigned(stateA) + "00000001");
		
      elsif	(stateA > "10000000") and stateA < "10000001" then
	  
	    stateA := "00000000";
		resetPE <= "001";
		
		if nextAdd <= lastAdd then
		  adressA := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateA := "00000001";
		else 
		
		 dataOut(7 downto 0) <= (others => '1');
		 weightOut(7 downto 0) <=  (others => '1'); 
		
		end if;
		
	  else
	    if nextAdd <= lastAdd then
		  adressA := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateA := "00000001";
		end if;
	  end if;
	  
	  if stateB > "00000000" and stateB < "10000001" then
		  von := to_integer((unsigned(stateB) * 8)-1);
		  bis := to_integer((unsigned(stateB)-1) * 8);
	      dataOut(15 downto 8) <= mem(to_integer(unsigned(adressB)))(von downto bis);
		  weightOut(15 downto 8) <= memb(to_integer(unsigned(adressB)))(von downto bis);
		  if(stateB = "00000000") then 
		    tresOut(15 downto 8) <= treshold(to_integer(unsigned(adressB)));
		  end if;
		  stateB := std_logic_vector(unsigned(stateB) + "00000001");
		 
	  elsif	(stateB > "10000000") then
	  
	    stateB := "00000000";
		resetPE <= "010";
		if nextAdd <= lastAdd then
		  adressB := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateB := "00000001";
		else 
		
		 dataOut(15 downto 8) <= (others => '1');
		 weightOut(15 downto 8) <=  (others => '1'); 
		
		end if;
		  
	  else
	    if nextAdd <= lastAdd then
		  adressB := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateB := "00000001";
		end if;
	  end if;
	  
	  if stateC > "00000000" and stateC < "10000001" then
		  von := to_integer((unsigned(stateC) * 8)-1);
		  bis := to_integer((unsigned(stateC)-1) * 8);
	      dataOut(23 downto 16) <= mem(to_integer(unsigned(adressC)))(von downto bis);
		  weightOut(23 downto 16) <= memb(to_integer(unsigned(adressC)))(von downto bis);
		  if(stateC = "00000000") then 
		    tresOut(23 downto 16) <= treshold(to_integer(unsigned(adressC)));
		  end if;
		  stateC := std_logic_vector(unsigned(stateC) + "00000001");
		  
	  elsif	(stateC > "10000000") then
	  
	    stateC := "00000000";
		resetPE <= "011";
		
		if nextAdd <= lastAdd then
		  adressC := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateC := "00000001";
		else 
		
		 dataOut(23 downto 16) <= (others => '1');
		 weightOut(23 downto 16) <=  (others => '1'); 
		
		end if;
		  
	  else
	    if nextAdd <= lastAdd then
		  adressC := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateC := "00000001";
		end if;
	  end if;
	  
	  if stateD > "00000000" and stateD < "10000001" then
		  von := to_integer((unsigned(stateD) * 8)-1);
		  bis := to_integer((unsigned(stateD)-1) * 8);
	      dataOut(31 downto 24) <= mem(to_integer(unsigned(adressD)))(von downto bis);
		  weightOut(31 downto 24) <= memb(to_integer(unsigned(adressD)))(von downto bis);
		  if(stateD = "00000000") then 
		    tresOut(31 downto 24) <= treshold(to_integer(unsigned(adressD)));
		  end if;
		  stateD := std_logic_vector(unsigned(stateD) + "00000001");
		  
		  
	  elsif	(stateD > "10000000") then
	  
	    stateD := "00000000";
		resetPE <= "100";
		if nextAdd <= lastAdd then
		  adressB := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateB := "00000001";
		else 
		
		 dataOut(31 downto 24) <= (others => '1');
		 weightOut(31 downto 24) <=  (others => '1'); 
		
		end if;
		  
	  else
	    if nextAdd <= lastAdd then
		  adressD := nextAdd;
		  nextAdd := std_logic_vector( unsigned(nextAdd) + "00000000001"); 
		  stateD := "00000001";
		end if;
	  end if;
	  
	  if (resetIn = '1') then
	    if nextAdd > lastAdd and stateA = "00000000" and stateB = "00000000"and stateC = "00000000" and stateD = "00000000" then
		  resetPE <= "111";
		end if;
	  end if; 
	  
	  
	  
	  
	  
	  
	  
    end if;
  end process;
  
end;
