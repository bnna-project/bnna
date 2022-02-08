library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bnn_adder is
  generic(
          W_I : integer;
          W_O : integer);
    port(
        a : in std_logic_vector(W_I-1 downto 0);
        b : in std_logic_vector(W_I-1 downto 0);
        y : out std_logic_vector(W_O-1 downto 0)
    );
 end bnn_adder;

 architecture rtl of bnn_adder is
    signal slv1 : std_logic_vector(W_O-1 downto 0):=(others => '0');
    signal slv2 : std_logic_vector(W_O-1 downto 0):=(others => '0');
    begin
        slv1(W_I - 1 downto 0) <= a;
        slv2(W_i - 1 downto 0) <= b;

        y <= std_logic_vector(unsigned(slv1) + unsigned(slv2));
end rtl;
