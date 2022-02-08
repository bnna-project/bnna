library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity inputBuffer is
  port(
    clk, rst, start: in std_logic; -- clock and Start signal
    weA, weB, weT: in std_logic; -- write enable for the Inputs
	dataA, dataB: in  std_logic_vector(1023 downto 0); -- Input of data and weigths
	dataT: in std_logic_vector(15 downto 0);-- Input of thresholds
	resetPE: out std_logic_vector(4 downto 0):="01111"; -- Reset line for the PU and Output buffer
	comando: in std_logic_vector(19 downto 0); -- comands from the fifo
	readCo: out std_logic; -- read enable to the fifo
	empty: in std_logic; -- indicates that fifo is empty
	len: in integer; -- length of the vectors
	o_A,o_B: buffer std_logic_vector(31 downto 0); --output of Data and weigths to the PU
	o_T: buffer std_logic_vector(63 downto 0);-- output of thresholds to the PU
	bnnRdy: out std_logic:= '1'; -- indicates whether the controller is ready to accept data
	outBufferIn: in std_logic -- indicates that the outputbuffer has pushed out all results
  );
end;

architecture behavior of inputBuffer is
--buffer for the Input
type ramtype is array (1024 downto 1) of std_logic_vector(1023 downto 0);
signal mem: ramtype;

type ramtypeb is array (1024 downto 1) of std_logic_vector(1023 downto 0);
signal memb: ramtypeb;

type tresHoldBuffer is array (1024 downto 1) of std_logic_vector(15 downto 0);
signal treshold: tresHoldBuffer;
--current adresses of the PUs
type adressRAM is array (4 downto 1) of std_logic_vector(19 downto 0);
signal addr:adressRAM := (others => "00000000000000000000");
--current caculation state of a PU
type stateRAM is array (4 downto 1) of std_logic_vector(7 downto 0);
signal state: stateRAM := (others =>  "00000000"); 

signal running, RESET: std_logic;

--function to fill up a vector with alternating 0 and 1
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


--function to fill up a vector with 1
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
  
		if rising_edge(clk) then  --store the Input
	
			if(weA = '1') then
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
			
			if(RESET = '1') then --Reset of the next adress
				spA := 0;
				spB := 0;
				spT := 0;
			end if;
		
		end if;
  
  end process;
  
  
 
  
  
  
  
  
  process(clk)
  variable von, bis: Integer:=0;
  variable com: std_logic_vector(19 downto 0);
  variable allrdy, tmp_empty, comanN: boolean;
  
  begin
	
	if rising_edge(clk) then
		
		if (outBufferIn = '1') then  -- checks if the outputbuffer has completed its job
            RESET <= '0';
			resetPE <= "01111";			
		end if;
		
		if(running = '1') then --sets the current comand
			if(empty = '0') then
				tmp_empty := false;
				if comanN = true then
					com := comando;
				end if;
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
		if(running = '1') then --checks the state of the PUS
			
			
			for I in 1 to 4 loop
				--curent PU has finished the comand and will be reset
				if(state(I) > std_logic_vector(to_unsigned((len/8), 8)) and (len mod 8) = 0 ) or (state(I) > std_logic_vector(to_unsigned((len/8)+1, 8)) and (len mod 8) > 0 ) then 
					
					resetPE(I-1) <= '1';
					state(I) <= "00000000";
				--curent PU is in the last step and the vectors need to be filled up 
				elsif (state(I) = std_logic_vector(to_unsigned((len/8)+1, 8)) and (len mod 8) > 0) then
				    
					von := to_integer((unsigned(state(I)) * 8)-1);
					bis := to_integer((unsigned(state(I))-1) * 8);
					o_T (((16*I)-1) downto ((I-1)*16))<= treshold(to_integer(unsigned(addr(I)(9 downto 0))));
					o_A(((8*I)-1) downto ((I-1)*8)) <= createFill(8-(len mod 8)) & mem(to_integer(unsigned(addr(I)(19 downto 10))))(von-(8-(len mod 8)) downto bis);
					o_B(((8*I)-1) downto ((I-1)*8)) <= createFillone(8-(len mod 8)) & memb(to_integer(unsigned(addr(I)(9 downto 0))))(von-(8-(len mod 8)) downto bis);
					
					state(I) <= std_logic_vector(unsigned(state(I)) + "00000001");
				--curent PU is in the middle of a caculation				
				elsif (state(I) > std_logic_vector(to_unsigned(0, 8))) then
					
					von := to_integer((unsigned(state(I)) * 8)-1); --end of the part vecktor
					bis := to_integer((unsigned(state(I))-1) * 8); --start of the part vecktor
					o_T (((16*I)-1) downto ((I-1)*16))<= treshold(to_integer(unsigned(addr(I)(9 downto 0)))); --output of the treshold
					o_A(((8*I)-1) downto ((I-1)*8)) <= mem(to_integer(unsigned(addr(I)(19 downto 10))))(von downto bis);--output of the data
					o_B(((8*I)-1) downto ((I-1)*8)) <= memb(to_integer(unsigned(addr(I)(9 downto 0))))(von downto bis);--output of the weigths
					report "Schleife" & integer'image(I);
					report "adresse von A" & integer'image(to_integer(unsigned(addr(I)(9 downto 0))));
					report "adresse von B" & integer'image(to_integer(unsigned(addr(I)(19 downto 10))));
					state(I) <= std_logic_vector(unsigned(state(I)) + "00000001"); --next state
					if (state(I) = std_logic_vector(to_unsigned(1, 8))) then -- in the first state the reset-Bit needs to be lifted
						resetPE(I-1) <= '0';
					end if; 
				--curent PU is empty
				else
					
					if( to_integer(unsigned(com)) > 0 and not tmp_empty) then --curent PU is empty and there is a comand available
						
						
						addr(I) <= com; -- sets the comand to the current PU 
						state(I) <= "00000001"; -- set the state to 1
						
						com := std_logic_vector(to_unsigned(0, 20)); --delets the comand, so it isnt used twice
					end if;
					
				
				end if;
			
			end loop;
			
			comanN:= false;
			
			for I in 1 to 4 loop --checks if a PU is empty and needs a comand
					
				if (state(I) = std_logic_vector(to_unsigned(0, 8))) then
					comanN:= true;
				end if;
				
			end loop;
			
			if(comanN = true and empty = '0') then -- requests a comand from the fifo if necessary
				readCo <= '1';
			else
				readCo <= '0';
				com := std_logic_vector(to_unsigned(0, 20));
			end if;
			
			
			if (RESET = '1') then --if the reset comand is read, checks if all caculation are done
				
				allrdy := true;
				for I in 1 to 4 loop
					
					if (state(I)> std_logic_vector(to_unsigned(0, 8))) then
						allrdy:= false;
					end if;
				end loop;
				
				if(allrdy) then --when caculation are done, the output buffer will get a reset to push the results out
					resetPE <= "11111";
				end if;
				
			end if;
			
		
		end if;
	end if;
  
  end process;
  
  
  
  
  
  
  
  
  
  process(start, RESET, clk)
  begin
	if(start = '1') then --starts the caculation
		running <= '1';
		bnnRdy <= '0';
	end if;

	if rising_edge(clk) then
	
		if (outBufferIn = '1') then --checks if the outputbuffer has completed its job
			bnnRdy <= '1'; 
			running <= '0';
		end if;
		
	
	end if;
	
  end process;
 

end;