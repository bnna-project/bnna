library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity inputBuffer is
  port(
    clk, rst, start: in std_logic;
    weA, weB, weT: in std_logic;
	dataA, dataB: in  std_logic_vector(1023 downto 0);
	dataT: in std_logic_vector(15 downto 0);
	resetPE: out std_logic_vector(4 downto 0):="01111";
	comando: in std_logic_vector(19 downto 0);
	readCo: out std_logic;
	empty: in std_logic;
	len: in integer;
	o_A,o_B: buffer std_logic_vector(31 downto 0);
	o_T: buffer std_logic_vector(63 downto 0);
	bnnRdy: out std_logic:= '1';
	outBufferIn: in std_logic
  );
end;

architecture behavior of inputBuffer is
type ramtype is array (1024 downto 1) of std_logic_vector(1023 downto 0);
signal mem: ramtype;

type ramtypeb is array (1024 downto 1) of std_logic_vector(1023 downto 0);
signal memb: ramtypeb;

type tresHoldBuffer is array (1024 downto 1) of std_logic_vector(15 downto 0);
signal treshold: tresHoldBuffer;

type adressRAM is array (4 downto 1) of std_logic_vector(19 downto 0);
signal addr:adressRAM := (others => "00000000000000000000");

type stateRAM is array (4 downto 1) of std_logic_vector(7 downto 0);
signal state: stateRAM := (others =>  "00000000"); 

signal running, RESET: std_logic;


function createFill(size : POSITIVE) return STD_LOGIC_VECTOR is
  variable temp : STD_LOGIC_VECTOR(size - 1 downto 0);

begin
  for i in 0 to size - 1 loop
    if (i mod 2 = 0) then
      temp(i) := '1';
    else
      temp(i) := '0';
    end if;
  end loop;
  return temp;
end function;



function createFillone (size : POSITIVE) return STD_LOGIC_VECTOR is
  variable temp : STD_LOGIC_VECTOR(size - 1 downto 0);

begin
  for i in 0 to size - 1 loop
      temp(i) := '1';
  end loop;
  return temp;
end function;


begin



  process(clk)
  Variable spA, spB, spT: Integer:=1;
  begin
  
		if rising_edge(clk) then
	
			if(weA = '1') then
				
				report "Signal Value = " & integer'image(spA);
				mem(spA) <= dataA;
				spA := spA+1;
			end if;
			
			if(weB = '1') then
				memb(spB) <= dataB;
				spB := spB+1;
			end if;
			
			if(weT = '1') then
				treshold(spT)<= dataT;
				spT := spT+1;
			end if;
			
			if(RESET = '1') then
				spA := 0;
				spB := 0;
				spT := 0;
			end if;
		
		end if;
  
  end process;
  
  
 
  
  
  
  
  
  process(clk)
  variable von, bis: Integer:=0;
  variable com: std_logic_vector(19 downto 0);
  variable allrdy, tmp_empty: boolean;
  
  begin
	
	if rising_edge(clk) then
		
		if (outBufferIn = '1') then
            RESET <= '0';
			resetPE <= "01111";			
		end if;
		
		if(running = '1') then
			if(empty = '0') then
				tmp_empty := false;
				com := comando; -- 0-9 A 10-19 B comando = 0 ?
				if (com  = (com'range => '1') ) then
					com:= (others => '0');
					RESET <= '1';
				else 
					RESET <= '0';
				end if;
			else
				tmp_empty := true;
			end if;
			
		
		
			
			
			
		end if;
	
	elsif falling_edge(clk) then
		if(running = '1') then
			
			
			
			if(empty = '0') then --abendern
				readCo <= '1';
			else
				readCo <= '0';
			end if;
		
			for I in 1 to 4 loop
				
				if(state(I) > std_logic_vector(to_unsigned((len/8), 8)) and (len mod 8) = 0 ) or (state(I) > std_logic_vector(to_unsigned((len/8)+1, 8)) and (len mod 8) > 0 ) then --aufrunden
					
					resetPE(I-1) <= '1';
					state(I) <= "00000000";
					
				elsif (state(I) = std_logic_vector(to_unsigned((len/8)+1, 8)) and (len mod 8) > 0) then
				    
					von := to_integer((unsigned(state(I)) * 8)-1);
					bis := to_integer((unsigned(state(I))-1) * 8);
					o_T (((16*I)-1) downto ((I-1)*16))<= treshold(to_integer(unsigned(addr(I)(9 downto 0))));
					o_A(((8*I)-1) downto ((I-1)*8)) <= createFill(len mod 8) & mem(to_integer(unsigned(addr(I)(9 downto 0))))(von-(len mod 8) downto bis);
					o_B(((8*I)-1) downto ((I-1)*8)) <= createFillone(len mod 8) & memb(to_integer(unsigned(addr(I)(19 downto 10))))(von-(len mod 8) downto bis);
					
					state(I) <= std_logic_vector(unsigned(state(I)) + "00000001");
					
				elsif (state(I) > std_logic_vector(to_unsigned(0, 8))) then
					
					von := to_integer((unsigned(state(I)) * 8)-1);
					bis := to_integer((unsigned(state(I))-1) * 8);
					o_T (((16*I)-1) downto ((I-1)*16))<= treshold(to_integer(unsigned(addr(I)(9 downto 0))));
					o_A(((8*I)-1) downto ((I-1)*8)) <= mem(to_integer(unsigned(addr(I)(9 downto 0))))(von downto bis);
					o_B(((8*I)-1) downto ((I-1)*8)) <= memb(to_integer(unsigned(addr(I)(19 downto 10))))(von downto bis);
					
					state(I) <= std_logic_vector(unsigned(state(I)) + "00000001");
					if (state(I) = std_logic_vector(to_unsigned(1, 8))) then
						resetPE(I-1) <= '0';
					end if; 
				
				else
					
					if( to_integer(unsigned(com)) > 0 and not tmp_empty) then
						
						
						addr(I) <= com;
						state(I) <= "00000001";
						
						com := std_logic_vector(to_unsigned(0, 20));
					end if;
					
				
				end if;
			
			end loop;
			
			
			if (RESET = '1') then
				
				allrdy := true;
				for I in 1 to 4 loop
					
					if (state(I)> std_logic_vector(to_unsigned(0, 8))) then
						allrdy:= false;
					end if;
				end loop;
				
				if(allrdy) then
					resetPE <= "11111";
				end if;
				
			end if;
			
		
		end if;
	end if;
  
  end process;
  
  
  
  
  
  
  
  
  
  process(start, RESET, clk)
  begin
	if(start = '1') then
		running <= '1';
		bnnRdy <= '0';
	end if;

	if rising_edge(clk) then
	
		if (outBufferIn = '1') then
			bnnRdy <= '1';
			running <= '0';
		end if;
		
	
	end if;
	
  end process;
 

end;