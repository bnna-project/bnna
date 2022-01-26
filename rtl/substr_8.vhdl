library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity substr_8 is
  port(
    a : in std_logic_vector(7 downto 0);
    y : out std_logic_vector(7 downto 0)
  );
end substr_8;

architecture rtl of substr_8 is

    signal a_extended : std_logic_vector(7 downto 0):= (others => '0');
    signal b_extended : std_logic_vector(7 downto 0):= (others => '0');

    begin

      a_extended <= a;
      b_extended <= std_logic_vector(to_unsigned(64, 8));

      y <= std_logic_vector(unsigned(a_extended) - unsigned(b_extended));

  end rtl;
