library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity controll is
  port(
    clk: in std_logic;
    we: in std_logic;
    dataIn: in std_logic_vector(7 downto 0);
	weigthIn: in std_logic_vector(7 downto 0);
    dwOut: buffer std_logic_vector(15 downto 0);
    adressData: out std_logic_vector (31 downto 0)
  );
end;


architecture behavior of controll is

 begin
  
  process(clk) 
  variable adress: std_logic_vector(31 downto 0):= x"00000001";
  begin
    adressData <= adress;
    if rising_edge(clk) then
      if we = '1' then dwOut <= weigthIn & dataIn;
	     adress := std_logic_vector(unsigned(adress) + x"00000001");
      end if;
	  if adress = x"0000005" then adress :=  x"00000001";
	  end if;
    end if;
  end process;
  
end;
