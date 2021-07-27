library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfileS is
  port (
    clk: in std_logic;
    we3: in std_logic;
    a1: in std_logic_vector(3 downto 0);
    a3: in std_logic_vector(3 downto 0);
    wd3: in std_logic_vector(7 downto 0);
    rd1: buffer std_logic_vector(7 downto 0)
  );
end;

architecture behavior of regfileS is
  type ramtype is array (4 downto 1) of std_logic_vector( 7 downto 0);
  signal mem: ramtype:= (others =>  "00000000");
begin
  process(clk) begin
    if rising_edge(clk) then
      if we3 = '1' then mem(to_integer(unsigned(a3))) <= wd3;
      end if;
    end if;
  end process;

  process(a1) begin
    if (to_integer(unsigned(a1)) = 0) then rd1 <=  (others => '0');
    else rd1 <= mem(to_integer(unsigned(a1)));
    end if;
  end process;
end;
