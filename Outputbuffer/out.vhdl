library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--collects the result of the PE´s
--and pushes them out when the calculations are done

entity outputBuffer is
  port (
    clk: in std_logic; --clock
    reset: in std_logic; --Signal to push out the results
    dataOut: out std_logic_vector(1023 downto 0); --Output
    dataIn: in std_logic_vector(3 downto 0); -- Input of PU results
	enableIn: in std_logic_vector(3 downto 0); -- enable write of the PUs
	dep, wid : in integer; -- depth and width of the input data
	start:in std_logic; -- signal that calculations have started
	outputAns: out std_logic:= '0' --signal that results have been pushed out
    
  );
end;

architecture behavior of outputBuffer is
  type ramtype is array (1023 downto 0) of std_logic_vector(1023 downto 0); --buffer of the results
  signal mem: ramtype;
 
 signal running, output:std_logic:= '0';
 signal conWidth, conDepth:Integer;
begin
  process(clk) --collets the results and stores them in order
  variable tmpW, tmpD: Integer:= 0;
 
  begin
    if rising_edge(clk) then 
		if (running  = '1') then --when calculations are running checke enable bits
		
			for I in 0 to 3 loop
				IF(enableIn(I) = '1') then --if a PU has a result
					mem(tmpW)(tmpD) <= dataIn(I); --store result in the next free slot
					tmpD := tmpD +1;
					if tmpD >= conDepth then 
						tmpD := 0;
						tmpW := tmpD +1;
					end if;
			end if;
		
		end loop;
			
			
		end if;
	
	
	elsif falling_edge(clk) then
	
	
		IF output = '1' then --results will be pushed out
			if tmpW > conWidth then
					
				tmpW:= conWidth;
			
			elsif tmpW > 0 then --push all results to the Output
				
				dataOut <= mem(conWidth-tmpW);
				
				tmpW:= tmpW-1;
				
			
			elsif (tmpD = 0) then -- inform the input controller that the results are out
				
				
				tmpD:= 0;
				tmpW := 0;
				outputAns <= '1'; -- signal for the input controller
				
			end if;
			
		else	
		
			outputAns <= '0';
		
		end if;
		
	end if;
  end process;
  
  process(clk) 
  
  begin
  
    if rising_edge(clk) then 
		if(start = '1') then --start the calculation phase
			running <= '1';
			output <= '0';
			conDepth <= dep; -- locks in depth and width
			conWidth <= wid;
		end if;
		if(reset = '1') then --Results have to be output
			running <= '0';
			output <= '1';
		else
			output <= '0';
		end if;
	end if;
  end process;

    
  
end;
