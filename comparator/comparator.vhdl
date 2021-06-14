library ieee;
use ieee.std_logic_1164.all;

entity comparator is
        generic(N: integer := 4);
        port(
                a : in std_logic_vector(N-1 downto 0);
                b : in std_logic_vector(N-1 downto 0);
                a_equal_b : out std_logic;
                a_less_b : out std_logic;
                a_great_b : out std_logic
        );
        end comparator;
architecture Behavioral of comparator is
signal temp1 : std_logic_vector(N-1 downto 0);
signal temp2 : std_logic_vector(N-1 downto 0);
signal temp3 : std_logic_vector(7 downto 0);
signal temp4 : std_logic_vector(7 downto 0);
signal temp5 : std_logic_vector(7 downto 0);
begin   
        --compare equality of a and b
        inst_gen_xnor: for i in 0 to N-1 generate
            temp1(i) <= a(i) xnor b(i);
        end generate;

        temp2(0) <= temp1(0);

        inst_gen_and: for i in 1 to N-1 generate
            temp2(i) <= temp2(i-1) and temp1(i);
         end generate;

         a_equal_b <= temp2(N-1);
         
end Behavioral;
    