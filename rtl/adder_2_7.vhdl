library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_2_7 is
  generic(
          W_i : integer;
          W_o : integer);
    port(
        a : in std_logic_vector(W_i-1 downto 0);
        b : in std_logic_vector(W_i-1 downto 0);
        y : out std_logic_vector(W_o-1 downto 0)
    );
 end adder_2_7;

 architecture rtl of adder_2_7 is
    signal slv1 : std_logic_vector(W_o-1 downto 0):=(others => '0');
    signal slv2 : std_logic_vector(W_o-1 downto 0):=(others => '0');
    begin
        slv1(W_i - 1 downto 0) <= a;
        slv2(W_i - 1 downto 0) <= b;

        y <= std_logic_vector(unsigned(slv1) + unsigned(slv2));
end rtl;
