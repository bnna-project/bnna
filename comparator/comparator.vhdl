library ieee;
use ieee.std_logic_1164.all;

entity comparator is
        generic(N: integer := 8);
        port(
                a : in std_logic_vector(N-1 downto 0);
                b : in std_logic_vector(N-1 downto 0);
                a_comp_b : out std_logic
        );
        end comparator;

architecture Behavioral of comparator is

signal wire_1 : std_logic_vector(N-1 downto 0);
signal wire_2 : std_logic_vector(N-2 downto 0);
begin   
       
        generate_comparators : for i in 0 to N-1 generate
                inst_comparator : entity work.comparator_1bit(Behavioral)
                        port map(a => a(i), b => b(i), a_comp_b => wire_1(i));
        end generate;
        wire_2(0) <= wire_1(0) and wire_1(1);

                geretate_and : for i in 2 to N-1 generate
                        wire_2(i-1) <= wire_2(i-2) and wire_1(i);
                end generate;
                        a_comp_b <= wire_2(N-2);
end Behavioral;
    