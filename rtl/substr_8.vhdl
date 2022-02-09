library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bnn_substr is
  port(
    a : in std_logic_vector(7 downto 0);
<<<<<<< HEAD:rtl/substr_8.vhdl
    y : out std_logic_vector(7 downto 0)
=======
    b : in std_logic_vector(7 downto 0);
    y : out std_logic_vector(8 downto 0)
>>>>>>> master:rtl/bnn_substr.vhdl
  );
end bnn_substr;

architecture rtl of bnn_substr is

<<<<<<< HEAD:rtl/substr_8.vhdl
    signal a_extended : std_logic_vector(7 downto 0):= (others => '0');
    signal b_extended : std_logic_vector(7 downto 0):= (others => '0');

    begin

      a_extended <= a;
      b_extended <= std_logic_vector(to_unsigned(64, 8));
=======
    signal a_extended : std_logic_vector(8 downto 0):= (others => '0');
    signal b_extended : std_logic_vector(8 downto 0):= (others => '0');

    begin

      a_extended (7 downto 0) <= a;
      b_extended (7 downto 0)<= b;
>>>>>>> master:rtl/bnn_substr.vhdl

      y <= std_logic_vector(unsigned(a_extended) - unsigned(b_extended));

  end rtl;
