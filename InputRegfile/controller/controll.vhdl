library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
  port (
	i_len: in integer;
    i_clk: in std_logic;
	i_reset: in std_logic;
	i_rdy: in std_logic;
	resetPE: out std_logic_vector(2 downto 0);
    --register A Interface
	i_wdDataA: in std_logic_vector(2047 downto 0);
	i_weA: in std_logic;
	--register A Connection
	o_wdDataA: out std_logic_vector(2047 downto 0);
	o_weA: out std_logic;
	o_waA: out std_logic_vector(11 downto 0);
	o_rdaA: out std_logic_vector(11 downto 0);
	i_rdA: in std_logic_vector(2047 downto 0);
	--register B Interface
	i_wdDataB: in std_logic_vector(2047 downto 0);
	i_weB: in std_logic;
	--register B Connection
	o_wdDataB: out std_logic_vector(2047 downto 0);
	o_weB: out std_logic;
	o_waB: out std_logic_vector(11 downto 0);
	o_rdaB: out std_logic_vector(11 downto 0);
	i_rdB: in std_logic_vector(2047 downto 0);
    --register Tres Interface
	i_wdDataT: in std_logic_vector(15 downto 0);
	i_weT: in std_logic;
	--register Tres Connection
	o_wdDataT: out std_logic_vector(15 downto 0);
	o_weT: out std_logic;
	o_waT: out std_logic_vector(11 downto 0);
	o_rdaT: out std_logic_vector(11 downto 0);
	i_rdT: in std_logic_vector(15 downto 0);
	--register State Connection
	o_wdDataS: out std_logic_vector(7 downto 0);
	o_weS: out std_logic;
	o_waS: out std_logic_vector(3 downto 0);
	o_rdaS: out std_logic_vector(3 downto 0);
	i_rdS: in std_logic_vector(7 downto 0);
	--register addr Connection
	o_wdDataAD: out std_logic_vector(23 downto 0);
	o_weAD: out std_logic;
	o_waAD: out std_logic_vector(3 downto 0);
	o_rdaAD: out std_logic_vector(3 downto 0);
	i_rdAD: in std_logic_vector(23 downto 0);
	--FiFo
	o_rd_en   : out  std_logic;
    i_rd_data : in std_logic_vector(23 downto 0);
    i_empty   : in std_logic;
	--Output
	o_A: buffer std_logic_vector(31 downto 0);
	o_B: buffer std_logic_vector(31 downto 0);
	o_T: buffer std_logic_vector(63 downto 0)
	
  );
end;

architecture behavior of controller is

begin
	
	o_weA <= i_weA;
	o_weB <= i_weB;
	o_weT <= i_weT;
	o_wdDataA <= i_wdDataA;
	o_wdDataB <= i_wdDataB;
	o_wdDataT <= i_wdDataT;
	
	
	process(i_clk)
	variable start: std_logic:= '0';
	variable CadrrA, CadrrB, CadrrT : integer := 1;
	begin
	
	if rising_edge(i_clk) then --Store Data
		if(i_rdy = '1') then start := '1';
		end if;
		if(start = '0') then 
			if i_weA = '1' then 
				o_waA <= std_logic_vector(to_unsigned(CadrrA, 12));
				CadrrA := CadrrA + 1;
            end if;
			if i_weB = '1' then 
				o_waB <= std_logic_vector(to_unsigned(CadrrB, 12));
				CadrrB := CadrrB + 1;
            end if;
			if i_weT = '1' then 
				o_waT <= std_logic_vector(to_unsigned(CadrrT, 12));
				CadrrT := CadrrT + 1;
            end if;
			
		end if;
	end if;
	
	end process;
	
	process(i_clk) 
	variable start, used: std_logic:= '0';
	variable von, bis : integer;
	begin
	
	if rising_edge(i_clk) then
		if(i_rdy = '1') then start := '1';
		end if;
		if(start = '1' ) then
		  used := '0';
		  for I in 1 to 4 loop
			o_rdaS <= std_logic_vector(to_unsigned(I, 4));
			o_rdaAD <= std_logic_vector(to_unsigned(I, 4));
			if (i_rdS > std_logic_vector(to_unsigned((i_len/8), 8))) then
				
				resetPE <= std_logic_vector(to_unsigned(I, 3));
				o_wdDataS <= "00000000";
				o_waS <= std_logic_vector(to_unsigned(I, 4));
				o_weS <= '1';
				
			elsif (i_rdS > std_logic_vector(to_unsigned(1, 8))) then
				
				von := to_integer((unsigned(i_rdS) * 8)-1);
			    bis := to_integer((unsigned(i_rdS)-1) * 8);
				
				o_rdaA <= i_rdAD(11 downto 0);
				o_rdaB <= i_rdAD(23 downto 12);
				
				o_A ((8*I)-1 downto (I-1)*8)<= i_rdA(von downto bis);
				o_B ((8*I)-1 downto (I-1)*8)<= i_rdB(von downto bis);
				o_wdDataS <= std_logic_vector(unsigned(i_rdS) + "000000001");
				o_waS <= std_logic_vector(to_unsigned(I, 4));
				o_weS <= '1';
				
			elsif (i_rdS > std_logic_vector(to_unsigned(0, 8))) then
			
				o_rdaT <= i_rdAD(11 downto 0);
				o_rdaA <= i_rdAD(11 downto 0);
				o_rdaB <= i_rdAD(23 downto 12);
				o_T ((16*I)-1 downto (I-1)*16)<= i_rdT;
				o_A ((8*I)-1 downto (I-1)*8)<= i_rdA(7 downto 0);
				o_B ((8*I)-1 downto (I-1)*8)<= i_rdB(7 downto 0);
				o_wdDataS <= std_logic_vector(unsigned(i_rdS) + "000000001");
				o_waS <= std_logic_vector(to_unsigned(I, 4));
				o_weS <= '1';
				
			else
				if(i_empty = '0' and used = '0') then
					resetPE <= std_logic_vector(to_unsigned(I, 3));
					o_rd_en <= '1';
					o_wdDataAD <= i_rd_data;
					o_waAD <= std_logic_vector(to_unsigned(I, 4));
					o_weAD <= '1';
					o_wdDataS <= "00000001";
					o_waS <= std_logic_vector(to_unsigned(I, 4));
					o_weS <= '1';
					used := '1';
				end if;
			end if;
		  end loop;
		 
		
		end if;
		
	end if;
	
	if falling_edge(i_clk) then
		resetPE <= "000";
		o_weAD <= '0';
		o_rd_en <= '0';
		o_weS <= '0';
		o_weAD <= '0';
	end if;
	
	end process;

end;