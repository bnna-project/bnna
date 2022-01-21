library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.parameters.all;

entity xnor_2_tb is
end xnor_2_tb;

architecture TEST of xnor_2_tb is

    signal data : sl;
    signal weight : sl;
    signal output1 : sl;
    
        component xnor_2 port
        (
            data : in sl;
            weight : in sl;
            output1 : out sl
        );
        end component;
    begin
        data <= '1', after 5 ns  '0', after 15 ns '1';
        weight <= '0' ,after 7 ns '1', after 17 ns '0';
        xnor_0: xnor_2
            port map (data => data, weight => weight, output1 => output1);
    end  TEST;
        
