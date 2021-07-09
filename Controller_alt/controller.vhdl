library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity controller is
  port(
    clk: in std_logic;
    reset: in std_logic; 
    write: in std_logic;
    parameter_vec: in std_logic_vector(7 downto 0);
	  weigth_vec: in std_logic_vector(7 downto 0);
    output: out std_logic_vector(15 downto 0);
    adress_out: out std_logic_vector (31 downto 0)
  );
end;


architecture behavior of controller is

 begin
  
  process(clk) 
  variable adress: std_logic_vector(31 downto 0):= x"00000000";
  begin
  adress_out <= adress;
    if (clk'event and clk = '1') then 
        if reset='1' then
            output <= x"0000";
            adress_out <= x"00000000";
        else 
              if write = '1' then
                output <= weigth_vec & parameter_vec;
                adress := std_logic_vector(unsigned(adress) + x"00000001");
              end if;
        end if;
    end if;
  end process;

end behavior;