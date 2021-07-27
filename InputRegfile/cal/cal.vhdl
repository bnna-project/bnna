library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity command_cal is
  port (
    clk: in std_logic;
    i_rdy: in std_logic;
    i_depthA: in Integer;
    i_widthB: in integer;
    o_com: buffer std_logic_vector(23 downto 0);
	i_full: in std_logic
  );
end;

architecture behavior of command_cal is
 
begin
  process(clk) 
  variable start: std_logic:= '0';
  variable deepthC, widthC: integer := 0;
  variable deepthTmp, widthTmp: integer := 1;
  begin
   if rising_edge(clk) then --Store Data
		if(i_rdy = '1' and start = '0') then 
			start := '1';
			deepthC := i_depthA;
			widthC := i_widthB;
		end if;
		if(start = '1' and i_full =  '0' and deepthTmp <= deepthC ) then
			o_com <= std_logic_vector(to_unsigned(deepthTmp, 12)) &  std_logic_vector(to_unsigned(widthTmp, 12));
			widthTmp := widthTmp +1;
			if(widthTmp > widthC ) then
				widthTmp := 0;
				deepthTmp := deepthTmp +1;
			end if;
		end if;
	end if;
  end process;

  
end;