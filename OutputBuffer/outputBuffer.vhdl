
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity outputBuffer is
  port (
    clk: in std_logic;
    reset: in std_logic;
    dataOut: out std_logic_vector(1023 downto 0);
    dataIn: in std_logic_vector(7 downto 0)
    
  );
end;

architecture behavior of outputBuffer is
  type ramtype is array (1023 downto 0) of std_logic_vector(1023 downto 0);
  signal mem: ramtype;
  type tmpVar is array (1 downto 0) of Integer;
  signal var: tmpVar:= (0,0);
  signal del: std_logic:= '0';
begin
  process(clk) 
  
  begin
    if rising_edge(clk) then
	
	  if del = '1' then 
		var(0) <= 0;
        var(1) <= 0;	
	  end if;
	
	  for I in 1 to 4 loop
	    
		if dataIn((2*I-1) downto (2*I-1)) = "1" then
	       mem(var(0)) <= mem(var(0)) & dataIn((2*(I-1)) downto (2*(I-1)));	
           var(1)<= var(1)+1;
           if var(1) > 1023 then
             var(0) <= var(0) + 1;
             var(1) <= 0;	
           end if;	
		end if;
	  end loop;
    end if;
  end process;

  process(reset, clk) 
  variable rst, tmp: integer:= 0;
  begin
    if reset = '1' then
		rst := 1;
	end if;
	if rising_edge(clk) and rst = 1 then
		if (var(0)-1) >= tmp then
			dataOut <=  mem(tmp);
			tmp:=tmp+1;
		else
			dataOut <=  mem(tmp)((var(1)-1) downto 0);
			tmp:= 0;
			rst:= 0;
			del<='1';
		end if;
	end if;
    
  end process;
end;
