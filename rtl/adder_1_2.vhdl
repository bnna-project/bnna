library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_1_2 is
    port(
        a : in std_logic;
        b : in std_logic;
        y : out std_logic_vector(1 downto 0)
    );
 end adder_1_2;

 architecture rtl of adder_1_2 is
    signal slv1 : std_logic_vector(1 downto 0):=(others => '0');
    signal slv2 : std_logic_vector(1 downto 0):=(others => '0');
    begin
        slv1(0) <= a;
        slv2(0) <= b;

        y <= std_logic_vector(unsigned(slv1) + unsigned(slv2));
end rtl;
