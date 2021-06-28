library ieee;
use ieee.std_logic_1164.all;

entity comparator_1bit is
        port(
                a : in std_logic;
                b : in std_logic;
                a_comp_b : out std_logic
        );
        end comparator_1bit;

architecture Behavioral of comparator_1bit is

signal xnor_o : std_logic;
signal or_o1 : std_logic;
signal not_o : std_logic;
signal and_o : std_logic;
signal result : std_logic;


begin   
        --comparing on equality inputs "a" and "b"
        xnor_o <= a xnor b;
        
        --comparing if "a" greater than "b"
        not_o <= not b;
        and_o <= not_o and a;
       
        -- after comparing we choose result from output xnor gate or and gate
        result <= xnor_o or and_o;
        
        a_comp_b <= result;
end Behavioral;
    