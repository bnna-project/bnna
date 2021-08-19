library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
        generic(N: integer := 16);
        port(
                a : in std_logic_vector(N-1 downto 0);
                b : in std_logic_vector(N-1 downto 0);
                a_comp_b : out std_logic
        );
        end comparator;

architecture Behavioral of comparator is
        begin   
                process(a, b) begin
                        if (is_x(a) or is_x(b))then
                                a_comp_b <= '-';
                        elsif ((a = b) or (a > b))then
                                a_comp_b <= '1';
                        else 
                                a_comp_b <= '0';
                        end if;
                end process;

        end Behavioral;
    