library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
        generic(N: integer := 16);
        port(
                a : in std_logic_vector(N-1 downto 0);--threshold
                b : in std_logic_vector(N-1 downto 0);--register result
                a_comp_b : out std_logic --Output
        );
        end comparator;
--Compares the results from the register and the threshold
architecture Behavioral of comparator is
        begin   
                process(a, b) begin
                        if (is_x(a) or is_x(b))then--result is undefined if one of the inputs is undefined
                                a_comp_b <= '-';
						elsif((a(N-1) > b(N-1))) then-- the result ist 0 if the threshold is bigger
                                a_comp_b <= '0';
                        elsif ((a(N-2 downto 0)= b(N-2 downto 0)) or (a(N-2 downto 0) > b(N-2 downto 0)))then
                                a_comp_b <= '1'; --the result ist 1 if the register result is bigger or as big as the threshold
                        else                     --Two complements must be taken into account when comparing
                                a_comp_b <= '0';
                        end if;
                end process;

        end Behavioral;
    