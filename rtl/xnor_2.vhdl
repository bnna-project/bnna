library ieee;
use ieee.std_logic_1164.all;


entity xnor_2 is
    port(
        data    : in std_logic;
        weight  : in std_logic;
        output1 : out std_logic
    );
    end xnor_2;
--Simple xnor which is used in the processing unit
architecture rtl of xnor_2 is

    signal xnor_o : std_logic;

    begin

        xnor_o <= data xnor weight;
        output1 <= xnor_o;

    end rtl;
