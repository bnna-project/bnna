library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.parameters.all;

entity pop_count_tb is
--generic(NUMBER_OF_BITs :INTEGER := 4);
end pop_count_tb;

architecture test of pop_count_tb is
    signal xnor_o   : std_logic_vector(NUMBER_OF_W_A -1 downto 0);
    signal output1  : std_logic_vector(NUMBER_OF_BITs_out downto 0);

    component pop_count 
        port(
            input1  : in std_logic_vector(NUMBER_OF_W_A -1 downto 0);
            output1 : out std_logic_vector(NUMBER_OF_BITs_out  downto 0)
        );
    end component;

    for all : pop_count use entity work.pop_count(rtl);
    
        begin
            xnor_o <= "11101010", "00000011" after 5 ns, "00000000" after 10 ns;
pop_count0: pop_count
            port map (input1 => xnor_o, output1 => output1);
    end test;
