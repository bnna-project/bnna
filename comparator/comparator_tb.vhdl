library ieee;
use ieee.std_logic_1164.all;

entity comparator_tb is
end comparator_tb;

architecture TEST of comparator_tb is
    signal a : std_logic_vector(1023 downto 0);
    signal b : std_logic_vector(1023 downto 0);
    signal y : std_logic;
    signal x : std_logic;
    begin
        inst_comparator :  entity work.comparator(Behavioral)
                        generic map (1023)
                        port map(a => a, b => b, a_equal_b => x, a_less_b => y);
        a <= (others => '1');
        b <= (others => '1');
    end TEST;