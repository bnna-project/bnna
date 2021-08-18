library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--collects the result of the PE´s
--and pushes them out when the calculations are done

entity outputBuffer is
  port (
    clk: in std_logic;
    reset: in std_logic;
    dataOut: out std_logic_vector(1023 downto 0);
    dataIn: in std_logic_vector(7 downto 0);
	dep, wid : in integer;
	start:in std_logic;
	outputAns: out std_logic:= '0'
    
  );
end;

architecture behavior of outputBuffer is
  type ramtype is array (1023 downto 0) of std_logic_vector(1023 downto 0);
  signal mem: ramtype;
 
 signal running, output:std_logic:= '0';
 signal conWidth, conDepth:Integer;
begin
  process(clk) --collets the results and stores them in order
  variable tmpW, tmpD: Integer:= 0;
  
  begin
    if rising_edge(clk) then 
		if (running  = '1') then
		
			for I in 1 to 4 loop
				IF(dataIn((I*2-1)downto(I*2-1)) = "1") then
					mem(tmpD)(tmpW) <= dataIn((I*2-2));
					tmpW := tmpW +1;
					if tmpW >= conWidth then 
						tmpW := 0;
						tmpD := tmpD +1;
					end if;
			end if;
		
		end loop;
			
			
		end if;
	
	
	elsif falling_edge(clk) then
	
	
		IF output = '1' then
			if tmpD > conDepth then
					
				tmpD:= conDepth;
			
			elsif tmpD > 0 then
				
				dataOut(conWidth-1 downto 0) <= mem(conDepth-tmpD)(conWidth-1 downto 0);
				tmpD:= tmpD-1;
			
			elsif (tmpD = 0) then
			
				tmpW := 0;
				outputAns <= '1';
				
			end if;
			
		else	
		
			outputAns <= '0';
		
		end if;
		
	end if;
  end process;
  
  process(clk) 
  
  begin
  
    if rising_edge(clk) then 
		if(start = '1') then
			running <= '1';
			output <= '0';
			conDepth <= dep;
			conWidth <= wid;
		end if;
		if(reset = '1') then
			running <= '0';
			output <= '1';
		end if;
	end if;
  end process;

    
  
end;
