library ieee;
use ieee.std_logic_1164.all;

entity comparator_tb is
end comparator_tb;

architecture TEST of comparator_tb is
    signal a : std_logic_vector(15 downto 0);
    signal b : std_logic_vector(15 downto 0);
    signal a_comp_b : std_logic;
    begin
        inst_comparator :  entity work.comparator(Behavioral)
                        generic map (8)
                        port map(a => a, b => b, a_comp_b => a_comp_b;
        a <= "11100", "10001" after 5 ns, "00000" after 10 ns;
        b <= "10000", "10010" after 5 ns, "00000" after 10 ns;
    end TEST;