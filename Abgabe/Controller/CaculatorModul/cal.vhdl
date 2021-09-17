library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Calculates commands from the sizes of the vectors and matrices
entity command_cal is
  port (
    clk: in std_logic; --clock
    i_rdy: in std_logic; -- Signal to start the Calculates
    i_depthA: in Integer; -- rows of the weigth matrix
    i_widthB: in integer; -- colums of the input data (should be one)
    o_com: buffer std_logic_vector(19 downto 0); -- Output of the current command
	wr_en: out  std_logic; -- enable write in the FiFo
	i_full: in std_logic -- indicates whether there is still room in the fifo.
  );
end;

architecture behavior of command_cal is
 
begin
  process(clk) 
  variable start: std_logic:= '0';
  variable deepthC, widthC: integer := 0;
  variable deepthTmp, widthTmp: integer := 1;
  begin
  
   
   if rising_edge(clk) then  --Checks for the start signal
		if(i_rdy = '1' and start = '0') then -- and locks the sizes of the input data
			start := '1';
			deepthC := i_depthA;
			widthC := i_widthB;
		end if;
		
		
	end if;
	if falling_edge(clk) then 
		if(start = '1' and i_full =  '0' and widthTmp <= widthC ) then --creates all the comands for a calculation
		    wr_en <= '1';
			o_com <= std_logic_vector(to_unsigned(widthTmp, 10)) &  std_logic_vector(to_unsigned(deepthTmp, 10)); --A command consists of two addresses
			deepthTmp := deepthTmp +1;
			if(deepthTmp > deepthC ) then
				deepthTmp := 1;
				widthTmp := widthTmp +1;
			end if;
		elsif(start = '1' and i_full =  '0' and widthTmp = widthC  +1 ) then -- when all commands have been created, there is a finish command
		
			wr_en <= '1';
			o_com <= "11111111111111111111"; --Tells the controller that this is the last command.
			widthTmp := widthTmp +1;
			start := '0'; -- stop further calculations
		else 
			wr_en <= '0';
		end if;
		
	end if;
  end process;

  
end;