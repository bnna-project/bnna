library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.parameters.all;

entity xnor_2 is
    port(
        data : in sl;
        weight : in sl;
        output1 : out sl
    );
    end xnor_2;

architecture behavior of xnor_2 is
    
    signal xnor_o : sl;

    begin
    
        xnor_o <= data xnor weight;
        output1 <= xnor_o;
    
    end behavior;