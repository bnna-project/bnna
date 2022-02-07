library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.parameters.all;

entity bnn_xnor is
    port(
        data : in std_logic;
        weight : in std_logic;
        output : out std_logic
    );
end bnn_xnor;

architecture behavior of bnn_xnor is begin
    output <= data xnor weight;
end behavior;