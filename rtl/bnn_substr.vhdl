library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bnn_substr is
  port(
    a : in std_logic_vector(7 downto 0);
    b : in std_logic_vector(7 downto 0);
    y : out std_logic_vector(8 downto 0)
  );
end bnn_substr;

architecture rtl of bnn_substr is

    signal a_extended : std_logic_vector(8 downto 0):= (others => '0');
    signal b_extended : std_logic_vector(8 downto 0):= (others => '0');

    begin

      a_extended (7 downto 0) <= a;
      b_extended (7 downto 0)<= b;

      y <= std_logic_vector(unsigned(a_extended) - unsigned(b_extended));

  end rtl;
